import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_user.dart';
import '../../domain/usecases/get_users.dart';
import '../../../../core/usecases/usecase.dart';

part 'user_event.dart';
part 'user_state.dart';

/// User BLoC - Presentation layer
/// Following Single Responsibility Principle
class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUser getUser;
  final GetUsers getUsers;

  UserBloc({required this.getUser, required this.getUsers})
    : super(UserInitial()) {
    on<GetUserEvent>(_onGetUser);
    on<GetUsersEvent>(_onGetUsers);
  }

  Future<void> _onGetUser(GetUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    final result = await getUser(GetUserParams(userId: event.userId));
    result.fold(
      (failure) => emit(UserError(message: failure.message)),
      (user) => emit(UserLoaded(user: user)),
    );
  }

  Future<void> _onGetUsers(GetUsersEvent event, Emitter<UserState> emit) async {
    emit(UsersLoading());
    final result = await getUsers(NoParams());
    result.fold(
      (failure) => emit(UsersError(message: failure.message)),
      (users) => emit(UsersLoaded(users: users)),
    );
  }
}
