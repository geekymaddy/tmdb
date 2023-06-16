// ignore_for_file: depend_on_referenced_packages

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../../helper/config.dart';
import '../../models/network_template/api_response.dart';
import 'network_exceptions.dart';

enum RequestType { get, post, put, delete }

class NetworkProvider {
  bool isAuthorized = false;
  String? _refreshToken;
  String? _accessToken;

  final Dio _dio = Dio();

  NetworkProvider({required this.isAuthorized}) {
    _dio
      ..options.baseUrl = ConstantURL.baseUrl + ConstantURL.port
      ..options.connectTimeout = 50000 as Duration?
      ..options.receiveTimeout = 50000 as Duration?
      ..httpClientAdapter
      ..options.responseType = ResponseType.json;

    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: true,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }
  }

  Future<ApiResponse?> performCall({
    required RequestType requestType,
    required String url,
    Map<String, dynamic>? queryParameters,
    data,
  }) async {

    if (isAuthorized) {
      await _addAuthInterceptor();
    }
    late Response response;
    queryParameters = queryParameters == null || queryParameters.isEmpty
        ? {}
        : queryParameters;
    data = data == null || data.isEmpty ? {} : data;

    try {
      switch (requestType) {
        case RequestType.get:
          response = await _dio.get(url, queryParameters: queryParameters);
          break;
        case RequestType.post:
          response = await _dio.post(
            url,
            queryParameters: queryParameters,
            data: data,
          );
          break;
        case RequestType.put:
          response =
              await _dio.put(url, queryParameters: queryParameters, data: data);
          break;
        case RequestType.delete:
          response = await _dio.delete(url, queryParameters: queryParameters);
          break;
      }
    } on PlatformException catch (_) {
      return ApiResponse(
        isSuccess: false,
        statusCode: 0,
        data: null,
        error: ErrorResponse(
          statusCode: 0,
          errorCode: 'PLATFORM_EXCEPTION',
          message: 'no message',
        ),
      );
    } catch (error) {
      final errorResponse = NetworkExceptions.getDioException(error);
      return ApiResponse(isSuccess: false, data: null, error: errorResponse);
    }
    if (response.statusCode == 200) {
        return ApiResponse(isSuccess: true, data: response, error: null);

    } else if (response.statusCode == 201) {
      return ApiResponse(isSuccess: true, data: response, error: null);
    } else {
      return ApiResponse(
        isSuccess: false,
        data: null,
        error: ErrorResponse(
          statusCode: response.statusCode,
          errorCode: '',
          message: response.statusMessage,
        ),
      );
    }

  }

  Future _addAuthInterceptor() async {
    await _getValues();

    /// Invalid accesstoken for testing purpose. You can use this for checking the working of `_refresh()` function.
    /// _accessToken = 'pyJhbGciOiJSUzI1NiIsImtpZCI6IjAyMjA1QTNGQjMwQTNBRTI3M0U0REUxOTY0QjUwNThDREJEMjY5NjlSUzI1NiIsInR5cCI6ImF0K2p3dCIsIng1dCI6IkFpQmFQN01LT3VKejVONFpaTFVGak52U2FXayJ9.eyJuYmYiOjE2MjQ1NDY5NTQsImV4cCI6MTYyNDU1MDU1NCwiaXNzIjoiaHR0cHM6Ly9rMnRlc3QubGFud2FyZXNvbHV0aW9ucy5jb20vYXV0aCIsImNsaWVudF9pZCI6IksyLk1vYmlsZSIsInN1YiI6ImI5MWQ4YTUyLTAyMmQtNGE1Ni04YjI4LWM5ZmNhMGQ4ODQ1OSIsImF1dGhfdGltZSI6MTYyNDUzNTQ3MywiaWRwIjoibG9jYWwiLCJwcmVmZXJyZWRfdXNlcm5hbWUiOiJrMm1vYmlsZXVzZXJAeW9wbWFpbC5jb20iLCJGaXJzdE5hbWUiOiJrMiBtb2JpbGV1c2VyIiwiT3JnYW5pemF0aW9uSWQiOiIxM2MzMGM5OC0xNWFmLTQ3MWQtODBhMy1iNmQ2MDliODIzZjciLCJPcmdhbml6YXRpb25OYW1lIjoiV2l0dGVybiIsIlVzZXJUeXBlIjoiMCIsIkVtYWlsIjoiazJtb2JpbGV1c2VyQHlvcG1haWwuY29tIiwiSXNBZG1pbiI6IkZhbHNlIiwiRVVMQSI6IlRydWUiLCJSb2xlVHlwZSI6IkN1c3RvbSIsIkVuYWJsZVVuU2F2ZWQiOiJGYWxzZSIsIkNSb2xlSWQiOiIyZTViMGE4Zi1lY2U4LTQ3NzgtOTg3MC01M2Y1ZmJjMzA5YTAiLCJ0eiI6IlNyaSBMYW5rYSBTdGFuZGFyZCBUaW1lIiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjpbIjEiLCJTeXNBZG1pbiJd';
    _dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers.addAll({
            if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
            Headers.contentTypeHeader: Headers.jsonContentType,
          });
          return handler.next(options);
        },
        onError: (e, handler) async {
          if (e.response?.statusCode == 401 && _refreshToken != null) {
            // Update the access token
            _accessToken = null;
            final RequestOptions options = e.response!.requestOptions;
            try {
              // call function for generating access token again
              _accessToken = await _refresh();
              options.headers['Authorization'] = 'Bearer $_accessToken';
              final Response response = await _dio.fetch(options);

              return handler.resolve(response);
            } catch (error, _) {
              // Refresh token expired
              // Redirect user to login...
            }
          }
          return handler.next(e);
        },
        onResponse: (response, handler) => handler.next(response),
      ),
    );
  }

  Future<String?> _refresh() async {
    try {
      return null;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> _getValues() async {
   /* _accessToken = await PersistentStorage().getAccessToken();
    _refreshToken = await PersistentStorage().getRefreshToken();*/
  }
}
