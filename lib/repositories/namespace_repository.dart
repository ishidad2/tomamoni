import 'package:symbol_rest_client/api.dart';

class NamespaceRepository {
  final NamespaceRoutesApi _namespaceApi;

  NamespaceRepository(this._namespaceApi);

  Future<List<String>> searchNamespaces() async {
    List<String> mosaicIds = [];
    int pageNumber = 1;
    const int pageSize = 100;
    const int maxPage = 20; // 適切な最大ページ数を設定

    while (true) {
      print('Fetching namespaces page $pageNumber');
      try {
        final response = await _namespaceApi.searchNamespaces(
          pageNumber: pageNumber,
          pageSize: pageSize,
          aliasType: AliasTypeEnum.number1, // モザイクエイリアス
        );
        if (response!.data.isEmpty) break;

        for (var info in response.data) {
          if (info.namespace.alias.mosaicId != null) {
            mosaicIds.add(info.namespace.alias.mosaicId!);
          }
        }

        if (pageNumber >= maxPage) break;
        pageNumber++;
      } catch (e) {
        print('Error fetching namespaces: $e');
        if (e is NoSuchMethodError) {
          print('NoSuchMethodError: ${e}');
        }
        break;
      }

      // 2秒待機
      await Future.delayed(const Duration(seconds: 2));
    }

    // モザイク名を取得
    List<String> tomatoMosaics = [];
    try {
      final mosaicNames =
          await _namespaceApi.getMosaicsNames(MosaicIds(mosaicIds: mosaicIds));

      for (var mosaic in mosaicNames?.mosaicNames ?? []) {
        if (mosaic.names.isNotEmpty) {
          String name = mosaic.names[0];
          // print('===========================');
          // print(mosaic.names);
          if (name.split('.').contains('tomato')) {
            tomatoMosaics.add(name);
          }
        }
      }
    } catch (e) {
      print('Error fetching mosaic names: $e');
    }

    print('===========================');
    print(tomatoMosaics);

    return tomatoMosaics;
  }
}
