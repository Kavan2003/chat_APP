class ChatMessage {
  final String senderId;
  final String? receiverId;
  final String message;

  ChatMessage({
    required this.senderId,
    this.receiverId,
    required this.message,
  });

  factory ChatMessage.fromJson(List<dynamic> json) {
    return ChatMessage(
      senderId: json[0].toString(),
      message: json[1].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
    };
  }
}
