// chatList_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_chat/bloc/chats/chats_bloc.dart';
import 'package:frontend_chat/models/Chatlist_models.dart';
import 'package:frontend_chat/screens/chat_screen.dart';
import 'package:frontend_chat/screens/search_screen.dart';
import 'package:frontend_chat/utils/component/bottombar.dart';
import 'package:frontend_chat/utils/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend_chat/theme.dart';

class ChatListScreen extends StatefulWidget {
  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryColor,
        title: Text(
          'Welcome to Chat App',
          style: AppTheme.heading1.copyWith(color: AppTheme.onPrimaryColor),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search_outlined, color: AppTheme.onPrimaryColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications, color: AppTheme.onPrimaryColor),
            onPressed: () {
              SnackBar snackBar = SnackBar(
                content: Text(
                  'Under Construction',
                  style: AppTheme.bodyText
                      .copyWith(color: AppTheme.onPrimaryColor),
                ),
                backgroundColor: AppTheme.primaryColor,
              );
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
              return Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                ),
              );
            } else if (state is ChatsListLoaded) {
              return ListView.builder(
                itemCount: state.chatList.data.length,
                itemBuilder: (context, index) {
                  final chatUser = state.chatList.data[index];
                  return Card(
                    color: AppTheme.surfaceColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppTheme.primaryColor,
                        child: Text(
                          chatUser.username[0].toUpperCase(),
                          style: AppTheme.bodyText.copyWith(
                            color: AppTheme.onPrimaryColor,
                          ),
                        ),
                      ),
                      title: Text(
                        chatUser.username,
                        style: AppTheme.bodyText
                            .copyWith(color: AppTheme.onSurfaceColor),
                      ),
                      trailing: state.newMessageCounts[chatUser.id] == null
                          ? null
                          : CircleAvatar(
                              backgroundColor: AppTheme.accentColor,
                              radius: 12,
                              child: Text(
                                "${state.newMessageCounts[chatUser.id]}",
                                style: AppTheme.bodyText.copyWith(
                                  color: AppTheme.onPrimaryColor,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                      onTap: () async {
                        final prefs = await SharedPreferences.getInstance();
                        final myId = prefs.getString('id') ?? '';

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              userId: chatUser.id,
                              myId: myId,
                              username: chatUser.username,
                            ),
                          ),
                        ).then((result) {
                          if (result == 'refresh') {
                            setState(() {});
                          }
                        });
                      },
                    ),
                  );
                },
              );
            } else if (state is ChatsError) {
              return Center(
                child: Text(
                  'Failed to load chats: ${state.message}',
                  style: AppTheme.bodyText.copyWith(color: AppTheme.errorColor),
                ),
              );
            } else {
              return Center(
                child: Text(
                  'No chats available',
                  style: AppTheme.bodyText
                      .copyWith(color: AppTheme.onBackgroundColor),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
