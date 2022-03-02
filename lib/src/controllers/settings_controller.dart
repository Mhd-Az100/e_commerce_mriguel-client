import 'package:flutter/material.dart';
import 'package:markets/src/helpers/global.dart';
import 'package:markets/src/repository/settings_repository.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/i18n.dart';
import '../models/credit_card.dart';
import '../models/user.dart';
import '../models/route_argument.dart';
import '../repository/user_repository.dart' as repository;

class SettingsController extends ControllerMVC {
  CreditCard creditCard = new CreditCard();
  GlobalKey<FormState> loginFormKey;
  GlobalKey<ScaffoldState> scaffoldKey;

  SettingsController() {
    loginFormKey = new GlobalKey<FormState>();
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
  }

  void update(User user) async {
    user.deviceToken = null;
    repository.update(user).then((value) {
     if(value != null)
      {
        if(repository.currentUser.value.phone == 'null') scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text(S.current.wrong_phone),
                              ));
        else scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(S.current.profile_settings_updated_successfully),
        ));

        if(cart && repository.currentUser.value.phone != "null") Navigator.of(scaffoldKey.currentContext).pushNamed('/Cart', arguments: RouteArgument(param: '/Pages', id: '2'));
        setState(() {});
      }
      else scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(S.current.wrong_phone),
      ));
    }).catchError((){
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(S.current.wrong_phone),
      ));
    });
    
  }
  void updatePhone(User user) async {
    user.deviceToken = null;
    repository.update(user).then((value) {
     if(value != null)
      {
        if(repository.currentUser.value.phone == 'null') scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text(S.current.wrong_phone),
                              ));
        else{
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(S.current.profile_settings_updated_successfully),
          ));
          // Navigator.of(scaffoldKey.currentContext).pop();
        } 

        if(cart && repository.currentUser.value.phone != "null") Navigator.of(scaffoldKey.currentContext).pop();
        setState(() {});
      }
      else scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(S.current.wrong_phone),
      ));
    }).catchError((){
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(S.current.wrong_phone),
      ));
    });
    
  }

  void updateCreditCard(CreditCard creditCard) {
    repository.setCreditCard(creditCard).then((value) {
      setState(() {});
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(S.current.payment_settings_updated_successfully),
      ));
    });
  }

  void listenForUser() async {
    creditCard = await repository.getCreditCard();
    setState(() {});
  }

  Future<void> refreshSettings() async {
    creditCard = new CreditCard();
  }
}
