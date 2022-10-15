import 'package:adm_socialmedia_app/app/kullanici_profili.dart';
import 'package:adm_socialmedia_app/model/begenme.dart';
import 'package:adm_socialmedia_app/viewmodel/chat_view_model.dart';
import 'package:adm_socialmedia_app/viewmodel/user_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:adm_socialmedia_app/ad_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BegenileriGor extends StatefulWidget {
  @override
  State<BegenileriGor> createState() => _BegenileriGorState();
}

class _BegenileriGorState extends State<BegenileriGor> {
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
  }

  @override
  Widget build(BuildContext context) {
    final _userModel = Provider.of<UserModel>(context);
    final _chatModel = Provider.of<ChatViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent.shade400,
        title: Text(
          "begenenler",
          style: TextStyle(fontSize: 14),
        ).tr(),
        actions: <Widget>[],
      ),
      body: FutureBuilder<List<Begenme?>?>(
        future: _userModel
            .getAllConversationsBegenme(_chatModel.sohbetEdilenUser!.userID!),
        builder: (context, begeniListesi) {
          if (!begeniListesi.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var tumBegeniler = begeniListesi.data;
            if (tumBegeniler!.length > 0) {
              return RefreshIndicator(
                color: Colors.lightBlueAccent,
                onRefresh: _begeniListesiniYenile,
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    var oankiKonusma = tumBegeniler[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context, rootNavigator: true)
                            .push(MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider(
                            create: (context) => ChatViewModel(
                                curretUser: _userModel.user!,
                                sohbetEdilenUser: _chatModel.sohbetEdilenUser!),
                            child: KullaniciProfiliPage(),
                          ),
                        ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(
                            oankiKonusma!.begenen_user_name!.trimRight(),
                            style: TextStyle(fontSize: 15),
                          ),
                          leading: CircleAvatar(
                            radius: 31,
                            backgroundColor: Colors.grey.withAlpha(31),
                            backgroundImage: NetworkImage(
                                oankiKonusma.begenen_user_profilUrl!),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: tumBegeniler.length,
                ),
              );
            } else {
              return RefreshIndicator(
                color: Colors.lightBlueAccent,
                onRefresh: _begeniListesiniYenile,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Container(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.local_fire_department,
                              color: Colors.lightBlueAccent,
                              size: 80,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Henüz Beğeniniz Bulunmamaktadır.",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                    height: MediaQuery.of(context).size.height - 150,
                  ),
                ),
              );
            }

            /*  child:
            Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 22),
                    child: GestureDetector(
                      onTap: () {},
                      child: Card(
                        color: Colors.white,
                        margin: EdgeInsets.zero,
                        child: FlatButton(
                          onPressed: () {},
                          child: ListTile(
                            title: Text(
                              "Adem Adıyaman",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 15),
                            ).tr(),
                            leading: Icon(
                              Icons.person_pin,
                              color: Colors.black,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: GestureDetector(
                      onTap: () {},
                      child: Card(
                        color: Colors.white,
                        margin: EdgeInsets.zero,
                        child: FlatButton(
                          onPressed: () {},
                          child: ListTile(
                            title: Text(
                              "Orhan Şenel",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 15),
                            ).tr(),
                            leading: Icon(
                              Icons.person_pin,
                              color: Colors.black,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: GestureDetector(
                      onTap: () {},
                      child: Card(
                        color: Colors.white,
                        margin: EdgeInsets.zero,
                        child: FlatButton(
                          onPressed: () {},
                          child: ListTile(
                            title: Text(
                              "Mehmet Çınar",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 15),
                            ).tr(),
                            leading: Icon(
                              Icons.person_pin,
                              color: Colors.black,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),*/

          }
        },
      ),
    );
  }

  Future<Null> _begeniListesiniYenile() async {
    setState(() {});
    await Future.delayed(Duration(seconds: 1));
    return null;
  }
}
