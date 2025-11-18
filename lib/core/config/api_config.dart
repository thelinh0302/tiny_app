// API configuration constants.
// Central place to manage the backend base URL per environment.
// You can override the default via --dart-define when running the app.
//
// Example:
// flutter run --dart-define=API_BASE_URL=https://jsonplaceholder.typicode.com
// flutter run --dart-define=API_BASE_URL=https://api.myprod.com --release
class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );
}
