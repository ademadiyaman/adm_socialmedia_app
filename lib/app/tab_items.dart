import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TabItem {
  Kullanicilar,
  Konusmalarim,
  Durumlar,
  KisiselPage,
//  Profil
}

class TabItemData {
  //final String title;
  final IconData icon;
  // final Colors color;

  TabItemData(this.icon);
  static Map<TabItem, TabItemData> tumTablar = {
    TabItem.Kullanicilar: TabItemData(Icons.supervised_user_circle),
    TabItem.Konusmalarim: TabItemData(Icons.chat),
    TabItem.Durumlar: TabItemData(Icons.photo),
    // TabItem.KullanicilarPage: TabItemData(Icons.person_add_alt_1_outlined),
    TabItem.KisiselPage: TabItemData(Icons.perm_contact_cal),
    //TabItem.Profil: TabItemData(Icons.person),
  };
}
