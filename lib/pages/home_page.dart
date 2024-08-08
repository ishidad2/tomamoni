import 'package:flutter/material.dart';
import '../components/drawer_menu.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/block_provider.dart';
import '../providers/transaction_provider.dart';
import '../widgets/ad_banner.dart';
import '../providers/namespace_provider.dart';
import '../widgets/scrolling_tomato_namespaces.dart';
import '../widgets/tomato_pie_chart.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key, this.title = 'Tomamoni'});

  final String title;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final namespacesAsyncValue = ref.watch(namespacesProvider);
    final blocksAsyncValue = ref.watch(blockStreamProvider);
    final transactionsAsyncValue = ref.watch(transactionProvider);

    // サンプルデータ
    Map<String, int> tomatoData = {
      'Cherry Tomato': 35,
      'Roma Tomato': 40,
      'Beefsteak Tomato': 25,
      'Heirloom Tomato': 30,
    };

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: DrawerMenu(scaffoldKey: _scaffoldKey),
      body: namespacesAsyncValue.when(
        data: (namespaces) => Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ScrollingTomatoNamespaces(namespaces: namespaces),
                  const SizedBox(height: 20),
                  // const RadialTextPointer(value: 82.0),
                  TomatoPieChart(tomatoData: tomatoData),
                  const SizedBox(height: 20),
                  Expanded(
                    child: blocksAsyncValue.when(
                      data: (blocks) => ListView.builder(
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
                                            title: Text(
                                                'Transaction ID: ${tx.id}'),
                                            subtitle: Text(
                                                'Type: ${tx.transaction.type}'),
                                          ))
                                      .toList(),
                                ),
                                loading: () =>
                                    const CircularProgressIndicator(),
                                error: (error, stack) => Text('Error: $error'),
                              ),
                            ],
                          );
                        },
                      ),
                      loading: () => const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text('新規ブロック読み込み中...\nしばらくお待ちください',
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                      error: (error, stack) =>
                          Center(child: Text('Error: $error')),
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
              Text('ネームスペース読み込み中...\nしばらくお待ちください',
                  style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
            ],
          ),
        ),
        error: (error, stack) => Center(child: Text('Namespace Error: $error')),
      ),
    );
  }
}
