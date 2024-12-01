class Message {
  final String id;
  final String content;
  final String chatId;
  final String owner;
  final String time;
  final bool seen;

  Message(
      {required this.id,
      required this.chatId,
      required this.content,
      required this.owner,
      required this.seen,
      required this.time});

  factory Message.fromJson(Map<String, dynamic> jsonMessage) {
    return Message(
        id: jsonMessage["_id"],
        chatId: jsonMessage["chatId"],
        content: jsonMessage["content"],
        owner: jsonMessage["owner"],
        time: jsonMessage["time"],
        seen: jsonMessage["seen"]);
  }
}
