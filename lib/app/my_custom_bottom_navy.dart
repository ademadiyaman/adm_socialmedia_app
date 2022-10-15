import 'package:adm_socialmedia_app/app/tab_items.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyCustomBottomNavigation extends StatelessWidget {
  const MyCustomBottomNavigation(
      {Key? key,
      required this.currentTab,
      required this.onSelectedTab,
      required this.sayfaOlusturucu,
      required this.navigatorKeys})
      : super(key: key);
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectedTab;
  final Map<TabItem, Widget> sayfaOlusturucu;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        activeColor: Colors.lightBlueAccent,
        items: [
          _navItemOlustur(TabItem.Kullanicilar),
          _navItemOlustur(TabItem.Konusmalarim),
          _navItemOlustur(TabItem.Durumlar),
          // _navItemOlustur(TabItem.KullanicilarPage),
          _navItemOlustur(TabItem.KisiselPage),
          //_navItemOlustur(TabItem.Profil),
        ],
        onTap: (index) => onSelectedTab(TabItem.values[index]),
      ),
      tabBuilder: (context, index) {
        final gosterilecekItem = TabItem.values[index];
        return CupertinoTabView(
            navigatorKey: navigatorKeys[gosterilecekItem],
            builder: (context) {
              return sayfaOlusturucu[gosterilecekItem]!;
            });
      },
    );
  }

  BottomNavigationBarItem _navItemOlustur(TabItem tabItem) {
    final olusturulacakTab = TabItemData.tumTablar[tabItem];
    return BottomNavigationBarItem(
      icon: Icon(olusturulacakTab!.icon),
    );
  }
}
