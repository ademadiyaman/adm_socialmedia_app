import 'package:adm_socialmedia_app/model/user.dart';
import 'package:adm_socialmedia_app/repository/user_repository.dart';
import 'package:adm_socialmedia_app/viewmodel/user_model.dart';
import 'package:flutter/material.dart';

enum AllUserViewState { Idle, Loaded, Busy }

class AllUserViewModel with ChangeNotifier {
  AllUserViewState _state = AllUserViewState.Idle;
  List<Uzer?>? _tumKullanicilar;
  Uzer? _enSonGetirilenUser;
  static final sayfaBasinaGonderiSayisi = 8;
  bool _hasMore = true;
  bool get hasMoreLoading => _hasMore;
  UserRepository _userRepository = UserRepository();

  List<Uzer?>? get kullanicilarListesi => _tumKullanicilar;
  AllUserViewState get state => _state;

  set state(AllUserViewState value) {
    _state = value;
    notifyListeners();
  }

  AllUserViewModel() {
    _tumKullanicilar = [];
    _enSonGetirilenUser = null;
    getUserWithPagination(_enSonGetirilenUser, false);
  }
  getUserWithPagination(
      Uzer? enSonGetirilenUser, bool yeniElemanlarGetiriliyor) async {
    if (_tumKullanicilar!.length > 0) {
      _enSonGetirilenUser = _tumKullanicilar!.last;
      print("En son getirilen username" + _enSonGetirilenUser!.userName!);
    }
    if (yeniElemanlarGetiriliyor) {
    } else {
      state = AllUserViewState.Busy;
    }

    var yeniListe = await _userRepository.getUserWithPagination(
        _enSonGetirilenUser, sayfaBasinaGonderiSayisi);
    if (yeniListe.length < sayfaBasinaGonderiSayisi) {
      _hasMore = false;
    }
    yeniListe.forEach((usr) => print("Getirilen Username" + usr!.userName!));
    _tumKullanicilar!.addAll(yeniListe);
    state = AllUserViewState.Loaded;
  }

  Future<void> dahaFazlaUserGetir() async {
    print("Daha fazla user getirildi - viewmodeldeyiz");
    if (_hasMore)
      getUserWithPagination(_enSonGetirilenUser, true);
    else
      print("Daha Fazla eleman yok o yüzden çağırılmayacak");
    await Future.delayed(Duration(seconds: 1));
  }

  Future<Null> refresh() async {
    _hasMore = true;
    _enSonGetirilenUser = null;
    _tumKullanicilar = [];
    getUserWithPagination(_enSonGetirilenUser, true);
  }

  Future<void> dahaFazlaBilgiGetir() async {
    print("Daha fazla user getirildi - viewmodeldeyiz");
    if (_hasMore)
      getUserWithPagination(_enSonGetirilenUser, true);
    else
      print("Daha Fazla eleman yok o yüzden çağırılmayacak");
    await Future.delayed(Duration(seconds: 1));
  }
}
