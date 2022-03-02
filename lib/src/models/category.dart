import '../models/media.dart';
import 'package:markets/src/helpers/helper.dart';

class Category {
  String id;
  String name;
  Media image;
  bool thisForMarket;
  bool select;
  List<Category> subCategories;

  Category({this.id, this.name});

  Category.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'];
      thisForMarket = false;
      image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0
          ? Media.fromJSON(jsonMap['media'][0])
          : new Media();

      subCategories =
          jsonMap['sub_cat'] != null && (jsonMap['sub_cat'] as List).length > 0
              ? List.from(jsonMap['sub_cat'])
                  .map((element) => Category.fromJSONWithSub(element))
                  .toSet()
                  .toList()
              : [];
    } catch (e) {
      id = '';
      name = '';
      thisForMarket = false;
      image = new Media();
      Helper.printToConsole(e);
    }
  }

  Category.fromJSONWithSub(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'];
      // select = false;
      image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0
          ? Media.fromJSON(jsonMap['media'][0])
          : new Media();
    } catch (e) {
      id = '';
      name = '';
      image = new Media();
      Helper.printToConsole(e);
    }
  }

  Category.fromMarketJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'];
      thisForMarket = true;
      image = jsonMap['media'] != null && (jsonMap['media'] as List).length > 0
          ? Media.fromJSON(jsonMap['media'][0])
          : new Media();
    } catch (e) {
      id = '';
      name = '';
      thisForMarket = false;
      image = new Media();
      Helper.printToConsole(e);
    }
  }
}
