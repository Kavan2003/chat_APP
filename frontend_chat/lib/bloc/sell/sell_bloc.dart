import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend_chat/models/sell_model.dart';
import 'package:frontend_chat/repositories/api_response.dart';
import 'package:frontend_chat/utils/constants.dart';
import 'package:http_parser/http_parser.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;

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
              'Content-Type': 'application/json'
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
              'content-type': 'application/json'
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
        emit(SellLoading());
        try {
          final prefs = await SharedPreferences.getInstance();
          final accesstoken = prefs.getString('accessToken') ?? '';
          final url = Uri.parse('$apiroute$sellRoute');

          if (kIsWeb) {
            var request = html.FormData();
            request.append('name', event.name);
            request.append('description', event.description);
            request.append('price', event.price);
            // for (var i = 0; i < event.images.length; i++) {

            // }
            var file = html.File(event.images, 'image/jpeg');
            request.appendBlob('images', file);

            var xhr = html.HttpRequest();
            xhr.open('POST', url.toString());
            xhr.setRequestHeader('Authorization', 'Bearer $accesstoken');
            xhr.setRequestHeader('Content-Type', 'multipart/form-data');
            xhr.send(request);

            // await xhr.onLoadEnd.first;
            xhr.onLoadEnd.listen((e) {
              if (xhr.status == 200) {
                print(xhr.responseText);
                final responseString = xhr.responseText;
                final sellresponse = ApiResponse<SellModel>.fromJson(
                    responseString!, (json) => SellModel.fromJson(json));
                if (sellresponse.status == "true") {
                  emit(SellCreateSuccess(sellresponse.data!));
                } else {
                  emit(SellError(sellresponse.message));
                }
              } else {
                emit(SellError(xhr.responseText!));
              }
            });
          } else {
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
            print(responseString);
            final sellresponse = ApiResponse<SellModel>.fromJson(
                responseString, (json) => SellModel.fromJson(json));
            sellresponse.status == "true"
                ? emit(SellCreateSuccess(sellresponse.data!))
                : emit(SellError(sellresponse.message));
          }
        } catch (e) {
          print('Api Fetch Error on sell $e');
          emit(SellError(e.toString()));
        }
      },
    );
  }
}
