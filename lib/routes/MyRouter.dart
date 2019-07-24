import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:love_chat/screens/login/login_page.dart';
import 'package:love_chat/screens/login/register_page.dart';
import 'package:love_chat/screens/home/home_page.dart';

class MyRouter {
  static final routes = <String, WidgetBuilder>{
    '/register': (BuildContext context) => RegisterPage(),
    '/home': (BuildContext context) => Home(),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    // Object arguments = settings.arguments;
    // if (settings.name == '/login2') {
    //   return MaterialPageRoute(
    //     settings: settings,
    //     builder: (BuildContext context) => Login(
    //       title: 'What??',
    //     ),
    //   );
    // }
    if (settings.name == '/') {
      print('00000000000000000000');
      return MaterialPageRoute(
        settings: settings, builder: (BuildContext context) => Login()
      );
    }
    return MaterialPageRoute(
        settings: settings, builder: routes[settings.name]);
  }
}
