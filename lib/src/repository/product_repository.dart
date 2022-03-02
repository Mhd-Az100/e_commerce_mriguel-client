import 'dart:convert';
import 'dart:io';

import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/helper.dart';
import '../models/address.dart';
import '../models/favorite.dart';
import '../models/filter.dart';
import '../models/product.dart';
import '../models/review.dart';
import '../models/user.dart';
import '../models/category.dart';
import '../repository/user_repository.dart' as userRepo;

// Future<Stream<Product>> getTrendingProducts(marketId) async {
//   final String url = '${GlobalConfiguration().getString('api_base_url')}trending_prd/$marketId';

//   final client = new http.Client();
//   final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

//   return streamedRest.stream
//       .transform(utf8.decoder)
//       .transform(json.decoder)
//       .map((data) => Helper.getData(data))
//       .expand((data) => (data as List))
//       .map((data) {
//     return Product.fromJSON(data);
//   });
// }
Future<Stream<Product>> getTrendingProducts() async {
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}products?with=market&limit=200';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return Product.fromJSON(data);
  });
}

Future<Stream<Product>> getProduct(String productId) async {
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}products/$productId?with=market;category;options;optionGroups;productReviews;productReviews.user';
  Helper.printToConsole(
      '-------------------------------------------------------------------------------- $url');
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .map((data) {
    return Product.fromJSON(data);
  });
}

Future<Stream<Product>> searchProducts(String search, Address address) async {
  // final String _searchParam = 'search=name:$search;description:$search&searchFields=name:like;description:like';
  final String _searchParam = 'search=name:$search&searchFields=name:like';
  final String _locationParam =
      'myLon=${address.longitude}&myLat=${address.latitude}&areaLon=${address.longitude}&areaLat=${address.latitude}';
  final String _orderLimitParam = 'limit=10';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}products?$_searchParam&$_locationParam&$_orderLimitParam';
  Helper.printToConsole(url);

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return Product.fromJSON(data);
  });
}

Future<Stream<Product>> getProductsByCategory(categoryId) async {
  Uri uri = Helper.getUri('api/products');
  Map<String, dynamic> _queryParams = {};
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Filter filter =
      Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));
//  final String url =
//      '${GlobalConfiguration().getString('api_base_url')}products?with=market&search=category_id:$categoryId&searchFields=category_id:=';
  _queryParams['with'] = 'market';
  _queryParams['search'] = 'category_id:$categoryId;hide:0';
  _queryParams['searchFields'] = 'category_id:=;hide:=';
  _queryParams['orderBy'] = 'id';
  _queryParams['sortedBy'] = 'desc';

  _queryParams['paginate'] = true;
  // _queryParams['sub_cat'] = true;

  _queryParams = filter.toQuery(oldQuery: _queryParams);
  Helper.printToConsole(_queryParams);
  uri = uri.replace(queryParameters: _queryParams);
  Helper.printToConsole(uri.toString());

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', uri));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getDataWithPaginate(data))
      .expand((data) => (data as List))
      .map((data) {
    return Product.fromJSON(data);
  });
}

Future<Stream<Product>> getProductsByMarketCategory(categoryId, marketId,
    {Category category}) async {
  Uri uri = Helper.getUri('api/products');
  Map<String, dynamic> _queryParams = {};
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Filter filter =
      Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));
//  final String url =
//      '${GlobalConfiguration().getString('api_base_url')}products?with=market&search=category_id:$categoryId&searchFields=category_id:=';
  _queryParams['with'] = 'market';

  _queryParams['search'] =
      'market_category_id:$categoryId;market_id:$marketId;hide:0';
  _queryParams['searchFields'] = 'market_category_id:=;market_id:=';
  _queryParams['orderBy'] = 'in_stock';
  _queryParams['sortedBy'] = 'desc';
  _queryParams['groupBy'] = 'id';

  _queryParams['paginate'] = true;

  _queryParams = filter.toQuery(oldQuery: _queryParams);
  Helper.printToConsole(_queryParams);
  uri = uri.replace(queryParameters: _queryParams);
  Helper.printToConsole(uri.toString());

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', uri));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getDataWithPaginate(data))
      .expand((data) => (data as List))
      .map((data) {
    return Product.fromJSON(data);
  });
}

