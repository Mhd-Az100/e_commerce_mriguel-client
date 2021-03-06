import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart';
import 'package:markets/src/elements/CircularLoadingWidget.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/i18n.dart';
import '../models/cart.dart';
import '../models/market.dart';
import '../models/product_order.dart';
import '../repository/settings_repository.dart';
import 'package:markets/src/models/paginate.dart';
import 'global.dart';

class Helper {
  // for mapping data retrieved form json array
  static getData(Map<String, dynamic> data) {
    return data['data'] ?? [];
  }

  static getDataWithPaginate(Map<String, dynamic> data) {
    // Helper.printToConsole(data['data']);
    productsPaginate = Paginate.fromJSON(data['data']);
    // Helper.printToConsole(productsPaginate.toMap());
    return data['data']['data'] ?? [];
  }

  static int getIntData(Map<String, dynamic> data) {
    return (data['data'] as int) ?? 0;
  }

  static Future<void> locationPermission() async {
    PermissionStatus permission =
        await LocationPermissions().requestPermissions();
  }

  static bool getBoolData(Map<String, dynamic> data) {
    return (data['data'] as bool) ?? false;
  }

  static getObjectData(Map<String, dynamic> data) {
    return data['data'] ?? new Map<String, dynamic>();
  }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  static Future<Marker> getMarker(Map<String, dynamic> res) async {
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/img/marker.png', 120);
    final Marker marker = Marker(
        markerId: MarkerId(res['id']),
        icon: BitmapDescriptor.fromBytes(markerIcon),
//        onTap: () {
//          //Helper.printToConsole(res.name);
//        },
        anchor: Offset(0.5, 0.5),
        infoWindow: InfoWindow(
            title: res['name'],
            snippet: res['distance'].toStringAsFixed(2) + ' mi',
            onTap: () {
              Helper.printToConsole('infowi tap');
            }),
        position: LatLng(
            double.parse(res['latitude']), double.parse(res['longitude'])));

    return marker;
  }

  static void printToConsole(text, {bool show = false}) {
    if (show) Helper.printToConsole(text);
  }

  static int doubleToDecimal(double number) {
    String fixedNumber = number.toStringAsFixed(3);
    int result = (double.parse(fixedNumber) * 1000).toInt();

    return result;
  }

  static void easyLoadingInstance() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Colors.yellow
      ..backgroundColor = Colors.green
      ..indicatorColor = Colors.yellow
      ..textColor = Colors.yellow
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..userInteractions = false
      ..dismissOnTap = false;
    // ..customAnimation = CustomAnimation();
  }

  static int randomNumber(max) {
    Random random = new Random();
    int randomNumber = random.nextInt(max);

    return randomNumber;
  }

  static Future<Marker> getMyPositionMarker(
      double latitude, double longitude) async {
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/img/my_marker.png', 120);
    final Marker marker = Marker(
        markerId: MarkerId(Random().nextInt(100).toString()),
        icon: BitmapDescriptor.fromBytes(markerIcon),
        anchor: Offset(0.5, 0.5),
        position: LatLng(latitude, longitude));

    return marker;
  }

  static List<Icon> getStarsList(double rate, {double size = 18}) {
    var list = <Icon>[];
    list = List.generate(rate.floor(), (index) {
      return Icon(Icons.star, size: size, color: Color(0xFFFFB24D));
    });
    if (rate - rate.floor() > 0) {
      list.add(Icon(Icons.star_half, size: size, color: Color(0xFFFFB24D)));
    }
    list.addAll(
        List.generate(5 - rate.floor() - (rate - rate.floor()).ceil(), (index) {
      return Icon(Icons.star_border, size: size, color: Color(0xFFFFB24D));
    }));
    return list;
  }

