import 'package:flutter/material.dart';
import 'package:love_chat/screens/chats/chat_item.dart';

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
    _tabController = TabController(vsync: this, initialIndex: 0, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorColor: Theme.of(context).accentColor,
            labelColor: Theme.of(context).accentColor,
            unselectedLabelColor: Theme.of(context).textTheme.caption.color,
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
              itemCount: 10,
              separatorBuilder: (BuildContext context, int index) => Divider(),
              itemBuilder: (BuildContext context, int index) {
                return ChatItem();
              },
            ),
            ListView.separated(
              itemCount: 20,
              separatorBuilder: (BuildContext context, int index) => Divider(),
              itemBuilder: (BuildContext context, int index) {
                 return ChatItem();
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