Future<Stream<Product>> getProductsByMarketSubCategory(
    {subcategoryId, marketId, Category category}) async {
  Uri uri = Helper.getUri('api/products');
  Map<String, dynamic> _queryParams = {};
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Filter filter =
      Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));
  _queryParams['with'] = 'market';

  _queryParams['search'] = 'sub_category_id:$subcategoryId';
  _queryParams['searchFields'] = 'sub_category_id:=';
  _queryParams['orderBy'] = 'id';
  _queryParams['sortedBy'] = 'desc';
  _queryParams['groupBy'] = 'market.id';

  _queryParams['paginate'] = true;

  _queryParams = filter.toQuery(oldQuery: _queryParams);
  Helper.printToConsole(_queryParams);
  uri = uri.replace(queryParameters: _queryParams);
  Helper.printToConsole(uri.toString());

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', uri));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getDataWithPaginate(data))
      .expand((data) => (data as List))
      .map((data) {
    return Product.fromJSON(data);
  });
}

Future<Stream<Product>> getProductsByMarketSubCategoryForMarket(
    {subcategoryId, marketId, Category category}) async {
  Uri uri = Helper.getUri('api/products');
  Map<String, dynamic> _queryParams = {};
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Filter filter =
      Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));
  _queryParams['with'] = 'market';
  _queryParams['search'] = _queryParams['search'] =
      'market_sub_category_id:$subcategoryId;market_id:$marketId;hide:0';
  _queryParams['searchFields'] = 'market_sub_category_id:=;market_id:=';
  _queryParams['orderBy'] = 'id';
  _queryParams['sortedBy'] = 'desc';
  _queryParams['groupBy'] = 'market.id';

  _queryParams['paginate'] = true;

  _queryParams = filter.toQuery(oldQuery: _queryParams);
  Helper.printToConsole(_queryParams);
  uri = uri.replace(queryParameters: _queryParams);
  Helper.printToConsole(uri.toString());

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', uri));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getDataWithPaginate(data))
      .expand((data) => (data as List))
      .map((data) {
    return Product.fromJSON(data);
  });
}

Future<Stream<Product>> getProductsMarketSubCategoriesByPaginate(
    page, categoryId, marketId) async {
  Uri uri = Helper.getUri('api/products');
  Map<String, dynamic> _queryParams = {};
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Filter filter =
      Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));
//  final String url =
//      '${GlobalConfiguration().getString('api_base_url')}products?with=market&search=category_id:$categoryId&searchFields=category_id:=';
  _queryParams['paginate'] = true;
  _queryParams['page'] = page.toString();

  _queryParams['with'] = 'market';

  _queryParams['search'] =
      'market_category_id:$categoryId;market_id:$marketId;hide:0';
  _queryParams['searchFields'] = 'market_category_id:=;market_id:=';
  _queryParams['orderBy'] = 'in_stock';
  _queryParams['sortedBy'] = 'desc';
  _queryParams['groupBy'] = 'id';

  _queryParams = filter.toQuery(oldQuery: _queryParams);
  Helper.printToConsole(_queryParams);
  uri = uri.replace(queryParameters: _queryParams);
  Helper.printToConsole(uri.toString());

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', uri));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getDataWithPaginate(data))
      .expand((data) => (data as List))
      .map((data) {
    return Product.fromJSON(data);
  });
}

Future<Stream<Product>> getProductsMarketSubCategoriesByPaginateSubCat(
    page, categoryId, marketId, subCat) async {
  Uri uri = Helper.getUri('api/products');
  Map<String, dynamic> _queryParams = {};
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Filter filter =
      Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));
