import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/config.dart';
import '../providers/node_config_provider.dart';

final symbolWebSocketServiceProvider = Provider<SymbolWebSocketService>((ref) {
  final nodeConfig = ref.watch(nodeConfigProvider);
  return SymbolWebSocketService(nodeConfig);
});

class SymbolWebSocketService {
  WebSocket? _webSocket;
  final StreamController<Map<String, dynamic>> _blockController =
      StreamController<Map<String, dynamic>>.broadcast();
  String? _uid;
  final NodeConfig nodeConfig;

  SymbolWebSocketService(this.nodeConfig);

  Future<void> connect() async {
    try {
      _webSocket = await WebSocket.connect(nodeConfig.websocket);

      print('WebSocket connection opened.');

      _webSocket!.listen(
        (data) {
          print('Data received: $data');

          final Map<String, dynamic> response = json.decode(data);
          if (response.containsKey('uid')) {
            _uid = response['uid'];
            print('UID received: $_uid');
            _subscribeToBlockChannel();
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

  void _subscribeToBlockChannel() {
    if (_uid != null) {
      sendMessage(json.encode({'uid': _uid, 'subscribe': 'block'}));
    }
  }

  void sendMessage(String message) {
    if (_webSocket != null && _webSocket!.readyState == WebSocket.open) {
      _webSocket!.add(message);
    } else {
      print('WebSocket is not connected.');
    }
  }

  Stream<Map<String, dynamic>> get blockStream => _blockController.stream;

  void dispose() {
    _webSocket?.close();
    _blockController.close();
  }
}
