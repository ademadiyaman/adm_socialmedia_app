import 'dart:ui';

import 'package:adm_socialmedia_app/app/sign_in/email_sifre_giris_ve_kayit.dart';
import 'package:adm_socialmedia_app/app/sign_in/password_reset.dart';
import 'package:adm_socialmedia_app/common_widget/social_login_button.dart';
import 'package:adm_socialmedia_app/model/user.dart';
import 'package:adm_socialmedia_app/viewmodel/user_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  void _misafirGirisi(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    Uzer? _user = await _userModel.signInAnonymously();
    print("Oturum Açan User Id:" + _user!.userID.toString());
  }

  void _googleIleGiris(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    Uzer? _user = await _userModel.signInWithGoogle();
    if (_user != null) print("Oturum Açan User Id:" + _user.userID.toString());
  }

  void _emailveSifreGiris(BuildContext context) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => EmailveSifreLoginPage(),
      ),
    );
  }

  void _sifreSifirlama(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ResetPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: ExactAssetImage('images/image.jpg'), fit: BoxFit.cover),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          //    mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 100,
              height: 100,
              margin: EdgeInsets.fromLTRB(22, 10, 22, 0),
              padding: EdgeInsets.all(1),
              constraints: BoxConstraints(
                  minWidth: 150, minHeight: 180, maxWidth: 550, maxHeight: 400),
              alignment: Alignment.topCenter,
              child: Image.asset("images/bluesend.png"),
            ),
            /*
            Padding(
              padding: EdgeInsets.only(top: 0, left: 108, bottom: 22),
              child: Text(
                "Blue Send",
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 24,
                    fontWeight: FontWeight.w500),
              ),
            ),*/
            const SizedBox(
              height: 28,
            ),
            Text(
              'kayit_veya_giris'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            ),
            const SizedBox(
              height: 18,
            ),
            SocialLoginButton(
                buttonText: 'gmail'.tr(),
                onPressed: () => _googleIleGiris(context),
                textColor: Colors.black87,
                butonColor: Colors.white,
                butonIcon: Image.asset(
                  "images/google.png",
                  height: 44,
                )),
            const SizedBox(
              height: 6,
            ),
            SocialLoginButton(
              onPressed: () => _emailveSifreGiris(context),
              buttonText: 'mail'.tr(),
              textColor: Colors.white,
              butonIcon: const Icon(
                Icons.mail_outline,
                color: Colors.white,
                size: 44,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 22, right: 22, bottom: 60, top: 22),
              child: TextButton(
                child: Text(
                  'sifremi_unuttum'.tr(),
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => _sifreSifirlama(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
