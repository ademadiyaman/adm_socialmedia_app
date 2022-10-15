import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Begenme {
  final String? begenen_kisi;
  final String? begenen_kisi_profilUrl;
  final String? begenilen_kisi;
  final Timestamp? begenme_zaman;
  String? begenen_user_name;
  String? begenilen_user_name;
  String? begenen_user_profilUrl;

  Begenme({
    this.begenilen_kisi,
    this.begenen_kisi,
    this.begenme_zaman,
    this.begenen_kisi_profilUrl,
    this.begenen_user_name,
    this.begenilen_user_name,
    this.begenen_user_profilUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'begenen': begenilen_kisi,
      'begenen_kisi_profilUrl': begenen_kisi_profilUrl,
      'begenen_kisi': begenen_kisi,
      'begenme_zaman': begenme_zaman,
      'begenen_user_name': begenen_user_name,
      'begenilen_user_name': begenilen_user_name,
      'begenen_user_profilUrl': begenen_user_profilUrl,
    };
  }

  Begenme.fromMap(Map<String, dynamic> map)
      : begenilen_kisi = map['begenilen_kisi'],
        begenen_kisi = map['begenen_kisi'],
        begenen_kisi_profilUrl = map['begenen_kisi_profilUrl'],
        begenilen_user_name = map['begenilen_user_name'],
        begenen_user_name = map['begenen_user_name'],
        begenme_zaman = map['begenme_zaman'] ?? FieldValue.serverTimestamp();

  @override
  String toString() {
    return 'Begenme{begenilen_kisi: $begenilen_kisi, begenen_kisi_profilUrl: $begenen_kisi_profilUrl, begenen_user_name: $begenen_user_name, begenilen_user_name: $begenilen_user_name, begenen_kisi: $begenen_kisi, begenme_zaman: $begenme_zaman}';
  }
}
