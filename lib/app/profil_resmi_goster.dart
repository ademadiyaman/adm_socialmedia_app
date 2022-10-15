import 'dart:io';

import 'package:adm_socialmedia_app/app/begenileri_gor.dart';
import 'package:adm_socialmedia_app/model/user.dart';
import 'package:adm_socialmedia_app/viewmodel/chat_view_model.dart';
import 'package:adm_socialmedia_app/viewmodel/user_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilResmiGoster extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfilResmiGoster();
}

class _ProfilResmiGoster extends State<ProfilResmiGoster> {
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
          'profil_resmi_goster',
          style: TextStyle(fontSize: 14, color: Colors.white),
        ).tr(),
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
              return Container(
                //  onRefresh: _listeyiYenile,
                color: Colors.black,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    var oankiUser = myUser[index];
                    return Center(
                      child: Column(
                        //verticalDirection: VerticalDirection.up,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 130),
                            child: Container(
                              width: 370,
                              height: 400,
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
                                  image: _profilfoto == null
                                      ? NetworkImage(
                                          oankiUser!.profilUrl!,
                                        )
                                      : FileImage(_profilfoto!)
                                          as ImageProvider,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                right: 222, bottom: 7, left: 0, top: 11),
                            child: Card(
                              margin: EdgeInsets.zero,
                              child: FlatButton(
                                height: 15,
                                minWidth: 15,
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true)
                                      .push(MaterialPageRoute(
                                    builder: (context) =>
                                        ChangeNotifierProvider(
                                      create: (context) => ChatViewModel(
                                          curretUser: _chatModel.curretUser!,
                                          sohbetEdilenUser:
                                              _chatModel.sohbetEdilenUser!),
                                      child: BegenileriGor(),
                                    ),
                                  ));
                                },
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.whatshot,
                                      size: 27,
                                      color: Colors.red,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 22, bottom: 4),
                            child: Row(
                              children: [
                                FlatButton(
                                  onPressed: () {},
                                  child: Text(
                                    "Beğenileri Gör",
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

  Future<Null> _listeyiYenile() async {
    setState(() {});
    await Future.delayed(Duration(seconds: 1));
    return null;
  }
}
