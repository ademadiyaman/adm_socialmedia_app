import 'dart:io';

import 'package:adm_socialmedia_app/locator.dart';
import 'package:adm_socialmedia_app/model/begen.dart';
import 'package:adm_socialmedia_app/model/begenme.dart';
import 'package:adm_socialmedia_app/model/konusma.dart';
import 'package:adm_socialmedia_app/model/mesaj.dart';
import 'package:adm_socialmedia_app/model/sikayet.dart';
import 'package:adm_socialmedia_app/model/status.dart';
import 'package:adm_socialmedia_app/model/user.dart';
import 'package:adm_socialmedia_app/repository/user_repository.dart';
import 'package:adm_socialmedia_app/services/auth_base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:adm_socialmedia_app/locator.dart';

enum ViewState { Idle, Busy, Loaded }

class UserModel with ChangeNotifier implements AuthBase {
  ViewState _state = ViewState.Idle;
  final UserRepository _userRepository = UserRepository();
  final FirebaseFirestore _firebaseDb = FirebaseFirestore.instance;
  Uzer? _user;
  String? emailHataMesaji;
  String? sifreHataMesaji;

  Uzer? get user => _user;

  ViewState get state => _state;

  set state(ViewState value) {
    notifyListeners();
    _state = value;
  }

  UserModel() {
    currentUser();
    // notifyListeners();
  }

  @override
  Future<Uzer?> currentUser() async {
    try {
      notifyListeners();
      state = ViewState.Busy;
      _user = (await _userRepository.currentUser());
      if (_user != null)
        return _user;
      else
        return null;
    } catch (e) {
      debugPrint("VM'deki Current User'da Hata:" + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<Uzer?> signInAnonymously() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.signInAnonymously();
      // notifyListeners();
      return _user;
    } catch (e) {
      debugPrint("VM'deki Current User'da Hata:" + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<Uzer?> signInWithGoogle() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.signInWithGoogle();
      if (_user != null)
        return _user;
      else
        return null;
    } catch (e) {
      debugPrint("VM'deki Current User'da Hata:" + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<Uzer?> signInWithEmailandPassword(String email, String sifre) async {
    try {
      if (_emailSifreKontrol(email, sifre)) {
        state = ViewState.Busy;
        _user = await _userRepository.signInWithEmailandPassword(email, sifre);
        notifyListeners();
        return _user;
      } else
        return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      state = ViewState.Busy;
      bool sonuc = await _userRepository.signOut();
      _user = null;
      notifyListeners();
      return sonuc;
    } catch (e) {
      debugPrint("VM'deki Current User'da Hata:" + e.toString());
      notifyListeners();
      return false;
    } finally {
      state = ViewState.Idle;
    }
  }

  Future<Status?> statusUploading(
      Status userID, String? fileType, File profilFoto) async {
    notifyListeners();
    //var indirmeLinki =
    await _userRepository.updateRepo(userID, fileType!, profilFoto);

    return null;
  }

  @override
  Future<Uzer?> createUserWithEmailandPassword(
      String email, String sifre) async {
    if (_emailSifreKontrol(email, sifre)) {
      try {
        state = ViewState.Busy;
        _user =
            await _userRepository.createUserWithEmailandPassword(email, sifre);
        return _user;
      } finally {
        state = ViewState.Idle;
      }
    } else
      return null;
  }

  bool _emailSifreKontrol(String email, String sifre) {
    var sonuc = true;
    if (sifre.length < 6) {
      sifreHataMesaji = "En az 6 karakter girmelisiniz!";
      sonuc = false;
    } else
      sifreHataMesaji = null;

    if (!email.contains('@')) {
      emailHataMesaji = "Geçersiz E mail adresi";
      sonuc = false;
    } else
      emailHataMesaji = null;
    notifyListeners();
    return sonuc;
  }

  Future<String?> updateStatus(
      Status status, String? fileType, File profilFoto) async {
    var downloadLink =
        await _userRepository.updateRepo(status, fileType!, profilFoto);
    return downloadLink;
  }

  Future<String?> uploadFile(
      String userID, String? fileType, File profilFoto) async {
    notifyListeners();
    var indirmeLinki =
        await _userRepository.uploadFile(userID, fileType, profilFoto);

    return indirmeLinki;
  }

  Future<bool> updateUserName(String userID, String yeniUserName) async {
    notifyListeners();
    var sonuc = await _userRepository.updateUserName(userID, yeniUserName);
    if (sonuc) {
      _user!.userName = yeniUserName;
    }
    notifyListeners();
    return sonuc;
  }

  Future<bool> updateDurum(String userID, String yeniDurum) async {
    var sonuc = await _userRepository.updateDurum(userID, yeniDurum);
    if (sonuc) {
      _user!.durum = yeniDurum;
    }
    notifyListeners();
    return sonuc;
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

  Future<bool?> deleteUser(String userID) async {
    var sonuc = await _userRepository.deleteUser(userID);
    notifyListeners();
    return sonuc;
  }

  Stream<List<Mesaj>> getMessages(String currentUser, String sohbetEdilenID) {
    return _userRepository.getMessages(currentUser, sohbetEdilenID);
  }

  Future<List<Konusma?>?> getAllConversations(String userID) async {
    return await _userRepository.getAllConversations(userID);
  }

  Future<List<Begenme?>?> getAllConversationsBegenme(String userID) async {
    return await _userRepository.getAllConversationsBegenme(userID);
  }

  Future<List<Uzer?>?> getUser(String userID) async {
    return await _userRepository.getAllConversationsUzer(userID);
  }

  Future<List<Uzer?>> getUserWithPagination(
      Uzer? enSonGetirilenUser, int getirilecekElemanSayisi) async {
    return await _userRepository.getUserWithPagination(
        enSonGetirilenUser, getirilecekElemanSayisi);
  }

  dahaFazlaBilgiGetir() {}

  Future<bool?> resimBegen(Begen begenenUser) async {
    return await _userRepository.begenenKullanici(begenenUser);
  }

  Future<bool?> sikayetEt(Sikayet sikayetEdenUser) async {
    return await _userRepository.sikayetEdenKullanici(sikayetEdenUser);
  }
}
