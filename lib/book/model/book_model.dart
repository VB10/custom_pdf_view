import 'package:vexana/vexana.dart';

class BookModel extends INetworkModel<BookModel> {
  String? id;
  String? name;
  int? pageCount;
  String? thumbnrailImage;

  String? expiryDate;

  BookModel({this.id, this.name, this.pageCount, this.thumbnrailImage});

  BookModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    pageCount = json['pageCount'];
    thumbnrailImage = json['thumbnrailImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['pageCount'] = this.pageCount;
    data['thumbnrailImage'] = this.thumbnrailImage;
    return data;
  }

  @override
  BookModel fromJson(Map<String, dynamic> json) {
    return BookModel.fromJson(json);
  }
}
