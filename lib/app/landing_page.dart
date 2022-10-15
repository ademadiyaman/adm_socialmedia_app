import 'package:adm_socialmedia_app/app/home_page.dart';
import 'package:adm_socialmedia_app/app/sign_in/sign_in_page.dart';
import 'package:adm_socialmedia_app/viewmodel/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context);
    if (_userModel.state == ViewState.Idle) {
      if (_userModel.user == null) {
        return SignInPage();
      } else {
        return HomePage(user: _userModel.user!);
      }
    } else {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
