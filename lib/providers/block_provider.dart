// providers/block_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/block.dart';
import '../repositories/symbol_websocket_repository.dart';
import '../services/symbol_websocket_service.dart';

// SymbolWebSocketServiceのインスタンスを提供するプロバイダー
final symbolWebSocketServiceProvider = Provider<SymbolWebSocketService>((ref) {
  return SymbolWebSocketService();
});

// SymbolWebSocketRepositoryのインスタンスを提供するプロバイダー
final symbolWebSocketRepositoryProvider = Provider<SymbolWebSocketRepository>((ref) {
  final service = ref.watch(symbolWebSocketServiceProvider);
  return SymbolWebSocketRepository(service);
});

// ブロックのストリームを監視するプロバイダー
final blockStreamProvider = StreamProvider<List<Block>>((ref) async* {
  final repository = ref.watch(symbolWebSocketRepositoryProvider);
  const nodeUrl = 'ws://dual-1.nodes-xym.work:3000/ws'; // ここにノードのURLを設定

  await repository.connect(nodeUrl);

  List<Block> blocks = [];

  await for (final block in repository.blockStream) {
    blocks = [block, ...blocks]; // 新しいブロックをリストに追加
    yield blocks; // 更新されたリストを供給
  }
});
