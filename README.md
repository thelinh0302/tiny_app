# Flutter Clean Architecture + SOLID Principles

A Flutter application demonstrating Clean Architecture principles combined with SOLID design patterns.

## 📐 Architecture Overview

This project follows Clean Architecture principles with three main layers:

### 1. **Domain Layer** (Business Logic)
The innermost layer containing business entities, repository interfaces, and use cases.

```
lib/features/user/domain/
├── entities/
│   └── user.dart                 # Pure Dart business entity
├── repositories/
│   └── user_repository.dart      # Repository contract (interface)
└── usecases/
    ├── get_user.dart             # Single responsibility use case
    └── get_users.dart            # Single responsibility use case
```

**Key Principles:**
- **Independent of frameworks** - No Flutter dependencies
- **Testable** - Pure Dart code, easy to unit test
- **Repository Pattern** - Defines contracts without implementation details

### 2. **Data Layer** (Data Management)
Implements the repository interfaces, handles data sources, and manages data transformations.

```
lib/features/user/data/
├── models/
│   ├── user_model.dart           # Data model with JSON serialization
│   └── user_model.g.dart         # Generated JSON serialization code
├── datasources/
│   └── user_remote_data_source.dart  # API communication
└── repositories/
    └── user_repository_impl.dart     # Repository implementation
```

**Key Principles:**
- **Data Models** extend Domain Entities adding serialization
- **Data Sources** handle external communication (API, Database, Cache)
- **Repository Implementation** converts exceptions to failures

### 3. **Presentation Layer** (UI)
Contains all UI-related code including BLoC for state management, pages, and widgets.

```
lib/features/user/presentation/
├── bloc/
│   ├── user_bloc.dart           # Business Logic Component
│   ├── user_event.dart          # Events
│   └── user_state.dart          # States
├── pages/
│   └── users_page.dart          # Screen/Page
└── widgets/
    └── user_list_widget.dart    # Reusable widget
```

**Key Principles:**
- **BLoC Pattern** for state management
- **Separation of concerns** - UI separated from business logic
- **Reactive programming** with streams

## 🎯 SOLID Principles Implementation

### **S** - Single Responsibility Principle
Each class has one responsibility:
- `GetUser` use case: Only gets a single user
- `GetUsers` use case: Only gets multiple users
- `UserRemoteDataSource`: Only handles remote data operations
- `UserRepository`: Only manages user data access

### **O** - Open/Closed Principle
- Use cases are open for extension (create new use cases) but closed for modification
- Repository interfaces define contracts that can have multiple implementations

### **L** - Liskov Substitution Principle
- `UserModel` extends `User` entity and can be used wherever `User` is expected
- All failures extend base `Failure` class

### **I** - Interface Segregation Principle
- `UserRepository` interface defines only necessary methods
- `UserRemoteDataSource` interface is specific to remote operations
- Use cases implement `UseCase<Type, Params>` interface

### **D** - Dependency Inversion Principle
- High-level modules (use cases) don't depend on low-level modules (data sources)
- Both depend on abstractions (repository interfaces)
- Dependency injection with GetIt

## 📦 Core Architecture Components

### Error Handling
```
lib/core/error/
├── exceptions.dart    # Data layer exceptions
└── failures.dart      # Domain layer failures
```

- **Exceptions**: Used in data layer (technical errors)
- **Failures**: Used in domain layer (business errors)
- **Either<Failure, Success>**: Functional error handling with Dartz

### Use Cases
```
lib/core/usecases/
└── usecase.dart       # Base use case interface
```

All use cases implement this interface ensuring consistency.

### Dependency Injection
```
lib/injection_container.dart
```

Centralized dependency injection using GetIt:
- `registerFactory()`: Creates new instance each time
- `registerLazySingleton()`: Creates instance on first use, reuses it

## 🛠️ Technologies Used

