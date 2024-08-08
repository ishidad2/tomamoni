import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './pages/home_page.dart';
import './utils/share_preferences_instance.dart';
import './providers/theme_mode_provider.dart';
import './config/config.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesInstance.initialize();

  // Mobile Ads SDKの初期化
  MobileAds.instance.initialize();

  // ノード設定の読み込み
  final prefs = SharedPreferencesInstance.instance;
  final selectedNodeHost = prefs.getString('selectedNodeHost') ??
      'https://sym-main-03.opening-line.jp:3001';
  final selectedNodeWebsocket = prefs.getString('selectedNodeWebsocket') ??
      'wss://sym-main-03.opening-line.jp:3001/ws';

  runApp(
    ProviderScope(
      overrides: [
        nodeConfigProvider.overrideWithValue(NodeConfig(
            host: selectedNodeHost, websocket: selectedNodeWebsocket)),
      ],
      child: const MyApp(),
    ),
  );
}

// ノード設定のプロバイダー
final nodeConfigProvider =
    Provider<NodeConfig>((ref) => throw UnimplementedError());

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Tomamoni',
      theme: _buildTheme(Brightness.light),
      darkTheme: _buildTheme(Brightness.dark),
      themeMode: ref.watch(themeModeProvider),
      home: const HomePage(),
    );
  }
}

ThemeData _buildTheme(Brightness brightness) {
  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
  );
}
