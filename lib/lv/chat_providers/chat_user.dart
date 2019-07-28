import 'package:flutter/material.dart';
import 'chat_engine.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:love_chat/lv/user/user.dart';
import 'package:love_chat/providers/userManager.dart';

class ChatUser extends ChangeNotifier {
  final IO.Socket _socket = ChatEngine().chatSocket;
  final List<User> userOnlineList = List();
  final UserManager _userManager = UserManager();

  static ChatUser _instance;

  factory ChatUser() {
    return _sharedInstance();
  }

  static ChatUser _sharedInstance() {
    if (_instance == null) {
      _instance = ChatUser._();
    }
    return _instance;
  }

  ChatUser._() {
    _socket.on('onUserConnected', (userJson) {
      if (userJson != null) {
        userJson = userJson as Map<String, dynamic>;
        User user = User.fromJson(userJson);
        onUserConnected(user);
      }
    });

    _socket.on('onlineUsers', (userList) {
      if (userList is List) {
        onReceiveOnlineUsers(userList);
      }
    });

    _socket.on('onUserDisconnected', (userJson) {
      if (userJson != null) {
        userJson = userJson as Map<String, dynamic>;
        User user = User.fromJson(userJson);
        onUserDisconnected(user);
      }
    });
  }

  // 处理用户上线事件
  void onUserConnected(User user) {
    print('onUserConnected $user');
    if (user.userId == _userManager.userId) {
      return;
    }
    bool hasContains = onlineUsersHasContainersUserId(user.userId);
    if (!hasContains) {
      userOnlineList.add(user);
      notifyListeners();
    }
  }

  // 用户断线
  void onUserDisconnected(User user) {
    if (onlineUsersHasContainersUserId(user.userId)) {
      int index = 0;
      bool hasFind = false;
      for (User aUser in userOnlineList) {
        if (aUser.userId == user.userId) {
          hasFind = true;
          break;
        }
        index++;
      }
      if (hasFind) {
        userOnlineList.removeAt(index);
        notifyListeners();
      }
    }
  }

  // 处理在线用户信息事件
  void onReceiveOnlineUsers(List userList) {
    print('_userManager.userId ${_userManager.userId}');
    print('onReceiveOnlineUsers $userList');

    List<User> list = User.userListFromJsonList(userList);
    List<int> userIdList = list.map((user) => user.userId).toList();

    bool needNotify = false;
    // 移除掉线的人
    userOnlineList.retainWhere((user) {
      bool satisfied = userIdList.contains(user.userId);
      if (!satisfied) {
        needNotify = true;
      }
      return satisfied;
    });

    for (User user in list) {
       if (user.userId != _userManager.userId && !onlineUsersHasContainersUserId(user.userId)) {
        userOnlineList.insert(0, user);
        needNotify = true;
      }
    }
    if (needNotify) {
      notifyListeners();
    }
  }

  // 获取当前在线用户列表是否包含此用户id
  bool onlineUsersHasContainersUserId(int userId) {
    return userOnlineList.map((user) => user.userId).toList().contains(userId);
  }
}
