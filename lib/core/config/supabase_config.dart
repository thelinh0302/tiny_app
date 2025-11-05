// Supabase configuration constants.
// Replace placeholders with your project's values from https://app.supabase.com
// Optionally, you can wire these to --dart-define for different environments.
class SupabaseConfig {
  // Example: https://abccompany.supabase.co
  static const String url = String.fromEnvironment(
    'https://vgmlntsmsrfwrlyremhz.supabase.co',
    defaultValue: 'https://vgmlntsmsrfwrlyremhz.supabase.co',
  );

  // Example: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
  static const String anonKey = String.fromEnvironment(
    'sb_publishable_11FYglkequ72cjcWRim_aw_Mr0iejyA',
    defaultValue: 'sb_publishable_11FYglkequ72cjcWRim_aw_Mr0iejyA',
  );
}
