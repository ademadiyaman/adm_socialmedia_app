import 'dart:convert';

import 'package:adm_socialmedia_app/model/mesaj.dart';
import 'package:adm_socialmedia_app/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

class BildirimGondermeServis {
  Future<bool?> bildirimGonder(
      Mesaj gonderilecekBildirim, Uzer gonderenUser, String token) async {
    String endUrl = "https://fcm.googleapis.com/fcm/send";
    // String toykin = token;
    String firebaseKey =
        "AAAAcSXFKKo:APA91bEeaHI_pimeZmBU5qkn6WWO9GhikNQtMS2C0_8faoeVljsc_8QEAn7tSyQjFZDdatDN_i0d6m728BgOEi8rurVgdf_kfwBMzXYug49zWhqj6ht7LtZ7eJB0XvkcXjYabdzXahSP";
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization": "key=$firebaseKey"
    };
    String json =
        '{ "to" : "$token", "data" : { "message" : "${gonderilecekBildirim.mesaj}", "title" : "${gonderenUser.userName} Yeni Mesaj", "gonderenUserID" : "${gonderenUser.userID}", "gonderenUserName" : "${gonderenUser.userName!}", "gonderenUserUrl" : "${gonderenUser.profilUrl}" } }';

    var client = http.Client();
    var response = await client.post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: headers,
        body: json);

    if (response.statusCode == 200) {
      print("işlem başarılı");
      print("mesaj: " + gonderilecekBildirim.mesaj.toString());
      print("user: " + gonderenUser.userName.toString());
      print("userID: " + gonderenUser.userID.toString());
      print("token: " + token.toString());
      print("json: " + json.toString());
    } else {
      print("işlem başarısız" + response.statusCode.toString());
      print("jsonumuz:" + json);
    }
  }
}
