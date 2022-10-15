import 'package:adm_socialmedia_app/common_widget/platform_duyarli_alert_dialog.dart';
import 'package:adm_socialmedia_app/model/sikayet.dart';
import 'package:adm_socialmedia_app/viewmodel/chat_view_model.dart';
import 'package:adm_socialmedia_app/viewmodel/user_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SikayetPage extends StatefulWidget {
  @override
  _SikayetPageState createState() => _SikayetPageState();
}

class _SikayetPageState extends State<SikayetPage> {
  @override
  Widget build(BuildContext context) {
    UserModel? _userModel = Provider.of<UserModel>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent.shade400,
        title: Text(
          'kullaniciyi_bildir',
          style: TextStyle(fontSize: 14),
        ).tr(),
        actions: <Widget>[],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 22,
              ),
              Padding(
                padding: const EdgeInsets.all(1),
                child: GestureDetector(
                  onTap: () {
                    _hesabiSikayetEt(context);
                  },
                  child: Card(
                    color: Colors.white,
                    margin: EdgeInsets.zero,
                    child: FlatButton(
                      onPressed: () {
                        _hesabiSikayetEt(context);
                      },
                      child: ListTile(
                        title: Text(
                          'rahatsiz',
                          style: TextStyle(
                              color: Colors.black,
                              fontStyle: FontStyle.normal,
                              fontSize: 15),
                        ).tr(),
                        leading: Icon(
                          Icons.error,
                          color: Colors.amber,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(1),
                child: GestureDetector(
                  onTap: () {
                    _hesabiSikayetEt1(context);
                  },
                  child: Card(
                    color: Colors.white,
                    margin: EdgeInsets.zero,
                    child: FlatButton(
                      onPressed: () => {
                        _hesabiSikayetEt1(context),
                      },
                      child: ListTile(
                        title: Text(
                          'spam',
                          style: TextStyle(
                              color: Colors.black,
                              fontStyle: FontStyle.normal,
                              fontSize: 15),
                        ).tr(),
                        leading: Icon(
                          Icons.error,
                          color: Colors.amber,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(0),
                child: GestureDetector(
                  onTap: () {},
                  child: Card(
                    color: Colors.white,
                    margin: EdgeInsets.zero,
                    child: FlatButton(
                      onPressed: () => {
                        _hesabiSikayetEt2(context),
                      },
                      child: ListTile(
                        title: Text(
                          'hoslanmadim',
                          style: TextStyle(
                              color: Colors.black,
                              fontStyle: FontStyle.normal,
                              fontSize: 15),
                        ).tr(),
                        leading: Icon(
                          Icons.error,
                          color: Colors.amber,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              /*
              SizedBox(
                height: 12,
              ),
              if (_isBannedAdReady)
                Container(
                  height: _bannerAd.size.height.toDouble(),
                  width: _bannerAd.size.width.toDouble(),
                  child: AdWidget(ad: _bannerAd),
                ),*/
            ],
          ),
        ),
      ),
    );
  }

  void _hesabiSikayetEt(BuildContext context) async {
    final _chatModel = Provider.of<ChatViewModel>(context, listen: false);
    final _userModel = Provider.of<UserModel>(context, listen: false);
    Sikayet _sikayetEdenUser = Sikayet(
      sikayet_eden_kisi: _chatModel.curretUser!.userID,
      sikayet_edilen_kisi: _chatModel.sohbetEdilenUser!.userID,
      sikayet: "Bu kullanıcı beni rahatsız ediyor.",
    );

    var updateResult = await _userModel.sikayetEt(_sikayetEdenUser);
    if (updateResult == true) {
      PlatformDuyarliAlertDialog(
        baslik: 'basarili'.tr(),
        icerik: 'donus'.tr(),
        anaButonYazisi: 'tamam'.tr(),
      ).goster(context);
      return;
    }
  }

  void _hesabiSikayetEt1(BuildContext context) async {
    final _chatModel = Provider.of<ChatViewModel>(context, listen: false);
    final _userModel = Provider.of<UserModel>(context, listen: false);
    Sikayet _sikayetEdenUser = Sikayet(
      sikayet_eden_kisi: _chatModel.curretUser!.userID,
      sikayet_edilen_kisi: _chatModel.sohbetEdilenUser!.userID,
      sikayet: "Bu kullanıcıyı spamla",
    );

    var updateResult = await _userModel.sikayetEt(_sikayetEdenUser);
    if (updateResult == true) {
      PlatformDuyarliAlertDialog(
        baslik: 'basarili'.tr(),
        icerik: 'donus'.tr(),
        anaButonYazisi: 'tamam'.tr(),
      ).goster(context);
      return;
    }
  }

  void _hesabiSikayetEt2(BuildContext context) async {
    final _chatModel = Provider.of<ChatViewModel>(context, listen: false);
    final _userModel = Provider.of<UserModel>(context, listen: false);
    Sikayet _sikayetEdenUser = Sikayet(
      sikayet_eden_kisi: _chatModel.curretUser!.userID,
      sikayet_edilen_kisi: _chatModel.sohbetEdilenUser!.userID,
      sikayet: "Sadece bundan hoşlanmadım",
    );

    var updateResult = await _userModel.sikayetEt(_sikayetEdenUser);
    if (updateResult == true) {
      PlatformDuyarliAlertDialog(
        baslik: 'basarili'.tr(),
        icerik: 'donus'.tr(),
        anaButonYazisi: 'tamam'.tr(),
      ).goster(context);
      return;
    }
  }
}
