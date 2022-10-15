import 'dart:io';

import 'package:adm_socialmedia_app/model/begen.dart';
import 'package:adm_socialmedia_app/model/begenme.dart';
import 'package:adm_socialmedia_app/model/konusma.dart';
import 'package:adm_socialmedia_app/model/mesaj.dart';
import 'package:adm_socialmedia_app/model/sikayet.dart';
import 'package:adm_socialmedia_app/model/status.dart';
import 'package:adm_socialmedia_app/model/user.dart';
import 'package:adm_socialmedia_app/services/database_base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FirestoreDBService implements DBBase {
  final FirebaseFirestore _firebaseDb = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser(Uzer? user) async {
    Map<String, dynamic> _eklenecekUzerMap = user!.toMap();

    DocumentSnapshot _okunanUser =
        await FirebaseFirestore.instance.doc("users/${user.userID}").get();

    if (_okunanUser.data() == null) {
      await _firebaseDb.collection("users").doc(user.userID).set(user.toMap());
      return true;
    } else {
      return true;
    }
  }

  @override
  Future<Uzer?> readUser(String? userID) async {
    DocumentSnapshot _okunanUser =
        await _firebaseDb.collection("users").doc(userID).get();
    Map<String, dynamic> _okunanUserBilgileriMap =
        _okunanUser.data() as Map<String, dynamic>;
    Uzer? _okunanUserNesnesi = Uzer.fromMap(_okunanUserBilgileriMap);
    return _okunanUserNesnesi;
  }

  /*
  @override
  Future<Uzer?> readUser(String userID) async {
    DocumentSnapshot _okunanUser =
        await _firebaseDb.collection("users").doc(userID).get();
    Map<String, dynamic>? _okunanUserBilgileriMap =
        _okunanUser.data() as Map<String, dynamic>?;
    Uzer? _okunanUserNesnesi = Uzer.fromMap(_okunanUserBilgileriMap);
    print("Okunan user nesnesi : " + _okunanUserNesnesi.toString());
    return _okunanUserNesnesi;
  }*/
  /*
  @override
  Future<List<Uzer?>> getAllUsers() async {
    QuerySnapshot querySnapshot = await _firebaseDb.collection("users").get();
    List<Uzer> tumKullanicilar = [];

    for (DocumentSnapshot tekUser in querySnapshot.docs) {
      Uzer _tekUzer = Uzer.fromMap(tekUser.data() as Map<String, dynamic>);
      tumKullanicilar.add(_tekUzer);
      // return print("Okunan user : " + tekUser.data().toString());
    }
    return tumKullanicilar;

    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await _firebaseDb.collectionGroup("users").get();
    List<Uzer?> tumKullanicilar = [];
    for (DocumentSnapshot<Map<String, dynamic>> tekUser in querySnapshot.docs) {
      Uzer? _tekUser = tekUser.data() as Uzer?;
      tumKullanicilar.add(_tekUser);
    }
    return null;
  }
  */

  @override
  Future<List<Begenme>> getAllConversationsBegenme(String userID) async {
    QuerySnapshot querySnapshot = await _firebaseDb
        .collection("begeniler")
        .where("begenen_kisi", isEqualTo: userID)
        .orderBy("begenme_zaman", descending: true)
        .get();

    List<Begenme> tumBegenmeler = [];

    for (DocumentSnapshot tekBegenme in querySnapshot.docs) {
      Begenme _tekKonusma =
          Begenme.fromMap(tekBegenme.data() as Map<String, dynamic>);
      tumBegenmeler.add(_tekKonusma);
    }
    return tumBegenmeler;
  }

  @override
  Future<List<Uzer>> getAllConversationsUser(String userID) async {
    QuerySnapshot querySnapshot = await _firebaseDb
        .collection("users")
        .where("userID", isEqualTo: userID)
        .get();

    List<Uzer> user = [];

    for (DocumentSnapshot tekUser in querySnapshot.docs) {
      Uzer _tekUser = Uzer.fromMap(tekUser.data() as Map<String, dynamic>);
      user.add(_tekUser);
    }
    return user;
  }

  @override
  Future<List<Konusma>> getAllConversations(String userID) async {
    QuerySnapshot querySnapshot = await _firebaseDb
        .collection("konusmalar")
        .where("konusma_sahibi", isEqualTo: userID)
        .orderBy("olusturulma_tarihi", descending: true)
        .get();

    List<Konusma> tumKonusmalar = [];

    for (DocumentSnapshot tekKonusma in querySnapshot.docs) {
      Konusma _tekKonusma =
          Konusma.fromMap(tekKonusma.data() as Map<String, dynamic>);
      tumKonusmalar.add(_tekKonusma);
    }
    return tumKonusmalar;
  }

  @override
  Future<bool> updateUserName(String? userID, String? yeniUserName) async {
    var users = await _firebaseDb
        .collection("users")
        .where("userName", isEqualTo: yeniUserName)
        .get();
    if (users.docs.length >= 1) {
      return false;
    } else {
      await _firebaseDb
          .collection("users")
          .doc(userID)
          .update({"userName": yeniUserName});
      return true;
    }
  }

  @override
  Future<bool> updateStatus(
    String? userID,
    String? fileType,
  ) async {
    var users = await _firebaseDb
        .collection("status")
        .where("profilUrl", isEqualTo: fileType)
        .get();
    if (users.docs.length >= 1) {
      return false;
    } else {
      await _firebaseDb
          .collection("status")
          .doc(userID)
          .update({"profilUrl": fileType});
      return true;
    }
  }

  @override
  Future<bool> updateProfilFoto(
    String? userID,
    String? fileType,
  ) async {
    var users = await _firebaseDb
        .collection("users")
        .where("profilUrl", isEqualTo: fileType)
        .get();
    if (users.docs.length >= 1) {
      return false;
    } else {
      await _firebaseDb
          .collection("users")
          .doc(userID)
          .update({"profilUrl": fileType});
      return true;
    }
  }

  @override
  Future<bool> updateDurum(String? userID, String? yeniDurum) async {
    var users = await _firebaseDb
        .collection("users")
        .where("durum", isEqualTo: yeniDurum)
        .get();
    if (users.docs.length == 1) {
      return false;
    } else {
      await _firebaseDb
          .collection("users")
          .doc(userID)
          .update({'durum': yeniDurum});
      return true;
    }
  }
