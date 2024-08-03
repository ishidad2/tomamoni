import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'models/block.dart';
import 'repositories/symbol_websocket_repository.dart';
import 'widgets/ad_banner.dart'; // ad_banner.dartファイルをインポート
import 'widgets/radial_text_pointer.dart'; // radial_text_pointer.dartファイルをインポート

void main() {
  // Mobile Ads SDKの初期化
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tomamoni',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Tomamoni App'),
        ),
        body: const RadialGaugeScreen(),
      ),
    );
  }
}

class RadialGaugeScreen extends StatefulWidget {
  const RadialGaugeScreen({super.key});

  @override
  _RadialGaugeScreenState createState() => _RadialGaugeScreenState();
}

class _RadialGaugeScreenState extends State<RadialGaugeScreen> {
  final SymbolWebSocketRepository _webSocketRepository = SymbolWebSocketRepository();
  final TextEditingController _controller = TextEditingController();
  final List<Block> _blocks = [];
  double _gaugeValue = 82.0;

  @override
  void initState() {
    super.initState();
    _connectToWebSocket();
  }

  /// WebSocketに接続し、新しいブロックをリスニングする
  void _connectToWebSocket() {
    _webSocketRepository.connect('ws://dual-1.nodes-xym.work:3000');
    _webSocketRepository.blockStream.listen((data) {
      // JSONデータをBlockオブジェクトに変換
      final blockData = data['data']['block'];
      final block = Block.fromJson(blockData);

      setState(() {
        _blocks.add(block);
      });
    });
  }

  @override
  void dispose() {
    _webSocketRepository.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      _webSocketRepository.sendMessage(_controller.text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // メインコンテンツ
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              RadialTextPointer(value: _gaugeValue), // 動的な値を渡す
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _blocks.length,
                  itemBuilder: (context, index) {
                    final block = _blocks[index];
                    return ListTile(
                      title: Text('Block Height: ${block.height}'),
                      subtitle: Text(
                        'Hash: ${block.previousBlockHash}\nTimestamp: ${block.timestamp}',
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        // 底部にバナー広告を固定
        const Align(
          alignment: Alignment.bottomCenter,
          child: AdBanner(), // AdBannerを表示
        ),
      ],
    );
  }
}