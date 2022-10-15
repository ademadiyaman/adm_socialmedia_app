import 'package:adm_socialmedia_app/app/landing_page.dart';
import 'package:adm_socialmedia_app/locator.dart';
import 'package:adm_socialmedia_app/router.dart';
import 'package:adm_socialmedia_app/viewmodel/user_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'viewmodel/user_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

String? version;
List<String> testDevices = ['1A1977A548883E1FECB7EA229B3FBB6D'];
void main() async {
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor:  Colors.transparent));
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  RequestConfiguration configuration =
      RequestConfiguration(testDeviceIds: testDevices);
  MobileAds.instance.updateRequestConfiguration(configuration);
//setupLocator();
  runApp(
    EasyLocalization(
        supportedLocales: const [Locale('en', 'US'), Locale('tr', 'TR')],
        path:
            'assets/translations', // <-- change the path of the translation files
        fallbackLocale: const Locale('en', 'US'),
        child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserModel(),
      child: MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          //onGenerateRoute: (settings) => generateRoute(settings),
          title: "Blue Send",
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: LandingPage()),
    );
  }
}
