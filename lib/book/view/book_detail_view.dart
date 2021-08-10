import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:vexana/vexana.dart';

import '../../product/cache/cache_manager.dart';
import '../../product/project_constant.dart';
import '../model/book_detail_model.dart';
import '../service/book_service.dart';

class BookViewDetail extends StatefulWidget {
  const BookViewDetail({Key? key, required this.service, required this.id}) : super(key: key);
  final String id;
  final IBookService service;

  @override
  _BookViewDetailState createState() => _BookViewDetailState();
}

class _BookViewDetailState extends State<BookViewDetail> {
  late Future<List<BookDetailModel>> futureAllItems;
  final PageController _controller = PageController();
  late final ICacheManager cacheManager;
  List<BookDetailModel> bookDetails = [];
  @override
  void initState() {
    super.initState();
    futureAllItems = widget.service.fetchBookDetail(widget.id);
    cacheManager = CacheManager(NetworkManager(options: BaseOptions()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.download),
        onPressed: () async {
          await cacheManager.createDocumentsPath(ProjectConstat.instance.key);
          await cacheManager.writeBookDetailInCache(widget.id, bookDetails);

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('ok')));
        },
      ),
      body: futureAllItems.toBuild<List<BookDetailModel>>(
          onSuccess: (data) {
            if (data != null) {
              bookDetails = data;
              return Column(
                children: [Expanded(child: buildBody(data)), buildBottomPreview(context, data)],
              );
            }

            return FlutterLogo();
          },
          loadingWidget: CircularProgressIndicator(),
          notFoundWidget: FlutterLogo(),
          onError: FlutterLogo()),
    );
  }

  PageView buildBody(List<BookDetailModel> data) {
    return PageView.builder(
      itemCount: data.length,
      controller: _controller,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Expanded(
              child: buildImage(data, index),
            ),
            Text('$index')
          ],
        );
      },
    );
  }

  SafeArea buildBottomPreview(BuildContext context, List<BookDetailModel> data) {
    return SafeArea(
      child: SizedBox(
        height: context.dynamicHeight(0.2),
        child: ListView.builder(
          itemCount: data.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                _controller.jumpToPage(index);
              },
              child: Card(
                child: SizedBox(
                  width: context.dynamicHeight(0.2),
                  child: buildImage(data, index),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  CachedNetworkImage buildImage(List<BookDetailModel> data, int index) {
    return CachedNetworkImage(
      imageUrl: data[index].url ?? '',
      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
