import 'package:cloud_firestore/cloud_firestore.dart';

class Begen {
  final String? oankiUser;
  final String? begenen;
  final String? profilFoto;
  final bool? bendenMi;

  Begen({this.begenen, this.oankiUser, this.profilFoto, this.bendenMi});

  Map<String, dynamic> toMap() {
    return {
      'begenen': begenen,
      'oankiUser': oankiUser,
      'profilFoto': profilFoto,
      'bendenMi': bendenMi,
    };
  }

  Begen.fromMap(Map<String, dynamic> map)
      : begenen = map['begenen'],
        oankiUser = map['oankiUser'],
        profilFoto = map['profilFoto'],
        bendenMi = map['bendenMi'];

  @override
  String toString() {
    return 'Begen{begenen: $begenen, oankiUser: $oankiUser, profilFoto: $profilFoto, bendenMi: $bendenMi}';
  }
}
