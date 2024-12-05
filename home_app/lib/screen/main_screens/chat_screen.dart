import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_app/cubits/chat.dart';
import 'package:home_app/screen/layout/sign_up_page.dart';
import 'package:home_app/screen/main_screens/chat_detail_screen.dart';
import 'package:home_app/states/chat_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<String> messages = [];
  String? selectedUser;
  String? userid;

  @override
  void initState() {
    BlocProvider.of<ChatCubit>(context).fetchChats();
    getUserId();
    super.initState();
  }

  void getUserId() async {
    final pref = await SharedPreferences.getInstance();
    final token = pref.getString("accessToken");
    try {
      final parts = token!.split('.');
      if (parts.length == 3) {
        final payload =
            utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
        final payloadMap = jsonDecode(payload);
        final id = payloadMap['id'];
        userid = id;
        print(userid);
      }
    } catch (e) {
      print('Error decoding JWT: $e');
    }
  }

  void clearChat(String chatId) {
    print('Clearing chat with ID: $chatId');
    // You can call a method from your ChatCubit to handle clearing chat messages.
    // BlocProvider.of<ChatCubit>(context).clearChat(chatId);
  }

  @override
  Widget build(BuildContext context) {
    print(userid);
    return Container(
      child: BlocBuilder<ChatCubit, ChatState>(builder: (context, state) {
        if (state is ChatLoaded) {
          final chats = state.chats;

          if (chats.isEmpty) {
            return const Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_off,
                    size: 100,
                  ),
                  Text(
                    "No Chats",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  )
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => userid != null
                                ? ChatDetailScreen(
                                    id: userid == chats[index].users[1].id
                                        ? chats[index].users[0].id
                                        : chats[index].users[1].id,
                                    userid: userid!,
                                  )
                                : const LoginPage()));
                  },
                  onLongPress: () {
                    showModalBottomSheet(
                      backgroundColor: Colors.red,
                      context: context,
                      builder: (_) {
                        return Wrap(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.delete),
                              title: const Text('Clear Chat Message'),
                              onTap: () {
                                Navigator.pop(context);
                                clearChat(chats[index].id);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: Text(
                      userid == chats[index].users[1].id
                          ? chats[index].users[0].name[0].toUpperCase()
                          : chats[index].users[1].name[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    userid == chats[index].users[1].id
                        ? chats[index].users[0].name
                        : chats[index].users[1].name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              );
            },
          );
        }

        print(state);

        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }),
    );
  }
}
