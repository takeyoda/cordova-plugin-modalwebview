package ore.cordova.modalwebview;

import android.animation.ObjectAnimator;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.graphics.Color;
import android.graphics.drawable.ClipDrawable;
import android.graphics.drawable.ShapeDrawable;
import android.graphics.drawable.shapes.RectShape;
import android.net.Uri;
import android.os.Bundle;
import android.support.annotation.ColorInt;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AppCompatActivity;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebChromeClient;
import android.webkit.WebResourceError;
import android.webkit.WebResourceRequest;
import android.webkit.WebResourceResponse;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.FrameLayout;

import android.graphics.drawable.Drawable;
import android.graphics.drawable.LayerDrawable;
import android.view.Gravity;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

public class WebViewActivity extends AppCompatActivity {

  private static final String EXTRA_URL = WebViewActivity.class.getName() + "#URL";
  private static final String EXTRA_TITLE = WebViewActivity.class.getName() + "#TITLE";
  private static final String EXTRA_ERROR_TEXT_COLOR = WebViewActivity.class.getName() + "#ERROR_TEXT_COLOR";
  private static final String EXTRA_ERROR_BACKGROUND_COLOR = WebViewActivity.class.getName() + "#ERROR_BACKGROUND_COLOR";
  private static final String EXTRA_ORIENTATION = WebViewActivity.class.getName() + "#ORIENTATION";

  public static Intent newCallingIntent(Context context, String url, String title,
                                        @ColorInt int errorTextColor, @ColorInt int errorBackgroundColor, int orientation) {
    return new Intent(context, WebViewActivity.class)
        .putExtra(EXTRA_URL, url)
        .putExtra(EXTRA_TITLE, title)
        .putExtra(EXTRA_ERROR_TEXT_COLOR, errorTextColor)
        .putExtra(EXTRA_ERROR_BACKGROUND_COLOR, errorBackgroundColor)
        .putExtra(EXTRA_ORIENTATION, orientation);
  }

  @Override
  protected void onCreate(Bundle bundle) {
    super.onCreate(bundle);
    //getWindow().requestFeature(Window.FEATURE_ACTIVITY_TRANSITIONS);
    final LinearLayout container = new LinearLayout(this);
    container.setOrientation(LinearLayout.VERTICAL);

    final ProgressBar progressBar = new ProgressBar(this, null, android.R.attr.progressBarStyleHorizontal);
    progressBar.setIndeterminate(false);
    progressBar.setMax(100);

    final ShapeDrawable bg = new ShapeDrawable();
    final RectShape bgs = new RectShape();
    bgs.resize(1, 1);
    bg.setShape(bgs);
    bg.getPaint().setColor(0xFF111111);
    final ShapeDrawable fg = new ShapeDrawable();
    final RectShape fgs = new RectShape();
    fgs.resize(1, 1);
    fg.setShape(fgs);
    fg.getPaint().setColor(0xFF00AAFF);
    final ClipDrawable fgc = new ClipDrawable(fg, Gravity.START, ClipDrawable.HORIZONTAL);
    final LayerDrawable d = new LayerDrawable(new Drawable[]{bg, fgc});
    d.setId(0, android.R.id.background);
    d.setId(1, android.R.id.progress);

    progressBar.setProgressDrawable(d);

    final LinearLayout.LayoutParams pblp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, 10);
    container.addView(progressBar, pblp);

