import 'dart:io';
import 'package:adm_socialmedia_app/model/begen.dart';
import 'package:adm_socialmedia_app/model/status.dart';
import 'package:adm_socialmedia_app/model/user.dart';

import 'package:adm_socialmedia_app/viewmodel/chat_view_model.dart';
import 'package:adm_socialmedia_app/viewmodel/status_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../common_widget/platform_duyarli_alert_dialog.dart';
import '../viewmodel/user_model.dart';

class ConfirmStatusScreen extends StatefulWidget {
  const ConfirmStatusScreen({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ConfirmStatusScreen();
}

class _ConfirmStatusScreen extends State<ConfirmStatusScreen> {
  File? _profilfoto;
  final ImagePicker _picker = ImagePicker();
  late final ChatViewModel? user;
  // final String? kullanici;
  static const String routeName = '/confirm-status-screen';

  Future<File?> _galeridenFotoSec(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      setState(() {
        //kullaniciAdi = _chatModel!.curretUser!.userID! as ChatViewModel;
        _profilfoto = File(image!.path);
        //_profilfoto = _controllerUserName2.text as File?;
      });

      return _profilfoto;
    } catch (e) {
      print("Hata Çıktı Gardaşşş: " + e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context);
    //  final _chatModel = Provider.of<ChatViewModel?>(context);
    //print("Hata Var Gardaşşş: " + file.toString());
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Yeni Hikaye Paylaş",
          style: TextStyle(fontSize: 17),
        ),
        actions: <Widget>[
          GestureDetector(
            child: FlatButton(
              onPressed: () {
                _galeridenFotoSec(ImageSource.gallery);
              },
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.add_photo_alternate_outlined,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: Center(
                child: AspectRatio(
                  aspectRatio: 9 / 16,
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
                            'https://www.pngall.com/wp-content/uploads/2/Upload-PNG-Image-File.png')
                        : FileImage(_profilfoto!) as ImageProvider,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.done, color: Colors.white),
        backgroundColor: Colors.green.shade400,
        onPressed: () async {
          // String? fileType;
          Status _begenenUser = Status(
            userID: _userModel.user!.userID!,
            profilUrl: _profilfoto,
            bendenMi: true,
          );

          var updateResult = await _userModel.updateStatus(
              _begenenUser, "statues", _profilfoto!);
          if (updateResult == true) {
            return;
          }
          //_profilFotoGuncelle(context);
        },
      ),
    );
  }

  void _profilFotoGuncelle(BuildContext context) async {
    Status? userID;
    final _userModel = Provider.of<UserModel>(context, listen: false);
    if (_profilfoto != null) {
      var url =
          await _userModel.statusUploading(userID!, "status", _profilfoto!);
      //print("gelen url :" + url!);
      if (url != true) {
        PlatformDuyarliAlertDialog(
          baslik: 'basarili'.tr(),
          icerik: 'degistirildi'.tr(),
          anaButonYazisi: 'tamam'.tr(),
        ).goster(context);
      } else {
        PlatformDuyarliAlertDialog(
          baslik: 'hata'.tr(),
          icerik: 'degistirilemedi'.tr(),
          anaButonYazisi: 'tamam'.tr(),
        ).goster(context);
      }
    }
  }
}
