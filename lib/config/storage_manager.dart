import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageManager{
 static var localStorage;
 static var sharedPreferences;
  /// 临时目录 eg: cookie
 static  var temporaryDirectory;

  static init() async{
    temporaryDirectory = await getTemporaryDirectory();
    localStorage = LocalStorage('LocalStorage'); //获取本地存储的数据
    sharedPreferences = await SharedPreferences.getInstance();//实例化
  }
}