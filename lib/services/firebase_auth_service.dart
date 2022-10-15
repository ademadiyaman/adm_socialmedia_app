import 'package:adm_socialmedia_app/model/user.dart';
import 'package:adm_socialmedia_app/services/auth_base.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:adm_socialmedia_app/repository/user_repository.dart';

class FirebaseAuthService implements AuthBase {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<Uzer?> currentUser() async {
    try {
      User user = await _firebaseAuth.currentUser!;
      return _userFromFirebase(user);
    } catch (e) {
      print("HATA" + e.toString());
      return null;
    }
  }

  Uzer _userFromFirebase(User? user) {
    if (user == null) null;
    return Uzer(userID: user!.uid, email: user.email);
  }

  @override
  Future<Uzer?> signInAnonymously() async {
    try {
      UserCredential sonuc = await _firebaseAuth.signInAnonymously();
      return _userFromFirebase(sonuc.user);
    } catch (e) {
      print("anonim giriş hata:" + e.toString());
      return null;
    }
  }

  @override
  Future<Uzer?> signInWithGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn();
    GoogleSignInAccount? _googleUser = await _googleSignIn.signIn();

    if (_googleUser != null) {
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      if (_googleAuth.idToken != null && _googleAuth.accessToken != null) {
        UserCredential sonuc = await _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.credential(
                idToken: _googleAuth.idToken,
                accessToken: _googleAuth.accessToken));
        User? _user = sonuc.user;
        return _userFromFirebase(_user);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return true;
    } catch (e) {
      print("Hata" + e.toString());
      return false;
    }
  }

  @override
  Future<Uzer?> createUserWithEmailandPassword(
      String email, String sifre) async {
    UserCredential sonuc = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: sifre);
    return _userFromFirebase(sonuc.user);
  }

  @override
  Future<Uzer?> signInWithEmailandPassword(String email, String sifre) async {
    UserCredential sonuc = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: sifre);
    return _userFromFirebase(sonuc.user);
  }

  /* @override
  Future<Uzer?> currentUser() async{
      try {
        User user = await _firebaseAuth.currentUser!;
         return _userFromFirebase(user);
      }catch(e){
        print("HATA"+e.toString());
        return null;
      }
  }
  Uzer _userFromFirebase(User user){
    if(user == null)
      return null;
      return Uzer(userID: user.uid);
  }
  @override
  Future<Uzer> signInAnonymously() async{
    try{
      UserCredential sonuc = await _firebaseAuth.signInAnonymously();
      _userFromFirebase(sonuc.user);
    }catch(e)
    {
      print("anonim giriş hata:"+e.toString());
      return null;
    }
  }

   @override
  Future<bool> signOut()async {
    try{
      await _firebaseAuth.signOut();
      return true;
    }catch(e){
      print("Hata"+e.toString());
      return false;
    }

  }

  @override
  Future<Uzer?> signInWithGoogle() async{
    GoogleSignIn _googleSignIn = GoogleSignIn();
    GoogleSignInAccount? _googleUser = await _googleSignIn.signIn();

  if(_googleUser != null){
    GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
    if (_googleAuth.idToken != null && _googleAuth.accessToken != null){
      UserCredential sonuc = await _firebaseAuth.signInWithCredential(
        GoogleAuthProvider.credential(idToken: _googleAuth.idToken, accessToken: _googleAuth.accessToken)
      );
      User? _user = sonuc.user;
      _userFromFirebase(_user!);
    }else {
      return null;
    }
  }else {
    return null;
  }
  }
*/
}
