enum Environment {
  development,
  production,
}

enum Platform {
  app,
  web,
}

class AppConfig {
  static late Environment _environment;
  static late Platform _platform;
  static late String _appName;
  static late String _apiBaseUrl;
  static late String _firebaseProjectId;
  static late bool _enableAnalytics;
  static late bool _enableCrashlytics;

  // Getters
  static Environment get environment => _environment;
  static Platform get platform => _platform;
  static String get appName => _appName;
  static String get apiBaseUrl => _apiBaseUrl;
  static String get firebaseProjectId => _firebaseProjectId;
  static bool get enableAnalytics => _enableAnalytics;
  static bool get enableCrashlytics => _enableCrashlytics;
  static bool get isProduction => _environment == Environment.production;
  static bool get isDevelopment => _environment == Environment.development;
  static bool get isApp => _platform == Platform.app;
  static bool get isWeb => _platform == Platform.web;

  // Initialize configuration based on flavor
  static void initialize({
    required Environment environment,
    required Platform platform,
  }) {
    _environment = environment;
    _platform = platform;

    switch (environment) {
      case Environment.development:
        _initializeDevelopment();
        break;
      case Environment.production:
        _initializeProduction();
        break;
    }
  }

  static void _initializeDevelopment() {
    _appName = isApp ? 'GDG GUG Dev' : 'GDG GUG Dev Web';
    _apiBaseUrl = 'https://dev-api.gdggug.com';
    _firebaseProjectId = 'gdg-gug-dev';
    _enableAnalytics = false;
    _enableCrashlytics = false;
  }

  static void _initializeProduction() {
    _appName = isApp ? 'GDG Gurugram University' : 'GDG Gurugram University';
    _apiBaseUrl = 'https://api.gdggug.com';
    _firebaseProjectId = 'gdg-gug-prod';
    _enableAnalytics = true;
    _enableCrashlytics = true;
  }

  static bool get showEnvironmentBanner => isDevelopment;
  static bool get enableDebugFeatures => isDevelopment;
} 