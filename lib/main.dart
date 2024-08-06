import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpodをインポート
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'providers/block_provider.dart'; // プロバイダーをインポート
import 'providers/transaction_provider.dart';
import 'widgets/ad_banner.dart'; // ad_banner.dartファイルをインポート
import 'widgets/radial_text_pointer.dart'; // radial_text_pointer.dartファイルをインポート
import 'config/config.dart';

void main() {
  // Mobile Ads SDKの初期化
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  // 環境の切り替え設定
  const environment =
      String.fromEnvironment('ENVIRONMENT', defaultValue: 'development');
  switch (environment) {
    case 'production':
      print('+++++++++++++++++++++++++++++++');
      print('+ starting app in $environment mode +');
      print('+++++++++++++++++++++++++++++++');
      AppConfig.setEnvironment(Environment.production);
      break;
    case 'staging':
      print('==== starting app in $environment mode ====');
      AppConfig.setEnvironment(Environment.staging);
      break;
    default:
      print('==== starting app in $environment mode ====');
      AppConfig.setEnvironment(Environment.development);
  }

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
    final blocksAsyncValue = ref.watch(blockStreamProvider);
    final transactionsAsyncValue = ref.watch(transactionProvider);

    return blocksAsyncValue.when(
      data: (blocks) => Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const RadialTextPointer(value: 82.0),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: blocks.length,
                    itemBuilder: (context, index) {
                      final block = blocks[index];
                      return ExpansionTile(
                        title: Text('Block Height: ${block.height}'),
                        subtitle: Text(
                          'Hash: ${block.previousBlockHash}\nTimestamp: ${block.timestamp}',
                        ),
                        children: [
                          transactionsAsyncValue.when(
                            data: (transactions) => Column(
                              children: transactions
                                  .map((tx) => ListTile(
                                        title: Text('Transaction ID: ${tx.id}'),
                                        subtitle: Text(
                                            'Type: ${tx.transaction.type}'),
                                      ))
                                  .toList(),
                            ),
                            loading: () => const CircularProgressIndicator(),
                            error: (error, stack) => Text('Error: $error'),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
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
            Text('新規ブロック監視中...\nしばらくお待ちください',
                style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
          ],
        ),
      ),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
