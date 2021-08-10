import 'package:custom_pdf_view/book/model/book_detail_model.dart';
import 'package:custom_pdf_view/book/model/book_model.dart';
import 'package:vexana/vexana.dart';

abstract class IBookService {
  final INetworkManager manager;

  IBookService(this.manager);

  Future<List<BookModel>> fetchAllBooks();
  Future<List<BookDetailModel>> fetchBookDetail(String id);
}

enum _BookPaths { books, bookDetail }

extension on _BookPaths {
  String rawValue({String? id}) {
    switch (this) {
      case _BookPaths.books:
        return 'books.json';
      case _BookPaths.bookDetail:
        return 'bookdetail/$id.json';
    }
  }
}

class BookService extends IBookService {
  BookService(INetworkManager manager) : super(manager);

  @override
  Future<List<BookModel>> fetchAllBooks() async {
    final response = await manager.send<BookModel, List<BookModel>>(_BookPaths.books.rawValue(),
        parseModel: BookModel(), method: RequestType.GET);

    return response.data ?? [];
  }

  @override
  Future<List<BookDetailModel>> fetchBookDetail(String id) async {
    final response = await manager.send<BookDetailModel, List<BookDetailModel>>(_BookPaths.bookDetail.rawValue(id: id),
        parseModel: BookDetailModel(), method: RequestType.GET);
    return response.data ?? [];
  }
}
