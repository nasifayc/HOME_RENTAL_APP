import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_app/cubits/chat.dart';
import 'package:home_app/states/chat_state.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';

class ChatDetailScreen extends StatefulWidget {
  final String id;
  final IO.Socket? socket;
  const ChatDetailScreen({super.key, required this.id, this.socket});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();

  void sendMessage(ChatCubit chatCubit, String recipientId) {
    chatCubit.addMessage(_messageController.text, recipientId);
    // if (_messageController.text.isNotEmpty) {
    //   widget.socket!.emit("sendMessage", {
    //     "sender": "user1", // Current logged-in user
    //     "receiver": '', // Selected user
    //     "content": _messageController.text
    //   });

    //   _messageController.clear();
    // }
  }

  @override
  void initState() {
    final chatCubit = BlocProvider.of<ChatCubit>(context);
    chatCubit.fetchChat(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final chatCubit = BlocProvider.of<ChatCubit>(context);
    return BlocBuilder<ChatCubit, ChatState>(builder: (context, state) {
      if (state is SingleChatLoaded) {
        final chat = state.chat;
        return Scaffold(
          appBar: AppBar(
            title: Text(chat.users[1].name),
            centerTitle: true,
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: chat.messages.length,
                  itemBuilder: (context, index) {
                    bool isSender =
                        index % 2 == 0; // Alternate sender for styling
                    return Align(
                      alignment: isSender
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSender ? Colors.teal : Colors.blueGrey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          chat.messages[index].content,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: "Enter a message",
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.teal),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.teal),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: const Icon(Icons.send),
                      color: Colors.teal,
                      iconSize: 28,
                      onPressed: () {
                        sendMessage(chatCubit, state.chat.users[1].id);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }

      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    });
  }
}
