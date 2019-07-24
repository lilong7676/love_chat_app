import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:love_chat/screens/login/login_page.dart';
import 'package:love_chat/screens/login/register_page.dart';
import 'package:love_chat/screens/home/home_page.dart';
import 'package:love_chat/screens/welcome_page.dart';

class MyRouter {
  static final routes = <String, WidgetBuilder>{
    '/': (BuildContext context) => WelcomePage(),
    '/login': (BuildContext context) => Login(),
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
   
    return MaterialPageRoute(
        settings: settings, builder: routes[settings.name]);
  }
}
