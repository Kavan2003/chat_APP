import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend_chat/models/user_models.dart';
import 'package:frontend_chat/repositories/api_response.dart';
import 'package:frontend_chat/utils/constants.dart';
import 'package:frontend_chat/utils/global.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitialState()) {
    on<AuthLoginEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        bool withusername = event.username != null;
        final url = Uri.parse('$apiroute$userRoute$loginRoute');
        final response = await http.post(url, headers: {
          'ngrok-skip-browser-warning': 'ngrok-skip-browser-warning'
        }, body: {
          if (withusername) 'username': event.username,
          if (!withusername) 'email': event.email,
          'password': event.password,
        });
        print(response.body);

        final userResponse = ApiResponse<UserModel>.fromJson(
            response.body, (json) => UserModel.fromJson(json));
//store userResponse.data!.accessToken; in local storage

        //final prefs;

        if (userResponse.status == "true") {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('accessToken', userResponse.data!.accessToken);
          print("avaiable");
          await prefs.setString('id', userResponse.data!.id);
          globalSocket = IO.io(websocket, <String, dynamic>{
            'transports': ['websocket', 'polling'],
            'autoConnect': false,
          });
          print("WebSocket initialized with URL: $websocket");

          globalSocket!.connect();
          globalSocket!.emit('registerUser', userResponse.data!.id);
          globalSocket!.on("registerUserAck", (data) {
            print(data);
          });
          print("avaiable");
          //todo: temp
          globalSocket!.on('connect', (_) {
            print('WebSocket connected');
            globalSocket!.emit('registerUser', userResponse.data!.id);
            print("User registered with ID: ${userResponse.data!.id}");
          });

          globalSocket!.on('connect_error', (error) {
            print('WebSocket connection error: $error');
          });

          globalSocket!.on('disconnect', (_) {
            print('WebSocket disconnected');
          });

          globalSocket!.on("registerUserAck", (data) {
            print("Received registerUserAck: $data");
          });

//
          emit(AuthSuccessState(
            userResponse.data!,
          ));
        } else {
          emit(AuthFailedState(
            userResponse.message,
            userResponse.status.toString(),
          ));
        }
      } catch (error) {
        print('Api Fetch Error on auth $error');
        emit(AuthFailedState(
          'Api Fetch Error ${error.toString()}',
          "000",
        ));
      }
    });

    on<AuthRegisterEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        final url = Uri.parse('$apiroute$userRoute$registerRoute');
        var request = http.MultipartRequest('POST', url)
          ..fields['username'] = event.username
          ..fields['email'] = event.email
          ..fields['password'] = event.password
          ..fields['YearOFStudy'] = event.yearOfStudy
          ..fields['Branch'] = event.branch
          ..fields['skills'] = event.skills
          ..fields['description'] = event.description;

        request.files.add(await http.MultipartFile.fromPath(
          'resume',
          event.resume,
          contentType: MediaType('application', 'pdf'),
        ));

        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);
        print(response.body);

        final userResponse = ApiResponse<UserModel>.fromJson(
            response.body, (json) => UserModel.fromJson(json));
        if (userResponse.status == "true") {
          emit(AuthSuccessState(userResponse.data!));
        } else {
          emit(AuthFailedState(
            userResponse.message,
            userResponse.status.toString(),
          ));
        }
      } catch (error) {
        print('Api Fetch Error $error');
        emit(AuthFailedState(
          'Api Fetch Error ${error.toString()}',
          "000",
        ));
      }
    });
  }
}
