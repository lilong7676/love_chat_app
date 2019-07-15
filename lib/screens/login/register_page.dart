import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _secondPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('注册')),
      body: ListView(
        padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
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
          Form(
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _usernameController,
                  autofocus: true,
                  validator: (inputValue) {
                    return inputValue.isEmpty ? '请输入用户名' : null;
                  },
                  decoration: InputDecoration(
                    labelText: '用户名:',
                    hintText: '输入用户名啊',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                TextFormField(
                  controller: _usernameController,
                  autofocus: true,
                  validator: (inputValue) {
                    return inputValue.isEmpty ? '请输入密码' : null;
                  },
                  decoration: InputDecoration(
                    labelText: '密码:',
                    hintText: '输入啊',
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                TextFormField(
                  controller: _usernameController,
                  autofocus: true,
                  validator: (inputValue) {
                    return inputValue.isEmpty ? '再次输入密码' : null;
                  },
                  decoration: InputDecoration(
                    labelText: '再次输入密码:',
                    hintText: '确认这个密码啊',
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),
                
              ],
            ),
          )
        ],
      ),
    );
  }
}