| Technology | Purpose |
|------------|---------|
| **flutter_bloc** | State management |
| **equatable** | Value equality comparison |
| **dartz** | Functional programming (Either, Option) |
| **get_it** | Dependency injection |
| **http** | HTTP client |
| **json_annotation** | JSON serialization annotations |
| **build_runner** | Code generation |
| **json_serializable** | JSON serialization code generation |
| **mockito** | Testing mocks |

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.7.0 or higher)
- Dart SDK
- IDE (VS Code, Android Studio, or IntelliJ)

### Installation

1. **Clone the repository**
```bash
git clone <repository-url>
cd finly_app
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Generate code** (if needed)
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. **Run the app**
```bash
flutter run
```

## 📱 Features

- ✅ Fetch and display list of users from API
- ✅ Clean Architecture implementation
- ✅ SOLID principles adherence
- ✅ BLoC pattern for state management
- ✅ Dependency injection
- ✅ Error handling
- ✅ Loading states
- ✅ Retry mechanism

## 🏗️ Project Structure

```
lib/
├── core/                          # Core utilities
│   ├── error/                     # Error handling
│   └── usecases/                  # Base use case
├── features/                      # Feature modules
│   └── user/                      # User feature
│       ├── data/                  # Data layer
│       ├── domain/                # Domain layer
│       └── presentation/          # Presentation layer
├── injection_container.dart       # Dependency injection setup
└── main.dart                      # App entry point
```

## 🧪 Testing

The architecture makes testing easy:

### Unit Tests
```dart
// Test use cases with mock repositories
test('should get user from repository', () async {
  when(mockRepository.getUser(any))
      .thenAnswer((_) async => Right(tUser));
  
  final result = await useCase(GetUserParams(userId: 1));
  
  expect(result, Right(tUser));
});
```

### Widget Tests
```dart
// Test BLoC with mock use cases
testWidgets('should show user list when loaded', (tester) async {
  when(mockGetUsers(any))
      .thenAnswer((_) async => Right(tUserList));
  
  await tester.pumpWidget(UsersPage());
  await tester.pumpAndSettle();
  
  expect(find.byType(UserListWidget), findsOneWidget);
});
```

## 📝 Adding New Features

Follow these steps to add a new feature:

1. **Create feature folder structure**
```
lib/features/new_feature/
├── data/
├── domain/
└── presentation/
```

2. **Domain Layer** - Define entities, repository interface, and use cases

3. **Data Layer** - Create models, data sources, and repository implementation

4. **Presentation Layer** - Create BLoC, pages, and widgets

5. **Dependency Injection** - Register dependencies in `injection_container.dart`

## 🔄 Data Flow

```
User Interaction → BLoC Event → Use Case → Repository Interface
                                                    ↓
                                          Repository Implementation
                                                    ↓
                                              Data Source
                                                    ↓
                                            External API/Database
                                                    ↓
                                              Data Source
                                                    ↓
                                          Repository Implementation
                                                    ↓
User Interface ← BLoC State ← Use Case ← Repository Interface
```

## 🎨 Key Architectural Decisions

1. **Separation of Concerns**: Each layer has distinct responsibilities
2. **Dependency Rule**: Dependencies point inward (Presentation → Domain ← Data)
3. **Abstraction**: Use interfaces for loose coupling
4. **Immutability**: Use `const` constructors and final fields
5. **Error Handling**: Use `Either<Failure, Success>` for explicit error handling
6. **State Management**: BLoC pattern for predictable state changes

## 📚 Learning Resources

- [Clean Architecture by Robert C. Martin](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [SOLID Principles](https://en.wikipedia.org/wiki/SOLID)
- [Flutter BLoC Documentation](https://bloclibrary.dev/)
- [Reso Coder's Flutter Clean Architecture Tutorial](https://resocoder.com/flutter-clean-architecture-tdd/)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## 📄 License

This project is for educational purposes.

## 👨‍💻 Author

Created to demonstrate Clean Architecture and SOLID principles in Flutter.

---

**Note**: This example uses [JSONPlaceholder](https://jsonplaceholder.typicode.com/) as a fake REST API for demonstration purposes.
