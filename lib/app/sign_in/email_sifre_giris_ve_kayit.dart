import 'dart:math';
import 'package:adm_socialmedia_app/app/hata_exception.dart';
import 'package:adm_socialmedia_app/app/home_page.dart';
import 'package:adm_socialmedia_app/app/sign_in/kullanici_sozlesmesi.dart';
import 'package:adm_socialmedia_app/app/sign_in/password_reset.dart';
import 'package:adm_socialmedia_app/common_widget/platform_duyarli_alert_dialog.dart';
import 'package:adm_socialmedia_app/common_widget/social_login_button.dart';
import 'package:adm_socialmedia_app/model/user.dart';
import 'package:adm_socialmedia_app/viewmodel/user_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

enum FormType { Register, LogIn }

class EmailveSifreLoginPage extends StatefulWidget {
  const EmailveSifreLoginPage({Key? key}) : super(key: key);

  @override
  _EmailveSifreLoginPageState createState() => _EmailveSifreLoginPageState();
}

class _EmailveSifreLoginPageState extends State<EmailveSifreLoginPage> {
  late String _email, _sifre;
  late String _butonText, _linkText;
  var _formType = FormType.LogIn;

  final _formKey = GlobalKey<FormState>();

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
        print("hata burada gardaşşş: " + e.toString());
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
        _formType == FormType.LogIn ? 'giris_yap'.tr() : 'kayit_ol'.tr();
    _linkText = _formType == FormType.LogIn
        ? "hesap_yok_kayit".tr()
        : "hesap_var_giris".tr();

    final _userModel = Provider.of<UserModel>(context);
    if (_userModel.user != null) {
      Future.delayed(Duration(milliseconds: 1), () {
        Navigator.of(context).popUntil(ModalRoute.withName("/"));
      });
    }
    return Scaffold(
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
                                'kayit_veya_giris'.tr(),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 19),
                              ),
                            ),
                            TextFormField(
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
                              onSaved: (String? _girilenEmail) {
                                _email = _girilenEmail!;
                              },
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              obscureText: true,
                              decoration: InputDecoration(
                                errorText: _userModel.sifreHataMesaji != null
                                    ? _userModel.sifreHataMesaji
                                    : null,
                                prefixIcon: Icon(Icons.password),
                                hintText: 'sifre'.tr(),
                                hintStyle: TextStyle(fontSize: 14),
                                //labelText: 'Şifre',
                                border: OutlineInputBorder(),
                              ),
                              onSaved: (String? _girilenSifre) {
                                _sifre = _girilenSifre!;
                              },
                            ),
                            SizedBox(
                              height: 18,
                            ),
                            SocialLoginButton(
                              textColor: Colors.white,
                              buttonText: _butonText,
                              butonColor: Colors.lightBlueAccent.shade700,
                              butonIcon: Icon(Icons.assignment_ind_rounded),
                              onPressed: () => _formSubmit(),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            FlatButton(
                              onPressed: () => _degistir(),
                              child: Text(_linkText),
                            ),
                            SizedBox(
                              height: 22,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => SozlesmePage(),
                                    ),
                                  );
                                },
                                child: Card(
                                  elevation: 5,
                                  child: ListTile(
                                    title: Text(
                                      'kullanici_sozlesme_uyari',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontStyle: FontStyle.normal,
                                          fontSize: 11),
                                    ).tr(),
                                    leading: Icon(
                                      Icons.info_outline_rounded,
                                      size: 32,
                                      color: Colors.lightBlueAccent,
                                    ),
                                  ),
                                ),
                              ),
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

  void _sifreSifirlama(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ResetPage(),
      ),
    );
  }

  void _kullaniciSozlesmesi(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ResetPage(),
      ),
    );
  }
}
