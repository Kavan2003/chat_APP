import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_chat/bloc/authBloc/auth_bloc.dart';
import 'package:frontend_chat/models/user_models.dart'; // Assuming this exists for UserModel
import 'package:file_picker/file_picker.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final yearOfStudyController = TextEditingController();
  final branchController = TextEditingController();
  final skillsController = TextEditingController();
  final descriptionController = TextEditingController();
  String? resumePath;
  Future<void> pickResume() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        resumePath = result.files.single.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      appBar: AppBar(
        title: const Text('Register for Chat'),
        backgroundColor: Colors.deepPurple[400],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Welcome ${state.user.username}! Registration successful.'),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is AuthFailedState) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Registration Failed'),
                    content: Text(state.message),
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
                  TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 20),
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
                  TextField(
                    controller: yearOfStudyController,
                    decoration: const InputDecoration(
                      labelText: 'Year of Study',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.school),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: branchController,
                    decoration: const InputDecoration(
                      labelText: 'Branch',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.account_tree),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: skillsController,
                    decoration: const InputDecoration(
                        labelText: 'Skills (comma separated)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.code)),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.description)),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: pickResume,
                    child: Text('Add Resume'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (usernameController.text.isNotEmpty &&
                          emailController.text.isNotEmpty &&
                          passwordController.text.isNotEmpty &&
                          yearOfStudyController.text.isNotEmpty &&
                          branchController.text.isNotEmpty &&
                          skillsController.text.isNotEmpty &&
                          descriptionController.text.isNotEmpty &&
                          resumePath != null) {
                        context.read<AuthBloc>().add(
                              AuthRegisterEvent(
                                  username: usernameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  yearOfStudy: yearOfStudyController.text,
                                  branch: branchController.text,
                                  skills: skillsController.text.split(','),
                                  description: descriptionController.text,
                                  resume: resumePath!),
                            );
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Registration Failed'),
                              content: const Text('Please fill all the fields'),
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
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple[400],
                        padding: const EdgeInsets.symmetric(vertical: 15)),
                    child: const Text('Register',
                        style: TextStyle(fontSize: 18, color: Colors.white)),
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
