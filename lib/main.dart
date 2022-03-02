import 'package:device_preview/device_preview.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:flutter_screenutil/screenutil_init.dart';
import 'generated/i18n.dart';
import 'route_generator.dart';
import 'src/bindings/shopping_card.dart';
import 'src/controllers/controller.dart';
import 'src/helpers/app_config.dart' as config;
import 'src/helpers/helper.dart';
import 'src/models/setting.dart';
import 'src/repository/settings_repository.dart' as settingRepo;
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Helper.easyLoadingInstance();
  await GlobalConfiguration().loadFromAsset("configurations");
  await Firebase.initializeApp();
  ShoppingCardBinding().dependencies();
  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => MyApp(), // Wrap your app
    ),
  );
  // MyApp());
}

class MyApp extends AppMVC {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  // This widget is the root of your application.
//  /// Supply 'the Controller' for this application.
  MyApp({Key key}) : super(con: Controller(), key: key);

  @override
  Widget build(BuildContext context) {
    return DynamicTheme(
        defaultBrightness: Brightness.light,
        data: (brightness) {
          if (brightness == Brightness.light) {
            return ThemeData(
              fontFamily: 'ProductSans',
              primaryColor: Colors.white,
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                  elevation: 0, foregroundColor: Colors.white),
              brightness: brightness,
              accentColor: config.Colors().mainColor(1),
              dividerColor: config.Colors().accentColor(0.05),
              focusColor: config.Colors().accentColor(1),
              hintColor: config.Colors().secondColor(1),
              textTheme: TextTheme(
                headline: TextStyle(
                    fontSize: 22.0, color: config.Colors().secondColor(1)),
                display1: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                    color: config.Colors().secondColor(1)),
                display2: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w700,
                    color: config.Colors().secondColor(1)),
                display3: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                    color: config.Colors().mainColor(1)),
                display4: TextStyle(
                    fontSize: 26.0,
                    fontWeight: FontWeight.w300,
                    color: config.Colors().secondColor(1)),
                subhead: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                    color: config.Colors().secondColor(1)),
                title: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w700,
                    color: config.Colors().mainColor(1)),
                body1: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: config.Colors().secondColor(1)),
                body2: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w400,
                    color: config.Colors().secondColor(1)),
                caption: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w300,
                    color: config.Colors().accentColor(1)),
              ),
            );
          } else {
            return ThemeData(
              fontFamily: 'ProductSans',
              primaryColor: Color(0xFF252525),
              brightness: Brightness.dark,
              scaffoldBackgroundColor: Color(0xFF2C2C2C),
              accentColor: config.Colors().mainDarkColor(1),
              hintColor: config.Colors().secondDarkColor(1),
              focusColor: config.Colors().accentDarkColor(1),
              textTheme: TextTheme(
                headline: TextStyle(
                    fontSize: 22.0, color: config.Colors().secondDarkColor(1)),
                display1: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                    color: config.Colors().secondDarkColor(1)),
                display2: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.w700,
                    color: config.Colors().secondDarkColor(1)),
                display3: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                    color: config.Colors().mainDarkColor(1)),
                display4: TextStyle(
                    fontSize: 26.0,
                    fontWeight: FontWeight.w300,
                    color: config.Colors().secondDarkColor(1)),
                subhead: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                    color: config.Colors().secondDarkColor(1)),
                title: TextStyle(
                    fontSize: 17.0,
                    fontWeight: FontWeight.w700,
                    color: config.Colors().mainDarkColor(1)),
                body1: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    color: config.Colors().secondDarkColor(1)),
                body2: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w400,
                    color: config.Colors().secondDarkColor(1)),
                caption: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w300,
                    color: config.Colors().secondDarkColor(0.6)),
              ),
            );
          }
        },
        themedWidgetBuilder: (context, theme) {
          return ValueListenableBuilder(
              valueListenable: settingRepo.setting,
              builder: (context, Setting _setting, _) {
                final FirebaseMessaging _firebaseMessaging =
                    FirebaseMessaging();
                _firebaseMessaging.subscribeToTopic('wamyada');
                _firebaseMessaging.configure(
                  onMessage: (Map<String, dynamic> message) async {
                    Helper.printToConsole("splash screen onMessage: $message");
                  },
                  onLaunch: (Map<String, dynamic> message) async {
                    Helper.printToConsole("splash screen onLaunch: $message");
                  },
                  onResume: (Map<String, dynamic> message) async {
                    Helper.printToConsole(" splash screen  onResume: $message");
                  },
                  // onBackgroundMessage: myBackgroundMessageHandler,
                );
                return ScreenUtilInit(
                    designSize: Size(414, 896),
                    allowFontScaling: false,
                    builder: () {
                      return GetMaterialApp(
                        navigatorObservers: [
                          FirebaseAnalyticsObserver(analytics: analytics),
                        ],
                        title: _setting.appName,
                        initialRoute: '/Splash',
                        onGenerateRoute: RouteGenerator.generateRoute,
                        debugShowCheckedModeBanner: false,
                        locale: _setting.mobileLanguage.value,
                        // builder: DevicePreview.appBuilder,
                        builder: EasyLoading.init(),
                        localizationsDelegates: [
                          S.delegate,
                          GlobalMaterialLocalizations.delegate,
                          GlobalWidgetsLocalizations.delegate,
                        ],
                        supportedLocales: S.delegate.supportedLocales,
                        localeListResolutionCallback: S.delegate
                            .listResolution(fallback: const Locale('en', '')),
                        theme: theme,
                      );
                    });
              });
        });
  }
}
