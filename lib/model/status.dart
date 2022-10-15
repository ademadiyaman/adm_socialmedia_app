import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class Status {
  final String? userID;
  final File? profilUrl;
  // final Timestamp createdAt;
  //final List<String?>? whoCanSee;
  final bool? bendenMi;

  Status(
      {this.userID,
      this.profilUrl,
      //required this.createdAt,
      // this.whoCanSee,
      this.bendenMi});

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'profilUrl': profilUrl,
      //'createdAt': createdAt,
      // 'whoCanSee': whoCanSee,
      'bendenMi': bendenMi,
    };
  }

  Status.fromMap(Map<String, dynamic> map)
      : userID = map['userID'],
        profilUrl = map['profilUrl'],
        // createdAt = map['createdAt'] ?? FieldValue.serverTimestamp(),
        bendenMi = map['bendenMi'];
//  whoCanSee: List<String>.from(map['whoCanSee']),

  @override
  String toString() {
    // TODO: implement toString
    return 'Status{userID: $userID, profilUrl: $profilUrl, bendenMi: $bendenMi}';
  }
}
