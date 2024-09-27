import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_chat/bloc/chats/chats_bloc.dart';
import 'package:frontend_chat/models/Chatlist_models.dart';
import 'package:frontend_chat/screens/chat_screen.dart';
import 'package:frontend_chat/screens/search_screen.dart';
import 'package:frontend_chat/utils/component/bottombar.dart';
import 'package:frontend_chat/utils/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: const Text(' Welcome to Chat App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_outlined),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchScreen()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              SnackBar snackBar =
                  const SnackBar(content: Text('Under Construction'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          ),
        ],
      ),
      bottomSheet: BottomBar(currentIndex: 0),
      body: BlocProvider(
        create: (context) => ChatsBloc()..add(FetchChatsList()),
        child: BlocBuilder<ChatsBloc, ChatsState>(
          builder: (context, state) {
            if (state is ChatsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ChatsListLoaded) {
              return ListView.builder(
                itemCount: state.chatList.data.length,
                itemBuilder: (context, index) {
                  final chatUser = state.chatList.data[index];
                  return ListTile(
                      // leading: CircleAvatar(
                      //   backgroundImage: NetworkImage(chatUser.avatar),
                      //   onBackgroundImageError: (exception, stackTrace) {
                      //     print('Error loading image: $exception');
                      //   },
                      // ),
                      title: Text(chatUser.username),
                      // subtitle: Text(
                      //   'New messages: ${state.newMessageCounts[chatUser.id] ?? 0}',
                      // ),
                      trailing: state.newMessageCounts[chatUser.id] == null
                          ? null
                          : CircleAvatar(
                              backgroundColor: Colors.blue,
                              child: Text(
                                "${state.newMessageCounts[chatUser.id]}",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                      onTap: () async {
                        final prefs = await SharedPreferences.getInstance();
                        final myId = prefs.getString('id') ?? '';

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                  userId: state.chatList.data[index].id,
                                  myId: myId,
                                  username: chatUser.username)),
                        );
                      });
                },
              );
            } else if (state is ChatsError) {
              return Center(
                  child: Text('Failed to load chats: ${state.message}'));
            } else {
              return const Center(child: Text('No chats available'));
            }
          },
        ),
      ),
    );
  }
}
