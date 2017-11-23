package ore.cordova.modalwebview;

import android.animation.ObjectAnimator;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.drawable.ClipDrawable;
import android.graphics.drawable.ShapeDrawable;
import android.graphics.drawable.shapes.RectShape;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.Window;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.FrameLayout;

import android.graphics.drawable.Drawable;
import android.graphics.drawable.LayerDrawable;
import android.view.Gravity;
import android.widget.LinearLayout;
import android.widget.ProgressBar;

public class WebViewActivity extends Activity {

  private static final String EXTRA_URL = WebView.class.getName() + "#URL";

  public static Intent newCallingIntent(Context context, String url) {
    return new Intent(context, WebViewActivity.class)
        .putExtra(EXTRA_URL, url);
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
    final ClipDrawable fgc = new ClipDrawable(fg, Gravity.LEFT, ClipDrawable.HORIZONTAL);
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
    webView.setWebViewClient(new WebViewClient());
    webView.setWebChromeClient(new WebChromeClient() {
      @Override
      public void onProgressChanged(WebView view, int newProgress) {
        progressBar.setAlpha(1);
        progressBar.setProgress(newProgress);
        if (newProgress >= 100) {
          ObjectAnimator.ofFloat(progressBar, "alpha", 1, 0).setDuration(500).start();
        }
      }
    });

    final FrameLayout.LayoutParams params = new FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT);
    setContentView(container, params);

    progressBar.setProgress(0);

    String url = getIntent().getStringExtra(EXTRA_URL);
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
    final MenuItem close = menu.add("Close");
    close.setIcon(android.R.drawable.ic_delete)
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
}
