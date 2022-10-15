import 'dart:io';

import 'package:adm_socialmedia_app/app/kullanici_resmi_goster.dart';
import 'package:adm_socialmedia_app/app/profil_resmi_goster.dart';
import 'package:adm_socialmedia_app/common_widget/social_login_button.dart';
import 'package:adm_socialmedia_app/viewmodel/chat_view_model.dart';
import 'package:adm_socialmedia_app/viewmodel/user_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:adm_socialmedia_app/ad_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class KullaniciProfiliPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _KullaniciProfiliPage();
}

class _KullaniciProfiliPage extends State<KullaniciProfiliPage> {
  File? _profilfoto;
  //late final XFile? _profilFoto;
  final ImagePicker _picker = ImagePicker();
  var _mesajController = TextEditingController();
  ScrollController _scrollController = new ScrollController();
  late BannerAd _bannerAd;
  late InterstitialAd _interstitialAd;
  bool _isBannedAdReady = false;
  bool _isInterstitialAdReady = false;
  late TextEditingController _controllerUserName;
  late TextEditingController _controllerUserName1;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    //_scrollController.addListener(_scrollListener);
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

    InterstitialAd.load(
        adUnitId: adHelper.interstitialAdUnitId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialAdReady = true;
        }, onAdFailedToLoad: (error) {
          print("Failed to load Interstitial Ad${error.message}");
        }));
    _controllerUserName = TextEditingController();
    _controllerUserName1 = TextEditingController();
  }

  void _kullaniciyaMesajGonder(int index) {}

  @override
  Widget build(BuildContext context) {
    ChatViewModel? _chatModel = Provider.of<ChatViewModel?>(context);
    UserModel? _userModel = Provider.of<UserModel?>(context);
    _controllerUserName.text = _userModel!.user!.userName!;
    _controllerUserName1.text = _userModel.user!.durum!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent.shade400,
        title: Text(
          _chatModel!.sohbetEdilenUser!.userName!,
          style: TextStyle(fontSize: 14),
        ).tr(),
        actions: <Widget>[
          /*IconButton(
            onPressed: () => _cikisIcinOnayIste(context),
            icon: Icon(Icons.exit_to_app),
          )*/
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _sayfayiYenile,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: GestureDetector(
                    onTap: () {
                      if (_isInterstitialAdReady) _interstitialAd.show();
                      Navigator.of(context, rootNavigator: true)
                          .push(MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                          create: (context) => ChatViewModel(
                              curretUser: _chatModel.curretUser,
                              sohbetEdilenUser: _chatModel.sohbetEdilenUser),
                          child: KullaniciResmiGoster(),
                        ),
                      ));
                    },
                    child: CircleAvatar(
                      radius: 75,
                      backgroundColor: Colors.red,
                      backgroundImage:
                          NetworkImage(_chatModel.sohbetEdilenUser!.profilUrl!),
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text(
                      _chatModel.sohbetEdilenUser!.email!,
                      style: TextStyle(
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          fontSize: 15),
                    ),
                    subtitle: Text('arkadas_kullanici_mail').tr(),
                    leading: Icon(
                      Icons.mail_outline,
                      size: 32,
                      color: Colors.black,
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text(
                      _chatModel.sohbetEdilenUser!.userName!,
                      style: TextStyle(
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          fontSize: 15),
                    ),
                    subtitle: Text('arkadas_kullanici_adi').tr(),
                    leading: Icon(
                      Icons.supervised_user_circle_outlined,
                      size: 32,
                      color: Colors.black,
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text(
                      _chatModel.sohbetEdilenUser!.durum!,
                      style: TextStyle(
                          color: Colors.black,
                          fontStyle: FontStyle.normal,
                          fontSize: 15),
                    ),
                    subtitle: Text('arkadas_kullanici_durumu').tr(),
                    leading: Icon(
                      Icons.web,
                      size: 32,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 22, left: 11, right: 11),
                  child: SocialLoginButton(
                    buttonText: 'mesaj_gonder'.tr(),
                    textColor: Colors.black,
                    butonColor: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                      //_kullaniciyaMesajGonder();
                      // _profilFotoGuncelle(context);
                    },
                    butonIcon: Icon(
                      Icons.message_outlined,
                      color: Colors.lightBlueAccent,
                    ),
                  ),
                ),
                SizedBox(
                  height: 28,
                ),
                if (_isBannedAdReady)
                  Container(
                    height: _bannerAd.size.height.toDouble(),
                    width: _bannerAd.size.width.toDouble(),
                    child: AdWidget(ad: _bannerAd),
                  ),
                SizedBox(
                  height: 18,
                ),
                /*
                Padding(
                  padding: const EdgeInsets.only(top: 1, left: 11, right: 11),
                  child: SocialLoginButton(
                    buttonText: 'profili_begen'.tr(),
                    textColor: Colors.white,
                    onPressed: () {
                      //_kullaniciyaMesajGonder();
                      // _profilFotoGuncelle(context);
                    },
                    butonIcon: Icon(
                      Icons.whatshot,
                      color: Colors.white,
                    ),
                  ),
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> _sayfayiYenile() async {
    //UserModel? _userModel = Provider.of<UserModel>(context, listen: false);
    setState(() {});
    await Future.delayed(Duration(seconds: 1));
    // var yeniResim = _userModel.user!.profilUrl! as Uzer?;
    return null;
  }
}
