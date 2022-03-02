import 'package:get/get.dart';
import 'package:markets/src/repository/cart_repository.dart';

class ShoppingCardController extends GetxController {
  var cartCount = 0.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  void setCardCount(int count) {
    this.cartCount.value = count;
    update();
  }
}
