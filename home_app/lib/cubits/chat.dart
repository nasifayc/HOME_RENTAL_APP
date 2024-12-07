import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_app/interfaces/chat.dart';
import 'package:home_app/states/chat_state.dart';
import 'package:home_app/model/chat_model.dart';

class ChatCubit extends Cubit<ChatState> {
  final IChatRepository chatRepo;
  ChatCubit({required this.chatRepo}) : super(ChatInitial());
  Future<void> fetchChats() async {
    final response = await chatRepo.fetchChats();

    response.fold((chats) {
      emit(ChatLoaded(chats!));
    }, (error) {
      emit(error!);
    });
  }

  Future<void> fetchChat(String id) async {
    final response = await chatRepo.fetchChat(id);

    response.fold((chat) {
      emit(SingleChatLoaded(chat!, ''));
    }, (error) {
      emit(error!);
    });
  }

  Future<void> addMessage(String content, String recipientId, Chat chat) async {
    final response = await chatRepo.addChat(content, recipientId);

    response.fold((chat) {
      fetchChat(recipientId);
    }, (error) {
      emit(SingleChatLoaded(chat, error!.message));
    });
  }

  Future<void> updateMessage(
      String content, String id, String recipientId, Chat chat) async {
    final response = await chatRepo.updateMessage(content, id);

    response.fold((chat) {
      fetchChat(recipientId);
    }, (error) {
      emit(SingleChatLoaded(chat, error!.message));
    });
  }

  Future<void> deleteMessage(String id, String recipientId, Chat chat) async {
    final response = await chatRepo.deleteMessage(id);
    response.fold((chat) {
      fetchChat(recipientId);
    }, (error) {
      emit(SingleChatLoaded(chat, ''));
    });
  }

  Future<void> clearChat(String id, List<Chat> chats) async {
    final response = await chatRepo.clearChat(id);
    response.fold((chat) {
      fetchChats();
    }, (error) {
      emit(ChatLoaded(chats));
    });
  }
}
