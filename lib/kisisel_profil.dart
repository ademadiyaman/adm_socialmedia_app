import 'dart:io';

import 'package:adm_socialmedia_app/ad_helper.dart';
import 'package:adm_socialmedia_app/app/ayarlar.dart';
import 'package:adm_socialmedia_app/app/confirm_status_contact.dart';
import 'package:adm_socialmedia_app/app/profil.dart';
import 'package:adm_socialmedia_app/app/profil_resmi_goster.dart';
import 'package:adm_socialmedia_app/app/sign_in/password_reset.dart';
import 'package:adm_socialmedia_app/common_widget/platform_duyarli_alert_dialog.dart';
import 'package:adm_socialmedia_app/common_widget/social_login_button.dart';
import 'package:adm_socialmedia_app/viewmodel/chat_view_model.dart';
import 'package:adm_socialmedia_app/viewmodel/user_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:adm_socialmedia_app/ad_helper.dart';
import 'model/user.dart';

class KisiselProfil extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _KisiselProfilState();
}

class _KisiselProfilState extends State<KisiselProfil> {
  late TextEditingController _controllerUserName;
  late TextEditingController _controllerUserName1;
  late TextEditingController _controllerUserName2;

  File? _profilfoto;
  //late final XFile? _profilFoto;
  final ImagePicker _picker = ImagePicker();

