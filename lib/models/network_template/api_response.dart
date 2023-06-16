import 'package:dio/dio.dart';

class ApiResponse {
  bool? isSuccess;
  dynamic data;
  ErrorResponse? error;
  int? statusCode;

  ApiResponse(
      {required this.data,
      required this.isSuccess,
      this.error,
      this.statusCode});
}

class ErrorResponse implements Exception {
  bool? isInternetError;
  int? statusCode;
  String? errorCode;
  String? message;
  Response<dynamic>? data;

  ErrorResponse(
      {this.isInternetError,
      required this.statusCode,
      required this.errorCode,
      required this.message,
      this.data}) {
    // if (isInternetError == null) {
    //   isInternetError = false;
    // }
  }
}
