import 'dart:convert';
import 'dart:io';

import 'package:adm_socialmedia_app/app/sohbet_page.dart';
import 'package:adm_socialmedia_app/model/user.dart';
import 'package:adm_socialmedia_app/viewmodel/chat_view_model.dart';
import 'package:adm_socialmedia_app/viewmodel/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'main.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  if (message.data != null) {
    NotificationHandler.showNotification(message.data);
    print("Handling a background message: ${message.data}");
    await Firebase.initializeApp();
  }
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');
  runApp(NotificationHandler());
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NotificationHandler extends StatelessWidget {
  FirebaseMessaging _fcm = FirebaseMessaging.instance;

  static final NotificationHandler _singleton = NotificationHandler._internal();
  factory NotificationHandler() {
    return _singleton;
  }
  NotificationHandler._internal();
  BuildContext? myContext;

  initializeFCMNotification(BuildContext context) async {
    myContext = context;
    Firebase.initializeApp();
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceieveLocalNotification);
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    //_fcm.subscribeToTopic("spor");

    // String? token = await _fcm.getToken();
    // print("token :" + token!);

    _fcm.onTokenRefresh.listen((newToken) async {
      User _currentUser = await FirebaseAuth.instance.currentUser!;
      FirebaseFirestore.instance
          .doc("tokens/" + _currentUser.uid)
          .set({"token": newToken});
    });
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      //RemoteNotification? notificeysin = message.notification;
      print('Ön plandan mesaj geldi!');
      print('Mesaj verisi: ${message.data}');
      if (message.data != null) {
        showNotification(message.data);
        // flutterLocalNotificationsPlugin.show(notification.hashCode,
        //   notification!.title, notification.body, NotificationDetails());
        print('Mesaj bildirim içeriyor: ${message.data}');
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      //RemoteNotification? notificeysin = message.notification;
      print('Ön plandan mesaj geldi!');
      print('Mesaj verisi: ${message.data}');
      if (message.data != null) {
        showNotification(message.data);
        // flutterLocalNotificationsPlugin.show(notification.hashCode,
        //   notification!.title, notification.body, NotificationDetails());
        print('Mesaj bildirim içeriyor: ${message.data}');
      }
    });
    FirebaseMessaging.onBackgroundMessage((message) async {
      //RemoteNotification? notificeysin = message.notification;
      print('Uygulama kapalıyken mesaj geldi!');
      print('Mesaj verisi: ${message.data}');
      if (message.data != null) {
        FirebaseMessaging.onBackgroundMessage(
            _firebaseMessagingBackgroundHandler);
        showNotification(message.data);
        // flutterLocalNotificationsPlugin.show(notification.hashCode,
        //   notification!.title, notification.body, NotificationDetails());
        print('Mesaj bildirim içeriyor: ${message.data}');
      }
    });
  }

  Future<void> _repeatNotification(Map<String, dynamic> message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('123', 'repeating channel name',
            channelDescription: 'repeating description');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.periodicallyShow(
        0,
        message["title"],
        message["message"],
        RepeatInterval.everyMinute,
        platformChannelSpecifics,
        androidAllowWhileIdle: true);
  }

  Future<void> _startForegroundService(Map<String, dynamic> message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('123', ' channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.startForegroundService(1, message["title"], message["message"],
            notificationDetails: androidPlatformChannelSpecifics,
            payload: 'item x');
  }

  static void showNotification(Map<String, dynamic> message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('123', 'Yeni Mesaj',
            channelDescription: 'dfssdfsdfsdf',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, message["title"], message["message"], platformChannelSpecifics,
        payload: jsonEncode(message));
  }

  Future<void> _showOngoingNotification(Map<String, dynamic> message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('123', 'Yeni Going',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ongoing: true,
            autoCancel: false);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, message["title"], message["message"], platformChannelSpecifics);
  }

  Future<void> _showNotificationMediaStyle(Map<String, dynamic> message) async {
    final String largeIconPath = await _downloadAndSaveFile(
        'https://via.placeholder.com/128x128/00FF00/000000', 'largeIcon');
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      '123',
      'Yeni Medya',
      channelDescription: 'media channel description',
      largeIcon: FilePathAndroidBitmap(largeIconPath),
      styleInformation: const MediaStyleInformation(),
    );
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, message["title"], message["message"], platformChannelSpecifics);
  }

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  Future onSelectNotification(String? payload) async {
    //final NotificationAppLaunchDetails? notificationAppLaunchDetails =
    //  await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    final _userModel = Provider.of<UserModel>(myContext!, listen: false);
    // if (notificationAppLaunchDetails!.didNotificationLaunchApp) {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
      Map<String, dynamic> gelenBildirim = await jsonDecode(payload);

      Navigator.of(myContext!, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (context) => ChatViewModel(
                curretUser: _userModel.user!,
                sohbetEdilenUser: Uzer.idveResim(
                  userID: gelenBildirim["gonderenUserID"],
                  userName: gelenBildirim["gonderenUserName"],
                  durum: '',
                  profilUrl: gelenBildirim["gonderenUserUrl"],
                  email: '',
                )),
            child: SohbetPage(),
          ),
        ),
      );
    }
    // }
  }

  Future onDidReceieveLocalNotification(
      int? id, String? title, String? message, String? payload) async {
    /*showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title!),
        content: Text(message!),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
            },
          )
        ],
      ),
    );*/
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  //late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

/*
  static _downloadAndSaveImage(String? url, String name) async {
    var directory = await getApplicationDocumentsDirectory();
    var filePath = '${directory.path}/$name';
    var response = await http.get(url);
    var file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }*/
}
