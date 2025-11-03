/// Custom exceptions for data layer
/// Following Single Responsibility Principle
class ServerException implements Exception {
  final String message;

  ServerException([this.message = 'Server exception occurred']);

  @override
  String toString() => message;
}

class CacheException implements Exception {
  final String message;

  CacheException([this.message = 'Cache exception occurred']);

  @override
  String toString() => message;
}

class NetworkException implements Exception {
  final String message;

  NetworkException([this.message = 'Network exception occurred']);

  @override
  String toString() => message;
}
