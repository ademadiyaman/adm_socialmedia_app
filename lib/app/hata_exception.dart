import 'package:easy_localization/easy_localization.dart';

class Hatalar {
  static String gorset(String hataKodu) {
    switch (hataKodu) {
      case 'email-already-in-use':
        return 'mail.kullanimda'.tr();
      case '505284406':
        return 'mail_bulunmuyor'.tr();
      default:
        return 'sifre_veya_mail_yanlis'.tr();
    }
  }
}
