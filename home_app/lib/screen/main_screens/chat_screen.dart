import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_app/cubits/chat.dart';
import 'package:home_app/screen/main_screens/chat_detail_screen.dart';
import 'package:home_app/states/chat_state.dart';
import 'package:home_app/utils/api_url.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late IO.Socket socket;
  List<String> messages = [];
  String? selectedUser; // Currently selected user to chat with

  @override
  void initState() {
    BlocProvider.of<ChatCubit>(context).fetchChats();
    connectSocket();
    super.initState();
  }

  void connectSocket() {
    socket = IO.io(baserURL, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket.connect();

    socket.on("connect", (_) {
      log("Connected to socket");
    });

    socket.on("receiveMessage", (data) {
      if (data["sender"] == selectedUser || data["receiver"] == selectedUser) {
        setState(() {
          messages.add(data["content"]);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BlocBuilder<ChatCubit, ChatState>(builder: (context, state) {
        if (state is ChatLoaded) {
          final chats = state.chats;
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
                          builder: (context) => ChatDetailScreen(
                              id: chats[index].users[1].id, socket: socket),
                        ));
                  },
                  leading: CircleAvatar(
                    backgroundColor: Colors.teal,
                    child: Text(
                      chats[index].users[1].name[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    chats[index].users[1].name,
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

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }
}
