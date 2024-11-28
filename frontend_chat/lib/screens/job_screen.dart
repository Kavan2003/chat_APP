import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_chat/bloc/jobbloc/job_bloc.dart';
import 'package:frontend_chat/screens/jobview_screen.dart';
import 'package:frontend_chat/theme.dart';
import 'package:frontend_chat/utils/component/bottombar.dart';

class JobScreen extends StatefulWidget {
  const JobScreen({super.key});

  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {
  bool isSearching = false;
  TextEditingController searchController = TextEditingController(text: "Jobs");

  @override
  void initState() {
    super.initState();
    context.read<JobBloc>().add(JobSearchEvent(''));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      bottomSheet: Container(child: BottomBar(currentIndex: 1)),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {
          // A pop up dialog to create a job asking for Job details like job description, skills, company website
          showDialog(
            context: context,
            builder: (context) {
              TextEditingController jobDescriptionController =
                  TextEditingController();
              TextEditingController skillsController = TextEditingController();
              TextEditingController companyWebsiteController =
                  TextEditingController();
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                title: Text(
                  'Create Job',
                  style: AppTheme.heading2,
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: jobDescriptionController,
                        decoration: AppTheme.inputDecoration.copyWith(
                          hintText: 'Job Description',
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: skillsController,
                        decoration: AppTheme.inputDecoration.copyWith(
                          hintText: 'Skills, separated',
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: companyWebsiteController,
                        decoration: AppTheme.inputDecoration.copyWith(
                          hintText: 'Company Website',
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      textStyle: AppTheme.buttonText,
                      foregroundColor: AppTheme.primaryColor,
                    ),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Create Job API call
                      context.read<JobBloc>().add(JobCreateEvent(
                          skillsController.text,
                          jobDescriptionController.text,
                          companyWebsiteController.text));
                      Navigator.pop(context);
                    },
                    style: AppTheme.primaryButton,
                    child: const Text('Create'),
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: AppTheme.secondaryColor,
        foregroundColor: AppTheme.onSecondaryColor,
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: isSearching
            ? TextField(
                controller: searchController,
                decoration: AppTheme.inputDecoration.copyWith(
                  hintText: 'Search...',
                  border: InputBorder.none,
                  filled: false,
                ),
                onChanged: (value) {
                  // searchController.text = value;
                },
                style: AppTheme.bodyText,
              )
            : Text(
                searchController.text,
                style: AppTheme.heading1.copyWith(color: Colors.white),
              ),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  BlocProvider.of<JobBloc>(context)
                      .add(JobSearchEvent(searchController.text));
                }
              });
            },
          ),
        ],
      ),
      body: BlocBuilder<JobBloc, JobState>(
        builder: (context, state) {
          if (state is JobLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is JobAllLoaded) {
            return ListView.builder(
              itemCount: state.jobs.data.length,
              itemBuilder: (context, index) {
                final job = state.jobs.data[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Container(
                    decoration: AppTheme.cardDecoration,
                    child: ListTile(
                      title: Text(
                        job.owner.username,
                        style: AppTheme.heading2,
                      ),
                      subtitle: Text(
                        job.skills.join(', '),
                        style: AppTheme.bodyText,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: AppTheme.onSurfaceColor,
                      ),
                      onTap: () {
                        // Navigate to JobViewScreen with job id
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JobViewScreen(
                              jobId: job.id,
                              query: searchController.text,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          } else if (state is JobError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(child: Text('No State fired'));
          }
        },
      ),
    );
  }
}
