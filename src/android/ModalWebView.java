package ore.cordova.modalwebview;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.LOG;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.support.annotation.ColorInt;

public class ModalWebView extends CordovaPlugin {

  private static final String LOG_TAG = "ModalWebView";

  private static final int REQUEST_CODE_CLOSE = 1;

  private CallbackContext closeContext;

  @ColorInt
  private int errorTextColor;

  @ColorInt
  private int errorBackgroundColor;

  @Override
  public boolean execute(final String action, final JSONArray args, final CallbackContext callbackContext) throws JSONException {
    if (action.equals("init")) {
      cordova.getThreadPool().execute(new Runnable() {
        public void run() {
          closeContext = callbackContext;
        }
      });
    } else if (action.equals("open")) {
      final String url = args.getString(0);
      final String title = args.getString(1);
      cordova.getThreadPool().execute(new Runnable() {
        public void run() {
          open(url, title);
          callbackContext.success();
        }
      });
    } else if (action.equals("setErrorTextColor")) {
      this.errorTextColor = toColorInt(args.getInt(0));
      callbackContext.success();
    } else if (action.equals("setErrorBackgroundColor")) {
      this.errorBackgroundColor = toColorInt(args.getInt(0));
      callbackContext.success();
    } else {
      LOG.e(LOG_TAG, "Invalid action : " + action);
      callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.INVALID_ACTION));
      return false;
    }
    return true;
  }

  private void open(String url, String title) {
    Activity context = cordova.getActivity();
    Intent intent = WebViewActivity.newCallingIntent(context, url, title, errorTextColor, errorBackgroundColor);
    cordova.startActivityForResult(this, intent, REQUEST_CODE_CLOSE);
    int enterAnimationId = ResourceUtils.getAnimationResourceIdentifier(context, "bottom_to_top");
    context.overridePendingTransition(enterAnimationId, android.R.anim.fade_out);
  }

  private void close() {
    if (closeContext != null) {
      PluginResult r = new PluginResult(PluginResult.Status.OK);
      r.setKeepCallback(true);
      closeContext.sendPluginResult(r);
    }
  }

  @Override
  public void onActivityResult(int requestCode, int resultCode, Intent intent) {
    if (requestCode == REQUEST_CODE_CLOSE) {
      close();
      return;
    }
    super.onActivityResult(requestCode, resultCode, intent);
  }

  private static int toColorInt(int rgb) {
    return Color.argb(
        0xFF,
        (rgb >> 16) & 0xFF,
        (rgb >> 8) & 0xFF,
        rgb & 0xFF);
  }
}
