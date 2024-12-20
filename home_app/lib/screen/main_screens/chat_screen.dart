import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_app/core/theme/app_theme.dart';
import 'package:home_app/cubits/chat.dart';
import 'package:home_app/model/chat_model.dart';
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

  String extractHourMinuteAmPm(String dateTime) {
    print(dateTime);
    // Parse the ISO 8601 string into a DateTime object
    DateTime parsedDate = DateTime.parse(dateTime);

    // Extract hour, minute, and determine AM/PM
    int hour = parsedDate.hour;
    int minute = parsedDate.minute;
    String period = hour >= 12 ? "PM" : "AM";

    // Convert to 12-hour format for display
    hour = hour % 12;
    hour = hour + 3 == 0 ? 12 : hour + 3; // Adjust for midnight (0 becomes 12)

    // Format as a string (e.g., "5:38 PM")
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }

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

  @override
  Widget build(BuildContext context) {
    final chatCubit = BlocProvider.of<ChatCubit>(context);
    AppTheme theme = AppTheme.of(context);

    return Container(
      child: BlocBuilder<ChatCubit, ChatState>(builder: (context, state) {
        if (state is ChatLoaded) {
          List<Chat> chats = List.from(state.chats)
            ..sort((a, b) => b.lastUpdatedTime.compareTo(a.lastUpdatedTime));

          if (chats.isEmpty) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.cloud_off,
                    size: 100,
                  ),
                  Text(
                    "No Chats",
                    style: TextStyle(fontSize: 20, color: theme.primaryText),
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
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: InkWell(
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
                            : const LoginPage(),
                      ),
                    );
                  },
                  onLongPress: () {
                    showModalBottomSheet(
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      context: context,
                      builder: (_) {
                        return Wrap(
                          children: [
                            ListTile(
                              leading:
                                  const Icon(Icons.delete, color: Colors.red),
                              title: const Text(
                                'Clear Chat Message',
                                style: TextStyle(color: Colors.black),
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                chatCubit.clearChat(
                                  chats[index].users[0].id == userid
                                      ? chats[index].users[1].id
                                      : chats[index].users[0].id,
                                  chats,
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        // User Avatar
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.teal,
                          child: Text(
                            userid == chats[index].users[1].id
                                ? chats[index].users[0].name[0].toUpperCase()
                                : chats[index].users[1].name[0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        // User Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userid == chats[index].users[1].id
                                    ? chats[index].users[0].name
                                    : chats[index].users[1].name,
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 5),

                              // Last Updated Time
                              Text(
                                extractHourMinuteAmPm(
                                    chats[index].lastUpdatedTime),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios,
                            color: Colors.grey, size: 20),
                      ],
                    ),
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
