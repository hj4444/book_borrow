import 'package:book_shelf/api/api.dart';
import 'package:book_shelf/model/api_code.dart';
import 'package:book_shelf/model/base_resp.dart';
import 'package:book_shelf/model/models.dart';
import 'package:book_shelf/utils/api_client_util.dart';

class BookDao {
  static getBooksByPager({int page, data}) async {
    try {
      List<BookModel> bookList;
      BaseResp<List> baseResp =
          await HttpManager().netFetch<List>(HttpMethod.get, Api.BOOK_LIST);

      if (baseResp.errorCode != ApiCode.SUCCESS) {
        return new Future.error(baseResp.errorMsg);
      }
      if (baseResp.data != null) {
        bookList = baseResp.data.map((value) {
          return BookModel.fromJson(value);
        }).toList();
        return bookList;
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
