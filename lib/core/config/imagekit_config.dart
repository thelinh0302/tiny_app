// ImageKit API configuration.
//
// This follows the same pattern as ApiConfig and lets you inject
// your ImageKit base URL and Basic Auth credentials via --dart-define
// so you don't hard-code secrets in the source.
//
// Example:
// flutter run \
//   --dart-define=IMAGEKIT_BASE_URL=https://api.imagekit.io/v1 \
//   --dart-define=IMAGEKIT_USERNAME=your_private_key \
//   --dart-define=IMAGEKIT_PASSWORD=

class ImageKitConfig {
  static const String baseUrl = String.fromEnvironment(
    'IMAGEKIT_BASE_URL',
    defaultValue: 'https://api.imagekit.io/v1',
  );

  // For ImageKit, username is typically the private API key.
  static const String username = String.fromEnvironment(
    'IMAGEKIT_USERNAME',
    defaultValue: 'private_e5uuY1lZVlkDq/Eq5hatXaJW/b8=',
  );

  // Often empty string for ImageKit basic auth, but configurable.
  static const String password = String.fromEnvironment('IMAGEKIT_PASSWORD');
}
