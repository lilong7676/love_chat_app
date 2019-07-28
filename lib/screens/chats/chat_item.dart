import 'package:flutter/material.dart';
import 'package:love_chat/lv/user/user.dart';

class ChatItem extends StatelessWidget {
  User _user;

  ChatItem({Key key, User user}) : super(key: key) {
    _user = user;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(12, 10, 12, 10),
      leading: CircleAvatar(
        backgroundColor: Colors.blueAccent,
      ),
      title: Text(_user.username),
      subtitle: Text(_user?.userId.toString()),
      enabled: true,
      onTap: (){},
    );
  }
}
