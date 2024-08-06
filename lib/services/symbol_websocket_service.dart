// WebSocket接続の管理とデータのストリーミングを担当
import 'dart:async';
import 'dart:convert';
import 'dart:io';

class SymbolWebSocketService {
  WebSocket? _webSocket;
  final StreamController<Map<String, dynamic>> _blockController =
      StreamController<Map<String, dynamic>>.broadcast();
  String? _uid;

  /// WebSocket接続を確立して新しいブロックをリスニングします
  Future<void> connect(String nodeUrl) async {
    try {
      // WebSocket接続を確立する
      _webSocket = await WebSocket.connect(nodeUrl);

      print('WebSocket connection opened.');

      _webSocket!.listen(
        (data) {
          print('Data received: $data'); // 受信データをログに出力

          final Map<String, dynamic> response = json.decode(data);
          if (response.containsKey('uid')) {
            _uid = response['uid'];
            print('UID received: $_uid');
            _subscribeToBlockChannel(); // UIDを受信した後にブロックチャネルを購読
          } else if (response.containsKey('data') &&
              response['data'].containsKey('block')) {
            _blockController.add(response['data']['block']);
          }
        },
        onDone: () {
          print('WebSocket connection closed.');
          _blockController.close();
        },
        onError: (error) {
          print('WebSocket error: $error');
        },
      );
    } catch (error) {
      print('Error connecting to WebSocket: $error');
    }
  }

  /// ブロックチャネルを購読します
  void _subscribeToBlockChannel() {
    if (_uid != null) {
      sendMessage(json.encode({'uid': _uid, 'subscribe': 'block'}));
    }
  }

  /// WebSocketを通じてメッセージを送信します
  void sendMessage(String message) {
    if (_webSocket != null && _webSocket!.readyState == WebSocket.open) {
      _webSocket!.add(message);
    } else {
      print('WebSocket is not connected.');
    }
  }

  /// 新しいブロックのストリームを取得します
  Stream<Map<String, dynamic>> get blockStream => _blockController.stream;

  /// WebSocket接続を閉じます
  void dispose() {
    _webSocket?.close();
    _blockController.close();
  }
}
