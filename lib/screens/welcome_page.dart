import 'package:flutter/material.dart';
import 'package:love_chat/providers/userManager.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    goHomeIfHasLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('欢迎LV~'),
      ),
    );
  }

  void goHomeIfHasLogin() {
    Future.delayed(Duration(seconds: 1)).then((_) async{
      UserManager userManager = await UserManager().restoreFromDisk();
      if (userManager != null && userManager.hasLogin()) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }
}
