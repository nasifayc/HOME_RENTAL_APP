import 'package:home_app/model/message_model.dart';
import 'package:home_app/model/user_model.dart';

class Chat {
  final String id;
  final List<User> users;
  final List<Message> messages;
  final Message? lastMessage;
  final String lastUpdatedTime;

  Chat(
      {required this.id,
      required this.lastMessage,
      required this.lastUpdatedTime,
      required this.messages,
      required this.users});
}
