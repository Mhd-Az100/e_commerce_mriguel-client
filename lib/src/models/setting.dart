import 'package:flutter/cupertino.dart';
import 'package:markets/src/helpers/helper.dart';

class Setting {
  String appName = '';
  double defaultTax;
  double minimum;
  String defaultCurrency;
  String distanceUnit;
  bool currencyRight = false;
  bool payPalEnabled = true;
  bool stripeEnabled = true;
  String mainColor;
  String mainDarkColor;
  String secondColor;
  String secondDarkColor;
  String accentColor;
  String accentDarkColor;
  String scaffoldDarkColor;
  String scaffoldColor;
  String googleMapsKey;
  ValueNotifier<Locale> mobileLanguage = new ValueNotifier(Locale('en', ''));
  String appVersion;
  String fcmKey;
  bool enableVersion = true;
  double maxDistance;
  double distanceFee;
  double distanceFeeOrder = 0;
  double marketFeeOrder;
  double maxMarket;
  double maxRadius;
  ValueNotifier<Brightness> brightness = new ValueNotifier(Brightness.light);

  Setting();

  Setting.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      appName = jsonMap['app_name'] ?? 'Mriguel';
      mainColor = jsonMap['main_color'] ?? '#ff6600';
      mainDarkColor = jsonMap['main_dark_color'] ?? '#ff6600';
      secondColor = jsonMap['second_color'] ?? '';
      secondDarkColor = jsonMap['second_dark_color'] ?? '';
      accentColor = jsonMap['accent_color'] ?? '';
      accentDarkColor = jsonMap['accent_dark_color'] ?? '';
      scaffoldDarkColor = jsonMap['scaffold_dark_color'] ?? '';
      scaffoldColor = jsonMap['scaffold_color'] ?? '';
      googleMapsKey = jsonMap['google_maps_key'] ?? null;
      mobileLanguage.value = Locale(jsonMap['mobile_language'] ?? "en", '');
      appVersion = jsonMap['app_version'] ?? '';
      distanceUnit = jsonMap['distance_unit'] ?? 'km';
      enableVersion = jsonMap['enable_version'] == null ? false : true;
      defaultTax = double.tryParse(jsonMap['default_tax']) ??
          0.0; //double.parse(jsonMap['default_tax'].toString());
      minimum = double.tryParse(jsonMap['minimum']) ?? 0.0;
      defaultCurrency = jsonMap['default_currency'] ?? '';
      currencyRight = jsonMap['currency_right'] == null ? false : true;
      payPalEnabled = jsonMap['enable_paypal'] == null ? false : true;
      stripeEnabled = jsonMap['enable_stripe'] == null ? false : true;
      maxDistance = jsonMap['max_distance'] == null
          ? 0
          : double.parse(jsonMap['max_distance']);
      distanceFee = jsonMap['distance_fee'] == null
          ? 0
          : double.parse(jsonMap['distance_fee']);
      marketFeeOrder = jsonMap['market_fee'] == null
          ? 0
          : double.parse(jsonMap['market_fee']);
      maxMarket = jsonMap['market_count'] == null
          ? 0
          : double.parse(jsonMap['market_count']);
      maxRadius = jsonMap['max_radius'] == null
          ? 0
          : double.parse(jsonMap['max_radius']);
      distanceFeeOrder = 0;
    } catch (e) {
      Helper.printToConsole(e);
    }
  }

//  ValueNotifier<Locale> initMobileLanguage(String defaultLanguage) {
//    SharedPreferences.getInstance().then((prefs) {
//      return new ValueNotifier(Locale(prefs.get('language') ?? defaultLanguage, ''));
//    });
//    return new ValueNotifier(Locale(defaultLanguage ?? "en", ''));
//  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["app_name"] = appName;
    map["app_version"] = appVersion;
    map["default_tax"] = defaultTax;
    map["default_currency"] = defaultCurrency;
    map["currency_right"] = currencyRight;
    map["enable_paypal"] = payPalEnabled;
    map["enable_stripe"] = stripeEnabled;
    map["mobile_language"] = mobileLanguage.value.languageCode;
    return map;
  }
}
