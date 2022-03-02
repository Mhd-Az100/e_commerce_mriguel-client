import 'package:get/get.dart';
import 'package:markets/src/controllers/shopping_card_controller.dart';

class ShoppingCardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ShoppingCardController>(ShoppingCardController());
  }
}
