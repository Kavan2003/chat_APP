import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_chat/bloc/profile_screen/profile_screen_bloc.dart';
import 'package:frontend_chat/screens/login_screen.dart';
import 'package:frontend_chat/theme.dart';
import 'package:frontend_chat/utils/component/bottombar.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileScreenBloc()..add(FetchUserProfile()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Profile',
              style: AppTheme.heading1.copyWith(color: Colors.white)),
        ),
        bottomNavigationBar: BottomBar(currentIndex: 3),
        body: BlocBuilder<ProfileScreenBloc, ProfileScreenState>(
          builder: (context, state) {
            if (state is ProfileScreenLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProfileScreenSuccess) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: state.user.avatar.isNotEmpty
                                    ? NetworkImage(state.user.avatar)
                                    : null,
                                child: state.user.avatar.isEmpty
                                    ? const Icon(Icons.person, size: 50)
                                    : null,
                              ),
                              const SizedBox(height: 16),
                              Text(state.user.username,
                                  style: AppTheme.heading1),
                              const SizedBox(height: 8),
                              Text(state.user.email, style: AppTheme.bodyText),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        child: Column(
                          children: [
                            ProfileInfoTile(
                              label: 'Year of Study',
                              value: state.user.yearOfStudy,
                            ),
                            ProfileInfoTile(
                              label: 'Branch',
                              value: state.user.branch,
                            ),
                            ProfileInfoTile(
                              label: 'Skills',
                              value: state.user.skills.join(', '),
                            ),
                            ProfileInfoTile(
                              label: 'Description',
                              value: state.user.description,
                            ),
                            ProfileInfoTile(
                              label: 'Resume',
                              value: state.user.resume,
                            ),
                            ProfileInfoTile(
                              label: 'Created At',
                              value: state.user.createdAt,
                            ),
                            ProfileInfoTile(
                              label: 'Updated At',
                              value: state.user.updatedAt,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: AppTheme.primaryButton,
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                            (Route<dynamic> route) => false,
                          );
                        },
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is ProfileScreenError) {
              return Center(
                child: Text(
                  state.message,
                  style: AppTheme.bodyText.copyWith(color: Colors.red),
                ),
              );
            } else {
              return const Center(
                child: Text('Unknown state', style: AppTheme.bodyText),
              );
            }
          },
        ),
      ),
    );
  }
}

class ProfileInfoTile extends StatelessWidget {
  final String label;
  final String value;

  const ProfileInfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label, style: AppTheme.heading2),
      subtitle: Text(value, style: AppTheme.bodyText),
      leading: Icon(Icons.info_outline, color: AppTheme.primaryColor),
    );
  }
}
