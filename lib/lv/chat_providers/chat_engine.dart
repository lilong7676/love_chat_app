import 'package:flutter/material.dart';
import 'package:love_chat/providers/userManager.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatEngine extends ChangeNotifier {
  IO.Socket _socket;
  IO.Socket get chatSocket => _socket;


  final UserManager _userManager = UserManager();

  static ChatEngine _instance;

  factory ChatEngine() {
    return _sharedInstance();
  }

  static ChatEngine _sharedInstance() {
    if (_instance == null) {
      _instance = ChatEngine._();
    }
    return _instance;
  }

  ChatEngine._() {
    String accessToken = _userManager.accessToken;

    IO.Socket socket = IO.io('http://localhost:3000', <String, dynamic>{
      'transports': ['websocket'],
      'query': {
        'token': accessToken,
      }
    });

    _socket = socket;

    socket.on('connect', (_) {
      print('connect');
      socket.emit('userLogin', 'flutter test');
    });

    socket.on('error', (error) {
      if (error) {}
      print('socket error $error');
    });

    socket.on('disconnect', (_) => print('disconnect'));
  }
  
  void onDisconnectedFromServer() {}
}
