import 'package:url_launcher/url_launcher.dart';

///
class LauncherUtil {
  ///
  static Future<void> launch({required LaunchType launchType, required String url}) async {
    final uriString = switch (launchType) {
      LaunchType.url => 'url:$url',
      LaunchType.sms => 'sms:$url',
      LaunchType.tel => 'tel:$url',
    };
    final Uri uri = Uri.parse(uriString);
    await launchUrl(uri);
  }
}

///
enum LaunchType {
  ///
  url,

  ///
  sms,

  ///
  tel
}
