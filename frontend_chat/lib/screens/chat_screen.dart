import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_chat/bloc/chats/chats_bloc.dart';
import 'package:frontend_chat/screens/videocall.dart';
import 'package:frontend_chat/utils/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  final String myId;
  final String userId;
  final String username;

  const ChatScreen(
      {super.key,
      required this.userId,
      required this.myId,
      required this.username});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // newMessageCounts remove this item
    newMessageCounts.remove(widget.userId);

    context.read<ChatsBloc>().add(ChatConnected(widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, 'refresh');
          },
        ),
        title: Text('Chat with ${widget.username}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatsBloc, ChatsState>(
              builder: (context, state) {
                if (state is ChatsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is Status) {
                  Text(state.status.status);
                  if (state.status.status == "No request") {
                    return Center(
                      child: ElevatedButton(
                        onPressed: () {
                          context
                              .read<ChatsBloc>()
                              .add(SendRequest(widget.myId, widget.userId));
                        },
                        child: const Text('Send Request'),
                      ),
                    );
                  } else if (state.status.canAccept) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('You have a request'),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: () {
                                  context.read<ChatsBloc>().add(AcceptRequest(
                                      widget.myId, widget.userId));
                                },
                                child: const Text('Accept'),
                              ),
                              TextButton(
                                onPressed: () {
                                  context.read<ChatsBloc>().add(RejectRequest(
                                      widget.myId, widget.userId));
                                },
                                child: const Text('Reject'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Center(
                      child: Text(state.status.status),
                    );
                  }
                } else if (state is ChatMessages) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollController.jumpTo(
                      _scrollController.position.maxScrollExtent,
                    );
                  });
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      final isSentByUser = message.senderId == widget.myId;
                      return Align(
                        alignment: isSentByUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isSentByUser
                                ? Colors.blueAccent
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            message.message,
                            style: TextStyle(
                              color:
                                  isSentByUser ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is ChatsError) {
                  return Center(child: Text(state.message));
                } else {
                  return const Center(child: Text('No messages available'));
                }
              },
            ),
          ),
          BlocBuilder<ChatsBloc, ChatsState>(
            builder: (context, state) {
              if (state is ChatMessages) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: const InputDecoration(
                            hintText: 'Type a message',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          final message = _messageController.text.trim();
                          if (message.isNotEmpty) {
                            context.read<ChatsBloc>().add(ChatSendMessage(
                                widget.myId, widget.userId, message));
                            _messageController.clear();
                          }
                        },
                      ),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}
