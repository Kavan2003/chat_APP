import 'dart:convert';

class ApiResponse<T> {
  final String status;
  final dynamic message;
  final T? data;

  ApiResponse(
      {required this.status, required this.message, required this.data});

  factory ApiResponse.fromJson(String str, T Function(dynamic) create) {
    //check if response is in json format or XMLError
    if (str.startsWith("<")) {
      return ApiResponse(
        status: "fail",
        message: "XML Error",
        data: null,
      );
    }

    final jsonData = json.decode(str);

    return ApiResponse(
      status: jsonData['status'].toString(),
      message: jsonData['message'] is List
          ? (jsonData['message'] as List).join(", ")
          : jsonData['message'],
      data: jsonData['status'] != "fail" && jsonData['data'] != null
          ? create(jsonData['data'])
          : null,
    );
  }
}
