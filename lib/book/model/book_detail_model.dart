import 'package:vexana/vexana.dart';

class BookDetailModel extends INetworkModel<BookDetailModel> {
  String? name;
  String? url;

  BookDetailModel({this.name, this.url});

  BookDetailModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['url'] = this.url;
    return data;
  }

  @override
  BookDetailModel fromJson(Map<String, dynamic> json) {
    return BookDetailModel.fromJson(json);
  }
}
