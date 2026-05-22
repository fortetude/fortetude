class AppConfig {
  static const googleFormsUrl = String.fromEnvironment(
    'GOOGLE_FORMS_URL',
    defaultValue: '#', 
  );
}