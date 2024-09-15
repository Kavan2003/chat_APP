part of 'job_bloc.dart';

@immutable
sealed class JobState {}

final class JobInitial extends JobState {}

final class JobLoading extends JobState {}

final class JobAllLoaded extends JobState {
  final AllJobModel jobs;

  JobAllLoaded(this.jobs);
}

final class JobLoaded extends JobState {
  final JobModel job;

  JobLoaded(this.job);
}

final class JobError extends JobState {
  final String message;

  JobError(this.message);
}
