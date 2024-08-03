import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ad_banner.dart'; // ad_banner.dartファイルをインポート

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
        body: const Stack(
          children: [
            // メインコンテンツ
            Center(
              child: Text('Hello, Tomamoni!'),
            ),
            // 底部にバナー広告を固定
            Align(
              alignment: Alignment.bottomCenter,
              child: AdBanner(),  // AdBannerを表示
            ),
          ],
        ),
      ),
    );
  }
}
