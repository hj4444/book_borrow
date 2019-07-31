import 'package:book_shelf/api/api.dart';
import 'package:book_shelf/consts/consts.dart';
import 'package:book_shelf/model/api_code.dart';
import 'package:book_shelf/model/base_resp.dart';
import 'package:book_shelf/model/models.dart';
import 'package:book_shelf/utils/api_client_util.dart';
import 'package:flustars/flustars.dart';

class UserDao {
  static Future<UserModel> login(LoginReq req) async {
    BaseResp<Map<String, dynamic>> baseResp = await HttpManager()
        .netFetch<Map<String, dynamic>>(HttpMethod.post, Api.LOGIN,
            data: req.toJson());
    if (baseResp.errorCode != ApiCode.SUCCESS) {
      return Future.error(baseResp.errorMsg);
    }
    UserModel model = UserModel.fromJson(baseResp.data);
    SpUtil.putBool(Consts.SP_IS_LOGIN, true);
    return model;
  }

  static Future<UserModel> register(RegisterReq req) async {
    BaseResp<Map<String, dynamic>> baseResp = await HttpManager()
        .netFetch<Map<String, dynamic>>(HttpMethod.post, Api.REGISTER,
            data: req.toJson());
    if (baseResp.errorCode != ApiCode.SUCCESS) {
      return Future.error(baseResp.errorMsg);
    }
    UserModel model = UserModel.fromJson(baseResp.data);
    setUserSession(model);
    return model;
  }

  static Future<bool> isLogin() async {
    bool b = SpUtil.getBool(Consts.SP_IS_LOGIN);
    return b != null && b;
  }

  static Future<UserModel> getUserInfo() async {
    var userMap = SpUtil.getObject(Consts.USER);
    return UserModel.fromJson(userMap);
  }

  static void setUserSession(UserModel user) {
    SpUtil.putObject(Consts.USER, user);
    SpUtil.putBool(Consts.SP_IS_LOGIN, true);
  }

  static Future<int> getUserId() async {
    UserModel userModel = await getUserInfo();
    return userModel.id;
  }

  static Future<UserModel> getUserByName(String name) async {
    BaseResp<Map<String, dynamic>> baseResp = await HttpManager()
        .netFetch<Map<String, dynamic>>(
            HttpMethod.get, Api.USER_BY_PARAM + name,
            data: null);
    if (baseResp.errorCode != ApiCode.SUCCESS) {
      return Future.error(baseResp.errorMsg);
    }
    UserModel model = UserModel.fromJson(baseResp.data);
    return model;
  }
}
