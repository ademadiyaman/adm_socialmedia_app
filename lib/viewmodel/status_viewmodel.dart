import 'dart:async';
import 'dart:io';

import 'package:adm_socialmedia_app/model/mesaj.dart';
import 'package:adm_socialmedia_app/model/status.dart';
import 'package:adm_socialmedia_app/model/user.dart';
import 'package:adm_socialmedia_app/repository/user_repository.dart';
import 'package:adm_socialmedia_app/viewmodel/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum StatusViewState { Idle, Loaded, Busy }

class StatusViewModel with ChangeNotifier {
  ViewState _state = ViewState.Idle;

  final UserRepository _userRepository = UserRepository();
  final FirebaseFirestore _firebaseDb = FirebaseFirestore.instance;
  Uzer? _user;

  Uzer? get user => _user;

  ViewState get state => _state;

  set state(ViewState value) {
    notifyListeners();
    _state = value;
  }

  StatusViewModel() {
    currentUser();
    // notifyListeners();
  }
  @override
  Future<Uzer?> currentUser() async {
    try {
      notifyListeners();
      state = ViewState.Busy;
      _user = (await _userRepository.currentUser());
      if (_user != null)
        return _user;
      else
        return null;
    } catch (e) {
      debugPrint("VM'deki Current User'da Hata:" + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

/*

  Future<String?> uploadFile(Status user, String? userID, String fileType, File file) async {
    notifyListeners();
    var indirmeLinki =
        await _userRepository.statusUploading(user, userID, fileType, file);

    return indirmeLinki;
  }*/
}
