import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // 用户名输入框
  TextFormField _userNameField;
  //密码输入框
  TextFormField _passwordField;

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                padding: EdgeInsets.only(top: 100),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        _formKey.currentState.validate();
                        loginAction();
                      },
                      child: Text('注册'),
                    ),
                    RaisedButton(
                      onPressed: () {
                        _formKey.currentState.validate();
                        loginAction();
                      },
                      child: Text('登录'),
                    ),
                  ],
                ))
          ],
        ),
      ),
      margin: EdgeInsets.fromLTRB(15, 20, 15, 20),
    );
  }

  void loginAction() {
    if (_nameController.text.isNotEmpty && _passwordController.text.isNotEmpty) {
      _nameFocusNode.unfocus();
      _passwordFocusNode.unfocus();
      
    }
  }
}
