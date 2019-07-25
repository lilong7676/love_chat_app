import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatEngin {
  ChatEngin() {
    IO.Socket socket = IO.io('http://localhost:3000', <String, dynamic>{'transports': ['websocket']});
    socket.on('connect', (_) {
     print('connect');
     socket.emit('msg', 'flutter test');
    });
    socket.on('msg', (data) => print(data));
    socket.on('disconnect', (_) => print('disconnect'));
    socket.on('fromServer', (_) => print(_));
  }
}