import 'package:adm_socialmedia_app/model/user.dart';
import 'package:adm_socialmedia_app/services/auth_base.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FakeAuthService implements AuthBase {
  String userID = "SDFAVFDAFSVD132423423";

  @override
  Future<Uzer?> currentUser() {
    // TODO: implement currentUser
    throw UnimplementedError();
  }

  @override
  Future<Uzer?> signInAnonymously() {
    // TODO: implement signInAnonymously
    throw UnimplementedError();
  }

  @override
  Future<Uzer?> signInWithGoogle() {
    // TODO: implement signInWithGoogle
    throw UnimplementedError();
  }

  @override
  Future<bool> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  Future<Uzer?> createUserWithEmailandPassword(String email, String sifre) {
    // TODO: implement createUserWithEmailandPassword
    throw UnimplementedError();
  }

  @override
  Future<Uzer?> signInWithEmailandPassword(String email, String sifre) {
    // TODO: implement signInWithEmailandPassword
    throw UnimplementedError();
  }
}
