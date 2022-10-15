import 'package:adm_socialmedia_app/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthBase {
  Future<Uzer?> currentUser();
  Future<Uzer?> signInAnonymously();
  Future<bool> signOut();
  Future<Uzer?> signInWithGoogle();
  Future<Uzer?> signInWithEmailandPassword(String email, String sifre);
  Future<Uzer?> createUserWithEmailandPassword(String email, String sifre);
}
