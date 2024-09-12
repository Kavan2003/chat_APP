class ChatUser {
  final String id;
  final String username;
  final String avatar;

  ChatUser({
    required this.id,
    required this.username,
    required this.avatar,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      id: json['id'],
      username: json['username'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'avatar': avatar,
    };
  }
}

class ChatListResponse {
  final List<ChatUser> data;

  ChatListResponse({
    required this.data,
  });

  factory ChatListResponse.fromJson(List<dynamic> list) {
    return ChatListResponse(
      data: list.map((user) => ChatUser.fromJson(user)).toList(),
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'data': data.map((user) => user.toJson()).toList(),
  //   };
  // }
}
