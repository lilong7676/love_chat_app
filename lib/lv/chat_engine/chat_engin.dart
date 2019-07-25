import 'package:love_chat/providers/userManager.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatEngin {
  ChatEngin() {
    UserManager userManager = UserManager();
    String accessToken = userManager.accessToken;
    

    IO.Socket socket = IO.io('http://10.0.2.2:3000', <String, dynamic>{'transports': ['websocket']});
    socket.on('connect', (_) {
     print('connect');
     socket.emit('userLogin', 'flutter test');
    });
    socket.on('msg', (data) => print(data));
    socket.on('disconnect', (_) => print('disconnect'));
    socket.on('fromServer', (_) => print(_));
  }
}