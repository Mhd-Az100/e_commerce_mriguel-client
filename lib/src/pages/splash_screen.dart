import 'package:flutter/material.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:markets/src/pages/pages.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../controllers/splash_screen_controller.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends StateMVC<SplashScreen> {
  SplashScreenController _con;

  SplashScreenState() : super(SplashScreenController()) {
    _con = controller;
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      // PermissionStatus permission = await LocationPermissions().requestPermissions();
      _con.progress.addListener(() {
        double progress = 0;
        _con.progress.value.values.forEach((_progress) {
          progress += _progress;
        });
        if (progress == 100) {
          try {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => PagesWidget()));
          } catch (e) {}
        }
      });
    } catch (e) {
      // loadData();
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
              image: DecorationImage(
                image: AssetImage("assets/img/backimg.png"),
                fit: BoxFit.cover,
              ),
        ),
        child: Center(
          // child: //Column(
            // mainAxisSize: MainAxisSize.max,
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            // children: <Widget>[
              // Image.asset(
              //   'assets/img/logo.png',
              //   width: 150,
              //   fit: BoxFit.cover,
              // ),
              // SizedBox(height: 50),
              // CircularProgressIndicator(
              //   valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).hintColor),
              // ),
          //   ],
          // ),
        ),
      ),
        // child: Center(
        //   child: Column(
        //     mainAxisSize: MainAxisSize.max,
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: <Widget>[
        //       Image.asset(
        //         'assets/img/logo.png',
        //         width: 150,
        //         fit: BoxFit.cover,
        //       ),
        //       SizedBox(height: 50),
        //       CircularProgressIndicator(
        //         valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).hintColor),
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}
