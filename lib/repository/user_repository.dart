import 'dart:ffi';
import 'dart:io';

import 'package:adm_socialmedia_app/locator.dart';
import 'package:adm_socialmedia_app/model/begen.dart';
import 'package:adm_socialmedia_app/model/begenme.dart';
import 'package:adm_socialmedia_app/model/konusma.dart';
import 'package:adm_socialmedia_app/model/mesaj.dart';
import 'package:adm_socialmedia_app/model/sikayet.dart';
import 'package:adm_socialmedia_app/model/status.dart';
import 'package:adm_socialmedia_app/model/user.dart';
import 'package:adm_socialmedia_app/services/auth_base.dart';
import 'package:adm_socialmedia_app/services/bildirim_gonderme_servis.dart';

import 'package:adm_socialmedia_app/services/firebase_auth_service.dart';
import 'package:adm_socialmedia_app/services/firebase_storage_service.dart';
import 'package:adm_socialmedia_app/services/firestore_db_service.dart';
import 'package:adm_socialmedia_app/viewmodel/chat_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../services/fake_auth_services.dart';

enum AppMode { DEBUG, RELEASE }

class UserRepository implements AuthBase {
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();
  final FakeAuthService _fakeAuthService = FakeAuthService();
  final FirestoreDBService _firestoreDBService = FirestoreDBService();
  final FirebaseStorageService _firebaseStorageService =
      FirebaseStorageService();
  BildirimGondermeServis _bildirimGondermeServis = BildirimGondermeServis();
  AppMode appMode = AppMode.RELEASE;
  Map<String, String> kullaniciToken = Map<String, String>();

