class AppConstants {
  // API Configuration
  static const String baseUrl = 'http://localhost:3000/api';
  static const String apiVersion = 'v1';
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Storage Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
  static const String userEmailKey = 'user_email';
  static const String themeMode = 'theme_mode';
  static const String languageCode = 'language_code';

  // Map Configuration
  static const double defaultZoom = 15.0;
  static const double defaultLatitude = 48.8566;
  static const double defaultLongitude = 2.3522;

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int minPhoneLength = 10;
  static const int maxPhoneLength = 15;

  // File Upload
  static const int maxImageSizeMB = 10;
  static const List<String> allowedImageExtensions = ['jpg', 'jpeg', 'png', 'webp'];

  // Date Formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';

  // App Info
  static const String appName = 'ParkShare';
  static const String appVersion = '1.0.0';
  static const String supportEmail = 'support@parkshare.com';
  static const String privacyPolicyUrl = 'https://parkshare.com/privacy';
  static const String termsOfServiceUrl = 'https://parkshare.com/terms';
}
