import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import './pages/home_page.dart';
import './share_preferences_instance.dart';
import './providers/theme_mode_provider.dart';
import './config/config.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesInstance.initialize();

  // Mobile Ads SDKの初期化
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
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

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
