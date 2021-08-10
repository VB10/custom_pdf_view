import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vexana/vexana.dart';

import '../../product/cache/cache_manager.dart';
import '../../product/project_constant.dart';

class BookCacheItems extends StatefulWidget {
  const BookCacheItems({Key? key}) : super(key: key);

  @override
  _BookCacheItemsState createState() => _BookCacheItemsState();
}

class _BookCacheItemsState extends State<BookCacheItems> {
  late final ICacheManager cacheManager;
  final String _id = '1134';

  List<String> paths = [];

  @override
  void initState() {
    super.initState();
    cacheManager = CacheManager(NetworkManager(options: BaseOptions()));
    checkAndSetItems();
  }

  Future<void> checkAndSetItems() async {
    await cacheManager.createDocumentsPath(ProjectConstat.instance.key);

    final items = await cacheManager.writeBookDetailInCache(_id, []);
    paths = items.map((e) => e.path).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PageView.builder(
        itemCount: paths.length,
        itemBuilder: (context, index) {
          return Image.file(File(paths[index]));
        },
      ),
    );
  }
}
