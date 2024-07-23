import 'dart:convert';

class ApiResponse<T> {
  final String status;
  final String message;
  final T? data;

  ApiResponse(
      {required this.status, required this.message, required this.data});

  factory ApiResponse.fromJson(
      String str, T Function(Map<String, dynamic>) create) {
    final jsonData = json.decode(str);
    return ApiResponse(
      status: jsonData['status'],
      message: jsonData['message'],
      data: jsonData['status'] != "fail" && jsonData['data'] != null
          ? create(jsonData['data'])
          : null,
    );
  }
}
