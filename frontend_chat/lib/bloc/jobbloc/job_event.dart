part of 'job_bloc.dart';

@immutable
sealed class JobEvent {}

//job search , view , create
class JobSearchEvent extends JobEvent {
  final String query;

  JobSearchEvent(this.query);
}

class JobViewEvent extends JobEvent {
  final String id;

  JobViewEvent(this.id);
}

class JobCreateEvent extends JobEvent {
  final String skills;
  final String jobDescription;
  final String companyWebsite;

  JobCreateEvent(this.skills, this.jobDescription, this.companyWebsite);
}
