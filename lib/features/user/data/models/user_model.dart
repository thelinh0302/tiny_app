import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

/// User model - Data layer
/// Extends domain entity and adds JSON serialization
/// Following Single Responsibility Principle
@JsonSerializable()
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.username,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  /// Convert domain entity to model
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      username: user.username,
    );
  }

  /// Convert model to domain entity
  User toEntity() {
    return User(id: id, name: name, email: email, username: username);
  }
}
