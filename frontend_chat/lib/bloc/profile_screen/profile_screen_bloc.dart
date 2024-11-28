import 'package:bloc/bloc.dart';
import 'package:frontend_chat/models/user_models.dart';
import 'package:frontend_chat/repositories/api_response.dart';
import 'package:frontend_chat/utils/constants.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

part 'profile_screen_event.dart';
part 'profile_screen_state.dart';

class ProfileScreenBloc extends Bloc<ProfileScreenEvent, ProfileScreenState> {
  ProfileScreenBloc() : super(ProfileScreenInitial()) {
    on<FetchUserProfile>(_onFetchUserProfile);
    on<UpdateUserProfile>(_onUpdateUserProfile);
    on<ChangeUserPassword>(_onChangeUserPassword);
    on<AddUserAvatar>(_onAddUserAvatar);
  }

  Future<void> _onFetchUserProfile(
      FetchUserProfile event, Emitter<ProfileScreenState> emit) async {
    emit(ProfileScreenLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getString('id') ?? '';
      final accesstoken = prefs.getString('accessToken') ?? '';
      final response = await http
          .get(Uri.parse('$apiroute${userRoute}view-profile'), headers: {
        'Authorization': 'Bearer $accesstoken',
      });
      print(response.body);
      if (response.statusCode == 200) {
        final apiResponse = ApiResponse<UserModel>.fromJson(
            response.body, (data) => UserModel.fromJson(data));
        emit(ProfileScreenSuccess(apiResponse.data!));
      } else {
        emit(ProfileScreenError('Failed to fetch user profile'));
      }
    } catch (e) {
      emit(ProfileScreenError(e.toString()));
    }
  }

  Future<void> _onUpdateUserProfile(
      UpdateUserProfile event, Emitter<ProfileScreenState> emit) async {
    emit(ProfileScreenLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final accesstoken = prefs.getString('accessToken') ?? '';

      final response = await http.put(
        Uri.parse('$apiroute${userRoute}update-profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accesstoken',
        },
        body: json.encode(event.user.toJson()),
      );
      if (response.statusCode == 200) {
        final apiResponse = ApiResponse<UserModel>.fromJson(
            response.body, (data) => UserModel.fromJson(data));
        emit(ProfileScreenSuccess(apiResponse.data!));
      } else {
        emit(ProfileScreenError('Failed to update user profile'));
      }
    } catch (e) {
      emit(ProfileScreenError(e.toString()));
    }
  }

  Future<void> _onChangeUserPassword(
      ChangeUserPassword event, Emitter<ProfileScreenState> emit) async {
    emit(ProfileScreenLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final accesstoken = prefs.getString('accessToken') ?? '';

      final response = await http.post(
        Uri.parse('$apiroute${userRoute}change-password'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accesstoken',
        },
        body: json.encode({
          'oldPassword': event.oldPassword,
          'newPassword': event.newPassword
        }),
      );
      if (response.statusCode == 200) {
        emit(ProfileScreenSuccess(
            UserModel.fromJson(json.decode(response.body))));
      } else {
        emit(ProfileScreenError('Failed to change password'));
      }
    } catch (e) {
      emit(ProfileScreenError(e.toString()));
    }
  }

  Future<void> _onAddUserAvatar(
      AddUserAvatar event, Emitter<ProfileScreenState> emit) async {
    emit(ProfileScreenLoading());
    try {
      final request = http.MultipartRequest(
          'POST', Uri.parse('$apiroute${userRoute}add-avatar'));
      request.files
          .add(await http.MultipartFile.fromPath('avatar', event.avatarPath));
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final apiResponse = ApiResponse<UserModel>.fromJson(
            responseBody, (data) => UserModel.fromJson(data));
        emit(ProfileScreenSuccess(apiResponse.data!));
      } else {
        emit(ProfileScreenError('Failed to add avatar'));
      }
    } catch (e) {
      emit(ProfileScreenError(e.toString()));
    }
  }
}
