import 'package:symbol_rest_client/api.dart';

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
      print('Error fetching transactions: $e');
      return [];
    }
  }
}
