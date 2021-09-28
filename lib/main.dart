import 'package:flutter_tiktok/pages/homePage.dart';
import 'package:flutter_tiktok/style/style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:flutter_tiktok/config/router_manager.dart';
import 'package:flutter_tiktok/pages/settingsPage.dart';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_tiktok/config/storage_manager.dart';
void main() async {
  /// 自定义报错页面
  if (kReleaseMode) {
    ErrorWidget.builder = (FlutterErrorDetails flutterErrorDetails) {
      debugPrint(flutterErrorDetails.toString());
      return Material(
        child: Center(
            child: Text(
          "发生了没有处理的错误\n请通知开发者",
          textAlign: TextAlign.center,
        )),
      );
    };
  }
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true);

  WidgetsFlutterBinding.ensureInitialized(); //将组件和flutter绑定？
  await StorageManager.init(); //本地存储初始化
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
        title: 'Flutter Tiktok',
        debugShowCheckedModeBanner: false,
        onGenerateRoute: Routers.generateRoute,
        theme: ThemeData(
          brightness: Brightness.dark,
          hintColor: Colors.white,
          accentColor: Colors.white,
          primaryColor: ColorPlate.orange,
          primaryColorBrightness: Brightness.dark,
          scaffoldBackgroundColor: ColorPlate.back1,
          dialogBackgroundColor: ColorPlate.back2,
          accentColorBrightness: Brightness.light,
          textTheme: TextTheme(
            bodyText1: StandardTextStyle.normal,
          ),
        ),
        home: SettingsPage(),
      ),
    );
  }
}
