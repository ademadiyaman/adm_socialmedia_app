import 'package:cloud_firestore/cloud_firestore.dart';

class Sikayet {
  final String? sikayet_eden_kisi;
  final String? sikayet_edilen_kisi;
  final String? sikayet;
  final Timestamp? sikayet_zaman;

  Sikayet({
    this.sikayet_eden_kisi,
    this.sikayet_edilen_kisi,
    this.sikayet,
    this.sikayet_zaman,
  });

  Map<String, dynamic> toMap() {
    return {
      'sikayet_eden_kisi': sikayet_eden_kisi,
      'sikayet_edilen_kisi': sikayet_edilen_kisi,
      'sikayet': sikayet,
      'sikayet_zaman': sikayet_zaman,
    };
  }

  Sikayet.fromMap(Map<String, dynamic> map)
      : sikayet_eden_kisi = map['sikayet_eden_kisi'],
        sikayet_edilen_kisi = map['sikayet_edilen_kisi'],
        sikayet = map['sikayet'],
        sikayet_zaman = map['sikayet_zaman'] ?? FieldValue.serverTimestamp();

  @override
  String toString() {
    return 'Sikayet{sikayet_eden_kisi: $sikayet_eden_kisi, sikayet_edilen_kisi: $sikayet_edilen_kisi, sikayet: $sikayet, sikayet_zaman: $sikayet_zaman}';
  }
}
