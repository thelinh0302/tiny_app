part of 'user_bloc.dart';

/// Base class for User states
abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

/// Initial state
class UserInitial extends UserState {}

/// Loading state for single user
class UserLoading extends UserState {}

/// Loaded state for single user
class UserLoaded extends UserState {
  final User user;

  const UserLoaded({required this.user});

  @override
  List<Object> get props => [user];
}

/// Error state for single user
class UserError extends UserState {
  final String message;

  const UserError({required this.message});

  @override
  List<Object> get props => [message];
}

/// Loading state for multiple users
class UsersLoading extends UserState {}

/// Loaded state for multiple users
class UsersLoaded extends UserState {
  final List<User> users;

  const UsersLoaded({required this.users});

  @override
  List<Object> get props => [users];
}

/// Error state for multiple users
class UsersError extends UserState {
  final String message;

  const UsersError({required this.message});

  @override
  List<Object> get props => [message];
}
