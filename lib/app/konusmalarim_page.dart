import 'package:adm_socialmedia_app/app/sohbet_page.dart';
import 'package:adm_socialmedia_app/model/konusma.dart';
import 'package:adm_socialmedia_app/model/user.dart';
import 'package:adm_socialmedia_app/viewmodel/chat_view_model.dart';
import 'package:adm_socialmedia_app/viewmodel/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KonusmalarimPage extends StatefulWidget {
  const KonusmalarimPage({Key? key}) : super(key: key);

  @override
  _KonusmalarimPageState createState() => _KonusmalarimPageState();
}

class _KonusmalarimPageState extends State<KonusmalarimPage> {
  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context);
    // ChatViewModel _chatModel = Provider.of<ChatViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent.shade400,
        title: Text(
          'konusmalarim',
          style: TextStyle(fontSize: 14),
        ).tr(),
      ),
      body: FutureBuilder<List<Konusma?>?>(
        future: _userModel.getAllConversations(_userModel.user!.userID!),
        builder: (context, konusmaListesi) {
          if (!konusmaListesi.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var tumKonusmalar = konusmaListesi.data;
            if (tumKonusmalar!.length > 0) {
              return RefreshIndicator(
                color: Colors.lightBlueAccent,
                onRefresh: _konusmalarimListesiniYenile,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    var oankiKonusma = tumKonusmalar[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true).push(
                          MaterialPageRoute(
                            builder: (context) => ChangeNotifierProvider(
                              create: (context) => ChatViewModel(
                                  curretUser: _userModel.user!,
                                  sohbetEdilenUser: Uzer.idveResim(
                                      userID: oankiKonusma!.kimle_konusuyor!,
                                      userName: oankiKonusma.konusulanUserName!,
                                      durum: oankiKonusma.konusulanUserDurum!,
                                      email: oankiKonusma.konusulanUserMail!,
                                      profilUrl: oankiKonusma
                                          .konusulanUserProfilURL!)),
                              child: SohbetPage(),
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        title: Text(
                          oankiKonusma!.son_mesaj!.trimRight(),
                          style: TextStyle(fontSize: 15),
                        ),
                        subtitle: Text(
                          oankiKonusma.konusulanUserName!,
                          style: TextStyle(fontSize: 13),
                        ),
                        leading: CircleAvatar(
                          radius: 31,
                          backgroundColor: Colors.grey.withAlpha(31),
                          backgroundImage: NetworkImage(
                              oankiKonusma.konusulanUserProfilURL!),
                        ),
                      ),
                    );
                  },
                  itemCount: tumKonusmalar.length,
                ),
              );
            } else {
              return RefreshIndicator(
                color: Colors.lightBlueAccent,
                onRefresh: _konusmalarimListesiniYenile,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Container(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.message_outlined,
                            color: Colors.lightBlueAccent,
                            size: 80,
                          ),
                          Text(
                            "Henüz Mesajınız Yok",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 22),
                          )
                        ],
                      ),
                    ),
                    height: MediaQuery.of(context).size.height - 150,
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }

  void _konusmalarimiGetir() async {
    final _userModel = Provider.of<UserModel>(context);
    var konusmalarim = await FirebaseFirestore.instance
        .collection("konusmalar")
        .where("konusma_sahibi", isEqualTo: _userModel.user!.userID!)
        .orderBy("olusturulma_tarihi", descending: true)
        .get();
    for (var konusma in konusmalarim.docs) {
      print("konusma: " + konusma.data().toString());
    }
  }

  Future<Null> _konusmalarimListesiniYenile() async {
    setState(() {});
    await Future.delayed(Duration(seconds: 1));
    return null;
  }
}
