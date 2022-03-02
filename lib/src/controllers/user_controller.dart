import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:markets/src/helpers/helper.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flushbar/flushbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

import '../../generated/i18n.dart';
import '../models/user.dart';
import '../repository/user_repository.dart' as repository;

class UserController extends ControllerMVC {
  User user = new User();
  bool hidePassword = true;
  bool _isLoggedIn = false;
  OverlayEntry loader;
  GlobalKey<FormState> loginFormKey;
  GlobalKey<ScaffoldState> scaffoldKey;
  FirebaseMessaging _firebaseMessaging;
  static final FacebookLogin facebookSignIn = new FacebookLogin();
  Map userProfile;

  UserController() {
    loginFormKey = new GlobalKey<FormState>();
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.getToken().then((String _deviceToken) {
      user.deviceToken = _deviceToken;
      Helper.printToConsole(user.deviceToken);
    });
    loader = Helper.overlayLoader(scaffoldKey.currentContext);
  }

  Future<Null> loginwithfb() async {
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${accessToken.token}');
        final profile = JSON.jsonDecode(graphResponse.body);
        // Helper.printToConsole('''
        //  Logged in!

        //  Token: ${accessToken.token}
        //  User id: ${accessToken.userId}
        //  Expires: ${accessToken.expires}
        //  Permissions: ${accessToken.permissions}
        //  Declined permissions: ${accessToken.declinedPermissions}
        //  ''');
        User user = new User();
        user.name = profile['name'];
        user.email = profile['email'];
        user.fbID = profile['id'];
        user.fbToken = result.accessToken.token;
        Helper.printToConsole(profile);
        registerAndLoginWithFb(user);
        break;
      case FacebookLoginStatus.cancelledByUser:
        Helper.printToConsole('Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
        Helper.printToConsole('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }
  }

  Future<Null> loginwithGg(_currentUser) async {
    User _user = new User();
    _user.name = _currentUser.displayName;
    _user.email = _currentUser.email;
    registerAndLoginWithGg(_user);
  }

  void login() async {
    FocusScope.of(scaffoldKey.currentContext).unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      Overlay.of(scaffoldKey.currentContext).insert(loader);
      repository.login(user).then((value) {
        //Helper.printToConsole(value.apiToken);
        if (value != null && value.apiToken != null) {
          loader.remove();
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(S.current.welcome + value.name),
            behavior: SnackBarBehavior.floating,
          ));
          Navigator.of(scaffoldKey.currentContext)
              .pushReplacementNamed('/Pages', arguments: 1);
        } else {
          loader.remove();
          // scaffoldKey.currentState.showSnackBar(SnackBar(
          //   content: Text(S.current.wrong_email_or_password),
          //   behavior: SnackBarBehavior.floating,
          // ));
          Flushbar(
            title: "Ooops !!",
            message: S.current.wrong_email_or_password,
            duration: Duration(seconds: 3),
            flushbarPosition: FlushbarPosition.TOP,
          )..show(scaffoldKey.currentState.context);
        }
      }).catchError((e) {
        loader.remove();
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });
    }
  }

  void register() async {
    FocusScope.of(scaffoldKey.currentContext).unfocus();
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      Overlay.of(scaffoldKey.currentContext).insert(loader);
      repository.register(user).then((value) {
        if (value != null && value.apiToken != null) {
          loader.remove();
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(S.current.welcome + value.name),
          ));
          Navigator.of(scaffoldKey.currentContext)
              .pushReplacementNamed('/Pages', arguments: 1);
        } else {
          loader.remove();
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(S.current.wrong_email_or_password),
          ));
        }
      }).catchError(() {
        loader.remove();
      }).whenComplete(() {
        Helper.hideLoader(loader);
      });
    }
  }

  void registerAndLoginWithFb(User user) async {
    FocusScope.of(scaffoldKey.currentContext).unfocus();
    Overlay.of(scaffoldKey.currentContext).insert(loader);
    repository.registerOrLogin(user).then((value) {
      if (value != null && value.apiToken != null) {
        loader.remove();
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(S.current.welcome + value.name),
        ));
        Navigator.of(scaffoldKey.currentContext)
            .pushReplacementNamed('/Pages', arguments: 1);
      } else {
        loader.remove();
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(S.current.wrong_email_or_password),
        ));
      }
    }).catchError(() {
      loader.remove();
    }).whenComplete(() {
      Helper.hideLoader(loader);
    });
  }

  void registerAndLoginWithGg(User user) async {
    FocusScope.of(scaffoldKey.currentContext).unfocus();
    Overlay.of(scaffoldKey.currentContext).insert(loader);
    repository.registerOrLoginWithGg(user).then((value) {
      if (value != null && value.apiToken != null) {
        loader.remove();
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(S.current.welcome + value.name),
        ));
        Navigator.of(scaffoldKey.currentContext)
            .pushReplacementNamed('/Pages', arguments: 1);
      } else {
        loader.remove();
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(S.current.wrong_email_or_password),
        ));
      }
    }).catchError(() {
      loader.remove();
    }).whenComplete(() {
      Helper.hideLoader(loader);
    });
  }

  void resetPassword() {
    if (loginFormKey.currentState.validate()) {
      loginFormKey.currentState.save();
      repository.resetPassword(user).then((value) {
        if (value != null && value == true) {
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content:
                Text(S.current.your_reset_link_has_been_sent_to_your_email),
            action: SnackBarAction(
              label: S.current.login,
              onPressed: () {
                Navigator.of(scaffoldKey.currentContext)
                    .pushReplacementNamed('/Login');
              },
            ),
            duration: Duration(seconds: 10),
          ));
        } else {
          scaffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(S.current.error_verify_email_settings),
          ));
        }
      });
    }
  }
}
