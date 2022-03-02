import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:package_info/package_info.dart';
import '../../generated/i18n.dart';
import '../repository/settings_repository.dart' as settingRepo;
import '../repository/user_repository.dart';

class SplashScreenController extends ControllerMVC {
  ValueNotifier<Map<String, double>> progress = new ValueNotifier(new Map());
  GlobalKey<ScaffoldState> scaffoldKey;

  SplashScreenController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    // Should define these variable before the app loaded
    progress.value = {"Setting": 0, "User": 0, "DeliveryAddress": 0};
    // checkAppVersion();
  }
  @override
  void initState() {
    // try {
    //   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    //   _firebaseMessaging.subscribeToTopic('wamyada');
    //   _firebaseMessaging.configure(
    //     onMessage: (Map<String, dynamic> message) async {
    //       Helper.printToConsole("splash screen onMessage: $message");
    //     },
    //     onLaunch: (Map<String, dynamic> message) async {
    //       Helper.printToConsole("splash screen onLaunch: $message");
    //     },
    //     onResume: (Map<String, dynamic> message) async {
    //       Helper.printToConsole(" splash screen  onResume: $message");
    //     },
    //     onBackgroundMessage: myBackgroundMessageHandler,
    //   );
    // } catch (e) {
    // }
    settingRepo.setting.addListener(() async {
      if (settingRepo.setting.value.appName != null &&
          settingRepo.setting.value.appName != '' &&
          settingRepo.setting.value.mainColor != null) {
        progress.value["Setting"] = 41;
        await settingRepo.getDefaultLanguage('fr').then((value) {
          settingRepo.setting.value.mobileLanguage.value =
              new Locale(value, '');
          Get.updateLocale(settingRepo.setting.value.mobileLanguage.value);
        });

        progress.notifyListeners();
      }
    });
    settingRepo.deliveryAddress.addListener(() {
      if (settingRepo.deliveryAddress.value.address != null) {
        progress.value["DeliveryAddress"] = 29;
        progress?.notifyListeners();
      }
    });
    currentUser.addListener(() {
      if (currentUser.value.auth != null) {
        progress.value["User"] = 30;
        progress.notifyListeners();
      }
    });
    Timer(Duration(seconds: 20), () {
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.current.verify_your_internet_connection),
      ));
    });

    super.initState();
  }

  // Future<void> checkAppVersion() async {
  //   PackageInfo packageInfo = await PackageInfo.fromPlatform();
  //   String version = packageInfo.version;
  //   scaffoldKey?.currentState?.showSnackBar(SnackBar(
  //       content: Text('App Version $version'),
  //     ));
  // }

  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }
  }
}
