import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_chat/bloc/chatlistbloc/chatlist_bloc.dart';
import 'package:frontend_chat/screens/chat_screen.dart';
import 'package:frontend_chat/screens/search_screen.dart';

class ChatlistScreen extends StatefulWidget {
  const ChatlistScreen({super.key});

  @override
  State<ChatlistScreen> createState() => _ChatlistScreenState();
}

class _ChatlistScreenState extends State<ChatlistScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ChatlistBloc>(context).add(FetchChatList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        actions: [
          IconButton.filledTonal(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchScreen()));
              },
              icon: Icon(Icons.search)),
        ],
        title: const Text('Chat List'),
      ),
      body: BlocBuilder<ChatlistBloc, ChatlistState>(
        builder: (context, state) {
          if (state is ChatlistInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatlistLoaded) {
            return ListView.builder(
              itemCount: state.chatList.data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                          senderId: state.chatList.data[index].id,
                        ),
                      ),
                    );
                  },
                  // leading: CircleAvatar(
                  //   backgroundImage:
                  //       NetworkImage(state.chatList.data[index].avatar),
                  //   onBackgroundImageError: (exception, stackTrace) {
                  //     print('Error: $exception');
                  //   },
                  // ),
                  title: Text(state.chatList.data[index].username),
                  // subtitle: Text(state.chatList.chats[index].lastMessage),
                );
              },
            );
          } else if (state is ChatlistError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return Container();
        },
      ),
    );
  }
}
