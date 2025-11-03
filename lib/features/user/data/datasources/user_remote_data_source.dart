import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/user_model.dart';

/// Remote data source contract
/// Following Interface Segregation Principle (SOLID)
abstract class UserRemoteDataSource {
  Future<UserModel> getUser(int userId);
  Future<List<UserModel>> getUsers();
  Future<UserModel> createUser(UserModel user);
}

/// Implementation of remote data source using Dio
/// Following Single Responsibility Principle
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final DioClient dioClient;

  UserRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<UserModel> getUser(int userId) async {
    try {
      final response = await dioClient.get('/users/$userId');

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to load user: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException('No internet connection');
      } else {
        throw ServerException(
          e.response?.statusMessage ?? 'Failed to load user',
        );
      }
    } catch (e) {
      throw ServerException('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<List<UserModel>> getUsers() async {
    try {
      final response = await dioClient.get('/users');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = response.data;
        return jsonList.map((json) => UserModel.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to load users: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException('No internet connection');
      } else {
        throw ServerException(
          e.response?.statusMessage ?? 'Failed to load users',
        );
      }
    } catch (e) {
      throw ServerException('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> createUser(UserModel user) async {
    try {
      final response = await dioClient.post('/users', data: user.toJson());

      if (response.statusCode == 201) {
        return UserModel.fromJson(response.data);
      } else {
        throw ServerException('Failed to create user: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw NetworkException('Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException('No internet connection');
      } else {
        throw ServerException(
          e.response?.statusMessage ?? 'Failed to create user',
        );
      }
    } catch (e) {
      throw ServerException('Unexpected error: ${e.toString()}');
    }
  }
}