/*
  @override
  Stream<Mesaj> getMessage(String currentUserID, String sohbetEdilenUserID) {
    var snapshot = _firebaseDb
        .collection("konusmalar")
        .doc(currentUserID + "--" + sohbetEdilenUserID)
        .collection("mesajlar")
        .doc(currentUserID)
        .snapshots();
    return snapshot.map(
        (snapshot) => Mesaj.fromMap(snapshot.data() as Map<String, dynamic>));
  }
*/

  @override
  Stream<List<Mesaj>> getMessages(
      String currentUserID, String sohbetEdilenUserID) {
    var snapshot = _firebaseDb
        .collection("konusmalar")
        .doc(currentUserID + "--" + sohbetEdilenUserID)
        .collection("mesajlar")
        .orderBy("date", descending: true)
        .limit(1)
        .snapshots();
    return snapshot.map((mesajListesi) =>
        mesajListesi.docs.map((mesaj) => Mesaj.fromMap(mesaj.data())).toList());
  }

  @override
  Future<bool> deleteUser(String? userID) async {
    var users = await _firebaseDb.collection("users").where("userID").get();
    if (users.docs.length >= 1) {
      await _firebaseDb.collection("users").doc(userID).delete();
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> deleteChat(String currentUserID, String sohbetEdilenUser) async {
    var users = await _firebaseDb
        .collection("konusmalar")
        .doc(currentUserID + "--" + sohbetEdilenUser)
        .collection("mesajlar")
        .orderBy("kimden", descending: true)
        //.limit(12)
        .get();
    if (users.docs.length >= 1) {
      await _firebaseDb
          .collection("konusmalar")
          .doc(currentUserID + "--" + sohbetEdilenUser)
          .delete();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> saveSikayet(Sikayet sikayetEdenUser) async {
    var _sikayetID = _firebaseDb.collection("sikayetler").doc().id;
    var _documentID = sikayetEdenUser.sikayet_eden_kisi;
    var _document2ID = sikayetEdenUser.sikayet_edilen_kisi;
    var _kaydedilecekMap = sikayetEdenUser.toMap();
    await _firebaseDb
        .collection("sikayetler")
        .doc(_documentID)
        .set(_kaydedilecekMap);
    await _firebaseDb.collection("sikayetler").doc(_documentID).set({
      "sikayet_eden_kisi": sikayetEdenUser.sikayet_eden_kisi,
      "sikayet_edilen_kisi": sikayetEdenUser.sikayet_edilen_kisi,
      "sikayet": sikayetEdenUser.sikayet,
      "sikayet_zaman": FieldValue.serverTimestamp(),
    });
    return true;
  }

  Future<bool> saveBegeni(Begen begenenUser) async {
    var _begeniID = _firebaseDb.collection("begeniler").doc().id;
    var _documentID = begenenUser.begenen!;
    var _document2ID = begenenUser.oankiUser!;
    var _kaydedilecekMap = begenenUser.toMap();
    await _firebaseDb
        .collection("begeniler")
        .doc(_documentID)
        .collection("begenme")
        .doc(_begeniID)
        .set(_kaydedilecekMap);

    await _firebaseDb.collection("begeniler").doc(_documentID).set({
      "begenen_kisi": begenenUser.oankiUser!,
      "begenilen_kisi": begenenUser.begenen!,
      "begenen_kisi_profilUrl": begenenUser.profilFoto!,
      "begenme_zaman": FieldValue.serverTimestamp(),
    });
    _kaydedilecekMap.update("bendenMi", (deger) => false);
    await _firebaseDb.collection("begeniler").doc(_document2ID).set({
      "begenen_kisi": begenenUser.begenen!,
      "begenilen_kisi": begenenUser.oankiUser!,
      "begenen_kisi_profilUrl": begenenUser.profilFoto!,
      "begenme_zaman": FieldValue.serverTimestamp(),
    });

    return true;
  }

  Future<bool?> saveStatus(Status status, File? profilPoto) async {
    var statusID = _firebaseDb.collection("status").doc().id;
    var _myDocumentID = status.userID;
    var _kaydedilecekMapYapisi = status.toMap();
    await _firebaseDb
        .collection("status")
        .doc(_myDocumentID)
        .collection("hikayeler")
        .doc(statusID)
        .set(_kaydedilecekMapYapisi);

    await _firebaseDb.collection("hikayeler").doc(_myDocumentID).set({
      "hikaye": profilPoto,
      "hikaye_sahibi": status.userID,
      "goren_zaman": FieldValue.serverTimestamp(),
    });

    return true;
  }

  Future<bool> saveMessage(Mesaj kaydedilecekMesaj) async {
    var _mesajID = _firebaseDb.collection("konusmalar").doc().id;
    var _myDocumentID =
        kaydedilecekMesaj.kimden + "--" + kaydedilecekMesaj.kime;
    var _receieverDocumentID =
        kaydedilecekMesaj.kime + "--" + kaydedilecekMesaj.kimden;
    var _kaydedilecekMesajMapYapisi = kaydedilecekMesaj.toMap();
    await _firebaseDb
        .collection("konusmalar")
        .doc(_myDocumentID)
        .collection("mesajlar")
        .doc(_mesajID)
        .set(_kaydedilecekMesajMapYapisi);

    await _firebaseDb.collection("konusmalar").doc(_myDocumentID).set({
      "konusma_sahibi": kaydedilecekMesaj.kimden,
      "kimle_konusuyor": kaydedilecekMesaj.kime,
      "son_mesaj": kaydedilecekMesaj.mesaj!,
      "konusma_goruldu": false,
      "olusturulma_tarihi": FieldValue.serverTimestamp(),
    });

    _kaydedilecekMesajMapYapisi.update("bendenMi", (deger) => false);
    await _firebaseDb
        .collection("konusmalar")
        .doc(_receieverDocumentID)
        .collection("mesajlar")
        .doc(_mesajID)
        .set(_kaydedilecekMesajMapYapisi);

    await _firebaseDb.collection("konusmalar").doc(_receieverDocumentID).set({
      "konusma_sahibi": kaydedilecekMesaj.kime,
      "kimle_konusuyor": kaydedilecekMesaj.kimden,
      "son_mesaj": kaydedilecekMesaj.mesaj!,
      "konusma_goruldu": false,
      "olusturulma_tarihi": FieldValue.serverTimestamp(),
    });

    return true;
  }

  @override
  Future<List<Uzer?>> getUserWithPagination(
      Uzer? enSonGetirilenUser, int getirilecekElemanSayisi) async {
    QuerySnapshot _querySnapshot;
    List<Uzer?> _tumKullanicilar = [];
    if (enSonGetirilenUser == null) {
      _querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .orderBy("userName")
          .limit(getirilecekElemanSayisi)
          .get();
    } else {
      _querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .orderBy("userName")
          .startAfter([enSonGetirilenUser.userName])
          .limit(getirilecekElemanSayisi)
          .get();

      await Future.delayed(Duration(seconds: 1));
    }
    for (DocumentSnapshot snap in _querySnapshot.docs) {
      Uzer? _tekUser = Uzer.fromMap(snap.data() as Map<String, dynamic>);
      _tumKullanicilar.add(_tekUser);
    }
    return _tumKullanicilar;
/*
  @override
  Future<DateTime?> saatiGoster(String? userID) async {
    await _firebaseDb.collection("server").doc(userID).set({
      "saat": FieldValue.serverTimestamp(),
    });
    var okunanMap = await _firebaseDb.collection("server").doc(userID).get();
    Timestamp okunanTarih = okunanMap.data() as Timestamp;
    return okunanTarih.toDate();
  }*/
  }

  Future<List<Mesaj?>?> getMessageWithPagination(
      String? currentUserID,
      String? sohbetEdilenUserID,
      Mesaj? enSonGetirilenMesaj,
      int getirilecekElemanSayisi) async {
    QuerySnapshot _querySnapshot;
    List<Mesaj?> _tumMesajlar = [];
    if (enSonGetirilenMesaj == null) {
      _querySnapshot = await FirebaseFirestore.instance
          .collection("konusmalar")
          .doc(currentUserID! + "--" + sohbetEdilenUserID!)
          .collection("mesajlar")
          .orderBy("date", descending: true)
          .limit(getirilecekElemanSayisi)
          .get();
    } else {
      _querySnapshot = await FirebaseFirestore.instance
          .collection("konusmalar")
          .doc(currentUserID! + "--" + sohbetEdilenUserID!)
          .collection("mesajlar")
          .orderBy("date", descending: true)
          .startAfter([enSonGetirilenMesaj.date])
          .limit(getirilecekElemanSayisi)
          .get();

      await Future.delayed(Duration(seconds: 1));
    }
    for (DocumentSnapshot snap in _querySnapshot.docs) {
      Mesaj? _tekMesaj = Mesaj.fromMap(snap.data() as Map<String, dynamic>);
      _tumMesajlar.add(_tekMesaj);
    }
    return _tumMesajlar;
  }

  uploadFile(String userID, String fileType, File? profilFoto) {}

  Future<String?> tokenGetir(String kime) async {
    DocumentSnapshot _token = await _firebaseDb.doc("tokens/" + kime).get();
    if (_token != null) {
      return _token.get("token");
    } else
      return null;
  }
}
