import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend_chat/bloc/jobbloc/job_bloc.dart';
import 'package:frontend_chat/models/sell_model.dart';
import 'package:frontend_chat/repositories/api_response.dart';
import 'package:frontend_chat/utils/constants.dart';
import 'package:http_parser/http_parser.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

part 'sell_event.dart';
part 'sell_state.dart';

class SellBloc extends Bloc<SellEvent, SellState> {
  SellBloc() : super(SellInitial()) {
    on<SellSearchEvent>(
      (event, emit) async {
        emit(SellLoading());
        try {
          final url =
              Uri.parse('$apiroute${sellRoute}search?keyword=${event.query}');
          final prefs = await SharedPreferences.getInstance();
          final accesstoken = prefs.getString('accessToken') ?? '';
          final response = await http.get(
            url,
            headers: {
              'Authorization': 'Bearer $accesstoken',
              'Content-Type': 'application/json',
              'ngrok-skip-browser-warning': 'ngrok-skip-browser-warning'
            },
          );

          print(response.body);
          final sellresponse = ApiResponse<AllSellModel>.fromJson(
              response.body, (json) => AllSellModel.fromJson(json));
          sellresponse.status == "true"
              ? emit(SellLoaded(sellresponse.data!))
              : emit(SellError(sellresponse.message));
        } catch (e) {
          print('Api Fetch Error on sell $e');
          emit(SellError(e.toString()));
        }
      },
    );

    on<SellviewIdEvent>(
      (event, emit) async {
        emit(SellLoading());
        try {
          final prefs = await SharedPreferences.getInstance();
          final accesstoken = prefs.getString('accessToken') ?? '';
          final url = Uri.parse('$apiroute${sellRoute}sellbyid?id=${event.id}');
          final response = await http.get(
            url,
            headers: {
              'Authorization': 'Bearer $accesstoken',
              'content-type': 'application/json',
              'ngrok-skip-browser-warning': 'ngrok-skip-browser-warning'
            },
          );
          print(response.body);
          final sellresponse = ApiResponse<SellModel>.fromJson(
              response.body, (json) => SellModel.fromJson(json));
          sellresponse.status == "true"
              ? emit(SellIdLoaded(sellresponse.data!))
              : emit(SellError(sellresponse.message));
        } catch (e) {
          print('Api Fetch Error on sell $e');
          emit(SellError(e.toString()));
        }
      },
    );

    on<SellCreateEvent>(
      (event, emit) async {
        try {
          emit(SellLoading());

          final prefs = await SharedPreferences.getInstance();
          final accesstoken = prefs.getString('accessToken') ?? '';
          final url = Uri.parse('$apiroute$sellRoute');

          var request = http.MultipartRequest('POST', url)
            ..headers.addAll({
              'Authorization': 'Bearer $accesstoken',
              'Content-Type': 'application/json',
            })
            ..fields['name'] = event.name
            ..fields['description'] = event.description
            ..fields['price'] = event.price;
          for (var i = 0; i < event.images.length; i++) {
            request.files.add(await http.MultipartFile.fromPath(
              'images',
              event.images[i],
              contentType: MediaType('image', 'jpeg'),
            ));
          }
          final response = await request.send();
          final responseString = await response.stream.bytesToString();
          if (response.statusCode == 200) {
            emit(SellLoading());
            add(SellSearchEvent(""));
          }
          print(responseString);
          final sellresponse = ApiResponse<SellModel>.fromJson(
              responseString, (json) => SellModel.fromJson(json));
          sellresponse.status == "true"
              ? emit(SellCreateSuccess(sellresponse.data!))
              : emit(SellError(sellresponse.message));
        } catch (e) {
          print('Api Fetch Error on sell $e');
          emit(SellError(e.toString()));
        }
      },
    );
  }
}
