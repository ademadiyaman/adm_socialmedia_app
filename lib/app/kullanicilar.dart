import 'package:adm_socialmedia_app/app/sohbet_page.dart';
import 'package:adm_socialmedia_app/model/user.dart';
import 'package:adm_socialmedia_app/services/firestore_db_service.dart';
import 'package:adm_socialmedia_app/viewmodel/all_user_viewmodel.dart';
import 'package:adm_socialmedia_app/viewmodel/chat_view_model.dart';
import 'package:adm_socialmedia_app/viewmodel/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:adm_socialmedia_app/ad_helper.dart';
import 'package:provider/provider.dart';

class KullanicilarPage extends StatefulWidget {
  const KullanicilarPage({Key? key}) : super(key: key);

  @override
  State<KullanicilarPage> createState() => _KullanicilarPageState();
}

class _KullanicilarPageState extends State<KullanicilarPage> {
  bool _isLoading = false;
  ScrollController _scrollController = ScrollController();

  late BannerAd _bannerAd;
  late InterstitialAd _interstitialAd;
  bool _isBannedAdReady = false;
  bool _isInterstitialAdReady = false;
  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: adHelper.bannerAdUnitId,
        listener: BannerAdListener(onAdLoaded: (_) {
          setState(() {
            _isBannedAdReady = true;
          });
        }, onAdFailedToLoad: (ad, error) {
          print("Failed${error.message}");
          _isBannedAdReady = false;
          ad.dispose();
        }),
        request: AdRequest())
      ..load();

    InterstitialAd.load(
        adUnitId: adHelper.interstitialAdUnitId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialAdReady = true;
        }, onAdFailedToLoad: (error) {
          print("Failed to load Interstitial Ad${error.message}");
        }));
    _scrollController.addListener(_listeScrollListener);
  }

  void _listeScrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      print("Listenin en altındayız");
      dahaFazlaKullaniciGetir();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent.shade400,
        title: Text(
          'kullanicilar',
          style: TextStyle(fontSize: 14),
        ).tr(),
      ),
      body: Consumer<AllUserViewModel>(
        builder: (context, model, child) {
          if (model.state == AllUserViewState.Busy) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (model.state == AllUserViewState.Loaded) {
            return RefreshIndicator(
              color: Colors.lightBlueAccent,
              onRefresh: model.refresh,
              child: GridView.builder(
                // shrinkWrap: true,
                controller: _scrollController,
                itemBuilder: (context, index) {
                  if (model.kullanicilarListesi!.length == 1) {
                    return _kullaniciYokUi();
                  } else if (model.hasMoreLoading &&
                      index == model.kullanicilarListesi!.length) {
                    print("Buradan geliyor");
                    return _yeniElemanlarYukleniyorIndicator();
                  } else {
                    return _userListeELemaniOlustur(index);
                  }
                },
                itemCount: model.hasMoreLoading
                    ? model.kullanicilarListesi!.length + 1
                    : model.kullanicilarListesi!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget _kullaniciYokUi() {
    final _kullanicilarModel = Provider.of<AllUserViewModel>(context);
    return RefreshIndicator(
      onRefresh: _kullanicilarModel.refresh,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.message_outlined,
                  color: Theme.of(context).primaryColor,
                  size: 100,
                ),
                Text(
                  "Sisteme kayıtlı bir kullanıcı bulunmamaktadır!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 31),
                ),
              ],
            ),
          ),
          height: MediaQuery.of(context).size.height - 150,
        ),
      ),
    );
  }

  Widget _userListeELemaniOlustur(int index) {
    final _userModel = Provider.of<UserModel>(context, listen: false);
    final _tumKullanicilarViewModel =
        Provider.of<AllUserViewModel>(context, listen: false);
    var _oankiUser = _tumKullanicilarViewModel.kullanicilarListesi![index];
    if (_oankiUser!.userID == _userModel.user!.userID) {
      return Container();
    }
    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (context) => ChatViewModel(
                curretUser: _userModel.user!, sohbetEdilenUser: _oankiUser),
            child: SohbetPage(),
          ),
        ));
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 3, right: 3, bottom: 0, top: 11),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 3, right: 3, bottom: 3, top: 6),
              height: 320,
              child: Card(
                elevation: 6,
                shadowColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: <Widget>[
                    ListTile(
                      tileColor: Colors.white54,
                      selectedTileColor: Colors.lightBlueAccent,
                      focusColor: Colors.lightBlueAccent,
                      title: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(31.0),
                            child: CircleAvatar(
                              radius: 85,
                              backgroundColor: Colors.grey.withAlpha(11),
                              backgroundImage:
                                  NetworkImage(_oankiUser.profilUrl!),
                            ),
                          ),
                          Text(
                            _oankiUser.userName!,
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        children: <Widget>[
                          Text(
                            _oankiUser.durum!,
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ), /*
            SizedBox(
              height: 59,
            ),
            if (_isBannedAdReady)
              Container(
                child: AdWidget(ad: _bannerAd),
                height: 100,
                width: 250,
                alignment: Alignment.center,
              ),
            SizedBox(
              height: 2,
            ),*/
          ],
        ),
      ),
    );
  }

  _yeniElemanlarYukleniyorIndicator() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: CircularProgressIndicator(
          color: Colors.lightBlueAccent,
        ),
      ),
    );
  }

  void dahaFazlaKullaniciGetir() async {
    if (_isLoading == false) {
      _isLoading = true;
      final _tumKullanicilarViewModel =
          Provider.of<AllUserViewModel>(context, listen: false);
      await _tumKullanicilarViewModel.dahaFazlaUserGetir();
      _isLoading = false;
    }
  }
}
