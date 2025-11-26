import 'dart:convert';

import 'package:dio/dio.dart';

import 'package:finly_app/core/config/imagekit_config.dart';
import 'package:finly_app/core/models/imagekit_file.dart';

/// Service to fetch files/icons from ImageKit using HTTP Basic Auth.
///
/// This keeps all ImageKit-specific concerns (base URL, auth header)
/// out of the UI layer and follows the same spirit as other core
/// services in the project.
class ImageKitService {
  final Dio _dio;

  ImageKitService({Dio? dio}) : _dio = dio ?? _buildDefaultDio();

  static Dio _buildDefaultDio() {
    final String username = ImageKitConfig.username;
    final String password = ImageKitConfig.password;

    // Build Basic Auth header only if username is provided.
    String? authHeader;
    if (username.isNotEmpty) {
      final credentials = '$username:$password';
      final encoded = base64Encode(utf8.encode(credentials));
      authHeader = 'Basic $encoded';
    }

    return Dio(
      BaseOptions(
        baseUrl: ImageKitConfig.baseUrl,
        headers:
            authHeader != null
                ? <String, dynamic>{'Authorization': authHeader}
                : null,
      ),
    );
  }

  /// Fetch icons under the `/finly` path, limited to 10 items.
  /// Returns only entries that have a non-empty `thumbnail` URL.
  Future<List<ImageKitFileModel>> fetchCategoryIcons() async {
    final response = await _dio.get<List<dynamic>>(
      '/files',
      queryParameters: <String, dynamic>{'path': '/finly', 'limit': 10},
    );

    final data = response.data ?? <dynamic>[];
    return data
        .whereType<Map<String, dynamic>>()
        .map(ImageKitFileModel.fromJson)
        .where((file) => file.thumbnail.isNotEmpty)
        .toList();
  }
}
