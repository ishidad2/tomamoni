// providers/block_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'transaction_provider.dart';
import '../models/block.dart';
import '../repositories/symbol_websocket_repository.dart';
import '../services/symbol_websocket_service.dart';
import '../providers/node_config_provider.dart';

// SymbolWebSocketServiceのインスタンスを提供するプロバイダー
final symbolWebSocketServiceProvider = Provider<SymbolWebSocketService>((ref) {
  final nodeConfig = ref.watch(nodeConfigProvider);
  return SymbolWebSocketService(nodeConfig);
});

// SymbolWebSocketRepositoryのインスタンスを提供するプロバイダー
final symbolWebSocketRepositoryProvider =
    Provider<SymbolWebSocketRepository>((ref) {
  final service = ref.watch(symbolWebSocketServiceProvider);
  return SymbolWebSocketRepository(service);
});

// ブロックのストリームを監視するプロバイダー
final blockStreamProvider = StreamProvider<List<Block>>((ref) async* {
  final repository = ref.watch(symbolWebSocketRepositoryProvider);

  await repository.connect();

  List<Block> blocks = [];

  await for (final block in repository.blockStream) {
    blocks = [block, ...blocks];
    // 新しいブロックのトランザクションを取得
    ref
        .read(transactionProvider.notifier)
        .fetchTransactionsForBlock(block.height.toString());
    yield blocks;
  }
});