    final WebView webView = new WebView(this);
    final LinearLayout.LayoutParams wlp = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.MATCH_PARENT);
    container.addView(webView, wlp);
    webView.getSettings().setJavaScriptEnabled(true);
    webView.getSettings().setSupportMultipleWindows(true);
    final int errorTextColor = getIntent().getIntExtra(EXTRA_ERROR_TEXT_COLOR, Color.TRANSPARENT);
    final int errorBackgroundColor = getIntent().getIntExtra(EXTRA_ERROR_BACKGROUND_COLOR, Color.TRANSPARENT);
    webView.setWebViewClient(new MWVWebViewClient(this, container, errorTextColor, errorBackgroundColor));
    webView.setWebChromeClient(new WebChromeClient() {
      @Override
      public void onProgressChanged(WebView view, int newProgress) {
        progressBar.setAlpha(1);
        progressBar.setProgress(newProgress);
        if (newProgress >= 100) {
          ObjectAnimator anim = ObjectAnimator.ofFloat(progressBar, "alpha", 1, 0).setDuration(500);
          anim.setStartDelay(180);
          anim.start();
        }
      }
      @Override
      public boolean onCreateWindow(WebView view, boolean dialog, boolean userGesture, android.os.Message resultMsg) {
        WebView.HitTestResult result = view.getHitTestResult();
        String data = result.getExtra();
        Context context = view.getContext();
        Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse(data));
        browserIntent.addCategory(Intent.CATEGORY_BROWSABLE);
        browserIntent.addCategory(Intent.CATEGORY_DEFAULT);
        context.startActivity(browserIntent);
        return false;
      }
    });

    setRequestedOrientation(getIntent().getIntExtra(EXTRA_ORIENTATION, ActivityInfo.SCREEN_ORIENTATION_UNSPECIFIED));

    final FrameLayout.LayoutParams params = new FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT);
    setContentView(container, params);

    progressBar.setProgress(0);

    String url = getIntent().getStringExtra(EXTRA_URL);
    String title = getIntent().getStringExtra(EXTRA_TITLE);
    setTitle(title);
    webView.loadUrl(url);
  }

  @Override
  public void finish() {
    super.finish();
    int exitAnimationId = ResourceUtils.getAnimationResourceIdentifier(this, "top_to_bottom");
    overridePendingTransition(android.R.anim.fade_in, exitAnimationId);
  }

  @Override
  public boolean onCreateOptionsMenu(Menu menu) {
    final MenuItem close = menu.add("\u00d7");
    final int iconClose = ResourceUtils.getDrawableResourceIdentifier(this, "ic_close_black_48dp");
    close.setIcon(iconClose)
        .setOnMenuItemClickListener(new MenuItem.OnMenuItemClickListener() {
          @Override
          public boolean onMenuItemClick(MenuItem menuItem) {
            finish();
            return true;
          }
        })
        .setShowAsAction(MenuItem.SHOW_AS_ACTION_ALWAYS);
    return super.onCreateOptionsMenu(menu);
  }

  private static class MWVWebViewClient extends WebViewClient {
    private final Context context;
    private final ViewGroup containerView;
    @ColorInt
    private final int errorTextColor;
    @ColorInt
    private final int errorBackgroundColor;

    MWVWebViewClient(Context context, ViewGroup containerView, int errorTextColor, int errorBackgroundColor) {
      this.context = context;
      this.containerView = containerView;
      this.errorTextColor = errorTextColor;
      this.errorBackgroundColor = errorBackgroundColor;
    }

    @Override
    public void onReceivedError(WebView view, int errorCode, String description, String failingUrl) {
      handleError(view);
    }

    @Override
    public void onReceivedError(WebView view, WebResourceRequest request, WebResourceError error) {
      if (!isForMainFrame(request)) {
        return;
      }
      handleError(view);
    }

    @Override
    public void onReceivedHttpError(WebView view, WebResourceRequest request, WebResourceResponse errorResponse) {
      if (!isForMainFrame(request)) {
        return;
      }
      handleError(view);
    }

    private void handleError(final WebView webView) {
      final int messageId = ResourceUtils.getStringResourceIdentifier(context, "modalwebview_error");
      final int actionId = ResourceUtils.getStringResourceIdentifier(context, "modalwebview_action_reload");
      Snackbar snackbar = Snackbar.make(containerView, messageId, Snackbar.LENGTH_LONG)
          .setAction(actionId, new View.OnClickListener() {
            @Override
            public void onClick(View view) {
              webView.reload();
            }
          });
      View snackbarView = snackbar.getView();
      if (this.errorTextColor != Color.TRANSPARENT) {
        TextView textView = (TextView) snackbarView.findViewById(android.support.design.R.id.snackbar_text);
        textView.setTextColor(this.errorTextColor);
      }
      if (this.errorBackgroundColor != Color.TRANSPARENT) {
        snackbarView.setBackgroundColor(this.errorBackgroundColor);
      }
      snackbar.show();
    }

    private static boolean isForMainFrame(WebResourceRequest request) {
      try {
        Class<?> wrrClass = Class.forName("android.webkit.WebResourceRequest");
        Method m = wrrClass.getMethod("isForMainFrame");
        return (Boolean) m.invoke(request);
      } catch (ClassNotFoundException e) {
        return false;
      } catch (NoSuchMethodException e) {
        return false;
      } catch (InvocationTargetException e) {
        return false;
      } catch (IllegalAccessException e) {
        return false;
      }
    }
  }
}
