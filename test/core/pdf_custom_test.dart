import 'dart:io';

import 'package:custom_pdf_view/book/model/book_detail_model.dart';
import 'package:custom_pdf_view/book/service/book_service.dart';
import 'package:custom_pdf_view/product/cache/cache_manager.dart';
import 'package:custom_pdf_view/product/project_constant.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:vexana/vexana.dart';

import 'mock_path.dart';

void main() {
  late IBookService bookService;
  late ICacheManager cacheManager;
  setUp(() {
    PathProviderPlatform.instance = MockPathProviderPlatform();
    bookService = BookService(
        NetworkManager(options: BaseOptions(baseUrl: ProjectConstat.instance.baseUrl), isEnableLogger: true));
    cacheManager = CacheManager(NetworkManager(options: BaseOptions()));
  });
  test('Fetch All Book Datas and Detail', () async {
    final response = await bookService.fetchAllBooks();
    final response2 = await bookService.fetchBookDetail(response.first.id ?? '');
    expect(response2, isNotNull);
  });

  test('Create Sample File', () async {
    final newPath = await cacheManager.createDocumentsPath('images');

    final file = File('${newPath.path}/a.json');
    await file.writeAsString('asdasd');
    final isOkayFile = await file.exists();
    expect(isOkayFile, true);
  });

  test('Fetch All Datas ', () async {
    final response = await bookService.fetchAllBooks();
    final response2 = await bookService.fetchBookDetail(response.first.id ?? '');
    await cacheManager.createDocumentsPath('image');
    final writeALlDataAndGet = await cacheManager.writeBookDetailInCache('${response.first.id}', response2);

    expect(writeALlDataAndGet.isNotEmpty, false);
  });
}
