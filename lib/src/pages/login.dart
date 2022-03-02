import 'package:flutter/material.dart';
import 'package:markets/src/models/user.dart';
// import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:sign_button/sign_button.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/i18n.dart';
import '../controllers/user_controller.dart';
import '../elements/BlockButtonWidget.dart';
import '../helpers/app_config.dart' as config;
import '../repository/user_repository.dart' as userRepo;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:markets/src/helpers/helper.dart';

class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends StateMVC<LoginWidget> {
  UserController _con;
  GoogleSignIn _googleSignIn;
  GoogleSignInAccount _currentUser;
  bool _signin = false;

  _LoginWidgetState() : super(UserController()) {
    _con = controller;
  }

  Future<void> _handleSignIn() async {
    try {
      _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
        // setState(() {
        _currentUser = account;
        // _handleSignOut();
        // Helper.printToConsole(_currentUser.displayName);
        if (_currentUser.email != null) {
          Helper.printToConsole(_currentUser.displayName);
          _con.loginwithGg(_currentUser);
        }
        // });
      });
      _googleSignIn.signInSilently();
      // _handleSignOut();
      await _googleSignIn.isSignedIn().then((value) => _signin = value);

      if (_signin) {
        Helper.printToConsole(_currentUser.displayName);
        _con.loginwithGg(_currentUser);
      } else
        await _googleSignIn.signIn().whenComplete(() {
          Helper.printToConsole(_currentUser.displayName);
          _con.loginwithGg(_currentUser);
        });

      // Helper.printToConsole(_currentUser.displayName);
    } catch (error) {
      Helper.printToConsole(error);
      // _handleSignIn();
    }
  }

  Future<void> _handleSignOut() async {
    await _googleSignIn.isSignedIn().then((value) => _signin = value);
  }

  @override
  void initState() {
    _googleSignIn = GoogleSignIn();
    // _handleSignOut();
    super.initState();
    if (userRepo.currentUser.value.apiToken != null) {
      Navigator.of(context).pushReplacementNamed('/Pages', arguments: 1);
    }
    // if(_signin) _googleSignIn.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: <Widget>[
          Positioned(
            top: 0,
            child: Container(
              width: config.App(context).appWidth(100),
              height: config.App(context).appHeight(37),
              decoration: BoxDecoration(color: Theme.of(context).accentColor),
            ),
          ),
          Positioned(
            top: config.App(context).appHeight(37) - 120,
            child: Container(
              width: config.App(context).appWidth(84),
              height: config.App(context).appHeight(37),
              child: Text(
                S.of(context).lets_start_with_login,
                style: Theme.of(context)
                    .textTheme
                    .display3
                    .merge(TextStyle(color: Theme.of(context).primaryColor)),
              ),
            ),
          ),
          Positioned(
            top: config.App(context).appHeight(37) - 50,
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(10.w)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 50.w,
                      color: Theme.of(context).hintColor.withOpacity(0.2),
                    )
                  ]),
              margin: EdgeInsets.symmetric(
                horizontal: 20,
              ),
              padding: EdgeInsets.only(
                  top: 50.w, right: 27.w, left: 27.w, bottom: 20.w),
              width: config.App(context).appWidth(88),
//              height: config.App(context).appHeight(55),
              child: Form(
                key: _con.loginFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      onSaved: (input) => _con.user.phone = input,
                      //validator: (input) => !input.contains('@') ? S.of(context).should_be_a_valid_email : null,
                      decoration: InputDecoration(
                        labelText: S.of(context).phone,
                        labelStyle:
                            TextStyle(color: Theme.of(context).accentColor),
                        contentPadding: EdgeInsets.all(12.w),
                        hintText: 'XXX-XXX-XXX',
                        hintStyle: TextStyle(
                            color:
                                Theme.of(context).focusColor.withOpacity(0.7)),
                        prefixIcon: Icon(Icons.phone_android,
                            color: Theme.of(context).accentColor),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.2))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.5))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.2))),
                      ),
                    ),
                    SizedBox(height: 30.w),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      onSaved: (input) => _con.user.password = input,
                      validator: (input) => input.length < 3
                          ? S.of(context).should_be_more_than_3_characters
                          : null,
                      obscureText: _con.hidePassword,
                      decoration: InputDecoration(
                        labelText: S.of(context).password,
                        labelStyle:
                            TextStyle(color: Theme.of(context).accentColor),
                        contentPadding: EdgeInsets.all(12.w),
                        hintText: '••••••••••••',
                        hintStyle: TextStyle(
                            color:
                                Theme.of(context).focusColor.withOpacity(0.7)),
                        prefixIcon: Icon(Icons.lock_outline,
                            color: Theme.of(context).accentColor),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _con.hidePassword = !_con.hidePassword;
                            });
                          },
                          color: Theme.of(context).focusColor,
                          icon: Icon(_con.hidePassword
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.2))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.5))),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.2))),
                      ),
                    ),
                    SizedBox(height: 30.w),
                    BlockButtonWidget(
                      text: Text(
                        S.of(context).login,
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ),
                      color: Theme.of(context).accentColor,
                      onPressed: () {
                        _con.login();
                      },
                    ),
                    SizedBox(height: 15.w),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SignInButton.mini(
                          // Buttons.Facebook,
                          // btnText: "Login with Facebook",
                          buttonType: ButtonType.facebook,
                          buttonSize: ButtonSize.small,
                          onPressed: () => _con.loginwithfb(),
                        ),
                        SignInButton.mini(
                            buttonType: ButtonType.google,
                            buttonSize: ButtonSize.small,
                            onPressed: () {
                              // Helper.printToConsole('click');
                              _handleSignIn();
                            }),
                      ],
                    ),
                    // SizedBox(height: 15),
                    SizedBox(height: 15.w),
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed('/Pages', arguments: 1);
                      },
                      shape: StadiumBorder(),
                      textColor: Theme.of(context).hintColor,
                      child: Text(S.of(context).skip),
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.w, vertical: 14.w),
                    ),
//                      SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10.w,
            child: Column(
              children: <Widget>[
                // FlatButton(
                //   onPressed: () {
                //     Navigator.of(context).pushNamed('/ForgetPassword');
                //     // Navigator.of(context).pushReplacementNamed('/ForgetPassword');
                //   },
                //   textColor: Theme.of(context).hintColor,
                //   child: Text(S.of(context).i_forgot_password),
                // ),
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/SignUp');
                    // Navigator.of(context).pushReplacementNamed('/SignUp');
                  },
                  textColor: Theme.of(context).hintColor,
                  child: Text(S.of(context).i_dont_have_an_account),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
