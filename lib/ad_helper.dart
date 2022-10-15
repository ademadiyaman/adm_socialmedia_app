import 'dart:io';

class adHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-6992050090491868/4394279617';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-6992050090491868/4394279617';
    } else {
      throw UnsupportedError("Unsupported Platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-6992050090491868/2481899317';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-6992050090491868/2481899317';
    } else {
      throw UnsupportedError("Unsupported Platform");
    }
  }
}