  List<Uzer?> tumKullaniciListesi = [];
  @override
  Future<Uzer?> currentUser() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.currentUser();
    } else {
      Uzer? _user = await _firebaseAuthService.currentUser();
      if (_user != null)
        return await _firestoreDBService.readUser(_user.userID!);
      else
        return null;
    }
  }

  @override
  Future<Uzer?> signInAnonymously() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInAnonymously();
    } else {
      return await _firebaseAuthService.signInAnonymously();
    }
  }

  @override
  Future<Uzer?> signInWithGoogle() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInWithGoogle();
    } else {
      Uzer? _user = await _firebaseAuthService.signInWithGoogle();
      if (_user != null) {
        bool _sonuc = await _firestoreDBService.saveUser(_user);
        if (_sonuc) {
          return await _firestoreDBService.readUser(_user.userID);
        } else {
          await _firebaseAuthService.signOut();
          return null;
        }
      } else
        return null;
    }
  }

  @override
  Future<bool> signOut() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signOut();
    } else {
      return await _firebaseAuthService.signOut();
    }
  }

  @override
  Future<Uzer?> createUserWithEmailandPassword(
      String email, String sifre) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.createUserWithEmailandPassword(
          email, sifre);
    } else {
      Uzer? _user = await _firebaseAuthService.createUserWithEmailandPassword(
          email, sifre);
      bool _sonuc = await _firestoreDBService.saveUser(_user);
      if (_sonuc) {
        return await _firestoreDBService.readUser(_user!.userID);
      } else
        return null;
    }
  }

  @override
  Future<Uzer?> signInWithEmailandPassword(String email, String sifre) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInWithEmailandPassword(email, sifre);
    } else {
      Uzer? _user =
          await _firebaseAuthService.signInWithEmailandPassword(email, sifre);
      return await _firestoreDBService.readUser(_user!.userID);
    }
  }

  Future<bool> updateUserName(String userID, String yeniUserName) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {
      return await _firestoreDBService.updateUserName(userID, yeniUserName);
    }
  }

  Future<String?> updateRepo(
      Status? status, String? fileType, File profilFoto) async {
    if (appMode == AppMode.DEBUG) {
      return "dosya";
    } else {
      var profilFotoUrl = await _firebaseStorageService.uploadStatuFile(
          status!, fileType!, profilFoto);
      await _firestoreDBService.saveStatus(status, profilFoto);
      return profilFotoUrl;
    }
  }

  Future<String?> uploadFile(
      String userID, String? fileType, File profilFoto) async {
    if (appMode == AppMode.DEBUG) {
      return "dosya_indirme_linki";
    } else {
      var profilFotoUrl = await _firebaseStorageService.uploadFile(
          userID, fileType, profilFoto);
      await _firestoreDBService.updateProfilFoto(userID, profilFotoUrl!);
      return profilFotoUrl;
    }
  }

  Future<bool> updateDurum(String userID, String yeniDurum) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {
      return await _firestoreDBService.updateDurum(userID, yeniDurum);
    }
  }

  @override
  Future<bool?> deleteUser(String userID) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {
      return await _firestoreDBService.deleteUser(userID);
    }
  }

  @override
  Future<bool?> deleteMesaj(
      String currentUserID, String sohbetEdilenUser) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {
      return await _firestoreDBService.deleteChat(
          currentUserID, sohbetEdilenUser);
    }
  }

  Stream<List<Mesaj>> getMessages(
      String currentUserID, String sohbetEdilenUserID) {
    if (appMode == AppMode.DEBUG) {
      return Stream.empty();
    } else {
      return _firestoreDBService.getMessages(currentUserID, sohbetEdilenUserID);
    }
  }

  Future<bool> saveMessage(Mesaj kaydedilecekMesaj, Uzer curretUser) async {
    if (appMode == AppMode.DEBUG) {
      return true;
    } else {
      var dbYazmaIslemi =
          await _firestoreDBService.saveMessage(kaydedilecekMesaj);
      if (dbYazmaIslemi) {
        var token = "";
        if (kullaniciToken.containsKey(kaydedilecekMesaj.kime)) {
          token = kullaniciToken[kaydedilecekMesaj.kime]!;
          print("Localden geldi: " + token);
        } else {
          token =
              (await _firestoreDBService.tokenGetir(kaydedilecekMesaj.kime))!;
          if (token != null) kullaniciToken[kaydedilecekMesaj.kime] = token;
          print("Veri tabanından geldi: " + token);
        }
        if (token != null) {
          await _bildirimGondermeServis.bildirimGonder(
              kaydedilecekMesaj, curretUser, token);
        }
        return true;
      } else {
        return false;
      }
    }
  }

  Future<bool> begenenKullanici(Begen begenenUser) async {
    if (appMode == AppMode.DEBUG) {
      return true;
    } else {
      return _firestoreDBService.saveBegeni(begenenUser);
    }
  }

  Future<bool> sikayetEdenKullanici(Sikayet sikayetEdenUser) async {
    if (appMode == AppMode.DEBUG) {
      return true;
    } else {
      return _firestoreDBService.saveSikayet(sikayetEdenUser);
    }
  }

  Future<List<Konusma>?> getAllConversations(String userID) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      // DateTime? _zaman = await _firestoreDBService.saatiGoster(userID);
      var konusmaListesi =
          await _firestoreDBService.getAllConversations(userID);
      try {
        for (var oankiKonusma in konusmaListesi) {
          var userListesindekiKullanici =
              listedeUserBul(oankiKonusma.kimle_konusuyor!);

          if (userListesindekiKullanici != null) {
            print("Veriler Local'den okundu.");
            oankiKonusma.konusulanUserName =
                userListesindekiKullanici.userName!;
            oankiKonusma.konusulanUserProfilURL =
                userListesindekiKullanici.profilUrl;
            oankiKonusma.konusulanUserDurum = userListesindekiKullanici.durum;
            oankiKonusma.konusulanUserMail = userListesindekiKullanici.email;
            //  oankiKonusma.sonOkunmaZamani = _zaman;

            /*   var _duration =
                _zaman!.difference(oankiKonusma.olusturulma_tarihi!.toDate());
            oankiKonusma.aradakiFark = timeago.format(
                _zaman.subtract(_zaman.subtract(_duration) as Duration)); */
          } else {
            print(
                "Aranan user daha önce getirilmemiştir! Veri tabanından getirilmesi gerekiyor.");
            var _veritabanindanOkunanUser = await _firestoreDBService
                .readUser(oankiKonusma.kimle_konusuyor!);
            oankiKonusma.konusulanUserName =
                _veritabanindanOkunanUser!.userName!;
            oankiKonusma.konusulanUserProfilURL =
                _veritabanindanOkunanUser.profilUrl;
            oankiKonusma.konusulanUserDurum = _veritabanindanOkunanUser.durum;
            oankiKonusma.konusulanUserMail = _veritabanindanOkunanUser.email;
            // oankiKonusma.sonOkunmaZamani = _zaman;
            /*var _durationn =
                _zaman.difference(oankiKonusma.olusturulma_tarihi!.toDate());
            oankiKonusma.aradakiFark = timeago.format(
                _zaman.subtract(_zaman.subtract(_durationn) as Duration));*/
          }
        }
        return konusmaListesi;
      } catch (e) {
        print("Hata Burada!" + e.toString());
      }
    }
  }

  Future<List<Uzer>?> getAllConversationsUzer(String userID) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      // DateTime? _zaman = await _firestoreDBService.saatiGoster(userID);
      var user = await _firestoreDBService.getAllConversationsUser(userID);
      try {
        for (var oankiUser in user) {
          var userListesindekiKullanici = listedeUserBul(oankiUser.userID!);

          if (userListesindekiKullanici != null) {
            print("Veriler Local'den okundu.");
            oankiUser.alinan_user_name = userListesindekiKullanici.userName!;
            oankiUser.alinan_user_profilUrl =
                userListesindekiKullanici.profilUrl!;
            //  oankiKonusma.sonOkunmaZamani = _zaman;

            /*   var _duration =
                _zaman!.difference(oankiKonusma.olusturulma_tarihi!.toDate());
            oankiKonusma.aradakiFark = timeago.format(
                _zaman.subtract(_zaman.subtract(_duration) as Duration)); */
          } else {
            print(
                "Aranan user daha önce getirilmemiştir! Veri tabanından getirilmesi gerekiyor.");
            var _veritabanindanOkunanUser =
                await _firestoreDBService.readUser(oankiUser.userID!);
            oankiUser.alinan_user_name = _veritabanindanOkunanUser!.userName!;
            oankiUser.alinan_user_profilUrl =
                _veritabanindanOkunanUser.profilUrl!;
            // oankiKonusma.sonOkunmaZamani = _zaman;
            /*var _durationn =
                _zaman.difference(oankiKonusma.olusturulma_tarihi!.toDate());
            oankiKonusma.aradakiFark = timeago.format(
                _zaman.subtract(_zaman.subtract(_durationn) as Duration));*/
          }
        }
        return user;
      } catch (e) {
        print("Hata Burada!" + e.toString());
      }
    }
  }

  Future<List<Begenme>?> getAllConversationsBegenme(String userID) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      // DateTime? _zaman = await _firestoreDBService.saatiGoster(userID);
      var begeniListesi =
          await _firestoreDBService.getAllConversationsBegenme(userID);
      try {
        for (var oankiBegeni in begeniListesi) {
          var userListesindekiKullanici =
              listedeUserBul(oankiBegeni.begenilen_kisi!);

          if (userListesindekiKullanici != null) {
            print("Veriler Local'den okundu.");
            oankiBegeni.begenen_user_name = userListesindekiKullanici.userName!;
            oankiBegeni.begenen_user_profilUrl =
                userListesindekiKullanici.profilUrl!;
            //  oankiKonusma.sonOkunmaZamani = _zaman;

            /*   var _duration =
                _zaman!.difference(oankiKonusma.olusturulma_tarihi!.toDate());
            oankiKonusma.aradakiFark = timeago.format(
                _zaman.subtract(_zaman.subtract(_duration) as Duration)); */
          } else {
            print(
                "Aranan user daha önce getirilmemiştir! Veri tabanından getirilmesi gerekiyor.");
            var _veritabanindanOkunanUser =
                await _firestoreDBService.readUser(oankiBegeni.begenilen_kisi!);
            oankiBegeni.begenen_user_name =
                _veritabanindanOkunanUser!.userName!;
            oankiBegeni.begenen_user_profilUrl =
                _veritabanindanOkunanUser.profilUrl!;
            // oankiKonusma.sonOkunmaZamani = _zaman;
            /*var _durationn =
                _zaman.difference(oankiKonusma.olusturulma_tarihi!.toDate());
            oankiKonusma.aradakiFark = timeago.format(
                _zaman.subtract(_zaman.subtract(_durationn) as Duration));*/
          }
        }
        return begeniListesi;
      } catch (e) {
        print("Hata Burada!" + e.toString());
      }
    }
  }

  Uzer? listedeUserBul(String userID) {
    for (int i = 0; i < tumKullaniciListesi.length; i++) {
      if (tumKullaniciListesi[i]!.userID == userID) {
        return tumKullaniciListesi[i]!;
      }
    }
    return null;
  }

  Future<List<Uzer?>> getUserWithPagination(
      Uzer? enSonGetirilenUser, int getirilecekElemanSayisi) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      List<Uzer?> _userList = await _firestoreDBService.getUserWithPagination(
          enSonGetirilenUser, getirilecekElemanSayisi);
      tumKullaniciListesi.addAll(_userList);
      return _userList;
    }
  }

  Future<List<Mesaj?>?> getMessageWithPagination(
      String? currentUserID,
      String? sohbetEdilenUserID,
      Mesaj? enSonGetirilenMesaj,
      int getirilecekElemanSayisi) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      return await _firestoreDBService.getMessageWithPagination(currentUserID!,
          sohbetEdilenUserID!, enSonGetirilenMesaj, getirilecekElemanSayisi);
    }
  }

  uploadStatus(String userID, String? fileType, File profilFoto) {}
}
