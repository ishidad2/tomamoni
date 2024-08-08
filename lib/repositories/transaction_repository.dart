import 'package:symbol_rest_client/api.dart';
import '../utils/logger.dart';

class TransactionRepository {
  final TransactionRoutesApi _transactionApi;

  TransactionRepository(this._transactionApi);

  Future<List<TransactionInfoDTO>> getConfirmedTransactions(
      String height) async {
    try {
      final response =
          await _transactionApi.searchConfirmedTransactions(height: height);
      return response?.data ?? [];
    } catch (e) {
      logger.e('Error fetching transactions: $e');
      return [];
    }
  }
}