  late BannerAd _bannerAd;
  late InterstitialAd _interstitialAd;
  bool _isBannedAdReady = false;
  bool _isInterstitialAdReady = false;
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
    _controllerUserName2 = TextEditingController();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    _interstitialAd.dispose();
    _controllerUserName.dispose();
    _controllerUserName1.dispose();
    super.dispose();
  }

  Future<File?> _kameradanFotoCek() async {
    try {
      final XFile? _image = await _picker.pickImage(source: ImageSource.camera);
      setState(() {
        _profilfoto = _image as File?;
        _profilfoto = File(_image!.path);
        Navigator.of(context).pop();
      });
      return _profilfoto!;
    } catch (e) {
      print("Hata Çıktı Gardaşşş: " + e.toString());
    }
  }

  Future<File?> _galeridenFotoSec(ImageSource source) async {
    ChatViewModel? kullaniciAdi;
    ChatViewModel? _chatModel =
        Provider.of<ChatViewModel?>(context, listen: false);
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      setState(() {
        //kullaniciAdi = _chatModel!.curretUser!.userID! as ChatViewModel;
        _profilfoto = File(image!.path);
        //_profilfoto = _controllerUserName2.text as File?;
      });
/*
      Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (context) => ChatViewModel(
            curretUser: _chatModel!.curretUser!,
          ),
          child: ConfirmStatusScreen(
            file: _profilfoto!,
          ),
        ),
      ));*/

      return _profilfoto;
    } catch (e) {
      print("Hata Çıktı Gardaşşş: " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    UserModel _userModel = Provider.of<UserModel>(context);
    ChatViewModel? _chatModel = Provider.of<ChatViewModel?>(context);
    _controllerUserName.text = _userModel.user!.userName!;
    _controllerUserName1.text = _userModel.user!.durum!;
    _controllerUserName2.text = _userModel.user!.profilUrl!;
    print("Profil Sayfasındaki user değerleri: " + _userModel.user!.toString());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent.shade400,
        title: Text(
          'profilim',
          style: TextStyle(fontSize: 16),
        ).tr(),
        actions: <Widget>[
          GestureDetector(
            onTap: () {},
            child: InkWell(
              onTap: () {
                Navigator.of(context, rootNavigator: true)
                    .push(MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider(
                    create: (context) => ChatViewModel(
                        curretUser: _chatModel!.curretUser,
                        sohbetEdilenUser: _chatModel.sohbetEdilenUser),
                    child: Ayarlar(),
                  ),
                ));
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.settings_applications,
                  size: 31,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Uzer?>?>(
        future: _userModel.getUser(_userModel.user!.userID!),
        builder: (context, user) {
          if (!user.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var myUser = user.data;
            if (myUser!.length > 0) {
              return RefreshIndicator(
                color: Colors.lightBlueAccent,
                onRefresh: _resmimiYenile,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    var oankiUser = myUser[index];
                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 11),
                          child: GestureDetector(
                            onTap: () {
                              if (_isInterstitialAdReady)
                                _interstitialAd.show();
                              Navigator.of(context, rootNavigator: true)
                                  .push(MaterialPageRoute(
                                builder: (context) => ChangeNotifierProvider(
                                  create: (context) => ChatViewModel(
                                      curretUser: _userModel.user!,
                                      sohbetEdilenUser: _userModel.user!),
                                  child: ProfilResmiGoster(),
                                ),
                              ));
                            },
                            child: CircleAvatar(
                              radius: 75,
                              backgroundColor: Colors.red,
                              backgroundImage:
                                  NetworkImage(oankiUser!.profilUrl!),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 11,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(0),
                          child: Card(
                            margin: EdgeInsets.zero,
                            elevation: 1,
                            child: ListTile(
                              title: (const Text("Hikayeleriniz")),
                              subtitle: Text(oankiUser.userName!),
                              leading: CircleAvatar(
                                radius: 35,
                                backgroundImage:
                                    NetworkImage(oankiUser.profilUrl!),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: SocialLoginButton(
                            buttonText: "Yeni Hikaye Ekle",
                            textColor: Colors.white,
                            onPressed: () async {
                              Navigator.of(context, rootNavigator: true)
                                  .push(MaterialPageRoute(
                                builder: (context) => ChangeNotifierProvider(
                                  create: (context) => ChatViewModel(
                                    curretUser: _chatModel!.curretUser,
                                    sohbetEdilenUser:
                                        _chatModel.sohbetEdilenUser,
                                  ),
                                  child: ConfirmStatusScreen(),
                                ),
                              ));
                            },
                            butonIcon: Icon(
                              Icons.add_photo_alternate_sharp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 4, left: 5, right: 5),
                          child: GestureDetector(
                            onTap: () {},
                            child: Card(
                              elevation: 5,
                              child: ListTile(
                                title: Text(
                                  oankiUser.email!,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontStyle: FontStyle.normal,
                                      fontSize: 15),
                                ),
                                subtitle: Text(
                                  'kullanici_mail',
                                  style: TextStyle(fontSize: 13),
                                ).tr(),
                                leading: Icon(
                                  Icons.mail_outline,
                                  size: 32,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 5, left: 5, right: 5),
                          child: Card(
                            elevation: 5,
                            child: ListTile(
                              title: Text(
                                oankiUser.userName!,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 15),
                              ),
                              subtitle: Text(
                                'kullanici_adi',
                                style: TextStyle(fontSize: 13),
                              ).tr(),
                              leading: Icon(
                                Icons.account_box_outlined,
                                size: 32,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 5, left: 5, right: 5),
                          child: Card(
                            elevation: 5,
                            child: ListTile(
                              title: Text(
                                oankiUser.durum!,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 15),
                              ),
                              subtitle: Text('kullanici_durumu',
                                      style: TextStyle(fontSize: 13))
                                  .tr(),
                              leading: Icon(
                                Icons.web,
                                size: 32,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: SocialLoginButton(
                            buttonText: 'profil_duzenle'.tr(),
                            textColor: Colors.white,
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true)
                                  .push(MaterialPageRoute(
                                builder: (context) => ChangeNotifierProvider(
                                  create: (context) => ChatViewModel(
                                      curretUser: _userModel.user!),
                                  child: ProfilPage(),
                                ),
                              ));
                              _userNameGuncelle(context);
                              _durumGuncelle(context);
                              _profilFotoGuncelle(context);
                            },
                            butonIcon: Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        if (_isBannedAdReady)
                          Container(
                            height: _bannerAd.size.height.toDouble(),
                            width: _bannerAd.size.width.toDouble(),
                            child: AdWidget(ad: _bannerAd),
                          ),
                      ],
                    );
                  },
                  itemCount: myUser.length,
                ),
              );
            } else {
              return GestureDetector();
            }
          }
        },
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
      baslik: "Emin Misiniz?",
      icerik: "Çıkmak İstediğinizden Emin Misiniz?",
      anaButonYazisi: "Evet",
      iptalButonYazisi: "Vazgeç",
    ).goster(context);

    if (sonuc == true) {
      _cikisYap(context);
    }
  }

  void _userNameGuncelle(BuildContext context) async {
    /*
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
    }*/
  }

  void _durumGuncelle(BuildContext context) async {
    /*
    final _userModel = Provider.of<UserModel>(context, listen: false);
    if (_userModel.user!.durum != _controllerUserName1.text) {
      var updateResult = await _userModel.updateDurum(
          _userModel.user!.userID!, _controllerUserName1.text);
      if (updateResult == true) {
        PlatformDuyarliAlertDialog(
          baslik: "Başarılı",
          icerik: "Durumunuz değiştirildi.",
          anaButonYazisi: "Tamam",
        ).goster(context);
      } else {
        _controllerUserName1.text = _userModel.user!.durum.toString();
        PlatformDuyarliAlertDialog(
          baslik: "Hata",
          icerik: "Durumunuz değiştirilemedi! Bu kullanıcı adı kullanılıyor.",
          anaButonYazisi: "Tamam",
        ).goster(context);
      }
    }*/
  }

  void _profilFotoGuncelle(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    if (_profilfoto != null) {
      var url = await _userModel.uploadFile(
          _userModel.user!.userID!, "profil_foto", _profilfoto!);
      //   print("gelen url :" + url!);
      if (url != true) {
        PlatformDuyarliAlertDialog(
          baslik: "Başarılı",
          icerik: "Profil resminiz değiştirildi.",
          anaButonYazisi: "Tamam",
        ).goster(context);
      } else {
        PlatformDuyarliAlertDialog(
          baslik: "Hata",
          icerik: "Profil resminiz değiştirilemedi!",
          anaButonYazisi: "Tamam",
        ).goster(context);
      }
    }
  }

  Future<Null> _resmimiYenile() async {
    //UserModel? _userModel = Provider.of<UserModel>(context, listen: false);
    setState(() {});
    await Future.delayed(Duration(seconds: 1));
    // var yeniResim = _userModel.user!.profilUrl! as Uzer?;
    return null;
  }

  void _sifreSifirlama(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ResetPage(),
      ),
    );
  }
}
