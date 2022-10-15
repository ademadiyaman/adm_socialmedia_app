import 'package:adm_socialmedia_app/app/hakkimizda.dart';
import 'package:adm_socialmedia_app/app/hesap_profil_ayarlari.dart';
import 'package:adm_socialmedia_app/app/profil.dart';
import 'package:adm_socialmedia_app/common_widget/platform_duyarli_alert_dialog.dart';
import 'package:adm_socialmedia_app/viewmodel/chat_view_model.dart';
import 'package:adm_socialmedia_app/viewmodel/user_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:adm_socialmedia_app/ad_helper.dart';
import 'package:provider/provider.dart';

class Ayarlar extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Ayarlar();
}

late BannerAd _bannerAd;

bool _isBannedAdReady = false;

class _Ayarlar extends State<Ayarlar> {
  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: adHelper.bannerAdUnitId,
        listener: BannerAdListener(onAdLoaded: (_) {
          setState(() {
            _isBannedAdReady = true;
          });
        }, onAdFailedToLoad: (ad, error) {
          print("Failed${error.message}");
          _isBannedAdReady = false;
          ad.dispose();
        }),
        request: AdRequest())
      ..load();
    // _controllerUserName = TextEditingController();
    // _controllerUserName1 = TextEditingController();
  }

  @override
  void dispose() {
    //_controllerUserName.dispose();
    //_controllerUserName1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel? _userModel = Provider.of<UserModel>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent.shade400,
        title: Text(
          'ayarlar',
          style: TextStyle(fontSize: 14, color: Colors.white),
        ).tr(),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context, rootNavigator: true)
                      .push(MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                      create: (context) =>
                          ChatViewModel(curretUser: _userModel.user!),
                      child: ProfilPage(),
                    ),
                  ));
                },
                child: Card(
                  color: Colors.white,
                  margin: EdgeInsets.zero,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true)
                          .push(MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                          create: (context) =>
                              ChatViewModel(curretUser: _userModel.user!),
                          child: ProfilPage(),
                        ),
                      ));
                    },
                    child: ListTile(
                      title: Text(
                        'profil_duzen',
                        style: TextStyle(
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 15),
                      ).tr(),
                      leading: Icon(
                        Icons.person_pin,
                        size: 32,
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(1),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context, rootNavigator: true)
                      .push(MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                      create: (context) =>
                          ChatViewModel(curretUser: _userModel.user!),
                      child: ProfilPage(),
                    ),
                  ));
                },
                child: Card(
                  color: Colors.white,
                  margin: EdgeInsets.zero,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true)
                          .push(MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                          create: (context) =>
                              ChatViewModel(curretUser: _userModel.user!),
                          child: HesapveProfilAyarlari(),
                        ),
                      ));
                    },
                    child: ListTile(
                      title: Text(
                        'uygulama_ayarlari',
                        style: TextStyle(
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 15),
                      ).tr(),
                      leading: Icon(
                        Icons.settings_applications_outlined,
                        size: 32,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(1),
              child: Card(
                color: Colors.white,
                margin: EdgeInsets.zero,
                child: FlatButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true)
                        .push(MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider(
                        create: (context) => ChatViewModel(
                            curretUser: _userModel.user!,
                            sohbetEdilenUser: null),
                        child: Hakkimizda(),
                      ),
                    ));
                  },
                  child: ListTile(
                    title: Text(
                      'hakkinda',
                      style: TextStyle(
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          fontSize: 15),
                    ).tr(),
                    leading: Icon(
                      Icons.info_outline_rounded,
                      size: 32,
                      color: Colors.amber,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(1),
              child: Card(
                elevation: 3,
                color: Colors.white,
                margin: EdgeInsets.zero,
                child: FlatButton(
                  onPressed: () => _cikisIcinOnayIste(context),
                  child: ListTile(
                    title: Text(
                      'cikis',
                      style: TextStyle(
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          fontSize: 15),
                    ).tr(),
                    leading: Icon(
                      Icons.exit_to_app,
                      size: 32,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 172,
            ),
            if (_isBannedAdReady)
              Container(
                height: _bannerAd.size.height.toDouble(),
                width: _bannerAd.size.width.toDouble(),
                child: AdWidget(ad: _bannerAd),
              ),
/*
            Padding(
              padding: EdgeInsets.all(21),
              child: Icon(Icons.person_pin),
            ),
            Padding(
              padding: EdgeInsets.all(21),
              child: Text(
                "Hesap Ayarlarınız",
                style: TextStyle(fontSize: 15),
              ),
            ),*/
          ],
        ),
      ),
    );
  }

  Future<bool> _cikisYap(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    bool sonuc = await _userModel.signOut();
    return sonuc;
  }

  Future _cikisIcinOnayIste(BuildContext context) async {
    final sonuc = await PlatformDuyarliAlertDialog(
      baslik: 'cikis_yap'.tr(),
      icerik: 'emin'.tr(),
      anaButonYazisi: 'evet'.tr(),
      iptalButonYazisi: 'hayir'.tr(),
    ).goster(context);

    if (sonuc == true) {
      _cikisYap(context);
      Navigator.pop(context);
    }
  }
}
