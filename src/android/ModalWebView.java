package ore.cordova.modalwebview;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;

import android.app.Activity;
import android.content.Intent;

public class ModalWebView extends CordovaPlugin {

  private static final String LOG_TAG = "ModalWebView";

  @Override
  public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
    if (action.equals("presentModalWebView")) {
      String url = args.getString(0);
      presentModalWebView(url);

      PluginResult r = new PluginResult(PluginResult.Status.NO_RESULT);
      r.setKeepCallback(true);
      callbackContext.sendPluginResult(r);

      return true;
    }
    return false;
  }

  private void presentModalWebView(String url) {
    Activity context = cordova.getActivity();
    Intent intent = WebViewActivity.newCallingIntent(context, url);
    context.startActivityForResult(intent, 0);
    int enterAnimationId = ResourceUtils.getAnimationResourceIdentifier(context, "bottom_to_top");
    context.overridePendingTransition(enterAnimationId, android.R.anim.fade_out);
  }
}
