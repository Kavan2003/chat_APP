class ChatMessage {
  final String senderId;
  final String receiverId;
  final String message;

  ChatMessage({
    required this.senderId,
    required this.receiverId,
    required this.message,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      message: json['message'],
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
