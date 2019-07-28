import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:love_chat/screens/chats/chat_item.dart';
import 'package:love_chat/lv/chat_providers/chat_user.dart';
import 'package:love_chat/lv/user/user.dart';

class Chats extends StatefulWidget {
  Chats({Key key}) : super(key: key);

  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, initialIndex: 1, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (_) => ChatUser()),
      ],
      child: Consumer<ChatUser>(
        builder: (context, chatUser, child) {
          print(
              'chatUser.userOnlineList.length ${chatUser.userOnlineList.length}');

          Container container = Container(
            child: Scaffold(
              appBar: AppBar(
                bottom: TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicatorColor: Theme.of(context).accentColor,
                  labelColor: Theme.of(context).accentColor,
                  unselectedLabelColor:
                      Theme.of(context).textTheme.caption.color,
                  tabs: <Widget>[
                    Tab(
                      text: 'Message',
                    ),
                    Tab(
                      text: 'Friends',
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  ListView.separated(
                    itemCount: chatUser.userOnlineList.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(),
                    itemBuilder: (BuildContext context, int index) {
                      User user = chatUser.userOnlineList[index];
                      return ChatItem(user: user);
                    },
                  ),
                  ListView.separated(
                    itemCount: chatUser.userOnlineList.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(),
                    itemBuilder: (BuildContext context, int index) {
                      User user = chatUser.userOnlineList[index];
                      return ChatItem(user: user);
                    },
                  ),
                ],
              ),
            ),
          );

          return container;
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
