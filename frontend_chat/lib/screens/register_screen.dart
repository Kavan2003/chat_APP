import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_chat/bloc/authBloc/auth_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:frontend_chat/theme.dart';

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
      backgroundColor: AppTheme.backgroundColor, // Use theme background color
      appBar: AppBar(
        title: Text(
          'Register for Chat',
          style: AppTheme.heading1.copyWith(color: AppTheme.onPrimaryColor),
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        iconTheme: IconThemeData(color: AppTheme.onPrimaryColor),
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Welcome ${state.user.username}! Registration successful.',
                    style: AppTheme.bodyText
                        .copyWith(color: AppTheme.onPrimaryColor),
                  ),
                  backgroundColor: AppTheme.primaryColor,
                ),
              );
            } else if (state is AuthFailedState) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: Text(
                      'Registration Failed',
                      style: AppTheme.heading2,
                    ),
                    content: Text(
                      state.message,
                      style: AppTheme.bodyText,
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text(
                          'OK',
                          style: AppTheme.buttonText
                              .copyWith(color: AppTheme.primaryColor),
                        ),
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
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTextField(
                    controller: usernameController,
                    labelText: 'Username',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: emailController,
                    labelText: 'Email',
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: passwordController,
                    labelText: 'Password',
                    icon: Icons.lock,
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: yearOfStudyController,
                    labelText: 'Year of Study',
                    icon: Icons.school,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: branchController,
                    labelText: 'Branch',
                    icon: Icons.account_tree,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: skillsController,
                    labelText: 'Skills (comma separated)',
                    icon: Icons.code,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: descriptionController,
                    labelText: 'Description',
                    icon: Icons.description,
                  ),
                  const SizedBox(height: 16),
                  resumePath == null
                      ? ElevatedButton.icon(
                          onPressed: pickResume,
                          icon: const Icon(Icons.attach_file),
                          label: Text(
                            'Add Resume',
                            style: AppTheme.buttonText,
                          ),
                          style: AppTheme.primaryButton,
                        )
                      : Container(
                          padding: const EdgeInsets.all(15),
                          child: Text(
                            'Resume selected: ${resumePath!}',
                            style: AppTheme.bodyText,
                          ),
                        ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      if (_areFieldsValid()) {
                        context.read<AuthBloc>().add(
                              AuthRegisterEvent(
                                username: usernameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                                yearOfStudy: yearOfStudyController.text,
                                branch: branchController.text,
                                skills: skillsController.text,
                                description: descriptionController.text,
                                resume: resumePath!,
                              ),
                            );
                      } else {
                        _showErrorDialog(context, 'Please fill all the fields');
                      }
                    },
                    style: AppTheme.primaryButton,
                    child: Text(
                      'Register',
                      style: AppTheme.buttonText,
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: AppTheme.bodyText,
      decoration: AppTheme.inputDecoration.copyWith(
        labelText: labelText,
        prefixIcon: Icon(icon, color: AppTheme.primaryColor),
      ),
    );
  }

  bool _areFieldsValid() {
    return usernameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        yearOfStudyController.text.isNotEmpty &&
        branchController.text.isNotEmpty &&
        skillsController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        resumePath != null;
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Registration Failed',
            style: AppTheme.heading2,
          ),
          content: Text(
            message,
            style: AppTheme.bodyText,
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'OK',
                style:
                    AppTheme.buttonText.copyWith(color: AppTheme.primaryColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
