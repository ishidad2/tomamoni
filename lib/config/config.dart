enum Environment { development, staging, production }

class NodeConfig {
  final String host;
  final String websocket;

  NodeConfig({required this.host, required this.websocket});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NodeConfig &&
          runtimeType == other.runtimeType &&
          host == other.host &&
          websocket == other.websocket;

  @override
  int get hashCode => host.hashCode ^ websocket.hashCode;
}

class AppConfig {
  static Environment _environment = Environment.development;

  static final Map<String, List<NodeConfig>> nodeConfigs = {
    'mainnet': [
      NodeConfig(
          host: 'https://sym-main-03.opening-line.jp:3001',
          websocket: 'wss://sym-main-03.opening-line.jp:3001/ws'),
      NodeConfig(
          host: 'https://symbol-mikun.net:3001',
          websocket: 'wss://symbol-mikun.net:3001/ws'),
      // Add more mainnet nodes here
    ],
    'testnet': [
      NodeConfig(
          host: 'https://testnet1.symbol-mikun.net:3001',
          websocket: 'wss://testnet1.symbol-mikun.net:3001/ws'),
      NodeConfig(
          host: 'https://testnet2.symbol-mikun.net:3001',
          websocket: 'wss://testnet2.symbol-mikun.net:3001/ws'),
      NodeConfig(
          host: 'https://sym-test-01.opening-line.jp:3001',
          websocket: 'wss://sym-test-01.opening-line.jp:3001/ws'),
      // Add testnet nodes here
    ],
  };

  static void setEnvironment(Environment env) {
    _environment = env;
  }

  static Environment get environment => _environment;
}
