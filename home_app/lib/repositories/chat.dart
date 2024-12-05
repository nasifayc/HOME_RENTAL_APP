import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:home_app/interfaces/chat.dart';
import 'package:home_app/model/chat_model.dart';
import 'package:home_app/model/message_model.dart';
import 'package:home_app/model/user_model.dart';
import 'package:home_app/states/chat_state.dart';
import 'package:home_app/core/api_url.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ChatRepository implements IChatRepository {
  @override
  Future<Either<List<Chat>?, ChatError?>> fetchChats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString("refreshToken") ?? '';
      String accessToken = prefs.getString("accessToken") ?? '';
      var response = await http.get(
        Uri.parse("$baserURL/api/v1/chats"),
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json"
        },
      );

      // Handle 401 or 403 to retry fetching with refreshed token
      if (response.statusCode == 401 || response.statusCode == 403) {
        final refreshResponse = await http.post(
          Uri.parse("$baserURL/api/v1/auth/refresh-token"),
          body: jsonEncode({"token": refreshToken}),
          headers: {"Content-Type": "application/json"},
        );

        if (refreshResponse.statusCode == 201) {
          final data = jsonDecode(refreshResponse.body);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("accessToken", data["access_token"]);
          await prefs.setString("refreshToken", data["refresh_token"]);
          accessToken = prefs.getString("accessToken") ?? '';

          // Retry fetching chats with new token
          response = await http.get(
            Uri.parse("$baserURL/chats"),
            headers: {
              "Authorization": "Bearer $accessToken",
              "Content-Type": "application/json"
            },
          );
        } else {
          return Right(ChatError('Failed to refresh access token'));
        }
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<Chat> chats = [];

        for (var chat in data) {
          List<Message> messages = [];
          final user1 = User.fromJson(chat['users'][0]);
          final user2 = User.fromJson(chat['users'][1]);

          for (var message in chat['messages']) {
            messages.add(Message.fromJson(message));
          }

          final lastMessage = chat['lastMessage'] != null
              ? Message.fromJson(chat['lastMessage'])
              : null;

          final newChat = Chat(
              id: chat['_id'],
              lastMessage: lastMessage,
              lastUpdatedTime: chat['lastUpdateTime'],
              messages: messages,
              users: [user1, user2]);

          chats.add(newChat);
        }

        return Left(chats);
      }

      return Right(ChatError('Error fetching messages: ${response.body}'));
    } catch (e) {
      return Right(ChatError('Network Error'));
    }
  }

  @override
  Future<Either<Chat?, ChatError?>> fetchChat(id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString("refreshToken") ?? '';
      String accessToken = prefs.getString("accessToken") ?? '';
      var response = await http.get(
        Uri.parse("$baserURL/api/v1/chats?user=$id"),
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json"
        },
      );

      if (response.statusCode == 401 || response.statusCode == 403) {
        final refreshResponse = await http.post(
          Uri.parse("$baserURL/auth/refresh-token"),
          body: jsonEncode({"token": refreshToken}),
          headers: {"Content-Type": "application/json"},
        );

        if (refreshResponse.statusCode == 201) {
          final data = jsonDecode(refreshResponse.body);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("accessToken", data["access_token"]);
          await prefs.setString("refreshToken", data["refresh_token"]);
          accessToken = prefs.getString("accessToken") ?? '';

          // Retry fetching chats with new token
          response = await http.get(
            Uri.parse("$baserURL/chats?user=$id"),
            headers: {
              "Authorization": "Bearer $accessToken",
              "Content-Type": "application/json"
            },
          );
        } else {
          return Right(ChatError('Failed to refresh access token'));
        }
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["_id"] == null) {
          final user1 = User.fromJson(data['users'][0]);
          final user2 = User.fromJson(data['users'][1]);

          return Left(Chat(
              id: "",
              lastMessage: Message(
                  id: "",
                  chatId: "",
                  content: "",
                  owner: "",
                  seen: false,
                  time: ""),
              lastUpdatedTime: "",
              messages: [],
              users: [user1, user2]));
        }

        List<Message> messages = [];
        final user1 = User.fromJson(data['users'][0]);
        final user2 = User.fromJson(data['users'][1]);

        for (var message in data['messages']) {
          messages.add(Message.fromJson(message));
        }
        final lastMessage = data['lastMessage'] != null
            ? Message.fromJson(data['lastMessage'])
            : null;

        final newChat = Chat(
            id: data['_id'],
            lastMessage: lastMessage,
            lastUpdatedTime: data['lastUpdateTime'],
            messages: messages,
            users: [user1, user2]);

        return Left(newChat);
      }

      return Right(ChatError('error fetching messages'));
    } catch (e) {
      print(e);
      return Right(ChatError('error fetching messages'));
    }
  }

  @override
  Future<Either<String?, ChatError?>> addChat(
      String content, String recipientId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString("refreshToken") ?? '';
      String accessToken = prefs.getString("accessToken") ?? '';
      var response = await http.post(
        Uri.parse("$baserURL/api/v1/messages"),
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "content": content,
          "recipientId": recipientId,
        }),
      );

      if (response.statusCode == 401 || response.statusCode == 403) {
        final refreshResponse = await http.post(
          Uri.parse("$baserURL/auth/refresh-token"),
          body: jsonEncode({"token": refreshToken}),
          headers: {"Content-Type": "application/json"},
        );

        if (refreshResponse.statusCode == 201) {
          final data = jsonDecode(refreshResponse.body);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("accessToken", data["access_token"]);
          await prefs.setString("refreshToken", data["refresh_token"]);
          accessToken = prefs.getString("accessToken") ?? '';

          response = await http.post(
            Uri.parse("$baserURL/messages"),
            headers: {
              "Authorization": "Bearer $accessToken",
              "Content-Type": "application/json"
            },
            body: jsonEncode({
              "content": content,
              "recipientId": recipientId,
            }),
          );
        } else {
          return Right(ChatError('Failed to refresh access token'));
        }
      }

      if (response.statusCode == 201) {
        return const Left('');
      }

      return Right(ChatError('error adding messages'));
    } catch (e) {
      return Right(ChatError('error adding messages'));
    }
  }

  @override
  Future<Either<String?, ChatError?>> deleteMessage(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString("refreshToken") ?? '';
      String accessToken = prefs.getString("accessToken") ?? '';
      var response = await http.delete(
        Uri.parse("$baserURL/api/v1/messages/$id"),
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json"
        },
      );

      if (response.statusCode == 401 || response.statusCode == 403) {
        final refreshResponse = await http.post(
          Uri.parse("$baserURL/auth/refresh-token"),
          body: jsonEncode({"token": refreshToken}),
          headers: {"Content-Type": "application/json"},
        );

        if (refreshResponse.statusCode == 201) {
          final data = jsonDecode(refreshResponse.body);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("accessToken", data["access_token"]);
          await prefs.setString("refreshToken", data["refresh_token"]);
          accessToken = prefs.getString("accessToken") ?? '';

          response = await http.delete(
            Uri.parse("$baserURL/messages/$id"),
            headers: {
              "Authorization": "Bearer $accessToken",
              "Content-Type": "application/json"
            },
          );
        } else {
          return Right(ChatError('Failed to refresh access token'));
        }
      }

      if (response.statusCode == 200) {
        return const Left("okay");
      }

      return Right(ChatError('error fetching messages'));
    } catch (e) {
      return Right(ChatError('error fetching messages'));
    }
  }

  @override
  Future<Either<String?, ChatError?>> clearChat(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final refreshToken = prefs.getString("refreshToken") ?? '';
      String accessToken = prefs.getString("accessToken") ?? '';
      var response = await http.delete(
        Uri.parse("$baserURL/api/v1/chats?user=$id"),
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json"
        },
      );

      if (response.statusCode == 401 || response.statusCode == 403) {
        final refreshResponse = await http.post(
          Uri.parse("$baserURL/auth/refresh-token"),
          body: jsonEncode({"token": refreshToken}),
          headers: {"Content-Type": "application/json"},
        );

        if (refreshResponse.statusCode == 201) {
          final data = jsonDecode(refreshResponse.body);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString("accessToken", data["access_token"]);
          await prefs.setString("refreshToken", data["refresh_token"]);
          accessToken = prefs.getString("accessToken") ?? '';

          response = await http.delete(
            Uri.parse("$baserURL/api/v1/chats?user=$id"),
            headers: {
              "Authorization": "Bearer $accessToken",
              "Content-Type": "application/json"
            },
          );
        } else {
          return Right(ChatError('Failed to refresh access token'));
        }
      }
      if (response.statusCode == 204) {
        return const Left("okay");
      }

      return Right(ChatError('error deleting chat'));
    } catch (e) {
      return Right(ChatError('error deleting chat'));
    }
  }
}
