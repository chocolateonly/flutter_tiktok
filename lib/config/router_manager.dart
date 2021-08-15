import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tiktok/pages/filePage.dart';
class RouteName {
  static const String file = 'file';
}

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.file:
        var list = settings.arguments as List;
        var title = list[0];
        return CupertinoPageRoute(builder: (_) => FilePage(title));
      default:
        return CupertinoPageRoute(builder: (_) => Scaffold(body: Center(child: Text('No route defined for ${settings.name}'))));
    }
  }
}