// サービスクラスを使用してWebSocket接続を管理し、データのストリームを提供
import 'dart:async';
import '../services/symbol_websocket_service.dart';
import '../models/block.dart';

class SymbolWebSocketRepository {
  final SymbolWebSocketService _webSocketService;

  SymbolWebSocketRepository(this._webSocketService);

  /// WebSocket接続を確立し、ブロックのストリームを取得します
  Future<void> connect(String nodeUrl) async {
    await _webSocketService.connect(nodeUrl);
  }

  /// 新しいブロックのストリームを取得します
  Stream<Block> get blockStream {
    return _webSocketService.blockStream
        .map((blockData) => Block.fromJson(blockData));
  }

  /// WebSocket接続を閉じます
  void dispose() {
    _webSocketService.dispose();
  }
}
