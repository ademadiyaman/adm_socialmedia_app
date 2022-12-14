import 'package:adm_socialmedia_app/app/sohbet_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Konusma {
  final String? konusma_sahibi;
  final String? kimle_konusuyor;
  final bool? goruldu;
  final Timestamp? olusturulma_tarihi;
  final String? son_mesaj;
  final Timestamp? gorulme_tarihi;
  String? konusulanUserName;
  String? konusulanUserProfilURL;
  String? konusulanUserMail;
  String? konusulanUserDurum;
  late DateTime? sonOkunmaZamani;
  late String? aradakiFark;

  Konusma(
      {this.konusma_sahibi,
      this.kimle_konusuyor,
      this.goruldu,
      this.olusturulma_tarihi,
      this.son_mesaj,
      this.gorulme_tarihi,
      this.konusulanUserProfilURL,
      this.konusulanUserMail,
      this.konusulanUserDurum,
      this.konusulanUserName});

  Map<String, dynamic> toMap() {
    return {
      'konusma_sahibi': konusma_sahibi,
      'kimle_konusuyor': kimle_konusuyor,
      'goruldu': goruldu,
      'olusturulma_tarihi': olusturulma_tarihi ?? FieldValue.serverTimestamp(),
      'son_mesaj': son_mesaj ?? FieldValue.serverTimestamp(),
      'gorulme_tarihi': gorulme_tarihi,
      'konusulanUserProfilURL': konusulanUserProfilURL,
      'konusulanUserMail': konusulanUserMail,
      'konusulanUserDurum': konusulanUserDurum,
      'konusulanUserName': konusulanUserName,
    };
  }

  Konusma.fromMap(Map<String, dynamic> map)
      : konusma_sahibi = map['konusma_sahibi'],
        kimle_konusuyor = map['kimle_konusuyor'],
        goruldu = map['goruldu'],
        olusturulma_tarihi = map['olusturulma_tarihi'],
        son_mesaj = map['son_mesaj'],
        gorulme_tarihi = map['gorulme_tarihi'],
        konusulanUserName = map['konusulanUserName'],
        konusulanUserDurum = map['konusulanUserDurum'],
        konusulanUserMail = map['konusulanUserMail'],
        konusulanUserProfilURL = map['konusulanUserProfilURL'];

  @override
  String toString() {
    return 'Konusma{konusma_sahibi: $konusma_sahibi, kimle_konusuyor: $kimle_konusuyor, goruldu: $goruldu, olusturulma_tarihi: $olusturulma_tarihi, son_mesaj: $son_mesaj, gorulme_tarihi: $gorulme_tarihi, konusulanUserName: $konusulanUserName, konusulanUserMail: $konusulanUserMail, konusulanUserDurum: $konusulanUserDurum, konusulanUserProfilURL: $konusulanUserProfilURL}';
  }
}
