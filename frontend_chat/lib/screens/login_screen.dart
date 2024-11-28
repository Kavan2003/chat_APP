import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_chat/bloc/authBloc/auth_bloc.dart';
import 'package:frontend_chat/screens/chatList_screen.dart';
import 'package:frontend_chat/screens/register_screen.dart';
import 'package:frontend_chat/utils/constants.dart';
import 'package:frontend_chat/theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();

  bool isUsernameLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthSuccessState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 2),
                    content: Text('Welcome ${state.user.username}!'),
                    backgroundColor: AppTheme.secondaryColor,
                  ),
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatListScreen(),
                  ),
                );
              } else if (state is AuthFailedState) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        title: const Text('Login Failed'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Icon(
                                Icons.error_outline,
                                color: AppTheme.errorColor,
                                size: 60,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                state.message,
                                textAlign: TextAlign.center,
                                style: AppTheme.bodyText,
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: AppTheme.secondaryButton,
                          ),
                        ],
                      );
                    },
                  );
                });
              }
            },
            builder: (context, state) {
              if (state is AuthLoadingState) {
                return const Center(child: CircularProgressIndicator());
              }
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      'Welcome Back',
                      style: AppTheme.heading1,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Please sign in to continue',
                      style: AppTheme.bodyText.copyWith(
                        color: AppTheme.onBackgroundColor.withOpacity(0.6),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    ToggleButtons(
                      borderColor: Colors.grey[300],
                      fillColor: AppTheme.primaryColor,
                      borderWidth: 2,
                      selectedBorderColor: AppTheme.primaryColor,
                      selectedColor: AppTheme.onPrimaryColor,
                      color: AppTheme.onBackgroundColor.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                      onPressed: (int index) {
                        setState(() {
                          isUsernameLogin = index == 0;
                        });
                      },
                      isSelected: [isUsernameLogin, !isUsernameLogin],
                      children: const <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32),
                          child: Text('Username'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32),
                          child: Text('Email'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    if (isUsernameLogin)
                      TextField(
                        controller: usernameController,
                        decoration: AppTheme.inputDecoration.copyWith(
                          labelText: 'Username',
                          prefixIcon: const Icon(Icons.person),
                        ),
                      ),
                    if (!isUsernameLogin)
                      TextField(
                        controller: emailController,
                        decoration: AppTheme.inputDecoration.copyWith(
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.email),
                        ),
                      ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: AppTheme.inputDecoration.copyWith(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        if (isUsernameLogin
                            ? usernameController.text.isNotEmpty &&
                                passwordController.text.isNotEmpty
                            : emailController.text.isNotEmpty &&
                                passwordController.text.isNotEmpty) {
                          context.read<AuthBloc>().add(
                                isUsernameLogin
                                    ? AuthLoginEvent(
                                        username: usernameController.text,
                                        password: passwordController.text)
                                    : AuthLoginEvent(
                                        email: emailController.text,
                                        password: passwordController.text),
                              );
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                title: const Text('Login Failed'),
                                content: SingleChildScrollView(
                                  child: ListBody(
                                    children: <Widget>[
                                      Icon(
                                        Icons.error_outline,
                                        color: AppTheme.errorColor,
                                        size: 60,
                                      ),
                                      const SizedBox(height: 20),
                                      const Text(
                                        'Please fill all the fields',
                                        textAlign: TextAlign.center,
                                        style: AppTheme.bodyText,
                                      ),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    style: AppTheme.secondaryButton,
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      style: AppTheme.primaryButton,
                      child: const Text(
                        'Login',
                        style: AppTheme.buttonText,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterScreen()));
                      },
                      child: Text(
                        'Don\'t have an account? Register',
                        style: AppTheme.bodyText.copyWith(
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
