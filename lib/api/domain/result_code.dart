
enum ResultCode {
  OK,

  MATCH_NOT_EXISTS,
  FIELD_NOT_EXISTS,

  INVALID_DATA,
  UNKOWN, SOCIAL_LOGIN_FAILD, REGISTER;

  static ResultCode valueOf(String errorCode) {
    List<ResultCode> errorCodes = ResultCode.values;

    for (var error in errorCodes) {
      if (error.name == errorCode) return error;
    }
    return ResultCode.UNKOWN;
  }
}
