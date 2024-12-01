import 'package:home_app/model/chat_model.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<Chat> chats;

  ChatLoaded(this.chats);
}

class SingleChatLoaded extends ChatState {
  final Chat chat;

  SingleChatLoaded(this.chat);
}

class ChatError extends ChatState {
  final String message;

  ChatError(this.message);
}
