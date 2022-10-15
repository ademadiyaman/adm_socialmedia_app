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

class ResetPage extends StatefulWidget {
  const ResetPage({Key? key}) : super(key: key);

  @override
  _ResetPageState createState() => _ResetPageState();
}

class _ResetPageState extends State<ResetPage> {
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
            "uygulama_ayarlari",
            style: TextStyle(fontSize: 14),
          ).tr(),
          actions: <Widget>[],
        ),
        body: _userModel.state == ViewState.Idle
            ? SingleChildScrollView(
                child: Container(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 100, right: 11, left: 11),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(11, 3, 11, 34),
                              child: Text(
                                'sifre_sifirlama'.tr(),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 19),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  errorText: _userModel.emailHataMesaji != null
                                      ? _userModel.emailHataMesaji
                                      : null,
                                  prefixIcon: Icon(Icons.mail),
                                  hintText: 'email'.tr(),
                                  hintStyle: TextStyle(fontSize: 14),
                                  //labelText: 'E mail',
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _mail = value;
                                  });
                                },
                                onSaved: (String? _girilenEmail) {
                                  _email = _girilenEmail!;
                                },
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            SizedBox(
                              height: 18,
                            ),
                            SocialLoginButton(
                              textColor: Colors.white,
                              buttonText: _butonText,
                              butonColor: Colors.lightBlueAccent.shade700,
                              butonIcon: Icon(
                                Icons.password_outlined,
                                color: Colors.white,
                              ),
                              onPressed: () => {
                                auth.sendPasswordResetEmail(email: _mail),
                                Navigator.of(context).pop(),
                              },
                            ),
                            SizedBox(
                              height: 22,
                            ),
                            Text(
                              'mailinizi_girin'.tr(),
                              style: TextStyle(fontSize: 13),
                            ),
                          ],
                        )),
                  ),
                ),
              )
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
