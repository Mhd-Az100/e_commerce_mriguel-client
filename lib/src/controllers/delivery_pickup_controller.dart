import 'package:flutter/material.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/i18n.dart';
import '../models/address.dart' as model;
import '../models/cart.dart';
import '../repository/cart_repository.dart';
import '../repository/settings_repository.dart' as settingRepo;
import '../repository/user_repository.dart' as userRepo;
import 'package:markets/src/helpers/helper.dart';

class DeliveryPickupController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;
  model.Address deliveryAddress;
  List<model.Address> addresses = <model.Address>[];
  List<Cart> carts = [];
  OverlayEntry loader;

  DeliveryPickupController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    loader = Helper.overlayLoader(scaffoldKey.currentContext);
    listenForCart();
    listenForDeliveryAddress();
    listenForAddresses();
    Helper.printToConsole(settingRepo.deliveryAddress.value.toMap());
  }

  void listenForAddresses({String message}) async {
    this.addresses.clear();
    final Stream<model.Address> stream = await userRepo.getAddresses();
    stream.listen((model.Address _address) {
      setState(() {
        addresses.add(_address);
      });
    }, onError: (a) {
      // Helper.printToConsole(a);
      loader.remove();
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(S.current.verify_your_internet_connection),
      ));
    }, onDone: () {
      Helper.hideLoader(loader);
      if (message != null) {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(message),
        ));
      }
    });
  }

  void listenForCart() async {
    final Stream<Cart> stream = await getCart();
    stream.listen((Cart _cart) {
      setState(() {
        carts.add(_cart);
      });
    });
  }

  void listenForDeliveryAddress() async {
    this.deliveryAddress = settingRepo.deliveryAddress.value;
    Helper.printToConsole(this.deliveryAddress.id);
  }

  void addAddress(model.Address address) {
    FocusScope.of(scaffoldKey.currentContext).unfocus();
    Overlay.of(scaffoldKey.currentContext).insert(loader);
    userRepo.addAddress(address).then((value) {
      // loader.remove();
      setState(() {
        settingRepo.deliveryAddress.value = value;
        this.deliveryAddress = value;
      });
    }).whenComplete(() {
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.current.new_address_added_successfully),
      ));
      // listenForAddresses();
    });
  }

  void addAddressFromDelivery(model.Address address) {
    FocusScope.of(scaffoldKey.currentContext).unfocus();
    Overlay.of(scaffoldKey.currentContext).insert(loader);
    userRepo.addAddress(address).then((value) async {
      // loader.remove();
      // setState(() async {
      settingRepo.deliveryAddress.value = value;
      this.deliveryAddress = value;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('select_address_id', value.id);
      // });
    }).catchError((e) {
      loader.remove();
    }).whenComplete(() {
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.current.new_address_added_successfully),
      ));
      Helper.hideLoader(loader);
      listenForAddresses();
      // Navigator.of(scaffoldKey.currentContext).pushNamed('/PaymentMethod');
    });
  }

  void updateAddress(model.Address address) {
    userRepo.updateAddress(address).then((value) {
      setState(() {
        settingRepo.deliveryAddress.value = value;
        this.deliveryAddress = value;
      });
    }).whenComplete(() {
      scaffoldKey?.currentState?.showSnackBar(SnackBar(
        content: Text(S.current.the_address_updated_successfully),
      ));
    });
  }

  void removeDeliveryAddress(model.Address address) async {
    userRepo.removeDeliveryAddress(address).then((value) {
      setState(() {
        this.addresses.remove(address);
      });
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(S.current.delivery_address_removed_successfully),
      ));
    });
  }
}
