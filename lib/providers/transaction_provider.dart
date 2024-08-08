import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:symbol_rest_client/api.dart';
import '../repositories/transaction_repository.dart';
import '../providers/node_config_provider.dart';

final transactionApiProvider = Provider((ref) {
  final nodeConfig = ref.watch(nodeConfigProvider);
  final apiClient = ApiClient(
    basePath: nodeConfig.host, // 動的なノード設定を使用
  );
  return TransactionRoutesApi(apiClient);
});

final transactionRepositoryProvider = Provider((ref) {
  final api = ref.watch(transactionApiProvider);
  return TransactionRepository(api);
});

final transactionProvider =
    AsyncNotifierProvider<TransactionNotifier, List<TransactionInfoDTO>>(() {
  return TransactionNotifier();
});

class TransactionNotifier extends AsyncNotifier<List<TransactionInfoDTO>> {
  @override
  Future<List<TransactionInfoDTO>> build() async {
    return [];
  }

  Future<void> fetchTransactionsForBlock(String height) async {
    state = const AsyncValue.loading();
    final repository = ref.read(transactionRepositoryProvider);
    state = await AsyncValue.guard(
        () => repository.getConfirmedTransactions(height));
  }
}
