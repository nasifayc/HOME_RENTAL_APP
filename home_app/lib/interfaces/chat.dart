import 'package:dartz/dartz.dart';
import 'package:home_app/model/chat_model.dart';
import 'package:home_app/states/chat_state.dart';

abstract class IChatRepository {
  Future<Either<List<Chat>?, ChatError?>> fetchChats();
  Future<Either<Chat?, ChatError?>> fetchChat(id);
  Future<Either<String?, ChatError?>> addChat(
      String content, String recipientId);
  Future<Either<String?, ChatError?>> deleteMessage(String id);
  Future<Either<String?, ChatError?>> clearChat(String id);
  Future<Either<String?, ChatError?>> updateMessage(String content, String id);
}
