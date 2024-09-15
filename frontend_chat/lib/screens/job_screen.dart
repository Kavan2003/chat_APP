import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_chat/bloc/jobbloc/job_bloc.dart';
import 'package:frontend_chat/screens/jobview_screen.dart';
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
                title: const Text('Create Job'),
                content: Column(
                  children: [
                    TextField(
                      controller: jobDescriptionController,
                      decoration:
                          const InputDecoration(hintText: 'Job Description'),
                    ),
                    TextField(
                      controller: skillsController,
                      decoration:
                          const InputDecoration(hintText: 'Skills , seprated'),
                    ),
                    TextField(
                      controller: companyWebsiteController,
                      decoration:
                          const InputDecoration(hintText: 'Company Website'),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Create Job API call
                      context.read<JobBloc>().add(JobCreateEvent(
                          skillsController.text,
                          jobDescriptionController.text,
                          companyWebsiteController.text));
                      Navigator.pop(context);
                    },
                    child: const Text('Create'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: isSearching
            ? TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  // searchController.text = value;
                },
              )
            : Text(searchController.text),
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
      bottomSheet: BottomBar(currentIndex: 1),
      body: BlocBuilder<JobBloc, JobState>(
        builder: (context, state) {
          if (state is JobLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is JobAllLoaded) {
            return ListView.builder(
              itemCount: state.jobs.data.length,
              itemBuilder: (context, index) {
                final job = state.jobs.data[index];
                return ListTile(
                  title: Text(job.owner.username),
                  subtitle: Text(job.skills.join(', ')),
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
                    )
                        // .then((_) {
                        //   // Code to run when JobViewScreen pops out
                        //   // For example, you can refresh the state or call a function
                        //   setState(() {
                        //     context
                        //         .read<JobBloc>()
                        //         .add(JobSearchEvent(searchController.text));
                        //   });
                        // })
                        ;
                  },
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
