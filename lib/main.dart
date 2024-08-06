import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpodをインポート
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'providers/block_provider.dart'; // プロバイダーをインポート
import 'widgets/ad_banner.dart'; // ad_banner.dartファイルをインポート
import 'widgets/radial_text_pointer.dart'; // radial_text_pointer.dartファイルをインポート

void main() {
  // Mobile Ads SDKの初期化
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const ProviderScope(child: MyApp())); // ProviderScopeでラップする
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

class RadialGaugeScreen extends ConsumerWidget {
  const RadialGaugeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // AsyncValueとしてブロックのストリームを監視
    final blocksAsyncValue = ref.watch(blockStreamProvider);

    return blocksAsyncValue.when(
      data: (blocks) => Stack(
        children: [
          // メインコンテンツ
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const RadialTextPointer(value: 82.0), // 動的な値を渡す
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: blocks.length,
                    itemBuilder: (context, index) {
                      final block = blocks[index];
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
            child: AdBanner(),
          ),
        ],
      ),
      loading: () => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('新規ブロック監視中...\nしばらくお待ちください', style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
          ],
        ),
      ), // 読み込み中の表示
      error: (error, stack) => Center(child: Text('Error: $error')), // エラー時の表示
    );
  }
}