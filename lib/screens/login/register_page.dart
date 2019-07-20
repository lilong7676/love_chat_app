import 'package:flutter/material.dart';
import 'package:love_chat/api/api_account.dart';
import 'package:love_chat/net/net_base_entity.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _secondPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
            key: _formKey,
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
                  controller: _passwordController,
                  obscureText: true,
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
                  controller: _secondPasswordController,
                  obscureText: true,
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
      floatingActionButton: FloatingActionButton(
        onPressed: registerAction,
        child: Icon(Icons.arrow_forward),
        backgroundColor: Colors.pink,
      ),
    );
  }

  void registerAction() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    String password1 = _passwordController.text;
    String password2 = _secondPasswordController.text;
    if (password1 != password2) {
      showToast('两次密码不一致');
      return;
    }

    Map<String, String> params = {
      'username': _usernameController.text,
      'password': _passwordController.text,
    };
    try {
      NetBaseEntity result = await ApiAccount.fetchRegister(params);
      if (result.code == 200) {
        Navigator.pop(context);
      } else {
        showToast(result.message);
      }
    } catch (e) {
      showToast('网络错误');
    }
  }

  void showToast(String text) {
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text(text), duration: Duration(milliseconds: 1500)));
  }
}
