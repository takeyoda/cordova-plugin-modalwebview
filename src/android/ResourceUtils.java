package ore.cordova.modalwebview;

import android.content.Context;

final class ResourceUtils {
  private ResourceUtils() {}
  static int getResourceIdentifier(Context context, String name, String type) {
    return context.getResources().getIdentifier(name, type, context.getPackageName());
  }
  static int getAnimationResourceIdentifier(Context context, String name) {
    return getResourceIdentifier(context, name, "anim");
  }
}
