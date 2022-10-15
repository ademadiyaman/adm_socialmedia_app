import 'dart:io';

import 'package:adm_socialmedia_app/app/begenileri_gor.dart';
import 'package:adm_socialmedia_app/common_widget/platform_duyarli_alert_dialog.dart';
import 'package:adm_socialmedia_app/model/begen.dart';
import 'package:adm_socialmedia_app/viewmodel/chat_view_model.dart';
import 'package:adm_socialmedia_app/viewmodel/user_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/user.dart';

class KullaniciResmiGoster extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _KullaniciResmiGoster();
}

class _KullaniciResmiGoster extends State<KullaniciResmiGoster> {
  File? _profilfoto;
  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context);
    final _chatModel = Provider.of<ChatViewModel>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          _chatModel.sohbetEdilenUser!.userName!,
          style: TextStyle(fontSize: 14, color: Colors.white),
        ).tr(),
      ),
      body: Container(
        color: Colors.black,
        child: Center(
          child: Column(
            //verticalDirection: VerticalDirection.up,
            children: <Widget>[
              Expanded(
                child: InteractiveViewer(
                  maxScale: 5,
                  child: Image(
                    colorBlendMode: BlendMode.screen,
                    isAntiAlias: false,
                    matchTextDirection: false,
                    filterQuality: FilterQuality.low,
                    gaplessPlayback: false,
                    fit: BoxFit.fitWidth,
                    excludeFromSemantics: true,
                    repeat: ImageRepeat.repeat,
                    alignment: Alignment.centerRight,
                    image: NetworkImage(
                      _chatModel.sohbetEdilenUser!.profilUrl!,
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(right: 252, bottom: 1, left: 10, top: 1),
                child: Card(
                  margin: EdgeInsets.zero,
                  child: FlatButton(
                    height: 15,
                    minWidth: 15,
                    onPressed: () {
                      /*
                      Navigator.of(context, rootNavigator: true)
                          .push(MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                          create: (context) =>
                              ChatViewModel(curretUser: _userModel.user!),
                          child: BegenileriGor(),
                        ),
                      ));*/
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.whatshot,
                          size: 27,
                          color: Colors.lightBlueAccent,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14, bottom: 11, top: 0),
                child: Row(
                  children: [
                    FlatButton(
                      onPressed: () async {
                        Begen _begenenUser = Begen(
                          oankiUser: _chatModel.curretUser!.userID,
                          begenen: _chatModel.sohbetEdilenUser!.userID,
                          profilFoto: _chatModel.sohbetEdilenUser!.profilUrl,
                          bendenMi: true,
                        );

                        var updateResult =
                            await _userModel.resimBegen(_begenenUser);
                        if (updateResult == true) {
                          return;
                        }
                      },
                      child: Text(
                        "Beğen",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _begen(BuildContext context) async {}
}
