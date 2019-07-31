class BaseResp<T> {
  int errorCode;

  String errorMsg;

  T data;
  BaseResp(this.errorCode, this.errorMsg, this.data);
}
