import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_chat/bloc/jobbloc/job_bloc.dart';

class JobViewScreen extends StatefulWidget {
  final String jobId;
  final String query;

  const JobViewScreen({super.key, required this.jobId, required this.query});

  @override
  State<JobViewScreen> createState() => _JobViewScreenState();
}

class _JobViewScreenState extends State<JobViewScreen> {
  @override
  void initState() {
    context.read<JobBloc>().add(JobViewEvent(widget.jobId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => {
            print(widget.query),
            context.read<JobBloc>().add(
                JobSearchEvent(widget.query == 'Jobs' ? '' : widget.query)),
            Navigator.pop(context)
          },
        ),
        title: Text('Job Details'),
      ),
      body: BlocBuilder<JobBloc, JobState>(
        builder: (context, state) {
          if (state is JobLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is JobLoaded) {
            final job = state.job;
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Job Description: ${job.jobDescription}',
                        style: TextStyle(fontSize: 18)),
                    SizedBox(height: 8),
                    Text('Company Website: ${job.companyWebsite}',
                        style: TextStyle(fontSize: 18)),
                    SizedBox(height: 8),
                    Text('Skills: ${job.skills.join(', ')}',
                        style: TextStyle(fontSize: 18)),
                    SizedBox(height: 8),
                    Text('Owner: ${job.owner.username}',
                        style: TextStyle(fontSize: 18)),
                    SizedBox(height: 8),
                    Text('Created At: ${job.createdAt}',
                        style: TextStyle(fontSize: 18)),
                    SizedBox(height: 8),
                    Text('Updated At: ${job.updatedAt}',
                        style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            );
          } else if (state is JobError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return Center(child: Text('No job details found'));
          }
        },
      ),
    );
  }
}
