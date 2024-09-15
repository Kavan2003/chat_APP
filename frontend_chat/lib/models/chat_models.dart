class ChatMessage {
  final String senderId;
  final String? receiverId;
  final String? groupId;
  final String message;
  final String? fileLink;
  final String id;
  //final DateTime createdAt;
  //final DateTime updatedAt;
  // final int version;

  ChatMessage({
    required this.senderId,
    this.receiverId,
    this.groupId,
    required this.message,
    this.fileLink,
    required this.id,
    // required this.createdAt,
    // required this.updatedAt,
    // required this.version,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      senderId: json['Owner'].toString(),
      receiverId: json['Recipient']?.toString(),
      groupId: json['grpid']?.toString(),
      message: json['message'].toString(),
      fileLink: json['filelink']?.toString(),
      id: json['_id'].toString(),
      // createdAt: DateTime.parse(json['createdAt']),
      // updatedAt: DateTime.parse(json['updatedAt']),
      // version: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Owner': senderId,
      'Recipient': receiverId,
      'grpid': groupId,
      'message': message,
      'filelink': fileLink,
      '_id': id,
      // 'createdAt': createdAt.toIso8601String(),
      // 'updatedAt': updatedAt.toIso8601String(),
      // '__v': version,
    };
  }
}

class ChatHistory {
  List<ChatMessage> messages;

  ChatHistory({required this.messages});

  factory ChatHistory.fromJson(List<dynamic> json) {
    return ChatHistory(
      messages: json.map((message) => ChatMessage.fromJson(message)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messages': messages.map((message) => message.toJson()).toList(),
    };
  }
}
