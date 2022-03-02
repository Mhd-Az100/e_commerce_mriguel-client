import 'package:markets/src/models/category.dart';
import 'package:markets/src/models/user.dart';
import 'package:markets/src/models/day.dart';
import 'package:intl/intl.dart';
import 'package:markets/src/helpers/helper.dart';
import '../models/media.dart';

class Market {
  String id;
  String name;
  Media image;
  String rate;
  String address;
  String description;
  String phone;
  String mobile;
  String information;
  double deliveryFee;
  double adminCommission;
  double defaultTax;
  String latitude;
  String longitude;
  bool closed;
  bool availableForDelivery;
  bool uniqueStore;
  double deliveryRange;
  double distance;
  double minimum;
  List<User> users;
  List<Category> categories;
  List<Day> days;
  // List<Category> marketCategories;

  Market();

  Market.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'];
      image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0
          ? Media.fromJSON(jsonMap['media'][0])
          : new Media();
      days = jsonMap['days'] != null && (jsonMap['days'] as List).length > 0
          ? List.from(jsonMap['days'])
              .map((element) => Day.fromJSON(element))
              .toList()
          : [];
      rate = jsonMap['rate'] ?? '0';
      deliveryFee = jsonMap['delivery_fee'] != null
          ? jsonMap['delivery_fee'].toDouble()
          : 0.0;
      adminCommission = jsonMap['admin_commission'] != null
          ? jsonMap['admin_commission'].toDouble()
          : 0.0;
      deliveryRange = jsonMap['delivery_range'] != null
          ? jsonMap['delivery_range'].toDouble()
          : 0.0;
      address = jsonMap['address'];
      description = jsonMap['description'];
      phone = jsonMap['phone'];
      mobile = jsonMap['mobile'];
      defaultTax = jsonMap['default_tax'] != null
          ? jsonMap['default_tax'].toDouble()
          : 0.0;
      information = jsonMap['information'];
      latitude = jsonMap['latitude'];
      longitude = jsonMap['longitude'];
      closed = (jsonMap['closed_at'] != null && jsonMap['open_at'] != null)
          ? this.isClosed(
              startTime: jsonMap['open_at'], endTime: jsonMap['closed_at'])
          : true;
      availableForDelivery = jsonMap['available_for_delivery'] ?? false;
      uniqueStore = jsonMap['unique_store'] ?? false;
      distance = jsonMap['distance'] != null
          ? double.parse(jsonMap['distance'].toString())
          : 0.0;
      minimum = jsonMap['minimum'] != null
          ? double.parse(jsonMap['minimum'].toString())
          : 0.0;
      // users = jsonMap['users'] != null && (jsonMap['users'] as List).length > 0
      //     ? List.from(jsonMap['users'])
      //         .map((element) => User.fromJSON(element))
      //         .toSet()
      //         .toList()
      //     : [];
      categories = jsonMap['market_categories'] != null &&
              (jsonMap['market_categories'] as List).length > 0
          ? List.from(jsonMap['market_categories'])
              .map((element) => Category.fromJSON(element))
              .toSet()
              .toList()
          : [];
      // marketCategories = jsonMap['market_categories'] != null &&
      //         (jsonMap['market_categories'] as List).length > 0
      //     ? List.from(jsonMap['market_categories'])
      //         .map((element) => Category.fromMarketJSON(element))
      //         .toSet()
      //         .toList()
      //     : [];
    } catch (e) {
      id = '';
      name = '';
      image = new Media();
      rate = '0';
      deliveryFee = 0.0;
      adminCommission = 0.0;
      deliveryRange = 0.0;
      address = '';
      description = '';
      phone = '';
      mobile = '';
      defaultTax = 0.0;
      information = '';
      latitude = '0';
      longitude = '0';
      closed = false;
      availableForDelivery = false;
      distance = 0.0;
      users = [];
      Helper.printToConsole('============> $e');
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'delivery_fee': deliveryFee,
      'distance': distance,
    };
  }

  bool isClosed({String startTime, String endTime}) {
    final start = startTime.split(':');
    final end = endTime.split(':');
    final _startTime = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, int.parse(start[0]), int.parse(start[1]));
    final _endTime = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, int.parse(end[0]), int.parse(end[1]));
    final currentTime = DateTime.now();
    if (currentTime.isAfter(_startTime) &&
        currentTime.isBefore(_endTime) &&
        inDays()) return false;
    return true;
  }

  bool inDays() {
    if (this.days.length > 0) {
      String name = DateFormat('EEEE').format(DateTime.now());

      var day = this.days.firstWhere(
            (element) =>
                element.name.toString().toLowerCase() == name.toLowerCase(),
            orElse: () => null,
          );

      if (day != null) return true;
    }
    return false;
  }
}
