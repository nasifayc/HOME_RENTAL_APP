import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket _socket;

  void connect() {
    _socket = IO.io('http://localhost:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket.connect();

    _socket.onConnect((_) {
      print('Connected to socket server');
    });

    _socket.onDisconnect((_) {
      print('Disconnected from socket server');
    });
  }

  void joinChat(String chatId) {
    _socket.emit('joinChat', chatId);
  }

  void leaveChat(String chatId) {
    _socket.emit('leaveChat', chatId);
  }

  void listenToMessageAdded(
      String name, Function(Map<String, dynamic>) onMessageAdded) {
    _socket.on('messageAdded-$name', (data) {
      onMessageAdded(data);
    });
  }

  void listenToMessageDeleted(Function(Map<String, dynamic>) onMessageDeleted) {
    _socket.on('messageDeleted', (data) {
      onMessageDeleted(data);
    });
  }

  void disconnect() {
    _socket.disconnect();
  }
}
