import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:vexana/vexana.dart';

import '../../product/project_constant.dart';
import '../model/book_model.dart';
import '../service/book_service.dart';
import 'book_cache_items.dart';
import 'book_detail_view.dart';

class BookView extends StatefulWidget {
  BookView({Key? key}) : super(key: key) {
    bookService = BookService(
        NetworkManager(options: BaseOptions(baseUrl: ProjectConstat.instance.baseUrl), isEnableLogger: true));
  }
  late final IBookService bookService;

  @override
  _BookViewState createState() => _BookViewState();
}

class _BookViewState extends State<BookView> {
  late Future<List<BookModel>> futureAllItems;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureAllItems = widget.bookService.fetchAllBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.favorite),
        onPressed: () {
          context.navigateToPage(BookCacheItems());
        },
      ),
      appBar: AppBar(title: Text('Book View')),
      body: buildAllFeatures(),
    );
  }

  Widget buildAllFeatures() {
    return futureAllItems.toBuild<List<BookModel>>(
        onSuccess: (data) {
          if (data != null) return _buildAllList(data);
          return FlutterLogo();
        },
        loadingWidget: CircularProgressIndicator(),
        notFoundWidget: FlutterLogo(),
        onError: FlutterLogo());
  }

  ListView _buildAllList(List<BookModel> data) {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return InkWell(
            onTap: () {
              context.navigateToPage(BookViewDetail(service: widget.bookService, id: data[index].id ?? ''));
            },
            child: buildCardWidget(context, data[index]));
      },
    );
  }

  Card buildCardWidget(BuildContext context, BookModel data) {
    return Card(
      child: Column(
        children: [
          SizedBox(height: context.dynamicHeight(0.2), child: Image.network(data.thumbnrailImage ?? '')),
          Text(data.name ?? ''),
        ],
      ),
    );
  }
}
