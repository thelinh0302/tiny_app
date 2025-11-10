// Supabase configuration constants.
// Replace placeholders with your project's values from https://app.supabase.com
// Optionally, you can wire these to --dart-define for different environments.
class SupabaseConfig {
  // Example: https://abccompany.supabase.co
  static const String url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://vgmlntsmsrfwrlyremhz.supabase.co',
  );

  // Example: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
  static const String anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'sb_publishable_11FYglkequ72cjcWRim_aw_Mr0iejyA',
  );

  // Google OAuth client IDs for google_sign_in -> Supabase idToken login
  // Web client ID (type: Web application) used to request idToken on Android/iOS
  static const String googleWebClientId = String.fromEnvironment(
    'GOOGLE_WEB_CLIENT_ID',
    defaultValue:
        '148122859551-iibdn73f1a30cn6dhok8re6r4bt47pl3.apps.googleusercontent.com',
  );

  // iOS client ID (type: iOS) required by google_sign_in on iOS
  static const String googleIOSClientId = String.fromEnvironment(
    'GOOGLE_IOS_CLIENT_ID',
    defaultValue:
        '148122859551-8mji481iib0pqgv8e2r7p9rqj73bsbqh.apps.googleusercontent.com',
  );
}
