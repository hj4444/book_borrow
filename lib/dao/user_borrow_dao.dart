import 'package:book_shelf/api/api.dart';
import 'package:book_shelf/dao/user_dao.dart';
import 'package:book_shelf/model/api_code.dart';
import 'package:book_shelf/model/api_result.dart';
import 'package:book_shelf/model/base_resp.dart';
import 'package:book_shelf/model/models.dart';
import 'package:book_shelf/utils/api_client_util.dart';

class UserBorrowDao {
  static Future<ApiResult> borrow(UserBookListModel model) async {
    BaseResp<String> baseResp = await HttpManager().netFetch<String>(
        HttpMethod.post, Api.USER_BORROW,
        data: model.toJson(model.items));
    if (baseResp.errorCode != ApiCode.SUCCESS) {
      return Future.error(baseResp.errorMsg);
    }

    return new ApiResult(null, true, ApiCode.SUCCESS);
  }

  static Future<List<UserBorrowHistoryModel>> getUserBookHistoryList() async {
    int userId = await UserDao.getUserId();
    List<UserBorrowHistoryModel> bookList;
    try {
      BaseResp<List> baseResp = await HttpManager().netFetch<List>(
          HttpMethod.get, Api.USER_BORROW_HISTORY + userId.toString(),
          data: userId);
      if (baseResp.errorCode != ApiCode.SUCCESS) {
        return new Future.error(baseResp.errorMsg);
      }
      if (baseResp.data != null) {
        bookList = baseResp.data.map((value) {
          return UserBorrowHistoryModel.fromJson(value);
        }).toList();
      }
    } catch (e) {
      print(e.toString());
    }
    return bookList;
  }
}
