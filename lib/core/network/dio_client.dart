import 'package:dio/dio.dart';

import '../config/api_config.dart';
import '../services/token_storage.dart';

/// Dio client configuration
/// Centralized HTTP client setup following Single Responsibility Principle
class DioClient {
  final Dio dio;
  final TokenStorage? tokenStorage;

  DioClient({Dio? dio, this.tokenStorage})
    : dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: ApiConfig.baseUrl,
              connectTimeout: const Duration(seconds: 30),
              receiveTimeout: const Duration(seconds: 30),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
            ),
          ) {
    _initializeInterceptors();
  }

  void _initializeInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          print(tokenStorage);
          // Attach Authorization header if we have an access token
          if (tokenStorage != null) {
            final accessToken = await tokenStorage!.getAccessToken();

            if (accessToken != null && accessToken.isNotEmpty) {
              options.headers['Authorization'] = 'Bearer $accessToken';
              print('🔑 Attached Authorization header');
            } else {
              print(
                '⚠️ No access token found; Authorization header not attached',
              );
            }
          }

          // Log request
          print('🚀 REQUEST[${options.method}] => ${options.uri}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Log response
          print(
            '✅ RESPONSE[${response.statusCode}] => ${response.requestOptions.uri}',
          );
          return handler.next(response);
        },
        onError: (error, handler) {
          // Log error
          print(
            '❌ ERROR[${error.response?.statusCode}] => ${error.requestOptions.uri}',
          );
          return handler.next(error);
        },
      ),
    );
  }

  // GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await dio.get(
      path,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // POST request
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // PUT request
  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  // DELETE request
  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    return await dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }
}
