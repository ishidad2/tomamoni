import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/config.dart';

final nodeConfigProvider =
    StateNotifierProvider<NodeConfigNotifier, NodeConfig>((ref) {
  return NodeConfigNotifier();
});

class NodeConfigNotifier extends StateNotifier<NodeConfig> {
  NodeConfigNotifier() : super(AppConfig.nodeConfigs['mainnet']!.first);

  void updateNodeConfig(NodeConfig newConfig) {
    state = newConfig;
  }
}
