import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/i18n.dart';
import '../models/favorite.dart';
import '../repository/product_repository.dart';
import 'package:markets/src/helpers/helper.dart';

class FavoriteController extends ControllerMVC {
  List<Favorite> favorites = <Favorite>[];
  GlobalKey<ScaffoldState> scaffoldKey;

  FavoriteController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    listenForFavorites();
  }

  void listenForFavorites({String message}) async {
    final Stream<Favorite> stream = await getFavorites();
    stream.listen((Favorite _favorite) {
      setState(() {
        favorites.add(_favorite);
      });
    }, onError: (a) {
      Helper.printToConsole(a);
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(S.current.verify_your_internet_connection),
      ));
    }, onDone: () {
      if (message != null) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  Future<void> refreshFavorites() async {
    favorites.clear();
    listenForFavorites(message: 'Favorites refreshed successfuly');
  }

  void removeFromFavorite(Favorite _favorite) async {
    removeFavorite(_favorite).then((value) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('This product was removed from favorites'),
      ));
    }).whenComplete(() {
      favorites.clear();
      setState(() {});
      listenForFavorites();
    });
  }
}
