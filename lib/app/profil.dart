import 'dart:io';

import 'package:adm_socialmedia_app/app/hakkimizda.dart';
import 'package:adm_socialmedia_app/app/sign_in/password_reset.dart';
import 'package:adm_socialmedia_app/common_widget/platform_duyarli_alert_dialog.dart';
import 'package:adm_socialmedia_app/common_widget/social_login_button.dart';
import 'package:adm_socialmedia_app/model/user.dart';
import 'package:adm_socialmedia_app/viewmodel/all_user_viewmodel.dart';
import 'package:adm_socialmedia_app/viewmodel/chat_view_model.dart';
import 'package:adm_socialmedia_app/viewmodel/user_model.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:adm_socialmedia_app/ad_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({Key? key}) : super(key: key);

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  bool _isLoading = false;
  ScrollController _scrollController = ScrollController();
  late TextEditingController _controllerUserName;
  late TextEditingController _controllerUserName1;
  late TextEditingController _controllerUserName2;
  File? _profilfoto;
  //late final XFile? _profilFoto;
  final ImagePicker _picker = ImagePicker();
  late BannerAd _bannerAd;

  bool _isBannedAdReady = false;
  @override
  void initState() {
    _bannerAd = BannerAd(
        size: AdSize.largeBanner,
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
    _controllerUserName = TextEditingController();
    _controllerUserName1 = TextEditingController();
    _controllerUserName2 = TextEditingController();
  }

  @override
  void dispose() {}

  Future<File?> _kameradanFotoCek() async {
    try {
      final XFile? _image = await _picker.pickImage(source: ImageSource.camera);
      setState(() {
        _profilfoto = _image as File?;
        _profilfoto = File(_image!.path);
        Navigator.of(context).pop();
      });
      return _profilfoto;
    } catch (e) {
      print("Hata Çıktı Gardaşşş: " + e.toString());
    }
  }

  Future<File?> _galeridenFotoSec(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      setState(() {
        _profilfoto = File(image!.path);
        //_profilfoto = _controllerUserName2.text as File?;
        Navigator.of(context).pop();
      });
      return _profilfoto;
    } catch (e) {
      print("Hata Çıktı Gardaşşş: " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    UserModel? _userModel = Provider.of<UserModel>(context);
    _controllerUserName.text = _userModel.user!.userName!;
    _controllerUserName1.text = _userModel.user!.durum!;
    _controllerUserName2.text = _userModel.user!.profilUrl!;
    // print("Profil Sayfasındaki user değerleri: " + _userModel.user!.toString());
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlueAccent.shade400,
          title: Text(
            'profil_duzenle',
            style: TextStyle(fontSize: 14),
          ).tr(),
          actions: <Widget>[],
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 184),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Container(
                                  height: 170,
                                  child: Column(
                                    children: <Widget>[
                                      ListTile(
                                        leading: Icon(Icons.camera),
                                        title: Text("Kameradan Çek"),
                                        onTap: () {
                                          _kameradanFotoCek();
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(Icons.photo),
                                        title: Text("Galeriden Seç"),
                                        onTap: () {
                                          _galeridenFotoSec(
                                              ImageSource.gallery);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              });
                        },
                        child: CircleAvatar(
                          radius: 75,
                          backgroundColor: Colors.red,
                          backgroundImage: _profilfoto == null
                              ? NetworkImage(_userModel.user!.profilUrl!)
                              : FileImage(_profilfoto!) as ImageProvider,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: TextFormField(
                        initialValue: _userModel.user!.email,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(fontSize: 14),
                          labelText: "kullanici_mail".tr(),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                //   color: Color(0xFFEE0A0A),
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: TextFormField(
                        cursorColor: Colors.lightBlueAccent,
                        controller: _controllerUserName,
                        decoration: InputDecoration(
                          hoverColor: Colors.lightBlueAccent,
                          iconColor: Colors.lightBlueAccent,
                          labelStyle: TextStyle(fontSize: 14),
                          labelText: 'kullanici_adi'.tr(),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                //   color: Color(0xFFEE0A0A),
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: TextFormField(
                        cursorColor: Colors.lightBlueAccent,
                        controller: _controllerUserName1,
                        decoration: InputDecoration(
                          labelStyle: TextStyle(fontSize: 14),
                          labelText: 'kullanici_durumu'.tr(),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                //       color: Color(0xFFEE0A0A),
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.all(Radius.circular(18)),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SocialLoginButton(
                        buttonText: 'degisiklikleri_kaydet'.tr(),
                        textColor: Colors.white,
                        onPressed: () {
                          _userNameGuncelle(context);
                          _durumGuncelle(context);
                          _profilFotoGuncelle(context);
                        },
                        butonIcon: Icon(Icons.save),
                      ),
                    ),
                    SizedBox(
                      height: 40,
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
            ),
          ),
        ));
  }

  _yeniElemanlarYukleniyorIndicator() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void dahaFazlaKullaniciGetir() async {
    if (_isLoading == false) {
      _isLoading = true;
      final _tumKullanicilarViewModel =
          Provider.of<AllUserViewModel>(context, listen: false);
      await _tumKullanicilarViewModel.dahaFazlaBilgiGetir();
      _isLoading = false;
    }
  }

  Future<bool> _cikisYap(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    bool sonuc = await _userModel.signOut();
    return sonuc;
  }

  Future _cikisIcinOnayIste(BuildContext context) async {
    final sonuc = await PlatformDuyarliAlertDialog(
      baslik: "Emin Misiniz?",
      icerik: "Çıkmak İstediğinizden Emin Misiniz?",
      anaButonYazisi: "Evet",
      iptalButonYazisi: "Vazgeç",
    ).goster(context);

    if (sonuc == true) {
      _cikisYap(context);
    }
  }

  void _profilFotoGuncelle(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    if (_profilfoto != null) {
      var url = await _userModel.uploadFile(
          _userModel.user!.userID!, "profil_foto", _profilfoto!);
      //print("gelen url :" + url!);
      if (url != true) {
        PlatformDuyarliAlertDialog(
          baslik: 'basarili'.tr(),
          icerik: 'degistirildi'.tr(),
          anaButonYazisi: 'tamam'.tr(),
        ).goster(context);
      } else {
        PlatformDuyarliAlertDialog(
          baslik: 'hata'.tr(),
          icerik: 'degistirilemedi'.tr(),
          anaButonYazisi: 'tamam'.tr(),
        ).goster(context);
      }
    }
  }

  void _userNameGuncelle(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    if (_userModel.user!.userName != _controllerUserName.text) {
      var updateResult = await _userModel.updateUserName(
          _userModel.user!.userID!, _controllerUserName.text);
      if (updateResult == true) {
        PlatformDuyarliAlertDialog(
          baslik: "Başarılı",
          icerik: "Kullanıcı adınız değiştirildi.",
          anaButonYazisi: "Tamam",
        ).goster(context);
      } else {
        _controllerUserName.text = _userModel.user!.userName.toString();
        PlatformDuyarliAlertDialog(
          baslik: "Hata",
          icerik:
              "Kullanıcı adınız değiştirilemedi! Bu kullanıcı adı kullanılıyor.",
          anaButonYazisi: "Tamam",
        ).goster(context);
      }
    }
  }

  void _durumGuncelle(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    if (_userModel.user!.durum! != _controllerUserName1.text) {
      var updateResult = await _userModel.updateDurum(
          _userModel.user!.userID!, _controllerUserName1.text);
      if (updateResult != true) {
        PlatformDuyarliAlertDialog(
          baslik: "Başarılı",
          icerik: "Durumunuz değiştirildi.",
          anaButonYazisi: "Tamam",
        ).goster(context);
      }
    }
  }

  void _sifreSifirlama(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ResetPage(),
      ),
    );
  }
}
