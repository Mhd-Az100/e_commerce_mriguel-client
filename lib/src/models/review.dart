import '../models/market.dart';
import '../models/product.dart';
import '../models/user.dart';
import 'package:markets/src/helpers/helper.dart';

class Review {
  String id;
  String orderId;
  String review;
  String review2;
  String rate;
  String rate2;
  User user;

  Review();
  Review.init(this.rate);

  Review.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      review = jsonMap['review'];
      review2 = '';
      rate2 = '0';
      rate = jsonMap['rate'].toString() ?? '0';
      user =
          jsonMap['user'] != null ? User.fromJSON(jsonMap['user']) : new User();
    } catch (e) {
      id = '';
      review = '';
      review2 = '';
      rate = '0';
      rate2 = '0';
      user = new User();
      Helper.printToConsole(e);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["review"] = review == '' ? review2 : review;
    map["rate"] = rate == '0' ? rate2 : rate;
    map["user_id"] = user?.id;
    map["order_id"] = orderId;
    return map;
  }

  @override
  String toString() {
    return this.toMap().toString();
  }

  Map ofMarketToMap(Market market) {
    var map = this.toMap();
    map["market_id"] = market?.id == null ? null : market.id;
    map["order_id"] = orderId;
    return map;
  }

  Map ofProductToMap(Product product) {
    var map = this.toMap();
    map["product_id"] = product.id;
    return map;
  }
}
