import 'package:adm_socialmedia_app/app/profil.dart';
import 'package:adm_socialmedia_app/app/sign_in/password_reset.dart';
import 'package:adm_socialmedia_app/app/sign_in/password_sifirla.dart';
import 'package:adm_socialmedia_app/common_widget/platform_duyarli_alert_dialog.dart';
import 'package:adm_socialmedia_app/dil_secenekleri.dart';
import 'package:adm_socialmedia_app/viewmodel/chat_view_model.dart';
import 'package:adm_socialmedia_app/viewmodel/user_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:adm_socialmedia_app/ad_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HesapveProfilAyarlari extends StatefulWidget {
  @override
  State<HesapveProfilAyarlari> createState() => _HesapveProfilAyarlariState();
}

late BannerAd _bannerAd;

bool _isBannedAdReady = false;

class _HesapveProfilAyarlariState extends State<HesapveProfilAyarlari> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bannerAd = BannerAd(
        size: AdSize.mediumRectangle,
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
  }

  void _sifreSifirlama(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SifirlaPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    UserModel? _userModel = Provider.of<UserModel>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent.shade400,
        title: Text(
          'uygulama_ayarlari',
          style: TextStyle(fontSize: 14),
        ).tr(),
        actions: <Widget>[],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: GestureDetector(
                onTap: () {},
                child: Card(
                  color: Colors.white,
                  margin: EdgeInsets.zero,
                  child: FlatButton(
                    onPressed: () {},
                    child: ListTile(
                      title: Text(
                        'karanlik_mod',
                        style: TextStyle(
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 15),
                      ).tr(),
                      trailing: Switch(
                        activeColor: Colors.lightBlueAccent,
                        onChanged: (bool value) {},
                        value: true,
                      ),
                      leading: Icon(
                        Icons.wb_sunny_outlined,
                        color: Colors.lightBlueAccent,
                        size: 22,
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
                  _sifreSifirlama(context);
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
                          child: DilSecenekleri(),
                        ),
                      ));
                    },
                    child: ListTile(
                      title: Text(
                        'dil',
                        style: TextStyle(
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 15),
                      ).tr(),
                      leading: Icon(
                        Icons.translate,
                        color: Colors.amber,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            /*
            Padding(
              padding: const EdgeInsets.all(1),
              child: GestureDetector(
                onTap: () {
                  _sifreSifirlama(context);
                },
                child: Card(
                  color: Colors.white,
                  margin: EdgeInsets.zero,
                  child: FlatButton(
                    onPressed: () => {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                          create: (context) => ChatViewModel(),
                          child: SifirlaPage(),
                        ),
                      )),
                    },
                    child: ListTile(
                      title: Text(
                        'sifre_sifirlama',
                        style: TextStyle(
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 15),
                      ).tr(),
                      leading: Icon(
                        Icons.translate,
                        color: Colors.amber,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ),*/
            Padding(
              padding: const EdgeInsets.all(0),
              child: GestureDetector(
                onTap: () {},
                child: Card(
                  color: Colors.white,
                  margin: EdgeInsets.zero,
                  child: FlatButton(
                    onPressed: () => {
                      _hesabiSilmekIcinOnayIste(context),
                    },
                    child: ListTile(
                      title: Text(
                        'hesabi_sil',
                        style: TextStyle(
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 15),
                      ).tr(),
                      leading: Icon(
                        Icons.delete_forever,
                        color: Colors.red,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            /*
            Padding(
              padding: const EdgeInsets.only(
                  left: 22, right: 22, bottom: 60, top: 22),
              child: TextButton(
                child: Text(
                  "Şifrenizi mi Unuttunuz?",
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () => _sifreSifirlama(context),
              ),
            ),*/
            SizedBox(
              height: 50,
            ),
            if (_isBannedAdReady)
              Container(
                height: _bannerAd.size.height.toDouble(),
                width: _bannerAd.size.width.toDouble(),
                child: AdWidget(ad: _bannerAd),
              ),
          ],
        ),
      ),
    );
  }

  Future<bool?> _hesabiSil(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    var updateResult = await _userModel.deleteUser(_userModel.user!.userID!);
    if (updateResult == true) {
      bool sonuc = await _userModel.signOut();
      return sonuc;
    } else {}
  }

  void _hesabiSilmekIcinOnayIste(BuildContext context) async {
    final sonuc = await PlatformDuyarliAlertDialog(
      baslik: 'emin_misiniz'.tr(),
      icerik: 'hesap_silme_uyari'.tr(),
      anaButonYazisi: 'evet'.tr(),
      iptalButonYazisi: 'hayir'.tr(),
    ).goster(context);

    if (sonuc == true) {
      _hesabiSil(context);
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }
}
