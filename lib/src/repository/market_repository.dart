import 'dart:convert';
import 'dart:io';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/helper.dart';
import '../models/address.dart';
import '../models/filter.dart';
import '../models/market.dart';
import '../models/review.dart';
import '../repository/user_repository.dart';

Future<Stream<Market>> getNearMarkets(
    Address myLocation, Address areaLocation) async {
  Uri uri = Helper.getUri('api/markets');
  Map<String, dynamic> _queryParams = {};
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Filter filter =
      Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));

  _queryParams['limit'] = '100';
  if (myLocation != null && areaLocation != null) {
    _queryParams['myLon'] = myLocation.longitude.toString();
    _queryParams['myLat'] = myLocation.latitude.toString();
    _queryParams['areaLon'] = areaLocation.longitude.toString();
    _queryParams['areaLat'] = areaLocation.latitude.toString();
  }
  // _queryParams['with'] = 'market';
  _queryParams['search'] = 'is_rest:0';
  _queryParams['searchFields'] = 'is_rest:=';
  _queryParams.addAll(filter.toQuery());
  uri = uri.replace(queryParameters: _queryParams);
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', uri));
  Helper.printToConsole(uri);
  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return Market.fromJSON(data);
  });
}

Future<Stream<Market>> getRests(
    Address myLocation, Address areaLocation) async {
  Uri uri = Helper.getUri('api/markets');
  Map<String, dynamic> _queryParams = {};
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Filter filter =
      Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));

  _queryParams['limit'] = '100';
  if (myLocation != null && areaLocation != null) {
    _queryParams['myLon'] = myLocation.longitude.toString();
    _queryParams['myLat'] = myLocation.latitude.toString();
    _queryParams['areaLon'] = areaLocation.longitude.toString();
    _queryParams['areaLat'] = areaLocation.latitude.toString();
  }

  _queryParams['search'] = 'is_rest:1';
  _queryParams['searchFields'] = 'is_rest:=';
  _queryParams.addAll(filter.toQuery());
  uri = uri.replace(queryParameters: _queryParams);

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', uri));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return Market.fromJSON(data);
  });
}

Future<Stream<Market>> searchMarkets(String search, Address address) async {
  // final String _searchParam = 'search=name:$search;description:$search&searchFields=name:like;description:like';
  final String _searchParam =
      'search=name:$search:$search&searchFields=name:like';
  final String _locationParam =
      'myLon=${address.longitude}&myLat=${address.latitude}&areaLon=${address.longitude}&areaLat=${address.latitude}';
  final String _orderLimitParam = 'orderBy=area&limit=5';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}markets?$_searchParam&$_locationParam&$_orderLimitParam';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return Market.fromJSON(data);
  });
}

Future<Stream<Market>> getMarket(String id, Address address) async {
  Uri uri = Helper.getUri('api/markets/$id');
  Map<String, dynamic> _queryParams = {};
  if (address != null) {
    _queryParams['myLon'] = address.longitude.toString();
    _queryParams['myLat'] = address.latitude.toString();
    _queryParams['areaLon'] = address.longitude.toString();
    _queryParams['areaLat'] = address.latitude.toString();
  }
  _queryParams['with'] = 'marketCategories';
  uri = uri.replace(queryParameters: _queryParams);
  Helper.printToConsole(uri.toString());
  Helper.printToConsole('------------------------------------------------');
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', uri));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .map((data) => Market.fromJSON(data));
}

Future<Stream<Review>> getMarketReviews(String id) async {
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}market_reviews?with=user&search=market_id:$id';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return Review.fromJSON(data);
  });
}

Future<Stream<Review>> getRecentReviews() async {
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}market_reviews?orderBy=updated_at&sortedBy=desc&limit=3&with=user';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return Review.fromJSON(data);
  });
}

Future<Review> addMarketReview(Review review, Market market, orderid) async {
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}market_reviews';
  final client = new http.Client();
  review.user = currentUser.value;
  review.orderId = orderid;
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(review.ofMarketToMap(market)),
  );
  Helper.printToConsole(response.body);
  if (response.statusCode == 200) {
    review = Review.fromJSON(json.decode(response.body)['data']);
  }
  return review;
}
