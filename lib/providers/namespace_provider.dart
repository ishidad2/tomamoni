// lib/providers/namespace_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:symbol_rest_client/api.dart';
import '../providers/node_config_provider.dart';
import '../repositories/namespace_repository.dart';
import '../utils/logger.dart';

final namespaceApiProvider = Provider<NamespaceRoutesApi>((ref) {
  final nodeConfig = ref.watch(nodeConfigProvider);
  logger.d('NamespaceRoutesApi: ${nodeConfig.host}');
  final apiClient = ApiClient(basePath: nodeConfig.host);
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
