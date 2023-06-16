import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../main.dart';
import '../../models/network_template/api_response.dart';

/// class of status codes
/// 1xx: Informational
/// 2xx: Success
/// 3xx: Redirection
/// 4xx: Client Error
/// 5xx: Server Error

class NetworkExceptions {
  static const noContent = 'No Content';
  static const badRequest = 'Bad Request Error';
  static const unAuthorized = 'Unauthorized error';
  static const forbidden = 'Forbidden error';
  static const notFound = 'Not Found error';
  static const methodNotFound = 'Method Not Allowed';
  static const internalServerError = 'Internal Server Error';
  static const badGateway = 'Bad Gateway error';
  static const serviceUnavailable = 'Service Unavailable error';
  static const gatewayTimeout = 'Gateway Timeout error';

  static const connectionTimeout = 'Connection timed out';

  static String handleResponse(int statusCode) {
    switch (statusCode) {
      case 204:
        return noContent;
      case 400:
        return badRequest;
      case 401:
        return unAuthorized;
      case 403:
        return forbidden;
      case 404:
        return notFound;
      case 405:
        return methodNotFound;
      case 500:
        return internalServerError;
      case 502:
        return badGateway;
      case 503:
        return serviceUnavailable;
      case 504:
        return gatewayTimeout;

      default:
        return 'Invalid Status Code: $statusCode';
    }
  }

  static ErrorResponse getDioException(error) {
    if (error is Exception) {
      try {
        String networkExceptions = "";
        int? statusCode;
        String? errorCode;
        Response<dynamic>? data;
        if (error is DioException ) {
          switch (error.type) {
            case DioExceptionType.connectionTimeout:
              networkExceptions = connectionTimeout;
              break;
            case DioExceptionType.sendTimeout:
              networkExceptions = 'Send timeout in connection with API server';
              break;
            case DioExceptionType.receiveTimeout:
              networkExceptions =
                  'Receive timeout in connection with API server';
              break;
            case DioExceptionType.badResponse:
              networkExceptions =
                  NetworkExceptions.handleResponse(error.response!.statusCode!);
              break;
            case DioExceptionType.cancel:
              networkExceptions = 'Request cancelled';
              break;
            case DioExceptionType.unknown:
              errorCode = 'NO_INTERNET';
              networkExceptions = 'No internet connection';
              // NoInternetView().showMyDialog();
              break;
            case DioExceptionType.badCertificate:
              networkExceptions = 'Bad certificate';
              break;
            case DioExceptionType.connectionError:
              errorCode = 'NO_INTERNET';
              networkExceptions = 'No internet connection';
              break;
          }
          statusCode = error.response?.statusCode ?? 0;
          data = error.response;
        } else if (error is SocketException) {
          errorCode = 'NO_INTERNET';
          networkExceptions = 'No internet connection';
          // NoInternetView().showMyDialog();
        } else {
          networkExceptions = 'Unexpected error occurred';
        }
        return ErrorResponse(
          errorCode: errorCode ?? '',
          data: data,
          statusCode: statusCode,
          message: networkExceptions,
        );
      } on FormatException catch (_) {
        return ErrorResponse(
          errorCode: '',
          statusCode: 0,
          message: 'Unexpected error occurred',
        );
      } catch (_) {
        return ErrorResponse(
          errorCode: '',
          statusCode: 0,
          message: 'Unexpected error occurred',
        );
      }
    } else {
      if (error.toString().contains('is not a subtype of')) {
        return ErrorResponse(
          errorCode: '',
          statusCode: 0,
          message: 'Unable to process the data',
        );
      } else {
        return ErrorResponse(
          errorCode: '',
          statusCode: 0,
          message: 'Unexpected error occurred',
        );
      }
    }
  }
}
