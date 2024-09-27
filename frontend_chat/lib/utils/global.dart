// globals.dart
import 'package:frontend_chat/models/Chatlist_models.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

IO.Socket? globalSocket;
Map<String, int> newMessageCounts = {};
ChatListResponse? globalchatList;
