import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_chat/bloc/authBloc/auth_bloc.dart';
import 'package:frontend_chat/screens/chatList_screen.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Login to Chat'),
        backgroundColor: Colors.deepPurple[400],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 2),
                  dismissDirection: DismissDirection.horizontal,
                  content: Text('Welcome ${state.user.username}!'),
                  backgroundColor: Colors.green,
                ),
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatlistScreen(),
                ),
              );
            } else if (state is AuthFailedState) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Login Failed'),
                      content: SingleChildScrollView(
                        child: ListBody(
                          children: <Widget>[
                            Center(
                              child: CircleAvatar(
                                backgroundColor: Colors.red,
                                child: IconButton(
                                  icon: const Icon(Icons.close,
                                      color: Colors.white),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(state.message, textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
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
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  ToggleButtons(
                    borderColor: Colors.grey,
                    fillColor: Colors.deepPurple[400],
                    borderWidth: 2,
                    selectedBorderColor: Colors.deepPurple[400],
                    selectedColor: Colors.white,
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(0),
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
                  const SizedBox(height: 20),
                  if (isUsernameLogin)
                    TextField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                  if (!isUsernameLogin)
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  const SizedBox(height: 20),
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
                              title: const Text('Login Failed'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Center(
                                      child: CircleAvatar(
                                        backgroundColor: Colors.red,
                                        child: IconButton(
                                          icon: const Icon(Icons.close,
                                              color: Colors.white),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    const Text('Please fill all the fields',
                                        textAlign: TextAlign.center),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.deepPurple[400],
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w200,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
