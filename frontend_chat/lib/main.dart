import 'package:flutter/material.dart';
import 'package:frontend_chat/bloc/authBloc/auth_bloc.dart';
import 'package:frontend_chat/bloc/chats/chats_bloc.dart';
import 'package:frontend_chat/bloc/jobbloc/job_bloc.dart';
import 'package:frontend_chat/bloc/searchbloc/search_bloc.dart';
import 'package:frontend_chat/screens/login_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_chat/bloc/sell/sell_bloc.dart';
import 'package:frontend_chat/theme.dart';

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
        BlocProvider(create: (context) => SearchBloc()),
        BlocProvider(create: (context) => ChatsBloc()),
        BlocProvider(create: (context) => JobBloc()),
        BlocProvider(create: (context) => SellBloc()),

        // BlocProvider(
        //   create: (context) => SubjectBloc(),
        // ),
      ],
      child: MaterialApp(
        title: 'Chat App',
        theme: AppTheme.themeData,
        home: const LoginScreen(),
      ),
    );
  }
}
