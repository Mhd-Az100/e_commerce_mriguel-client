import 'dart:convert';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:markets/src/helpers/helper.dart';

import 'package:markets/src/models/clictopay.dart';

Future<Stream<ClicToPay>> getOrderFormForPay({amount, orderNumber}) async {
  try {
    final String url =
        '${GlobalConfiguration().getString('clic_to_pay_url')}register.do?amount=$amount&currency=788&language=en&orderNumber=$orderNumber&password=N85SvZrx7&returnUrl=finish.html&userName=0870437019&jsonParams={"orderNumber":$orderNumber}&pageView=DESKTOP&expirationDate=2023-09-08T14:14:14';

    final client = new http.Client();
    final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

    Helper.printToConsole(url);
    return streamedRest.stream
        .transform(utf8.decoder)
        .transform(json.decoder)
        .map((data) {
      return ClicToPay.fromJSON(data);
    });
  } catch (e) {
    print('from order to pay $e');
  }
}
