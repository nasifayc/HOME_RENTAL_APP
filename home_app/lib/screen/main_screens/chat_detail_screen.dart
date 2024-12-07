import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_app/core/theme/app_theme.dart';
import 'package:home_app/cubits/chat.dart';
import 'package:home_app/cubits/user.dart';
import 'package:home_app/model/message_model.dart';
import 'package:home_app/states/chat_state.dart';
import 'package:flutter/material.dart';
import 'package:home_app/states/user_state.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:home_app/model/chat_model.dart';

class ChatDetailScreen extends StatefulWidget {
  final String id;
  final String userid;

  const ChatDetailScreen({super.key, required this.id, required this.userid});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  late IO.Socket _socket;
  String compareAndOrderIds(String id1, String id2) {
    if (id1.compareTo(id2) <= 0) {
      return "$id1-$id2";
    } else {
      return "$id2-$id1";
    }
  }

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void sendMessage(ChatCubit chatCubit, String recipientId, Chat chat) {
    chatCubit.addMessage(_messageController.text, recipientId, chat);
    _messageController.clear();
  }

  String extractHourMinuteAmPm(String dateTime) {
    // Parse the ISO 8601 string into a DateTime object
    DateTime parsedDate = DateTime.parse(dateTime);

    // Extract hour, minute, and determine AM/PM
    int hour = parsedDate.hour;
    int minute = parsedDate.minute;
    String period = hour >= 12 ? "PM" : "AM";

    // Convert to 12-hour format for display
    hour = hour % 12;
    hour = hour == 0 ? 12 : hour; // Adjust for midnight (0 becomes 12)

    // Format as a string (e.g., "5:38 PM")
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }

  List<Message> messages = [];

