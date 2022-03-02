import 'package:get/get.dart';
import 'package:markets/src/helpers/global.dart';
import 'package:markets/src/models/clictopay.dart';
import 'package:markets/src/models/route_argument.dart';
import '../repository/clic_to_pay_repository.dart';
import '../helpers/helper.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ClicToPayController extends GetxController {
  var url = ''.obs;
  var isLoading = true.obs;
  int step = 0;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    this.listenForPayment();
  }

//https://test.clictopay.com/payment/rest/
  //register.do?amount=340&currency=788&
  //language=en&orderNumber=4454321&password=N85SvZrx7&
  //returnUrl=finish.html&userName=0870437019&jsonParams=
  //{%22orderNumber%22:1234567890}&pageView=DESKTOP&
  //expirationDate=2022-09-08T14:14:14

  void listenForPayment({String message}) async {
    EasyLoading.show();
    int orderNumber = Helper.randomNumber(9999999);
    final Stream<ClicToPay> stream = await getOrderFormForPay(
      orderNumber: orderNumber,
      amount: Helper.doubleToDecimal(totalAmount),
    );
    stream.listen((ClicToPay _clictopay) {
      if (_clictopay != null) {
        this.url.value = _clictopay.formUrl;
        isLoading.value = false;
        update();
      }

      Helper.printToConsole(this.url.value);
    }, onError: (a) {
      print('from listenForPayment $a');
      EasyLoading.dismiss();
    }, onDone: () {});
  }

  void checkOutPage() {
    step++;
    if (step == 2) {
      Get.toNamed('/CashOnDelivery',
          arguments: new RouteArgument(param: 'Credit Card'));
    }
  }
}
