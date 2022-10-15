import 'dart:async';

import 'package:adm_socialmedia_app/model/mesaj.dart';
import 'package:adm_socialmedia_app/model/user.dart';
import 'package:adm_socialmedia_app/repository/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum ChatViewState { Idle, Loaded, Busy }

class ChatViewModel with ChangeNotifier {
  final FirebaseFirestore _firebaseDb = FirebaseFirestore.instance;
  List<Mesaj?>? _tumMesajlar;
  ChatViewState _state = ChatViewState.Idle;
  static final sayfaBasinaGonderiSayisi = 13;

  UserRepository _userRepository = UserRepository();

  final Uzer? curretUser;
  final Uzer? sohbetEdilenUser;
  Mesaj? _enSonGetirilenMesaj;
  Mesaj? _listeyeEklenenIlkMesaj;
  bool _hasMore = true;
  bool _yeniMesajDinleListener = false;
  bool get hasMoreLoading => _hasMore;
  StreamSubscription? _streamSubscription;

  ChatViewModel({this.curretUser, this.sohbetEdilenUser}) {
    _tumMesajlar = [];
    getMessageWithPagination(true);
  }

  List<Mesaj?>? get mesajlarListesi => _tumMesajlar;
  ChatViewState get state => _state;

  set state(ChatViewState value) {
    _state = value;
    notifyListeners();
  }

  @override
  dispose() {
    print("Chatviewmodel dispose edildi!");
    _streamSubscription!.cancel();
    super.dispose();
  }

  Future<bool?> deleteUser(String userID) async {
    var sonuc = await _userRepository.deleteUser(userID);
    notifyListeners();
    return sonuc;
  }
/*
  Future<bool?> deleteChat(String currentUserID) async {
    //var sonuc;
    // var _mesajID = _firebaseDb.collection("konusmalar").doc().id;
    // var myDocumentID = userID.kimden;
    var sonuc = await _userRepository.deleteMesaj(currentUserID);
    notifyListeners();
    return sonuc;
  }*/

  Future<bool?> saveMessage(Mesaj kaydedilecekMesaj, Uzer curretUser) async {
    return await _userRepository.saveMessage(kaydedilecekMesaj, curretUser);
  }

  void getMessageWithPagination(bool yeniMesajlarGetiriliyor) async {
    if (_tumMesajlar!.length > 0) {
      _enSonGetirilenMesaj = _tumMesajlar!.last;
    }
    if (!yeniMesajlarGetiriliyor) state = ChatViewState.Busy;
    var getirilenMesajlar = await _userRepository.getMessageWithPagination(
        curretUser!.userID!,
        sohbetEdilenUser!.userID!,
        _enSonGetirilenMesaj,
        sayfaBasinaGonderiSayisi);
    if (getirilenMesajlar!.length < sayfaBasinaGonderiSayisi) {
      _hasMore = false;
    }
    getirilenMesajlar
        .forEach((msj) => print("Getirilen Mesajlar: " + msj!.mesaj!));
    _tumMesajlar!.addAll(getirilenMesajlar);
    if (_tumMesajlar!.length > 0) {
      _listeyeEklenenIlkMesaj = _tumMesajlar!.first;
      print("Listeye eklenen ilk mesaj" + _listeyeEklenenIlkMesaj!.mesaj!);
    }

    state = ChatViewState.Loaded;

    if (_yeniMesajDinleListener == false) {
      _yeniMesajDinleListener = true;
      print("Listener yok o yüzden atanacak");
      yeniMesajDinleListenerAta();
    }
  }

  Future<void> dahaFazlaMesajGetir() async {
    print("Daha fazla mesaj getir tetiklendi - viewmodeldeyiz");
    if (_hasMore)
      getMessageWithPagination(true);
    else
      print("Daha Fazla eleman yok o yüzden çağırılmayacak");
    await Future.delayed(Duration(seconds: 2));
  }

  void yeniMesajDinleListenerAta() {
    print("Yeni mesajlar için listener atandı");
    _streamSubscription = _userRepository
        .getMessages(curretUser!.userID!, sohbetEdilenUser!.userID!)
        .listen((anlikData) {
      if (anlikData.isNotEmpty) {
        print("Listener tetiklendi son getirilen veri: " +
            anlikData[0].toString());
        if (anlikData[0].date != null) {
          if (_listeyeEklenenIlkMesaj == null) {
            _tumMesajlar!.insert(0, anlikData[0]);
          } else if (_listeyeEklenenIlkMesaj!.date!.millisecondsSinceEpoch !=
              anlikData[0].date!.millisecondsSinceEpoch)
            _tumMesajlar!.insert(0, anlikData[0]);
        }
        state = ChatViewState.Loaded;
      }
    });
  }

  Future<bool?> deleteChat(
      String currentUserID, String sohbetEdilenUser) async {
    //var _mesajID = _firebaseDb.collection("konusmalar").doc().id;
    // var myDocumentID = userID.kimden;
    var sonuc =
        await _userRepository.deleteMesaj(currentUserID, sohbetEdilenUser);
    notifyListeners();
    return sonuc;
  }

  updateStatus() {}
}
