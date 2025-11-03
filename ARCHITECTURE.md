# Architecture Documentation

## Clean Architecture Layers

```
┌─────────────────────────────────────────────────────────────────┐
│                        Presentation Layer                        │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │                         UI (Flutter)                        │ │
│  │  • Pages (UsersPage)                                        │ │
│  │  • Widgets (UserListWidget)                                 │ │
│  └────────────────────────────────────────────────────────────┘ │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │                    State Management (BLoC)                  │ │
│  │  • UserBloc                                                 │ │
│  │  • UserEvent (GetUserEvent, GetUsersEvent)                 │ │
│  │  • UserState (Loading, Loaded, Error)                      │ │
│  └────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                              ↓ ↑
┌─────────────────────────────────────────────────────────────────┐
│                          Domain Layer                            │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │                        Use Cases                            │ │
│  │  • GetUser(userId) → Either<Failure, User>                 │ │
│  │  • GetUsers() → Either<Failure, List<User>>                │ │
│  └────────────────────────────────────────────────────────────┘ │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │                    Repository Interface                     │ │
│  │  • UserRepository (abstract)                                │ │
│  │    - getUser(userId)                                        │ │
│  │    - getUsers()                                             │ │
│  └────────────────────────────────────────────────────────────┘ │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │                         Entities                            │ │
│  │  • User (id, name, email, username)                        │ │
│  └────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                              ↓ ↑
┌─────────────────────────────────────────────────────────────────┐
│                           Data Layer                             │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │                  Repository Implementation                  │ │
│  │  • UserRepositoryImpl                                       │ │
│  │    - Converts exceptions to failures                        │ │
│  │    - Transforms models to entities                          │ │
│  └────────────────────────────────────────────────────────────┘ │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │                       Data Sources                          │ │
│  │  • UserRemoteDataSource (API)                               │ │
│  │    - HTTP requests to JSONPlaceholder API                   │ │
│  └────────────────────────────────────────────────────────────┘ │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │                          Models                             │ │
│  │  • UserModel extends User                                   │ │
│  │    - JSON serialization/deserialization                     │ │
│  └────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                              ↓ ↑
┌─────────────────────────────────────────────────────────────────┐
│                         External APIs                            │
│                    (JSONPlaceholder API)                         │
└─────────────────────────────────────────────────────────────────┘
```

## SOLID Principles Applied

### 1. Single Responsibility Principle (SRP)

Each class has one reason to change:

```dart
// ✅ GetUser - Single responsibility: Get one user
class GetUser implements UseCase<User, GetUserParams> {
  final UserRepository repository;
  
  Future<Either<Failure, User>> call(GetUserParams params) async {
    return await repository.getUser(params.userId);
  }
}

// ✅ GetUsers - Single responsibility: Get multiple users
class GetUsers implements UseCase<List<User>, NoParams> {
  final UserRepository repository;
  
  Future<Either<Failure, List<User>>> call(NoParams params) async {
    return await repository.getUsers();
  }
}
```

### 2. Open/Closed Principle (OCP)

Classes are open for extension but closed for modification:

```dart
// ✅ Base Failure class - Can extend with new failure types
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);
}

// ✅ Extending without modifying base class
class ServerFailure extends Failure { }
class NetworkFailure extends Failure { }
class CacheFailure extends Failure { }
```

### 3. Liskov Substitution Principle (LSP)

Derived classes can substitute base classes:

```dart
// ✅ UserModel extends User and can be used anywhere User is expected
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.username,
  });
  
  // Additional functionality for JSON serialization
  factory UserModel.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}
```

### 4. Interface Segregation Principle (ISP)

Interfaces are specific and focused:

```dart
// ✅ UserRepository interface with only necessary methods
abstract class UserRepository {
  Future<Either<Failure, User>> getUser(int userId);
  Future<Either<Failure, List<User>>> getUsers();
}

// ✅ Separate interface for remote operations
abstract class UserRemoteDataSource {
  Future<UserModel> getUser(int userId);
  Future<List<UserModel>> getUsers();
}
```

### 5. Dependency Inversion Principle (DIP)

High-level modules don't depend on low-level modules:

```dart
// ✅ Use case depends on abstraction (UserRepository)
class GetUser implements UseCase<User, GetUserParams> {
  final UserRepository repository; // Abstract interface
  
  GetUser(this.repository);
}

// ✅ Repository implementation depends on abstraction (UserRemoteDataSource)
class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource; // Abstract interface
  
  UserRepositoryImpl({required this.remoteDataSource});
}
```

## Dependency Flow

```
┌─────────────────────────────────────────────────────────────┐
│  Dependency Injection Container (GetIt)                     │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  registerFactory(() => UserBloc(                            │
│    getUser: sl(),      ←─────────────────┐                  │
│    getUsers: sl(),     ←────────────┐    │                  │
│  ))                                  │    │                  │
│                                      │    │                  │
│  registerLazySingleton(() => GetUser(sl()))  ←──┐          │
│  registerLazySingleton(() => GetUsers(sl())) ←──┼──┐       │
│                                      │    │      │  │       │
│  registerLazySingleton<UserRepository>(         │  │       │
│    () => UserRepositoryImpl(        │    │      │  │       │
│      remoteDataSource: sl(),  ←─────┼────┼──────┘  │       │
│    )                                 │    │         │       │
│  )                                   │    │         │       │
│                                      │    │         │       │
│  registerLazySingleton<UserRemoteDataSource>(     │       │
│    () => UserRemoteDataSourceImpl(  │    │         │       │
│      client: sl(),      ←────────────┼────┼─────────┘       │
│    )                                 │    │                  │
│  )                                   │    │                  │
│                                      │    │                  │
│  registerLazySingleton(() => http.Client())                 │
│                                      └────┴──────────────────┘
└─────────────────────────────────────────────────────────────┘
```

