import 'dart:io';

import 'package:custom_pdf_view/book/model/book_detail_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vexana/vexana.dart';

abstract class ICacheManager {
  String? mainPath;

  ICacheManager(this.networkManager);
  Future<Directory> createDocumentsPath(String name);
  Future<List<FileSystemEntity>> writeBookDetailInCache(String name, List<BookDetailModel> items);

  final INetworkManager networkManager;
}

class CacheManager extends ICacheManager {
  CacheManager(INetworkManager networkManager) : super(networkManager);

  @override
  Future<Directory> createDocumentsPath(String name) async {
    if (mainPath != null) {
      return Directory(mainPath!);
    }
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String applicaitonPath = appDirectory.path;
    final newPath = await Directory('$applicaitonPath/$name').create();
    mainPath = newPath.path;
    return newPath;
  }

  Future<List<FileSystemEntity>> writeBookDetailInCache(String name, List<BookDetailModel> items) async {
    if (mainPath == null) {
      throw Exception('You can must be create document path');
    }
    final bookDetailDirectory = await Directory('$mainPath/$name').create();

    for (var i = 0; i < items.length; i++) {
      final file = File('${bookDetailDirectory.path}/$i.png');
      if (!await file.exists()) {
        final bytes = await networkManager.downloadFileSimple('${items[i].url}', null);
        await file.writeAsBytes(bytes.data);
      }
    }

    final allItems = await bookDetailDirectory.list().toList();
    return allItems;
  }
}
