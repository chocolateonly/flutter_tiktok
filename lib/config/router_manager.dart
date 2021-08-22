import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tiktok/pages/filePage.dart';
import 'package:flutter_tiktok/pages/settingsPage.dart';
import 'package:flutter_tiktok/pages/homePage.dart';
class RouteName {
  static const String file = 'file';
  static const String settings='settings';
  static const String home='home';
}

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.file:
        var list = settings.arguments as List;
        var title = list[0];
        return CupertinoPageRoute(builder: (_) => FilePage(title));
      case RouteName.settings:
        return CupertinoPageRoute(builder: (_) => SettingsPage());
      case RouteName.home:
        return CupertinoPageRoute(builder: (_) => HomePage());
      default:
        return CupertinoPageRoute(builder: (_) => Scaffold(body: Center(child: Text('No route defined for ${settings.name}'))));
    }
  }
}