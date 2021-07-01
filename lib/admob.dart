import 'dart:io';

// import 'package:firebase_admob/firebase_admob.dart';

class AdMobServices {
  static String appId = 'ca-app-pub-5029109567391688~5689332767';
  static String bannerId = 'ca-app-pub-5029109567391688/4957573124';
  // static String interstitialId = 'ca-app-pub-1718282816355121/2557721287';
  static String rewardId = 'ca-app-pub-5029109567391688/9344612528';
  String getAdMobAppId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-1718282816355121~1682675195';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-5029109567391688~5689332767';
    }
    return null;
  }

  String getBannerAppId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-1718282816355121/7042797177';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-1718282816355121/2557721287';
    }
    return null;
  }

  String getInterstitialAppId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-1718282816355121/5753782143';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-1718282816355121/8548414563';
    }
    return null;
  }

  String getRewarded() {
    if (Platform.isIOS) {
      return 'ca-app-pub-1718282816355121/1814537130';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-1718282816355121/2368541647';
    }
    return null;
  }

  //creating ads
  // BannerAd createBannerAd() {
  //   BannerAd bannerAd =
  //       BannerAd(adUnitId: BannerAd.testAdUnitId, size: AdSize.smartBanner);
  //   return bannerAd;
  // }

  // InterstitialAd createInterstialAd() {
  //   InterstitialAd interstialAd = InterstitialAd(
  //     adUnitId: InterstitialAd.testAdUnitId,
  //     listener: (event) {
  //       print(
  //           "************************************$event****************************************");
  //       switch (event) {
  //         case MobileAdEvent.clicked:
  //           // add
  //           break;
  //         default:
  //       }
  //     },
  //   );
  //   return interstialAd;
  // }

  // createReawrdAdAndLoad() {
  //   RewardedVideoAd.instance.load(adUnitId: RewardedVideoAd.testAdUnitId);
  // }
  // createReawrdAdAndLoad() {
  //   RewardedVideoAd.instance.load(
  //       adUnitId: RewardedVideoAd.testAdUnitId,
  //       targetingInfo: MobileAdTargetingInfo());
  //   RewardedVideoAd.instance.listener =
  //       (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
  //     switch (event) {
  //       case RewardedVideoAdEvent.rewarded:
  //         RewardedVideoAd.instance.load(adUnitId: RewardedVideoAd.testAdUnitId);

  //         ///
  //         break;
  //       default:
  //     }
  //     print(
  //         "************************************createReawrdAdAndLoad $event****************************************");
  //   };
  // }
}
