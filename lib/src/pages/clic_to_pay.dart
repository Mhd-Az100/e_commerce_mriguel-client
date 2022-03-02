import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';
import '../controllers/clic_to_pay_controller.dart';
import 'package:get/get.dart';

class ClicToPay extends StatefulWidget {
  const ClicToPay({Key key}) : super(key: key);

  @override
  _ClicToPayState createState() => _ClicToPayState();
}

class _ClicToPayState extends State<ClicToPay> {
  InAppWebViewController webView;

  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClicToPayController>(
      init: ClicToPayController(),
      builder: (controller) => SafeArea(
        child: Scaffold(
          body: controller.isLoading.value
              ? SizedBox(
                  height: 0,
                )
              : InAppWebView(
                  initialUrl: controller.url.value,
                  initialHeaders: {},

                  onWebViewCreated: (InAppWebViewController controller) {
                    // webView = controller;
                    // EasyLoading.show();
                  },
                  onLoadStart:
                      (InAppWebViewController appController, String url) {},
                  onLoadStop:
                      (InAppWebViewController appController, String url) {
                    // status = true;
                    controller.checkOutPage();
                    EasyLoading.dismiss();
                  },
                  // onWindowFocus: (controller) => {},
                ),
        ),
      ),
    );
  }
}
