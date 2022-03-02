import 'dart:convert';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;

import '../helpers/helper.dart';
import '../models/slider.dart';

Future<Stream<SliderProduct>> getSliders() async {
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}sliders?with=category';
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
  Helper.printToConsole(url);
  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) => SliderProduct.fromJSON(data));
}
