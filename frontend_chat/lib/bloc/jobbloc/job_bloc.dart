import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:frontend_chat/models/job_models.dart';
import 'package:frontend_chat/repositories/api_response.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:frontend_chat/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'job_event.dart';
part 'job_state.dart';

class JobBloc extends Bloc<JobEvent, JobState> {
  JobBloc() : super(JobInitial()) {
    on<JobSearchEvent>((event, emit) async {
      print('Job Search Eventloading');
      emit(JobLoading());
      try {
        final prefs = await SharedPreferences.getInstance();
        final accesstoken = prefs.getString('accessToken') ?? '';
        final url =
            Uri.parse('$apiroute$jobRoute/search?keyword=${event.query}');
        final response = await http.get(
          url,
          headers: {'Authorization': 'Bearer $accesstoken'},
        );
        print(response.body);
        final jobresponse = ApiResponse<AllJobModel>.fromJson(
            response.body, (json) => AllJobModel.fromJson(json));
        jobresponse.status == "true"
            ? emit(JobAllLoaded(jobresponse.data!))
            : emit(JobError(jobresponse.message));
      } catch (e) {
        print('Api Fetch Error on job $e');
        emit(JobError(e.toString()));
      }
    });
    on<JobViewEvent>((event, emit) async {
      emit(JobLoading());
      try {
        final prefs = await SharedPreferences.getInstance();
        final accesstoken = prefs.getString('accessToken') ?? '';
        final url = Uri.parse('$apiroute${jobRoute}jobbyid?id=${event.id}');
        final response = await http.get(
          url,
          headers: {
            'Authorization': 'Bearer $accesstoken',
          },
        );
        print(response.body);
        final jobresponse = ApiResponse<JobModel>.fromJson(
            response.body, (json) => JobModel.fromJson(json));
        jobresponse.status == "true"
            ? emit(JobLoaded(jobresponse.data!))
            : emit(JobError(jobresponse.message));
      } catch (e) {
        print('Api Fetch Error on job $e');
        emit(JobError(e.toString()));
      }
    });
    on<JobCreateEvent>((event, emit) async {
      emit(JobLoading());
      try {
        final prefs = await SharedPreferences.getInstance();
        final accesstoken = prefs.getString('accessToken') ?? '';
//           body {
//   "skills": ["JavaScript", "Node.js"],
//   "jobDescription": "Full Stack Developer",
//   "companyWebsite": "https://example.com"
// }

//convert skills that is comma spearated values to array
        final arrayskills = event.skills.split(',');
        print(arrayskills);
        print(event.jobDescription);
        print(event.companyWebsite);
        final url = Uri.parse('$apiroute$jobRoute');
        final response = await http.post(
          url,
          body: jsonEncode({
            'skills': arrayskills,
            'jobDescription': event.jobDescription,
            'companyWebsite': event.companyWebsite,
          }),
          headers: {
            'Authorization': 'Bearer $accesstoken',
            'Content-Type': 'application/json',
          },
        );
        print(response.body);
        final jobresponse = ApiResponse<JobModel>.fromJson(
            response.body, (json) => JobModel.fromJson(json));
        jobresponse.status == "true" ? {} : emit(JobError(jobresponse.message));
      } catch (e) {
        print('Api Fetch Error on job $e');
        emit(JobError(e.toString()));
      }
    });
  }
}
