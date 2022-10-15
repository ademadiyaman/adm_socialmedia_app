import 'package:adm_socialmedia_app/model/konusma.dart';
import 'package:adm_socialmedia_app/model/mesaj.dart';
import 'package:adm_socialmedia_app/model/user.dart';

abstract class DBBase {
  Future<bool> saveUser(Uzer? user);
  Future<Uzer?> readUser(String? userID);
  Future<bool> deleteUser(String? userID);
  Future<bool> updateUserName(String? userID, String? yeniUserName);
  Future<List<Uzer?>> getUserWithPagination(
      Uzer? enSonGetirilenUser, int _getirilecekElemanSayisi);
  Future<List<Konusma?>> getAllConversations(String userID);
  Stream<List<Mesaj>> getMessages(
      String currentUserID, String sohbetEdilenUserID);
  Future<bool?> saveMessage(Mesaj kaydedilecekMesaj);
  // Future<DateTime?> saatiGoster(String? userID);
}
