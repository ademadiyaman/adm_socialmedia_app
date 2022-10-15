import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class Uzer {
  final String? userID;
  String? email;
  String? userName;
  String? durum;
  String? profilUrl;
  String? begenenler;
  String? kullaniciSozlesmesi;
  String? alinan_user_name;
  String? alinan_user_profilUrl;
  int? seviye;
  Uzer({required this.userID, required this.email});
  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'email': email,
      'userName': userName ??
          email!.substring(0, email!.indexOf('@')) + randomSayiUret(),
      'durum': durum ?? 'Merhaba, ben bu uygulayamayı kullanıyorum.',
      'profilUrl': profilUrl ??
          'https://www.gstatic.com/mobilesdk/160503_mobilesdk/logo/2x/firebase_28dp.png',
      'kullaniciSozlesmesi': kullaniciSozlesmesi ??
          'Kullanıcı Sözleşmesini okudum, anladım, onaylıyorum.',
      'seviye': seviye ?? 1,
      'alinan_user_name': alinan_user_name,
      'alinan_user_profilUrl': alinan_user_profilUrl
    };
  }

  Uzer.fromMap(Map<String, dynamic> map)
      : userID = map['userID'],
        email = map['email'],
        userName = map['userName'],
        durum = map['durum'],
        profilUrl = map['profilUrl'],
        kullaniciSozlesmesi = map['kullaniciSozlesmesi'],
        alinan_user_name = map['alinan_user_name'],
        alinan_user_profilUrl = map['alinan_user_profilUrl'],
        seviye = map['seviye'];
  Uzer.idveResim({
    required this.userID,
    required this.profilUrl,
    required this.userName,
    required this.durum,
    required this.email,
  });

  @override
  String toString() {
    return 'Uzer{userID: $userID, email: $email, userName: $userName, durum: $durum, profilUrl: $profilUrl, kullaniciSozlesmesi: $kullaniciSozlesmesi, alinan_user_name: $alinan_user_name, alinan_user_profilUrl: $alinan_user_profilUrl, seviye: $seviye}';
  }

  String randomSayiUret() {
    int rastgeleSayi = Random().nextInt(999999999);
    return rastgeleSayi.toString();
  }
}
