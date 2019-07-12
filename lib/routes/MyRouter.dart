import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:love_chat/screens/login/login_page.dart';

class MyRouter {
  static final routes = <String, WidgetBuilder>{
    '/': (BuildContext context) => Login(),
    '/login': (BuildContext context) => Login(title: '测试啊啊',),
  };

  static Route<dynamic> getRoute(RouteSettings settings) {
    // Object arguments = settings.arguments;
    if (settings.name == '/login2') {
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => Login(title: 'What??',),
      );
    }
    return MaterialPageRoute(
        settings: settings,
        builder: routes[settings.name]
      );
  }
}