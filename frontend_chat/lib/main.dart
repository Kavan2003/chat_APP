import 'package:flutter/material.dart';
import 'package:frontend_chat/bloc/authBloc/auth_bloc.dart';
import 'package:frontend_chat/bloc/chatlistbloc/chatlist_bloc.dart';
import 'package:frontend_chat/bloc/searchbloc/search_bloc.dart';
import 'package:frontend_chat/screens/login_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_chat/screens/register_screen.dart';

import 'bloc/chatbloc/chat_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => ChatBloc()),
        BlocProvider(create: (context) => SearchBloc()),
        BlocProvider(create: (context) => ChatlistBloc()),
        // BlocProvider(
        //   create: (context) => SubjectBloc(),
        // ),
      ],
      child: MaterialApp(
        title: 'Chat App',
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