//  static Future<List> getPriceWithCurrency(double myPrice) async {
//    final Setting _settings = await getCurrentSettings();
//    List result = [];
//    if (myPrice != null) {
//      result.add('${myPrice.toStringAsFixed(2)}');
//      if (_settings.currencyRight) {
//        return '${myPrice.toStringAsFixed(2)} ' + _settings.defaultCurrency;
//      } else {
//        return _settings.defaultCurrency + ' ${myPrice.toStringAsFixed(2)}';
//      }
//    }
//    if (_settings.currencyRight) {
//      return '0.00 ' + _settings.defaultCurrency;
//    } else {
//      return _settings.defaultCurrency + ' 0.00';
//    }
//  }

  static Widget getPrice(double myPrice, BuildContext context,
      {TextStyle style, bool currency = false}) {
    if (style != null) {
      style = style.merge(TextStyle(fontSize: style.fontSize + 2));
    }
    try {
      return RichText(
        softWrap: false,
        overflow: TextOverflow.fade,
        maxLines: 1,
        text: setting.value?.currencyRight != null &&
                setting.value?.currencyRight == false
            ? TextSpan(
                text: currency == true ? setting.value?.defaultCurrency : '',
                style: style ?? Theme.of(context).textTheme.subhead,
                children: <TextSpan>[
                  TextSpan(
                      text: myPrice.toStringAsFixed(3) ?? '',
                      style: style ?? Theme.of(context).textTheme.subhead),
                ],
              )
            : TextSpan(
                text: myPrice.toStringAsFixed(3) ?? '',
                style: style ?? Theme.of(context).textTheme.subhead,
                children: <TextSpan>[
                  TextSpan(
                      text: currency == true
                          ? setting.value?.defaultCurrency
                          : '',
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: style != null
                              ? style.fontSize - 4
                              : Theme.of(context).textTheme.subhead.fontSize -
                                  4)),
                ],
              ),
      );
    } catch (e) {
      return Text('');
    }
  }

  static double getTotalOrderPrice(ProductOrder productOrder, double tax,
      double deliveryFee, double couponValue) {
    double total = productOrder.price * productOrder.quantity;
    productOrder.options.forEach((option) {
      total += option.price != null ? option.price : 0;
    });
    if (couponValue > 0) total -= total * (couponValue / 100);
    total += deliveryFee;
    total += tax * total / 100;
    return total;
  }

  static double getTotalProductPrice(ProductOrder productOrder) {
    double total = productOrder.price * productOrder.quantity;
    productOrder.options.forEach((option) {
      total += option.price != null ? option.price : 0;
    });
    // if(couponValue > 0)
    // total -= total * (couponValue / 100);
    // total += deliveryFee;
    // total += tax * total / 100;
    return total;
  }

  static String getDistance(double distance) {
    String unit = setting.value.distanceUnit;
    if (unit == 'km') {
      distance *= 1.60934;
    }
    return distance != null
        ? distance.toStringAsFixed(2) + " " + trans(unit)
        : "";
  }

  static bool canDelivery(Market _market, {List<Cart> carts}) {
    bool _can = true;
    carts?.forEach((Cart _cart) {
      _can &= _cart.product.deliverable;
    });
    _can &= _market.availableForDelivery &&
        (_market.distance <= _market.deliveryRange);
    return _can;
  }

  static String skipHtml(String htmlString) {
    var document = parse(htmlString);
    String parsedString = parse(document.body.text).documentElement.text;
    return parsedString;
  }

  static Future<int> getInstallDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('install_date')) {
      prefs.setString('install_date', DateTime.now().toString());
      return 0;
    }

    final installDate = prefs.getString('install_date');
    final dateNow = DateTime.now();
    final difference = dateNow.difference(DateTime.parse(installDate)).inDays;

    return difference;
  }

  static Future<bool> getFirstShow() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('show_dialog')) {
      return true;
    }

    prefs.setBool('show_dialog', true);
    return false;
  }

  static Html applyHtml(context, String html, {TextStyle style}) {
    return Html(
      blockSpacing: 0,
      data: html,
      defaultTextStyle: style ??
          Theme.of(context).textTheme.body2.merge(TextStyle(fontSize: 14)),
      useRichText: false,
      customRender: (node, children) {
        if (node is dom.Element) {
          switch (node.localName) {
            case "br":
              return SizedBox(
                height: 0,
              );
            case "p":
              return Padding(
                padding: EdgeInsets.only(top: 0, bottom: 0),
                child: Container(
                  width: double.infinity,
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.start,
                    children: children,
                  ),
                ),
              );
          }
        }
        return null;
      },
    );
  }

  static OverlayEntry overlayLoader(context) {
    OverlayEntry loader = OverlayEntry(builder: (context) {
      final size = MediaQuery.of(context).size;
      return Positioned(
        height: size.height,
        width: size.width,
        top: 0,
        left: 0,
        child: Material(
          color: Theme.of(context).primaryColor.withOpacity(0.85),
          child: CircularLoadingWidget(height: 200),
        ),
      );
    });
    return loader;
  }

  static hideLoader(OverlayEntry loader) {
    Timer(Duration(milliseconds: 500), () {
      try {
        loader?.remove();
      } catch (e) {}
    });
  }

  static String limitString(String text,
      {int limit = 24, String hiddenText = "..."}) {
    return text.substring(0, min<int>(limit, text.length)) +
        (text.length > limit ? hiddenText : '');
  }

  static String getCreditCardNumber(String number) {
    String result = '';
    if (number != null && number.isNotEmpty && number.length == 16) {
      result = number.substring(0, 4);
      result += ' ' + number.substring(4, 8);
      result += ' ' + number.substring(8, 12);
      result += ' ' + number.substring(12, 16);
    }
    return result;
  }

  static Uri getUri(String path) {
    String _path = Uri.parse(GlobalConfiguration().getString('base_url')).path;
    if (!_path.endsWith('/')) {
      _path += '/';
    }
    Uri uri = Uri(
        scheme: Uri.parse(GlobalConfiguration().getString('base_url')).scheme,
        host: Uri.parse(GlobalConfiguration().getString('base_url')).host,
        path: _path + path);
    return uri;
  }

  static String trans(String text) {
    switch (text) {
      case "App\\Notifications\\StatusChangedOrder":
        return S.current.order_status_changed;
      case "App\\Notifications\\NewOrder":
        return S.current.new_order_from_client;
      case "km":
        return S.current.km;
      case "mi":
        return S.current.mi;
      default:
        return "";
    }
  }
}
