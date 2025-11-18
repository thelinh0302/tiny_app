import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Simple wrapper around [FlutterSecureStorage] for auth tokens.
///
/// Stores:
/// - accessToken
/// - refreshToken
/// - expireAt (ISO-8601 string)
class TokenStorage {
  static const _keyAccessToken = 'accessToken';
  static const _keyRefreshToken = 'refreshToken';
  static const _keyExpireAt = 'expireAt';

  final FlutterSecureStorage _storage;

  const TokenStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required String expireAt,
  }) async {
    await Future.wait([
      _storage.write(key: _keyAccessToken, value: accessToken),
      _storage.write(key: _keyRefreshToken, value: refreshToken),
      _storage.write(key: _keyExpireAt, value: expireAt),
    ]);
  }

  Future<String?> getAccessToken() => _storage.read(key: _keyAccessToken);

  Future<String?> getRefreshToken() => _storage.read(key: _keyRefreshToken);

  Future<String?> getExpireAt() => _storage.read(key: _keyExpireAt);

  Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: _keyAccessToken),
      _storage.delete(key: _keyRefreshToken),
      _storage.delete(key: _keyExpireAt),
    ]);
  }
}