//  final String url =
//      '${GlobalConfiguration().getString('api_base_url')}products?with=market&search=category_id:$categoryId&searchFields=category_id:=';
  _queryParams['paginate'] = true;
  _queryParams['page'] = page.toString();

  _queryParams['with'] = 'market';

  _queryParams['search'] =
      'market_category_id:$categoryId;market_id:$marketId;market_sub_category_id:$subCat;hide:0';
  _queryParams['searchFields'] =
      'market_category_id:=;market_id:=;market_sub_category_id:=';
  _queryParams['orderBy'] = 'in_stock';
  _queryParams['sortedBy'] = 'desc';
  _queryParams['groupBy'] = 'id';

  _queryParams = filter.toQuery(oldQuery: _queryParams);
  Helper.printToConsole(_queryParams);
  uri = uri.replace(queryParameters: _queryParams);
  Helper.printToConsole(uri.toString());

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', uri));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getDataWithPaginate(data))
      .expand((data) => (data as List))
      .map((data) {
    return Product.fromJSON(data);
  });
}

Future<Stream<Product>> getProductsByMarketSubCategoryPaginate(
    {subcategoryId, marketId, Category category, page}) async {
  Uri uri = Helper.getUri('api/products');
  Map<String, dynamic> _queryParams = {};
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Filter filter =
      Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));
  _queryParams['with'] = 'market';

  _queryParams['search'] = 'sub_category_id:$subcategoryId';
  _queryParams['searchFields'] = 'sub_category_id:=';
  _queryParams['orderBy'] = 'id';
  _queryParams['sortedBy'] = 'desc';
  _queryParams['page'] = page.toString();

  _queryParams['paginate'] = true;

  _queryParams = filter.toQuery(oldQuery: _queryParams);
  Helper.printToConsole(_queryParams);
  uri = uri.replace(queryParameters: _queryParams);
  Helper.printToConsole(uri.toString());

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', uri));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getDataWithPaginate(data))
      .expand((data) => (data as List))
      .map((data) {
    return Product.fromJSON(data);
  });
}

Future<Stream<Product>> getProductsByPaginate(page, categoryId) async {
  Uri uri = Helper.getUri('api/products');
  Map<String, dynamic> _queryParams = {};
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Filter filter =
      Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));
//  final String url =
//      '${GlobalConfiguration().getString('api_base_url')}products?with=market&search=category_id:$categoryId&searchFields=category_id:=';
  _queryParams['with'] = 'market';
  _queryParams['search'] = 'category_id:$categoryId;hide:0';
  _queryParams['searchFields'] = 'category_id:=;hide:=';
  _queryParams['paginate'] = true;
  _queryParams['sub_cat'] = true;
  _queryParams['orderBy'] = 'id';
  _queryParams['sortedBy'] = 'desc';
  _queryParams['page'] = page.toString();

  _queryParams = filter.toQuery(oldQuery: _queryParams);
  Helper.printToConsole(_queryParams);
  uri = uri.replace(queryParameters: _queryParams);
  Helper.printToConsole(uri.toString());

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', uri));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getDataWithPaginate(data))
      .expand((data) => (data as List))
      .map((data) {
    return Product.fromJSON(data);
  });
}

Future<Stream<Product>> getSubCatProductsByMarketPaginate(
    page, categoryId, marketId,
    {Category category}) async {
  Uri uri = Helper.getUri('api/products');
  Map<String, dynamic> _queryParams = {};
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Filter filter =
      Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));
//  final String url =
//      '${GlobalConfiguration().getString('api_base_url')}products?with=market&search=category_id:$categoryId&searchFields=category_id:=';
  _queryParams['with'] = 'market';

  _queryParams['search'] = 'sub_category_id:$categoryId;hide:0';
  _queryParams['searchFields'] = 'sub_category_id:=;hide:=';

  _queryParams['paginate'] = true;
  _queryParams['page'] = page.toString();

  _queryParams = filter.toQuery(oldQuery: _queryParams);
  Helper.printToConsole(_queryParams);
  uri = uri.replace(queryParameters: _queryParams);
  Helper.printToConsole(uri.toString());

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', uri));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getDataWithPaginate(data))
      .expand((data) => (data as List))
      .map((data) {
    return Product.fromJSON(data);
  });
}

