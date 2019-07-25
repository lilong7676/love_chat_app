import 'package:flutter/material.dart';
import 'package:love_chat/screens/chats/chats.dart';
import 'package:love_chat/lv/chat_engine/chat_engin.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PageController _pageController;
  int _page = 0;

  @override
  void initState() {


  ChatEngin ce = ChatEngin();


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          onPageChanged: _onPageChanged,
          children: <Widget>[
            Chats(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              title: Text('Message'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('我'),
            ),
          ],
          onTap: navigationTapped,
          currentIndex: _page,
        ),
      ),
    );
  }

  void _onPageChanged(int page) {}

  void navigationTapped(int page) {}

  /// 
}