  @override
  void initState() {
    final chatCubit = BlocProvider.of<ChatCubit>(context);
    chatCubit.fetchChat(widget.id);

    _socket = IO.io('http://192.168.78.41:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket.connect();

    _socket.onConnect((_) {
      print('Connected to socket server');
    });

    _socket.on('messageAdded-${compareAndOrderIds(widget.id, widget.userid)}',
        (data) {
      setState(() {
        messages.add(data);
      });
    });

    _socket.on('messageDeleted-${compareAndOrderIds(widget.id, widget.userid)}',
        (data) {
      setState(() {
        messages =
            messages.where((message) => message.id != data['_id']).toList();
      });
    });

    _socket.on('messageUpdated-${compareAndOrderIds(widget.id, widget.userid)}',
        (data) {
      setState(() {
        messages = messages.map((message) {
          if (message.id == data['_id']) {
            return Message.fromJson(data);
          }
          return message;
        }).toList();
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.extentAfter);
      }
    });

    BlocProvider.of<UserCubit>(context).fetchRate(widget.id);
    super.initState();
  }

  void _showUpdateDialog(BuildContext context, Message message,
      ChatCubit chatCubit, String chatId, AppTheme theme) {
    final TextEditingController updateController = TextEditingController();
    updateController.text = message.content;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: theme.primaryBackground,
          title: const Text("Update Message"),
          content: TextField(
            controller: updateController,
            decoration: const InputDecoration(hintText: "Edit your message"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                "Cancel",
                style: theme.typography.labelSmall,
              ),
            ),
            TextButton(
              onPressed: () {
                final updatedContent = updateController.text.trim();
                if (updatedContent.isNotEmpty) {
                  // chatCubit.updateMessage(message.id, chatId, updatedContent);
                }
                Navigator.of(context).pop();
              },
              child: Text("Update", style: theme.typography.labelSmall),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AppTheme theme = AppTheme.of(context);
    final chatCubit = BlocProvider.of<ChatCubit>(context);
    final userCubit = BlocProvider.of<UserCubit>(context);

    return WillPopScope(
        onWillPop: () async {
          chatCubit.fetchChats();
          userCubit.getProfile();
          return true;
        },
        child: BlocConsumer<ChatCubit, ChatState>(listener: (context, state) {
          if (state is SingleChatLoaded) {
            if (state.error != '') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ),
              );
            }
          }
          if (state is SingleChatLoaded) {
            setState(() {
              messages = List.from(state.chat.messages);
            });
          }
        }, builder: (context, state) {
          if (state is SingleChatLoaded) {
            final chat = state.chat;
            return Scaffold(
              appBar: AppBar(
                title: Text(chat.users[1].id == widget.id
                    ? chat.users[1].name
                    : chat.users[0].name),
                centerTitle: true,
                actions: [
                  BlocConsumer<UserCubit, UserState>(
                      listener: (context, state) {
                    if (state is UserError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }, builder: (context, state) {
                    if (state is RateLoaded) {
                      return GestureDetector(
                        onTap: () => _showRatingDialog(
                            context, state.rate, userCubit, widget.id),
                        child: StarRatingWidget(
                          rating: state.rate,
                          starSize: 15,
                        ),
                      );
                    }

                    return const CircularProgressIndicator();
                  })
                ],
              ),
              body: Column(
                children: [
                  messages.isEmpty
                      ? const Expanded(
                          flex: 8,
                          child: Center(
                            child: Text("Start Conversation"),
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                              controller: _scrollController,
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                return Align(
                                  alignment:
                                      widget.id == chat.messages[index].owner
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft,
                                  child: GestureDetector(
                                    onTap: () {
                                      if (messages[index].owner ==
                                          widget.userid) {
                                        // Show options to Update or Delete the message
                                        showModalBottomSheet(
                                          backgroundColor: theme.primary,
                                          context: context,
                                          builder: (context) {
                                            return Wrap(
                                              children: [
                                                ListTile(
                                                  leading: Icon(
                                                    Icons.edit,
                                                    color: theme.secondary,
                                                  ),
                                                  title: Text(
                                                    'Update Message',
                                                    style: theme
                                                        .typography.labelMedium,
                                                  ),
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    _showUpdateDialog(
                                                        context,
                                                        messages[index],
                                                        chatCubit,
                                                        chat.id,
                                                        theme);
                                                    // _showUpdateDialog(messages[index]); // Call update dialog
                                                  },
                                                ),
                                                ListTile(
                                                  leading: Icon(
                                                    Icons.delete,
                                                    color: theme.secondary,
                                                  ),
                                                  title: Text(
                                                    'Delete Message',
                                                    style: theme
                                                        .typography.labelMedium,
                                                  ),
                                                  onTap: () {
                                                    Navigator.pop(
                                                        context); // Close the modal
                                                    chatCubit.deleteMessage(
                                                        messages[index].id,
                                                        widget.id,
                                                        chat);
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color:
                                            widget.id != messages[index].owner
                                                ? Colors.teal
                                                : Colors.blueGrey[200],
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ConstrainedBox(
                                        constraints: const BoxConstraints(
                                          maxWidth: 200.0, // Limit width to 200
                                        ),
                                        child: IntrinsicWidth(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  chat.messages[index].content,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                  ),
                                                  softWrap:
                                                      true, // Allow text wrapping
                                                ),
                                              ),
                                              const SizedBox(
                                                  height:
                                                      4), // Spacing between text and time
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    extractHourMinuteAmPm(chat
                                                        .messages[index].time),
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w200,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              })),
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
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.teal),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.teal),
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
                            sendMessage(
                                chatCubit,
                                widget.id != state.chat.users[0].id
                                    ? state.chat.users[1].id
                                    : state.chat.users[0].id,
                                chat);
                            _scrollController.animateTo(
                              _scrollController.position.extentAfter,
                              duration: const Duration(milliseconds: 100),
                              curve: Curves.easeInOut,
                            );
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
        }));
  }
}

class DoubleCheckIcon extends StatelessWidget {
  final double size;

  const DoubleCheckIcon({Key? key, this.size = 24.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Icon(
          Icons.check,
          size: size,
        ),
        Positioned(
          left: size * 0.15, // Slight offset for the second check
          child: Icon(
            Icons.check,
            size: size,
          ),
        ),
      ],
    );
  }
}

class StarRatingWidget extends StatelessWidget {
  final num rating; // The float rating between 0.0 and 5.0
  final double starSize; // The size of each star
  final Color filledColor; // Color for filled stars
  final Color unfilledColor; // Color for unfilled stars

  const StarRatingWidget({
    Key? key,
    required this.rating,
    this.starSize = 24.0,
    this.filledColor = Colors.yellow,
    this.unfilledColor = Colors.grey,
  })  : assert(rating >= 0.0 && rating <= 5.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starFraction = (rating - index).clamp(0.0, 1.0);
        return Icon(
          starFraction == 1.0
              ? Icons.star // Fully lit star
              : starFraction > 0.0
                  ? Icons.star_half // Half-lit star
                  : Icons.star_border, // Unlit star
          size: starSize,
          color: starFraction > 0 ? filledColor : unfilledColor,
        );
      }),
    );
  }
}

void _showRatingDialog(
    BuildContext context, num initialRating, UserCubit userCubit, String id) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Rate User"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Select a rating below:"),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    userCubit.rate(index + 1, id);
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.blue,
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      );
    },
  );
}
