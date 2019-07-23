import 'package:flutter/material.dart';

class ChatItem extends StatelessWidget {
  const ChatItem({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(12, 10, 12, 10),
      leading: CircleAvatar(
        backgroundColor: Colors.blueAccent,
      ),
      title: Text('title'),
      subtitle: Text('subTitle'),
      enabled: true,
      onTap: (){},
    );
  }
}
