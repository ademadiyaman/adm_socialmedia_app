import 'dart:io';

import 'package:adm_socialmedia_app/app/kullanici_profili.dart';
import 'package:adm_socialmedia_app/app/sikayet_et.dart';
import 'package:adm_socialmedia_app/common_widget/platform_duyarli_alert_dialog.dart';
import 'package:adm_socialmedia_app/model/mesaj.dart';
import 'package:adm_socialmedia_app/model/user.dart';
import 'package:adm_socialmedia_app/notification_handler.dart';
import 'package:adm_socialmedia_app/services/bildirim_gonderme_servis.dart';
import 'package:adm_socialmedia_app/viewmodel/all_user_viewmodel.dart';
import 'package:adm_socialmedia_app/viewmodel/chat_view_model.dart';
import 'package:adm_socialmedia_app/viewmodel/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class SohbetPage extends StatefulWidget {
  @override
  _SohbetPageState createState() => _SohbetPageState();
}

class _SohbetPageState extends State<SohbetPage> {
  BildirimGondermeServis _bildirimGondermeServis = BildirimGondermeServis();
  Map<String, String> kullaniciToken = Map<String, String>();
  FlutterSoundRecorder? _soundRecorder;

  var _mesajController = TextEditingController();
  ScrollController _scrollController = new ScrollController();
  bool _isLoading = false;
  bool isRecorderInit = false;
  bool isRecording = false;
  bool isShowSendButton = false;
  File? _profilfoto;

