import 'package:flutter/material.dart';
import 'package:flutter_tiktok/config/storage_manager.dart';

class LocaleModel extends ChangeNotifier {
  static const localeValueList = ['zh', 'en',"ms"];

  //
  static const kLocaleIndex = 'kLocaleIndex';

  int _localeIndex=0;

  int get localeIndex => _localeIndex;

  Locale get locale {
      var value = localeValueList[_localeIndex].split("-");
      return Locale(value[0], value.length == 2 ? value[1] : '');
  }

  LocaleModel() {
    _localeIndex = StorageManager.sharedPreferences!.getInt(kLocaleIndex) ?? 0;
  }

  switchLocale(int index) {
    _localeIndex = index;
    notifyListeners();
   StorageManager.sharedPreferences!.setInt(kLocaleIndex, index);
  }

  static String localeName(index, context) {
    switch (index) {
      case 0:
        return '中文';
      case 1:
        return 'English';
      default:
        return '';
    }
  }
}
