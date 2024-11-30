import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_app/interfaces/chat.dart';
import 'package:home_app/states/chat_state.dart';

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

  Future<void> addMessage(String content, String recipientId) async {
    final response = await chatRepo.addChat(content, recipientId);

    response.fold((chat) {
      fetchChat(recipientId);
    }, (error) {
      emit(error!);
    });
  }

  Future<void> deleteMessage(String id, String recipientId) async {
    final response = await chatRepo.deleteMessage(id);
    print(response);
    response.fold((chat) {
      fetchChat(recipientId);
    }, (error) {
      emit(error!);
    });
  }
}
