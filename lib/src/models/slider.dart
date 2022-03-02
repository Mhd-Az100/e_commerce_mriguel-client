import '../models/media.dart';
import '../models/category.dart';
import 'package:markets/src/helpers/helper.dart';

class SliderProduct {
  String id;
  String name;
  String productID;
  String categoryID;
  String storeID;
  Media image;
  Category category;

  SliderProduct();

  SliderProduct.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'];
      productID = jsonMap['product_id'].toString();
      categoryID = jsonMap['cat_id'].toString();
      storeID = jsonMap['store_id'].toString();
      image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0
          ? Media.fromJSON(jsonMap['media'][0])
          : new Media();
      category = jsonMap['category'] != null
          ? Category.fromJSON(jsonMap['category'])
          : Category();
    } catch (e) {
      id = '';
      name = '';
      image = new Media();
      Helper.printToConsole('error caught: $e');
    }
  }
}
