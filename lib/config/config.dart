// lib/config/config.dart

enum Environment { development, staging, production }

class AppConfig {
  static Environment _environment = Environment.development;

  static void setEnvironment(Environment env) {
    _environment = env;
  }

  static String get symbolNodeUrl {
    switch (_environment) {
      case Environment.development:
        return 'wss://001-sai-dual.symboltest.net:3001/ws';
      case Environment.staging:
        return 'wss://001-sai-dual.symboltest.net:3001/ws';
      case Environment.production:
        return 'wss://dual-1.nodes-xym.work:3001/ws';
    }
  }

  static String get symbolRestGatewayUrl {
    switch (_environment) {
      case Environment.development:
        return 'https://d001-sai-dual.symboltest.net:3001';
      case Environment.staging:
        return 'https://001-sai-dual.symboltest.net:3001';
      case Environment.production:
        return 'https://dual-1.nodes-xym.work:3001';
    }
  }

  // 他の設定も同様に追加できます
  static String get appName {
    switch (_environment) {
      case Environment.development:
        return 'Tomamoni Dev';
      case Environment.staging:
        return 'Tomamoni Staging';
      case Environment.production:
        return 'Tomamoni';
    }
  }
}
