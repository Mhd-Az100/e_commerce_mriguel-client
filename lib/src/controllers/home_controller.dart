import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
// import 'package:markets/src/helpers/global.dart';
import 'package:markets/src/helpers/helper.dart';
import 'package:markets/src/models/slider.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:package_info/package_info.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/category.dart';
import '../models/market.dart';
import '../models/product.dart';
import '../models/review.dart';
import '../helpers/global.dart';
import '../repository/slider_repository.dart';
import '../repository/category_repository.dart';
import '../repository/market_repository.dart';
import '../repository/product_repository.dart';
import '../repository/settings_repository.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:yaml/yaml.dart';
import 'dart:io';

class HomeController extends GetxController {
  List<Category> categories = <Category>[];
  List<Market> topMarkets = <Market>[];
  List<Market> topRests = <Market>[];
  List<Review> recentReviews = <Review>[];
  List<Product> trendingProducts = <Product>[];
  List<SliderProduct> sliders = <SliderProduct>[];
  GlobalKey<ScaffoldState> scaffoldKey;
  String version;
  // bool isAlertboxOpened;

  HomeController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForSliders();
    listenForCategories();
    listenForTopMarkets();
    listenForTopRests();
    Helper.getInstallDate();
    // checkAppVersion();
    // listenForRecentReviews();
    // listenForTrendingProducts();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    // FirebaseMessaging().getToken().then((value) => Helper.printToConsole(value));
    this.checkAppVersion(Get.context);
  }

  void setDisableUpdate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('disable_update_msg', true);
  }

  Future<void> goToGoogleReviews(context) async {
    Future.delayed(Duration(seconds: 3), () {
      showDialog(
          context: scaffoldKey.currentContext,
          barrierDismissible:
              true, // set to false if you want to force a rating
          builder: (context) {
            return RatingDialog(
              icon: Image.asset(
                'assets/img/google_play.png',
                // width: 100,
                // height: 100,
              ), // set your own image/icon widget
              title: "The Rating Dialog",
              description:
                  "Tap a star to set your rating. Add more description here if you want.",
              submitButton: "SUBMIT",
              // alternativeButton: "Contact us instead?", // optional
              // positiveComment: "We are so happy to hear :)", // optional
              // negativeComment: "We're sad to hear :(", // optional
              accentColor: Colors.red, // optional
              onSubmitPressed: (int rating) {
                Helper.printToConsole("onSubmitPressed: rating = $rating");
                Navigator.pop(context);
                Navigator.pop(context);
                // TODO: open the app's page on Google Play / Apple App Store
              },
              onAlternativePressed: () {
                Helper.printToConsole("onAlternativePressed: do something");
                // TODO: maybe you want the user to contact you instead of rating a bad review
              },
            );
          });
    });
  }

  Future<void> checkAppVersion(context) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentVersion = packageInfo.version;

    Future.delayed(Duration(seconds: 10), () {
      Helper.printToConsole('currentVersion $currentVersion');
      Helper.printToConsole('appVersion $appVersion');
      if (appVersion != currentVersion && showD && appVersion != null) {
        showDialog(
            context: Get.context,
            builder: (_) => NetworkGiffyDialog(
                  image: Image.asset(
                    "assets/img/Mriguel.jpg",
                    fit: BoxFit.cover,
                  ),
                  title: Text('عملا على تحسين تجربتكم يرجى تحديث التطبيق',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.w600)),
                  entryAnimation: EntryAnimation.BOTTOM,
                  onOkButtonPressed: () async {
                    showD = false;
                    const url =
                        'https://play.google.com/store/apps/details?id=com.mriguel.markets';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                    Navigator.pop(context);
                  },
                  buttonOkText: Text(
                    'تحديث',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  buttonCancelText: Text('تجاهل',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  onCancelButtonPressed: () {
                    showD = false;
                    Navigator.pop(context);
                    // setDisableUpdate();
                  },
                )).then((value) => Navigator.pop(context));
      }
    });
  }

  Future<void> listenForSliders() async {
    final Stream<SliderProduct> stream = await getSliders();
    stream.listen((SliderProduct _slider) {
      sliders.add(_slider);
    }, onError: (a) {
      Helper.printToConsole(a);
    }, onDone: () {
      update();
    });
  }

  Future<void> listenForCategories() async {
    final Stream<Category> stream = await getCategories();
    stream.listen((Category _category) {
      categories.add(_category);
    }, onError: (a) {
      Helper.printToConsole(a);
    }, onDone: () {
      update();
    });
  }

  Future<void> listenForTopMarkets() async {
    final Stream<Market> stream =
        await getNearMarkets(deliveryAddress.value, deliveryAddress.value);
    stream.listen(
        (Market _market) {
          topMarkets.add(_market);
        },
        onError: (a) {},
        onDone: () {
          update();
        });
  }

  Future<void> listenForTopRests() async {
    final Stream<Market> stream =
        await getRests(deliveryAddress.value, deliveryAddress.value);
    stream.listen(
        (Market _market) {
          topRests.add(_market);
        },
        onError: (a) {},
        onDone: () {
          update();
        });
  }

  Future<void> listenForRecentReviews() async {
    final Stream<Review> stream = await getRecentReviews();
    stream.listen(
        (Review _review) {
          recentReviews.add(_review);
        },
        onError: (a) {},
        onDone: () {
          update();
        });
  }

  // Future<void> listenForTrendingProducts() async {
  //   final Stream<Product> stream = await getTrendingProducts();
  //   stream.listen((Product _product) {
  //     setState(() => trendingProducts.add(_product));
  //   }, onError: (a) {
  //     Helper.printToConsole(a);
  //   }, onDone: () {});
  // }

  void requestForCurrentLocation(BuildContext context) {
    Helper.locationPermission();
    OverlayEntry loader = Helper.overlayLoader(context);
    Overlay.of(context).insert(loader);
    setCurrentLocation().then((_address) async {
      deliveryAddress.value = _address;
      await refreshHome();
      loader.remove();
    });
  }

  Future<void> refreshHome() async {
    categories = <Category>[];
    topMarkets = <Market>[];
    topRests = <Market>[];
    // recentReviews = <Review>[];
    trendingProducts = <Product>[];
    sliders = <SliderProduct>[];

    await listenForSliders();
    await listenForCategories();
    await listenForTopMarkets();
    await listenForTopRests();
    // await listenForRecentReviews();
    // await listenForTrendingProducts();
  }
}
