import 'package:adm_socialmedia_app/app/konusmalarim_page.dart';
import 'package:adm_socialmedia_app/app/kullanici_profili.dart';
import 'package:adm_socialmedia_app/app/kullanicilar.dart';
import 'package:adm_socialmedia_app/app/my_custom_bottom_navy.dart';
import 'package:adm_socialmedia_app/app/profil.dart';
import 'package:adm_socialmedia_app/app/sign_in/durumlar.dart';
import 'package:adm_socialmedia_app/app/tab_items.dart';
import 'package:adm_socialmedia_app/common_widget/platform_duyarli_alert_dialog.dart';
import 'package:adm_socialmedia_app/kisisel_profil.dart';
import 'package:adm_socialmedia_app/model/user.dart';
import 'package:adm_socialmedia_app/notification_handler.dart';
import 'package:adm_socialmedia_app/viewmodel/all_user_viewmodel.dart';
import 'package:adm_socialmedia_app/viewmodel/chat_view_model.dart';
import 'package:adm_socialmedia_app/viewmodel/status_viewmodel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class HomePage extends StatefulWidget {
  final Uzer user;
  HomePage({Key? key, required this.user}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  TabItem _currentTab = TabItem.Kullanicilar;

  Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.Kullanicilar: GlobalKey<NavigatorState>(),
    TabItem.Konusmalarim: GlobalKey<NavigatorState>(),
    TabItem.Durumlar: GlobalKey<NavigatorState>(),
    TabItem.KisiselPage: GlobalKey<NavigatorState>(),
    //TabItem.Profil: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, Widget> tumSayfalar() {
    return {
      TabItem.Kullanicilar: ChangeNotifierProvider(
        create: (context) => AllUserViewModel(),
        child: KullanicilarPage(),
      ),
      TabItem.Konusmalarim: ChangeNotifierProvider(
        create: (context) => ChatViewModel(),
        child: KonusmalarimPage(),
      ),
      TabItem.Durumlar: ChangeNotifierProvider(
        create: (context) => StatusViewModel(),
        child: Durumlar(),
      ),
      // TabItem.KullanicilarPage: KullaniciProfiliPage(),
      TabItem.KisiselPage: KisiselProfil(),
      //  TabItem.Profil: ProfilPage(),
    };
  }

  @override
  void initState() {
    super.initState();
    NotificationHandler().initializeFCMNotification(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async =>
            await navigatorKeys[_currentTab]!.currentState!.maybePop(),
        child: MyCustomBottomNavigation(
          navigatorKeys: navigatorKeys,
          sayfaOlusturucu: tumSayfalar(),
          currentTab: _currentTab,
          onSelectedTab: (secilenTab) {
            if (secilenTab == _currentTab) {
              navigatorKeys[secilenTab]!
                  .currentState!
                  .popUntil((route) => route.isFirst);
            } else {
              setState(() {
                _currentTab = secilenTab;
              });
            }
          },
        ));
  }

/*

      appBar: AppBar(
        actions: <Widget>[
          TextButton(onPressed: ()=> _cikisYap(context),
          child: Text("Çıkış Buradan",  style: TextStyle(color: Colors.white),)
            ,)
        ],
        backgroundColor: Colors.lightBlueAccent,
        title: Text("Ana Sayfa"),
      ),
      body: MyCustomBottomNavigation(sayfaOlusturucu : tumSayfalar(),currentTab: _currentTab, onSelectedTab: (secilentab) {
        setState(() {
          _currentTab=secilentab;
        });
        print("Seçilen Tab Item: "+secilentab.toString());
      },),

  Future<bool> _cikisYap(BuildContext context) async{
    final _userModel = Provider.of<UserModel>(context, listen: false);
    bool sonuc =  await _userModel.signOut();
   return sonuc;
  }*/
}
