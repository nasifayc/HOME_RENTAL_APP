import 'dart:developer';

import 'package:flutter/material.dart';
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
  final TextEditingController _messageController = TextEditingController();
  List<String> messages = [];
  List<String> users = []; // List of users
  String? selectedUser; // Currently selected user to chat with

  @override
  void initState() {
    super.initState();
    fetchUsers();
    connectSocket();
  }

  void fetchUsers() {
    // Mock data for user list, replace this with API call to fetch user list
    setState(() {
      users = ["user2", "user3", "user4"];
    });
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

  void sendMessage() {
    if (_messageController.text.isNotEmpty && selectedUser != null) {
      socket.emit("sendMessage", {
        "sender": "user1", // Current logged-in user
        "receiver": selectedUser, // Selected user
        "content": _messageController.text
      });
      setState(() {
        messages.add(_messageController.text); // Add to local chat list
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return selectedUser == null ? buildUserList() : buildChatScreen();
  }

  Widget buildUserList() {
    return Container(
      color: Colors.grey[200],
      child: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.teal,
                child: Text(
                  users[index][0].toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(
                users[index],
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              onTap: () {
                setState(() {
                  selectedUser = users[index];
                  messages
                      .clear(); // Clear previous messages when switching users
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget buildChatScreen() {
    return Column(
      children: [
        Expanded(
          child: Container(
            color: Colors.grey[200],
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                bool isSender = index % 2 == 0; // Alternate sender for styling
                return Align(
                  alignment:
                      isSender ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSender ? Colors.teal : Colors.blueGrey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      messages[index],
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
                onPressed: sendMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }
}
