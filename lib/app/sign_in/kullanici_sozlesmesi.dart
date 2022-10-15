import 'dart:math';
import 'package:adm_socialmedia_app/app/hata_exception.dart';
import 'package:adm_socialmedia_app/app/home_page.dart';
import 'package:adm_socialmedia_app/common_widget/platform_duyarli_alert_dialog.dart';
import 'package:adm_socialmedia_app/common_widget/social_login_button.dart';
import 'package:adm_socialmedia_app/model/user.dart';
import 'package:adm_socialmedia_app/viewmodel/user_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

enum FormType { Register, LogIn }

class SozlesmePage extends StatefulWidget {
  const SozlesmePage({Key? key}) : super(key: key);

  @override
  _SozlesmePageState createState() => _SozlesmePageState();
}

class _SozlesmePageState extends State<SozlesmePage> {
  final auth = FirebaseAuth.instance;
  late String _email, _sifre;
  late String _butonText, _linkText;
  var _formType = FormType.LogIn;
  late String _mail;

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
  }

  void _formSubmit() async {
    _formKey.currentState!.save();
    debugPrint("email" + _email + "şifre" + _sifre);

    final _userModel = Provider.of<UserModel>(context, listen: false);
    if (_formType == FormType.LogIn) {
      try {
        Uzer? _girisYapanUser =
            await _userModel.signInWithEmailandPassword(_email, _sifre);
        if (_girisYapanUser != null)
          print("Oturum Açan User Id:" + _girisYapanUser.userID!.toString());
      } catch (e) {
        PlatformDuyarliAlertDialog(
          baslik: 'giris_hata'.tr(),
          anaButonYazisi: 'tamam'.tr(),
          icerik: Hatalar.gorset(e.hashCode.toString()),
        ).goster(context);
      }
    } else {
      try {
        Uzer? _olusturulanUser =
            await _userModel.createUserWithEmailandPassword(_email, _sifre);
        if (_olusturulanUser != null)
          print("Oturum Açan User Id:" + _olusturulanUser.userID.toString());
      } catch (e) {
        PlatformDuyarliAlertDialog(
          baslik: 'kayit_hata'.tr(),
          anaButonYazisi: 'tamam'.tr(),
          icerik: Hatalar.gorset(e.hashCode.toString()),
        ).goster(context);
      }
    }
  }

  void _degistir() {
    setState(() {
      _formType =
          _formType == FormType.LogIn ? FormType.Register : FormType.LogIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    _butonText =
        _formType == FormType.LogIn ? 'sifirlama'.tr() : 'kayit_ol'.tr();
    _linkText = _formType == FormType.LogIn
        ? "hesap_yok_kayit".tr()
        : "hesap_var_giris".tr();

    final _userModel = Provider.of<UserModel>(context);
    if (_userModel.user != null) {
      Future.delayed(Duration(milliseconds: 231), () {
        Navigator.of(context).pop();
      });
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent.shade400,
        title: Text(
          "kullanici_sozlesmesi",
          style: TextStyle(fontSize: 14),
        ).tr(),
        actions: <Widget>[],
      ),
      body: SingleChildScrollView(
        child: Container(
          //var oankiUser = myUser[index];
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(31, 3, 11, 34),
                    child: Text(
                      'kullanici_sozlesmesi',
                      style: TextStyle(color: Colors.black, fontSize: 19),
                    ).tr(),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    'kural_1'.tr(),
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    'kural_2'.tr(),
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    'kural_3'.tr(),
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    'kural_4'.tr(),
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    'kural_5'.tr(),
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    'kural_6'.tr(),
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    'kural_7'.tr(),
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    'kural_8'.tr(),
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    'kural_9'.tr(),
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    'kural_10'.tr(),
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    'kural_11'.tr(),
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    'kural_12'.tr(),
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    'kural_13'.tr(),
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    'kural_14'.tr(),
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    'kural_15'.tr(),
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    'kural_16'.tr(),
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Text(
                    'kural_17'.tr(),
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