## Error Handling Strategy

```
┌──────────────────────────────────────────────────────────┐
│                    Data Layer                             │
│  try {                                                    │
│    final response = await client.get(url);               │
│    return UserModel.fromJson(response);                  │
│  } catch (e) {                                            │
│    throw ServerException('Error message');  ────┐        │
│  }                                                │        │
└───────────────────────────────────────────────────┼────────┘
                                                    │
                                                    ↓
┌──────────────────────────────────────────────────────────┐
│               Repository Implementation                   │
│  try {                                                    │
│    final model = await remoteDataSource.getUser(id);     │
│    return Right(model.toEntity());                       │
│  } on ServerException catch (e) {  ←──────────────┐      │
│    return Left(ServerFailure(e.message)); ────┐   │      │
│  }                                              │   │      │
└─────────────────────────────────────────────────┼───┼──────┘
                                                  │   │
                                                  ↓   ↓
┌──────────────────────────────────────────────────────────┐
│                      Use Case                             │
│  final result = await repository.getUser(userId);        │
│  return result; // Either<Failure, User>  ←──────────────┤
└──────────────────────────────────────────────────────────┘
                                                  │
                                                  ↓
┌──────────────────────────────────────────────────────────┐
│                        BLoC                               │
│  result.fold(                                             │
│    (failure) => emit(UserError(message: failure.message)),│
│    (user) => emit(UserLoaded(user: user)),               │
│  );                                                       │
└──────────────────────────────────────────────────────────┘
```

## State Management Flow (BLoC)

```
┌──────────────────────────────────────────────────────────┐
│                        UI Layer                           │
│                                                           │
│  User taps button                                         │
│       │                                                   │
│       ↓                                                   │
│  context.read<UserBloc>().add(GetUsersEvent())          │
└───────────────────────────────┬──────────────────────────┘
                                │
                                ↓
┌──────────────────────────────────────────────────────────┐
│                      UserBloc                             │
│                                                           │
│  on<GetUsersEvent>((event, emit) async {                │
│    emit(UsersLoading());          ────────────┐          │
│    final result = await getUsers(NoParams()); │          │
│    result.fold(                                │          │
│      (failure) => emit(UsersError(...)),      │          │
│      (users) => emit(UsersLoaded(...)),       │          │
│    );                                          │          │
│  });                                           │          │
└────────────────────────────────────────────────┼──────────┘
                                                 │
                                                 ↓
┌──────────────────────────────────────────────────────────┐
│                        UI Layer                           │
│                                                           │
│  BlocBuilder<UserBloc, UserState>(                       │
│    builder: (context, state) {                           │
│      if (state is UsersLoading) {  ←──────────┤          │
│        return CircularProgressIndicator();               │
│      } else if (state is UsersLoaded) {                  │
│        return UserListWidget(users: state.users);        │
│      } else if (state is UsersError) {                   │
│        return ErrorWidget(state.message);                │
│      }                                                    │
│    },                                                     │
│  )                                                        │
└──────────────────────────────────────────────────────────┘
```

## Testing Strategy

### Unit Tests
```dart
// Domain Layer - Test Use Cases
test('should get user from repository', () async {
  // Arrange
  when(mockRepository.getUser(any))
      .thenAnswer((_) async => Right(tUser));
  
  // Act
  final result = await useCase(GetUserParams(userId: 1));
  
  // Assert
  expect(result, Right(tUser));
  verify(mockRepository.getUser(1));
});

// Data Layer - Test Repository
test('should return user when remote call is successful', () async {
  // Arrange
  when(mockRemoteDataSource.getUser(any))
      .thenAnswer((_) async => tUserModel);
  
  // Act
  final result = await repository.getUser(1);
  
  // Assert
  expect(result, Right(tUser));
});
```

### Widget Tests
```dart
testWidgets('should show user list when loaded', (tester) async {
  // Arrange
  when(mockGetUsers(any))
      .thenAnswer((_) async => Right(tUserList));
  
  // Act
  await tester.pumpWidget(makeTestableWidget(UsersPage()));
  await tester.pumpAndSettle();
  
  // Assert
  expect(find.byType(UserListWidget), findsOneWidget);
});
```

### BLoC Tests
```dart
blocTest<UserBloc, UserState>(
  'emits [UsersLoading, UsersLoaded] when GetUsersEvent is added',
  build: () {
    when(mockGetUsers(any))
        .thenAnswer((_) async => Right(tUserList));
    return userBloc;
  },
  act: (bloc) => bloc.add(GetUsersEvent()),
  expect: () => [
    UsersLoading(),
    UsersLoaded(users: tUserList),
  ],
);
```

## Benefits of This Architecture

1. **Testability**: Each layer can be tested independently
2. **Maintainability**: Changes in one layer don't affect others
3. **Scalability**: Easy to add new features following the same pattern
4. **Flexibility**: Can swap implementations (e.g., API → Local DB)
5. **Reusability**: Use cases and entities can be reused across features
6. **Clean Code**: Clear separation of concerns
7. **Type Safety**: Compile-time error detection
8. **Predictability**: Consistent patterns across the codebase
