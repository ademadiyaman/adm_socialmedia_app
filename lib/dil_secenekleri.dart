import 'package:adm_socialmedia_app/app/profil.dart';
import 'package:adm_socialmedia_app/viewmodel/chat_view_model.dart';
import 'package:adm_socialmedia_app/viewmodel/user_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:adm_socialmedia_app/ad_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DilSecenekleri extends StatefulWidget {
  @override
  State<DilSecenekleri> createState() => _DilSecenekleriState();
}

late BannerAd _bannerAd;
late InterstitialAd _interstitialAd;
bool _isBannedAdReady = false;
bool _isInterstitialAdReady = false;

class _DilSecenekleriState extends State<DilSecenekleri> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bannerAd = BannerAd(
        size: AdSize.largeBanner,
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
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd.dispose();
    _interstitialAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel? _userModel = Provider.of<UserModel>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent.shade400,
        title: Text(
          "dil_ayarlari",
          style: TextStyle(fontSize: 14),
        ).tr(),
        actions: <Widget>[],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 41),
              child: GestureDetector(
                onTap: () {},
                child: Card(
                  color: Colors.white,
                  margin: EdgeInsets.zero,
                  child: FlatButton(
                    onPressed: () {},
                    child: ListTile(
                      title: Text(
                        'turkce',
                        style: TextStyle(
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 15),
                      ).tr(),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(1),
              child: GestureDetector(
                onTap: () {},
                child: Card(
                  color: Colors.white,
                  margin: EdgeInsets.zero,
                  child: FlatButton(
                    onPressed: () {
                      if (_isInterstitialAdReady) _interstitialAd.show();
                      /*Navigator.of(context, rootNavigator: true)
                          .push(MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                          create: (context) =>
                              ChatViewModel(curretUser: _userModel.user!),
                          child: ProfilPage(),
                        ),
                      ));*/
                    },
                    child: ListTile(
                      title: Text(
                        'ingilizce',
                        style: TextStyle(
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontSize: 15),
                      ).tr(),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 51),
              child: GestureDetector(
                onTap: () {},
                child: Center(
                  child: Text(
                    'dil_destegi',
                    style: TextStyle(
                        color: Colors.black,
                        fontStyle: FontStyle.italic,
                        fontSize: 12),
                  ).tr(),
                ),
              ),
            ),
            SizedBox(
              height: 80,
            ),
            if (_isBannedAdReady)
              Container(
                //alignment: Alignment.bottomCenter,
                height: _bannerAd.size.height.toDouble(),
                width: _bannerAd.size.width.toDouble(),
                child: AdWidget(ad: _bannerAd),
              ),
          ],
        ),
      ),
    );
  }
}
