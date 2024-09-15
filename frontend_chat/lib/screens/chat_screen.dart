import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc/chatbloc/chat_bloc.dart';
import '../models/chat_models.dart';

class ChatScreen extends StatefulWidget {
  final String senderId;
  ChatScreen({required this.senderId});
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ChatBloc>(context).add(ChatConnect(id: widget.senderId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App'),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatInitial || state is ChatLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is ChatMessageReceivedState ||
                    state is ChatMessageSent) {
                  List<ChatMessage> messages = state is ChatMessageReceivedState
                      ? state.messages
                      : (state as ChatMessageSent).messages;
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(messages[index].message),
                        subtitle: Text('From: ${messages[index].senderId}'),
                      );
                    },
                  );
                } else if (state is ChatError) {
                  return Center(child: Text('Error: ${state.message}'));
                }
                return Container();
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
                      hintText: 'Enter your message',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () async {
                    if (_messageController.text.isNotEmpty) {
                      final prefs = await SharedPreferences.getInstance();
                      final id = prefs.getString('id') ?? '';
                      BlocProvider.of<ChatBloc>(context).add(ChatSendMessage(
                        senderId: id,
                        receiverId: widget.senderId,
                        message: _messageController.text,
                      ));
                      _messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
