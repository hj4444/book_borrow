import 'package:common_utils/common_utils.dart';

class LoginReq {
  String name;
  String password;

  LoginReq(this.name, this.password);

  LoginReq.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        password = json['password'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'password': password,
      };

  @override
  String toString() {
    return '{' +
        " \"name\":\"" +
        name +
        "\"" +
        ", \"password\":\"" +
        password +
        "\"" +
        '}';
  }
}

class RegisterReq {
  String name;
  String password;
  String actualName;

  RegisterReq(this.name, this.password, this.actualName);

  RegisterReq.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        password = json['password'],
        actualName = json['actualName'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'password': password,
        'actualName': actualName,
      };

  @override
  String toString() {
    return '{' +
        " \"name\":\"" +
        name +
        "\"" +
        ", \"password\":\"" +
        password +
        "\"" +
        ", \"actualName\":\"" +
        actualName +
        "\"" +
        '}';
  }
}

class UserModel {
  String icon;
  int id;
  String name;
  String password;

  UserModel.fromJson(Map<String, dynamic> json)
      : icon = json['icon'],
        id = json['id'],
        name = json['name'],
        password = json['password'];

  Map<String, dynamic> toJson() => {
        'icon': icon,
        'id': id,
        'name': name,
        'password': password,
      };

  @override
  String toString() {
    StringBuffer sb = new StringBuffer('{');
    sb.write(",\"icon\":\"$icon\"");
    sb.write(",\"id\":$id");
    sb.write(",\"name\":\"$name\"");
    sb.write(",\"password\":\"$password\"");
    sb.write('}');
    return sb.toString();
  }
}

class BookModel {
  int id;
  String name;
  String description;
  String url;
  bool isSelected;
  bool isDeleted;
  BookModel(this.id, this.name, this.description, this.url, this.isDeleted,
      this.isSelected);

  BookModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['id'],
        description = json['description'],
        isDeleted = false,
        isSelected = (json['select_status'] as int) == 1 ? true : false,
        url = json['url'];

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'id': id,
        'url': url,
      };
}

class UserBookListModel {
  List<UserBookModel> items;

  UserBookListModel({this.items});
  factory UserBookListModel.fromJson(dynamic json) {
    List<UserBookModel> list = (json as List).map((i) {
      return UserBookModel.fromJson((i));
    }).toList();
    return UserBookListModel(items: list);
  }
  List toJson(List<UserBookModel> list) {
    List jsonList = List();
    jsonList = list.map((item) => item.toJson()).toList();
    return jsonList;
  }
}

class UserBookModel {
  int bookId;
  int userId;
  String name;
  String description;
  String url;
  String beginDate;
  String endDate;
  UserBookModel(this.bookId, this.userId, this.name, this.description, this.url,
      this.beginDate, this.endDate);

  UserBookModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    bookId = json['bookId'];
    userId = json['userId'];
    description = json['description'];
    url = json['url'];
    beginDate = json['beginDate'];
    endDate = json['endDate'];
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'bookId': bookId,
        'userId': userId,
        'description': description,
        'url': url,
        'beginDate': beginDate,
        'endDate': endDate,
      };
}

class UserBorrowHistoryModel {
  String bookName;
  String beginDate;
  String endDate;
  String url;
  String borrowDate;
  UserBorrowHistoryModel(
      this.bookName, this.beginDate, this.endDate, this.url, this.borrowDate);

  UserBorrowHistoryModel.fromJson(Map<String, dynamic> json) {
    bookName = json['bookName'];
    beginDate = DateUtil.getDateStrByTimeStr(json['beginDate'],
        format: DateFormat.YEAR_MONTH_DAY);
    endDate = DateUtil.getDateStrByTimeStr(json['endDate'],
        format: DateFormat.YEAR_MONTH_DAY);
    url = json['url'];
    borrowDate = DateUtil.getDateStrByTimeStr(json['ctime'],
        format: DateFormat.YEAR_MONTH_DAY);
  }

  Map<String, dynamic> toJson() => {
        'bookName': bookName,
        'beginDate': beginDate,
        'endDate': endDate,
        'url': url,
        'borrowDate': borrowDate,
      };
}

class CommonResult {
  List data;

  CommonResult.fromJson(Map<String, dynamic> json) : data = json['data'];
}
