import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:symbol_rest_client/api.dart';
import '../config/config.dart';
import '../repositories/namespace_repository.dart';

final namespaceApiProvider = Provider<NamespaceRoutesApi>((ref) {
  final apiClient = ApiClient(basePath: AppConfig.symbolRestGatewayUrl);
  return NamespaceRoutesApi(apiClient);
});

final namespaceRepositoryProvider = Provider<NamespaceRepository>((ref) {
  final api = ref.watch(namespaceApiProvider);
  return NamespaceRepository(api);
});

final namespacesProvider = FutureProvider<List<String>>((ref) async {
  final repository = ref.watch(namespaceRepositoryProvider);
  return repository.searchNamespaces();
});
