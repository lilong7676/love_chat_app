import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:love_chat/providers/globalSettings.dart';
import 'package:love_chat/providers/userManager.dart';
import 'package:provider/provider.dart';
import 'package:love_chat/net/net_utils.dart';
import 'package:dio/dio.dart';

class Login extends StatefulWidget {
  final String title;
  Login({Key key, this.title}) : super(key: key);
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // 用户名输入框
  TextFormField _userNameField;
  //密码输入框
  TextFormField _passwordField;

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  TapGestureRecognizer _registerTapGesture;
  @override
  void initState() {
    _userNameField = TextFormField(
      controller: _nameController,
      autofocus: true,
      focusNode: _nameFocusNode,
      decoration: InputDecoration(
        labelText: '用户名:',
        hintText: '你爱我吗？',
        prefixIcon: Icon(Icons.person),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return '你不爱我啊';
        }
        return null;
      },
    );

    _passwordField = TextFormField(
      controller: _passwordController,
      obscureText: true,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        labelText: '密码:',
        hintText: '你猜密码是啥',
        prefixIcon: Icon(Icons.lock),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return '密码都懒得输吗？';
        }
        return null;
      },
    );

    _registerTapGesture = TapGestureRecognizer()..onTap = registerAction;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title ?? '登录'),
      ),
      body: Container(
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Text(
                  'LoveChat',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.pink,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              _userNameField,
              _passwordField,
              Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: RichText(
                    text: TextSpan(
                      text: '还没有注册？',
                      children: <TextSpan>[
                        TextSpan(
                          text: '现在注册',
                          style: TextStyle(color: Colors.pink),
                          recognizer: _registerTapGesture,
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ),
        margin: EdgeInsets.fromLTRB(15, 20, 15, 20),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          loginAction();
        },
        child: Icon(Icons.arrow_forward),
        backgroundColor: Colors.pink,
      ),
    );
  }

  void loginAction() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    Map<String, String> params = {
      'username': _nameController.text,
      'password': _passwordController.text,
      'client_id': '1_6at33278mzs4o8oo84cco0c0gs8kc0ss0co4ww8ks0k48gc0oc',
      'client_secret': '60qx1xjm7f4sog04gg4sw48kkwcw40wgoooowossgsw84c00ww',
      'grant_type': 'password'
    };

    Dio dio = Dio();
    dio.options.contentType =
        ContentType.parse("application/x-www-form-urlencoded");

    dio.post('$baseUrl/oauth/token', data: params).then((result) {
      print(result);
      Map<String, dynamic> res = result.data as Map;
      if (res['code'] as int == 200) {
        String accessToken = res['data']['accessToken'] as String;
        UserManager().accessToken = accessToken;
        print(UserManager());
      } else {
        showToast(res['message'] as String);
      }
    }).catchError((error) {
      showToast(error.toString());
      print(error);
    });

    // GlobalSettings globalSettings = Provider.of<GlobalSettings>(context);
    // globalSettings.brightnessTheme = globalSettings.brightnessTheme == ThemeData.dark() ? ThemeData.light() : ThemeData.dark();

    // if (ModalRoute.of(context).settings.name == '/login2') {
    //   Navigator.pop(context, 'testPopResult');
    // } else {
    //   Navigator.pushNamed(context, '/login2', arguments: {'a': 1, 'b': 2})
    //       .then((result) {
    //     print('push Result $result');
    //   });
    // }
  }

  void unfocus() {
    _nameFocusNode.unfocus();
    _passwordFocusNode.unfocus();
  }

  void registerAction() {
    Navigator.pushNamed(context, '/register');
  }

  void showToast(String text) {
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text(text), duration: Duration(milliseconds: 1500)));
  }
}