Future<Stream<Product>> getProductsByMarketPaginate(page, categoryId, marketId,
    {Category category}) async {
  Uri uri = Helper.getUri('api/products');
  Map<String, dynamic> _queryParams = {};
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Filter filter =
      Filter.fromJSON(json.decode(prefs.getString('filter') ?? '{}'));
//  final String url =
//      '${GlobalConfiguration().getString('api_base_url')}products?with=market&search=category_id:$categoryId&searchFields=category_id:=';
  _queryParams['with'] = 'market';

  _queryParams['search'] =
      'market_category_id:$categoryId;market_id:$marketId;hide:0';
  _queryParams['searchFields'] = 'market_category_id:=;market_id:=;hide:=';
  _queryParams['orderBy'] = 'in_stock';
  _queryParams['sortedBy'] = 'desc';
  _queryParams['groupBy'] = 'id';

  _queryParams['paginate'] = true;
  _queryParams['page'] = page.toString();

  _queryParams = filter.toQuery(oldQuery: _queryParams);
  Helper.printToConsole(_queryParams);
  uri = uri.replace(queryParameters: _queryParams);
  Helper.printToConsole(uri.toString());

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', uri));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getDataWithPaginate(data))
      .expand((data) => (data as List))
      .map((data) {
    return Product.fromJSON(data);
  });
}

Future<Stream<Favorite>> isFavoriteProduct(String productId) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return Stream.value(null);
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}favorites/exist?${_apiToken}product_id=$productId&user_id=${_user.id}';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getObjectData(data))
      .map((data) => Favorite.fromJSON(data));
}

Future<Stream<Favorite>> getFavorites() async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return Stream.value(null);
  }
  final String _apiToken = 'api_token=${_user.apiToken}&';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}favorites?${_apiToken}with=product;user;options&search=user_id:${_user.id}&searchFields=user_id:=';

  Helper.printToConsole(url);
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) => Favorite.fromJSON(data));
}

Future<Favorite> addFavorite(Favorite favorite) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Favorite();
  }
  final String _apiToken = 'api_token=${_user.apiToken}';
  favorite.userId = _user.id;
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}favorites?$_apiToken';
  final client = new http.Client();
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(favorite.toMap()),
  );
  return Favorite.fromJSON(json.decode(response.body)['data']);
}

Future<Favorite> removeFavorite(Favorite favorite) async {
  User _user = userRepo.currentUser.value;
  if (_user.apiToken == null) {
    return new Favorite();
  }
  final String _apiToken = 'api_token=${_user.apiToken}';
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}favorites/${favorite.id}?$_apiToken';
  final client = new http.Client();
  final response = await client.delete(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
  );
  return Favorite.fromJSON(json.decode(response.body)['data']);
}

Future<Stream<Product>> getProductsOfMarket(String marketId) async {
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}products?with=market&search=market.id:$marketId;hide:0&searchFields=market.id:=;hide:=&searchJoin=and';

  Helper.printToConsole(url);
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return Product.fromJSON(data);
  });
}

Future<Stream<Product>> getTrendingProductsOfMarket(String marketId) async {
  // TODO Trending products only
  final String url =
      // '${GlobalConfiguration().getString('api_base_url')}products?with=market&search=market.id:$marketId&searchFields=market.id:=';
      '${GlobalConfiguration().getString('api_base_url')}trending_prd/$marketId';

  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));

  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return Product.fromJSON(data);
  });
}

Future<Stream<Product>> getFeaturedProductsOfMarket(String marketId) async {
  // TODO Featured products only
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}products?with=market&search=market_id:$marketId;featured:1;hide:0&searchFields=market_id:=;featured:=;hide:=&searchJoin=and&orderBy=updated_at&sortedBy=desc';
  final client = new http.Client();
  final streamedRest = await client.send(http.Request('get', Uri.parse(url)));
  Helper.printToConsole(url);
  Helper.printToConsole('ddddddddd--------------------------------------');
  return streamedRest.stream
      .transform(utf8.decoder)
      .transform(json.decoder)
      .map((data) => Helper.getData(data))
      .expand((data) => (data as List))
      .map((data) {
    return Product.fromJSON(data);
  });
}

Future<Review> addProductReview(Review review, Product product) async {
  final String url =
      '${GlobalConfiguration().getString('api_base_url')}product_reviews';
  final client = new http.Client();
  review.user = userRepo.currentUser.value;
  final response = await client.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: json.encode(review.ofProductToMap(product)),
  );
  if (response.statusCode == 200) {
    review = Review.fromJSON(json.decode(response.body)['data']);
  }
  return review;
}