  //late final XFile? _profilFoto;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_scrollListener);
    _soundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw RecordingPermissionException('Mic Permission Not Allowed');
    }
    await _soundRecorder!.openRecorder();
    isRecorderInit = true;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _mesajController.dispose();
    _soundRecorder!.closeRecorder();
    isRecorderInit = false;
  }

  @override
  Widget build(BuildContext context) {
    final _chatModel = Provider.of<ChatViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent.shade400,
        title: GestureDetector(
          onTap: () {
            Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(
                create: (context) => ChatViewModel(
                    curretUser: _chatModel.curretUser!,
                    sohbetEdilenUser: _chatModel.sohbetEdilenUser!),
                child: KullaniciProfiliPage(),
              ),
            ));
          },
          child: Text(
            _chatModel.sohbetEdilenUser!.userName!,
            style: TextStyle(fontSize: 15),
          ),
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                // onTap: () => _silmekIcinOnayIste(context),
                child: TextButton(
                    onPressed: () => fotografGonder(context),
                    child: Text(
                      'fotograf_gonder',
                      style: TextStyle(fontSize: 15),
                    ).tr()),
              ),
              PopupMenuItem(
                onTap: () => _silmekIcinOnayIste(context),
                child: TextButton(
                  onPressed: () => _silmekIcinOnayIste(context),
                  child: Text(
                    'konusmayi_sil',
                    style: TextStyle(fontSize: 15),
                  ).tr(),
                ),
              ),
              PopupMenuItem(
                // onTap: () => _silmekIcinOnayIste(context),
                child: TextButton(
                  onPressed: () => _kullaniciyiSikayetEt(context),
                  child: Text(
                    'kullaniciyi_bildir',
                    style: TextStyle(fontSize: 15),
                  ).tr(),
                ),
              ),
            ],
          ),
        ],
      ),
      body: _chatModel.state == ChatViewState.Busy
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Column(
                children: <Widget>[
                  _buildMesajListesi(),
                  //_buildBildirimGosterme(),
                  _buildYeniMesajGir(),
                ],
              ),
            ),
    );
  }

  Widget _kullaniciProfiliGoster(int index) {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    final _tumKullanicilarViewModel =
        Provider.of<AllUserViewModel>(context, listen: false);
    var _oankiUser = _tumKullanicilarViewModel.kullanicilarListesi![index];
    if (_oankiUser!.userID == _userModel.user!.userID) {
      return Container();
    }
    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (context) => ChatViewModel(
                curretUser: _userModel.user!, sohbetEdilenUser: _oankiUser),
            child: SohbetPage(),
          ),
        ));
      },
    );
  }

  Widget _buildMesajListesi() {
    return Consumer<ChatViewModel>(builder: (context, chatModel, child) {
      return Expanded(
        child: ListView.builder(
          controller: _scrollController,
          reverse: true,
          itemBuilder: (context, index) {
            if (chatModel.hasMoreLoading &&
                chatModel.mesajlarListesi!.length == index) {
              return _yeniElemanlarYukleniyorIndicator();
            } else {
              return _konusmaBalonuOlustur(chatModel.mesajlarListesi![index]!);
            }
          },
          itemCount: chatModel.hasMoreLoading
              ? chatModel.mesajlarListesi!.length + 1
              : chatModel.mesajlarListesi!.length,
        ),
      );
    });
  }

  Widget _buildYeniMesajGir() {
    final _chatModel = Provider.of<ChatViewModel>(context);
    final _userModel = Provider.of<UserModel>(context);
    return Container(
      padding: EdgeInsets.only(bottom: 10, left: 8, right: 0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextFormField(
              onChanged: (val) {
                if (val.isNotEmpty) {
                  setState(() {
                    isShowSendButton = true;
                  });
                } else {
                  setState(() {
                    isShowSendButton = false;
                  });
                }
              },
              autofocus: true,
              controller: _mesajController,
              cursorColor: Colors.blueGrey,
              style: new TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: 'mesajinizi_yazin'.tr(),
                hintStyle: TextStyle(fontSize: 12),
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 0),
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: 3,
              ),
              child: FloatingActionButton(
                elevation: 50,
                backgroundColor: Colors.blue.shade700,
                child: Icon(
                  Icons.send,
                  size: 21,
                  color: Colors.white,
                ),
                onPressed: () async {
                  _buildBildirimGosterme(context);
                  if (_mesajController.text.trim().length > 0) {
                    //Uzer? curretUser;
                    Mesaj _kaydedilecekMesaj = Mesaj(
                      kimden: _chatModel.curretUser!.userID!,
                      kime: _chatModel.sohbetEdilenUser!.userID!,
                      bendenMi: true,
                      mesaj: _mesajController.text,
                    );
                    var token;
                    var sonuc = await _chatModel.saveMessage(
                        _kaydedilecekMesaj, _chatModel.curretUser!);
                    if (sonuc!) {
                      _mesajController.clear();
                      _scrollController.animateTo(
                        0,
                        curve: Curves.easeOut,
                        duration: const Duration(milliseconds: 10),
                      );
                    }
                    setState(() {
                      _mesajController.text = '';
                    });
                    if (isShowSendButton) {
                      await _chatModel.saveMessage(
                          _kaydedilecekMesaj, _chatModel.curretUser!);
                    }
                  } else {
                    var temDir = await getTemporaryDirectory();
                    var path = '${temDir.path}/flutter_sound.aac';
                    if (!isRecorderInit) {
                      return;
                    }
                    if (isRecording) {
                      await _soundRecorder!.stopRecorder();
                    } else {
                      await _soundRecorder!.startRecorder(
                        toFile: path,
                      );
                    }
                    setState(() {
                      isRecording = !isRecording;
                    });
                  }
                },
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            child: FloatingActionButton(
              elevation: 50,
              backgroundColor: Colors.green,
              child: GestureDetector(
                child: Icon(
                  isShowSendButton ? Icons.close : Icons.mic,
                  size: 19,
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                _buildBildirimGosterme(context);
                if (_mesajController.text.trim().length > 0) {
                  Mesaj _kaydedilecekMesaj = Mesaj(
                    kimden: _chatModel.curretUser!.userID!,
                    kime: _chatModel.sohbetEdilenUser!.userID!,
                    bendenMi: true,
                    mesaj: _mesajController.text,
                  );
                  var token;
                  var sonuc = await _chatModel.saveMessage(
                      _kaydedilecekMesaj, _chatModel.curretUser!);
                  if (sonuc!) {
                    _mesajController.clear();
                    _scrollController.animateTo(
                      0,
                      curve: Curves.easeOut,
                      duration: const Duration(milliseconds: 10),
                    );
                  }
                  setState(() {
                    _mesajController.text = '';
                  });
                } else {
                  var temDir = await getTemporaryDirectory();
                  var path = '${temDir.path}/flutter_sound.aac';
                  if (!isRecorderInit) {
                    Mesaj _kaydedilecekMesaj = Mesaj(
                        kimden: _chatModel.curretUser!.userID!,
                        kime: _chatModel.sohbetEdilenUser!.userID!,
                        bendenMi: true,
                        mesaj: temDir.path);
                    await _chatModel.saveMessage(
                        _kaydedilecekMesaj, _chatModel.curretUser!);
                    return;
                  }
                  if (isRecording) {
                    await _soundRecorder!.startRecorder(toFile: path);
                  } else {
                    await _soundRecorder!.startRecorder(
                      toFile: path,
                    );
                  }
                  setState(() {
                    isRecording = !isRecording;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _konusmaBalonuOlustur(Mesaj? oankiMesaj) {
    Color _gelenMesajRenk = Colors.lightBlue.shade100;
    Color _gidenMesajRenk = Colors.lightBlueAccent.shade400;
    final _chatModel = Provider.of<ChatViewModel>(context);
    var _saatDakikaDegeri = "";

    try {
      _saatDakikaDegeri =
          _saatDakikaGoster(oankiMesaj!.date ?? Timestamp(1, 1))!;
    } catch (e) {
      print("Hata var" + e.toString());
    }
    var _benimMesajimMi = oankiMesaj!.bendenMi;
    if (_benimMesajimMi!) {
      return Padding(
        padding: EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: _gidenMesajRenk,
                    ),
                    padding: EdgeInsets.all(11),
                    margin: EdgeInsets.all(2),
                    child: Text(
                      oankiMesaj.mesaj!,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Text(
                  _saatDakikaDegeri,
                  style: TextStyle(fontSize: 10),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Colors.grey.withAlpha(31),
                  backgroundImage:
                      NetworkImage(_chatModel.sohbetEdilenUser!.profilUrl!),
                ),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: _gelenMesajRenk,
                    ),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(4),
                    child: Text(oankiMesaj.mesaj!),
                  ),
                ),
                Text(
                  _saatDakikaDegeri,
                  style: TextStyle(fontSize: 10),
                ),
              ],
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      );
    }
  }

  String? _saatDakikaGoster(Timestamp? date) {
    var _formatter = DateFormat.Hm();
    var _formatlanmisTarih = _formatter.format(date!.toDate());
    return _formatlanmisTarih;
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      eskiMesajlariGetir();
    }
  }

  _yeniElemanlarYukleniyorIndicator() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: CircularProgressIndicator(
          color: Colors.lightBlueAccent,
          backgroundColor: Colors.white70,
        ),
      ),
    );
  }

  void eskiMesajlariGetir() async {
    print("Listenin en üstündeyiz eski mesajları getir");
    final _chatModel = Provider.of<ChatViewModel>(context, listen: false);
    if (_isLoading == false) {
      _isLoading = true;
      await _chatModel.dahaFazlaMesajGetir();
      _isLoading = false;
    }
  }

  Future<File?> _kameradanFotoCek() async {
    var _yeniResim = await _picker.pickImage(source: ImageSource.camera);
    final File? file = File(_yeniResim!.path);
    return file;
  }

  Future<File?> _galeridenFotoSec(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      setState(() {
        _profilfoto = File(image!.path);
        Navigator.of(context).pop();
      });
      return _profilfoto;
    } catch (e) {
      print("Hata Çıktı Gardaşşş: " + e.toString());
    }
  }

  _gestureDetector(BuildContext context) {
    final _chatModel = Provider.of<ChatViewModel>(context, listen: false);
    Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent.shade400,
        title: Text("Sohbet"),
        actions: <Widget>[
          FlatButton(
            onPressed: () => _gestureDetector(context),
            child: Icon(
              Icons.add_photo_alternate_outlined,
            ),
          )
        ],
      ),
      body: _chatModel.state == ChatViewState.Busy
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                          height: 133,
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.camera),
                                title: Text("Kameradan Çek"),
                                onTap: () {
                                  _kameradanFotoCek();
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.photo),
                                title: Text("Galeriden Seç"),
                                onTap: () {
                                  _galeridenFotoSec(ImageSource.gallery);
                                },
                              ),
                            ],
                          ),
                        );
                      });
                },
                child: Column(
                  children: <Widget>[
                    _buildMesajListesi(),
                    _buildYeniMesajGir(),
                  ],
                ),
              ),
            ),
    );
  }

  Future<bool?> _mesajiSil(BuildContext context) async {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    final _chatModel = Provider.of<ChatViewModel>(context, listen: false);
    //bool sonuc;
    var updateResult = await _chatModel.deleteChat(
        _chatModel.curretUser!.userID!, _chatModel.sohbetEdilenUser!.userID!);
    try {
      if (updateResult == true) {
        Navigator.pop(context);
        PlatformDuyarliAlertDialog(
          baslik: "Başarılı",
          icerik: "Mesajınız başarı ile silindi.",
          anaButonYazisi: "Tamam",
        ).goster(context);
        return true;
      } else {
        PlatformDuyarliAlertDialog(
          baslik: "Hata",
          icerik:
              "Kullanıcı adınız değiştirilemedi! Bu kullanıcı adı kullanılıyor.",
          anaButonYazisi: "Tamam",
        ).goster(context);
        return false;
      }
    } catch (e) {
      print("Hata Çıhtı gardaşşş: " + e.toString());
    }
  }

  Future _silmekIcinOnayIste(BuildContext context) async {
    final sonuc = await PlatformDuyarliAlertDialog(
      baslik: 'sil'.tr(),
      icerik: 'konusma_silme_uyari'.tr(),
      anaButonYazisi: 'evet'.tr(),
      iptalButonYazisi: 'hayir'.tr(),
    ).goster(context);

    if (sonuc == true) {
      _mesajiSil(context);
      Navigator.pop(context);
    }
  }

  fotografGonder(BuildContext context) {}

  void _kullaniciyiSikayetEt(BuildContext context) {
    UserModel? _userModel = Provider.of<UserModel>(context, listen: false);
    ChatViewModel? _chatModel =
        Provider.of<ChatViewModel>(context, listen: false);
    Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
      builder: (context) => ChangeNotifierProvider(
        create: (context) => ChatViewModel(
            curretUser: _chatModel.curretUser,
            sohbetEdilenUser: _chatModel.sohbetEdilenUser),
        child: SikayetPage(),
      ),
    ));
  }

  _buildBildirimGosterme(BuildContext context) async {
    ChatViewModel? _chatModel =
        Provider.of<ChatViewModel>(context, listen: false);
    Mesaj _kaydedilecekMesaj = Mesaj(
      kimden: _chatModel.curretUser!.userID!,
      kime: _chatModel.sohbetEdilenUser!.userID!,
      bendenMi: true,
      mesaj: _mesajController.text,
    );
    var token;

    var konustugumKullanici = _chatModel.sohbetEdilenUser;
    if (konustugumKullanici != null) {
      await _bildirimGondermeServis.bildirimGonder(
          _kaydedilecekMesaj, _chatModel.curretUser!, token);
      return false;
    }
  }
}
