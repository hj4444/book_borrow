import 'dart:convert';
import 'dart:io';

import 'package:book_shelf/model/base_resp.dart';
import 'package:dio/dio.dart';

class HttpManager {
  static const CONTENT_TYPE_JSON = "application/json";
  static const CONTENT_TYPE_FORM = "application/x-www-form-urlencoded";
  String _codeKey = "errorCode";
  String _msgKey = "errorMsg";
  String _dataKey = "data";
  static final HttpManager _singleton = HttpManager._init();
  static Dio _dio;
  Options _options = getDefOptions();

  static HttpManager getInstance() {
    return _singleton;
  }

  factory HttpManager() {
    return _singleton;
  }

  HttpManager._init() {
    _dio = new Dio(_options);
  }

  void setConfig(HttpConfig config) {
    _codeKey = config.code ?? _codeKey;
    _msgKey = config.msg ?? _msgKey;
    _dataKey = config.data ?? _dataKey;
    _mergeOption(config.options);
    if (_dio != null) {
      _dio.options = _options;
    }
  }

  void _mergeOption(Options opt) {
    _options.method = opt.method ?? _options.method;
    _options.headers = (new Map.from(_options.headers))..addAll(opt.headers);
    _options.baseUrl = opt.baseUrl ?? _options.baseUrl;
    _options.connectTimeout = opt.connectTimeout ?? _options.connectTimeout;
    _options.receiveTimeout = opt.receiveTimeout ?? _options.receiveTimeout;
    _options.responseType = opt.responseType ?? _options.responseType;
    _options.data = opt.data ?? _options.data;
    _options.extra = (new Map.from(_options.extra))..addAll(opt.extra);
    _options.contentType = opt.contentType ?? _options.contentType;
    _options.validateStatus = opt.validateStatus ?? _options.validateStatus;
    _options.followRedirects = opt.followRedirects ?? _options.followRedirects;
  }

  Future<BaseResp<T>> netFetch<T>(String method, String url,
      {data, Options options, CancelToken cancelToken}) async {
    Response response = await _dio.request(url,
        data: data,
        options: _checkOptions(method, options),
        cancelToken: cancelToken);

    int _code;
    String _msg;
    T _data;
    if (response.statusCode == HttpStatus.ok ||
        response.statusCode == HttpStatus.created) {
      try {
        if (response.data is Map) {
          _code = (response.data[_codeKey] is String)
              ? int.tryParse(response.data[_codeKey])
              : response.data[_codeKey];
          _msg = response.data[_msgKey];
          _data = response.data[_dataKey];
        } else {
          Map<String, dynamic> _dataMap = _decodeData(response);
          _code = (_dataMap[_codeKey] is String)
              ? int.tryParse(_dataMap[_codeKey])
              : _dataMap[_codeKey];
          _msg = _dataMap[_msgKey];
          _data = _dataMap[_dataKey];
        }
        return new BaseResp(_code, _msg, _data);
      } catch (e) {
        return new Future.error(new DioError(
          response: response,
          message: "data parsing exception...",
          type: DioErrorType.RESPONSE,
        ));
      }
    }
    return new Future.error(new DioError(
      response: response,
      message: "statusCode: $response.statusCode, service error",
      type: DioErrorType.RESPONSE,
    ));
  }

  Map<String, dynamic> _decodeData(Response response) {
    if (response == null ||
        response.data == null ||
        response.data.toString().isEmpty) {
      return new Map();
    }
    return json.decode(response.data.toString());
  }

  Options _checkOptions(method, options) {
    if (options == null) {
      options = new Options();
    }
    options.method = method;
    return options;
  }

  static Options getDefOptions() {
    Options options = new Options();
    options.contentType = ContentType.parse(CONTENT_TYPE_JSON);
    options.responseType = ResponseType.JSON;
    options.connectTimeout = 5000;
    options.receiveTimeout = 3000;
    return options;
  }
}

class HttpConfig {
  HttpConfig({
    this.status,
    this.code,
    this.msg,
    this.data,
    this.options,
  });

  String status;
  String code;
  String msg;
  String data;
  Options options;
}

class HttpMethod {
  static final String get = "GET";
  static final String post = "POST";
  static final String put = "PUT";
  static final String head = "HEAD";
  static final String delete = "DELETE";
  static final String patch = "PATCH";
}
