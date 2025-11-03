part of 'user_bloc.dart';

/// Base class for User events
abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

/// Event to get a single user
class GetUserEvent extends UserEvent {
  final int userId;

  const GetUserEvent({required this.userId});

  @override
  List<Object> get props => [userId];
}

/// Event to get all users
class GetUsersEvent extends UserEvent {
  const GetUsersEvent();
}
