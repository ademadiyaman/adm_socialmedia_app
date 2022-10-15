import 'dart:io';

import 'package:adm_socialmedia_app/model/status.dart';
import 'package:adm_socialmedia_app/services/storage_base.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService implements StorageBase {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  Reference? reference;
  @override
  Future<String?> uploadFile(
      String? userID, String? fileType, File? yuklenecelDosya) async {
    reference = _firebaseStorage
        .ref()
        .child(userID!)
        .child(fileType!)
        .child("profil_foto.png");
    var uploadTask = reference!.putFile(yuklenecelDosya!);

    var url = await (await uploadTask).ref.getDownloadURL();
    return url;
  }

  @override
  Future<String?> uploadStatuFile(
      Status userID, String? fileType, File file) async {
    reference = _firebaseStorage
        .ref()
        .child(userID.toString())
        .child(fileType!)
        .child("stories.png");
    var uploadTask = reference!.putFile(file);

    var url = await (await uploadTask).ref.getDownloadURL();
    return url;
  }
}
