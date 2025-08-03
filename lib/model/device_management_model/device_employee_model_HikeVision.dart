// Model file for device related employee operations

class UserSearchRequest {
  String devIndex;
  UserInfoSearchCond userInfoSearchCond;

  UserSearchRequest({
    required this.devIndex,
    required this.userInfoSearchCond,
  });

  Map<String, dynamic> toJson() => {
        'devIndex': devIndex,
        'UserInfoSearchCond': userInfoSearchCond.toJson(),
      };
}

class UserInfoSearchCond {
  String searchID;
  int searchResultPosition;
  int maxResults;

  UserInfoSearchCond({
    required this.searchID,
    required this.searchResultPosition,
    required this.maxResults,
  });

  Map<String, dynamic> toJson() => {
        'searchID': searchID,
        'searchResultPosition': searchResultPosition,
        'maxResults': maxResults,
      };
}

class UserSearchResponse {
  UserInfoSearch userInfoSearch;

  UserSearchResponse({required this.userInfoSearch});

  factory UserSearchResponse.fromJson(Map<String, dynamic> json) =>
      UserSearchResponse(
        userInfoSearch: UserInfoSearch.fromJson(json['UserInfoSearch']),
      );
}

class UserInfoSearch {
  String searchID;
  String responseStatusStrg;
  int numOfMatches;
  int totalMatches;
  List<UserInfo> userInfo;

  UserInfoSearch({
    required this.searchID,
    required this.responseStatusStrg,
    required this.numOfMatches,
    required this.totalMatches,
    required this.userInfo,
  });

  factory UserInfoSearch.fromJson(Map<String, dynamic> json) => UserInfoSearch(
        searchID: json['searchID'],
        responseStatusStrg: json['responseStatusStrg'],
        numOfMatches: json['numOfMatches'],
        totalMatches: json['totalMatches'],
        userInfo: (json['UserInfo'] as List)
            .map((user) => UserInfo.fromJson(user))
            .toList(),
      );
}

class UserInfo {
  String employeeNo;
  String name;
  String userType;
  bool closeDelayEnabled;
  Valid valid;
  String password;
  String doorRight;
  List<RightPlan> rightPlan;
  int maxOpenDoorTime;
  int openDoorTime;
  bool localUIRight;
  String userVerifyMode;

  UserInfo({
    required this.employeeNo,
    required this.name,
    required this.userType,
    required this.closeDelayEnabled,
    required this.valid,
    required this.password,
    required this.doorRight,
    required this.rightPlan,
    required this.maxOpenDoorTime,
    required this.openDoorTime,
    required this.localUIRight,
    required this.userVerifyMode,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        employeeNo: json['employeeNo'],
        name: json['name'],
        userType: json['userType'],
        closeDelayEnabled: json['closeDelayEnabled'],
        valid: Valid.fromJson(json['Valid']),
        password: json['password'],
        doorRight: json['doorRight'],
        rightPlan: (json['RightPlan'] as List)
            .map((plan) => RightPlan.fromJson(plan))
            .toList(),
        maxOpenDoorTime: json['maxOpenDoorTime'],
        openDoorTime: json['openDoorTime'],
        localUIRight: json['localUIRight'],
        userVerifyMode: json['userVerifyMode'],
      );
}

class Valid {
  bool enable;
  String timeType;
  String beginTime;
  String endTime;

  Valid({
    required this.enable,
    required this.timeType,
    required this.beginTime,
    required this.endTime,
  });

  factory Valid.fromJson(Map<String, dynamic> json) => Valid(
        enable: json['enable'],
        timeType: json['timeType'],
        beginTime: json['beginTime'],
        endTime: json['endTime'],
      );
}

class RightPlan {
  int doorNo;
  String planTemplateNo;

  RightPlan({
    required this.doorNo,
    required this.planTemplateNo,
  });

  factory RightPlan.fromJson(Map<String, dynamic> json) => RightPlan(
        doorNo: json['doorNo'],
        planTemplateNo: json['planTemplateNo'],
      );
}

class UserDeleteRequest {
  String devIndex;
  UserInfoDetail userInfoDetail;

  UserDeleteRequest({
    required this.devIndex,
    required this.userInfoDetail,
  });

  Map<String, dynamic> toJson() => {
        'DevIndex': devIndex,
        'UserInfoDetail': userInfoDetail.toJson(),
      };
}

class UserInfoDetail {
  String mode;
  List<EmployeeNo> employeeNoList;

  UserInfoDetail({
    required this.mode,
    required this.employeeNoList,
  });

  Map<String, dynamic> toJson() => {
        'mode': mode,
        'EmployeeNoList': employeeNoList.map((e) => e.toJson()).toList(),
      };
}

class EmployeeNo {
  String employeeNo;

  EmployeeNo({
    required this.employeeNo,
  });

  Map<String, dynamic> toJson() => {
        'employeeNo': employeeNo,
      };
}

class UserDeleteResponse {
  String message;

  UserDeleteResponse({
    required this.message,
  });

  factory UserDeleteResponse.fromJson(Map<String, dynamic> json) => UserDeleteResponse(
        message: json['message'],
      );
}

class UserValidInfo {
  final String beginTime;
  final String endTime;
  final bool enable;
  final String timeType;

  UserValidInfo({
    required this.beginTime,
    required this.endTime,
    required this.enable,
    required this.timeType,
  });

  Map<String, dynamic> toJson() => {
    'beginTime': beginTime,
    'endTime': endTime,
    'enable': enable,
    'timeType': timeType,
  };

  factory UserValidInfo.fromJson(Map<String, dynamic> json) => UserValidInfo(
    beginTime: json['beginTime'],
    endTime: json['endTime'],
    enable: json['enable'],
    timeType: json['timeType'],
  );
}

class UserModifyInfo {
  final String employeeNo;
  final String name;
  final UserValidInfo valid;

  UserModifyInfo({
    required this.employeeNo,
    required this.name,
    required this.valid,
  });

  Map<String, dynamic> toJson() => {
    'employeeNo': employeeNo,
    'name': name,
    'Valid': valid.toJson(),
  };

  factory UserModifyInfo.fromJson(Map<String, dynamic> json) => UserModifyInfo(
    employeeNo: json['employeeNo'],
    name: json['name'],
    valid: UserValidInfo.fromJson(json['Valid']),
  );
}

class UserModifyRequest {
  final String devIndex;
  final UserModifyInfo userInfo;

  UserModifyRequest({
    required this.devIndex,
    required this.userInfo,
  });

  Map<String, dynamic> toJson() => {
    'DevIndex': devIndex,
    'UserInfo': userInfo.toJson(),
  };
}

class UserModifyResponse {
  final String? requestURL;
  final int statusCode;
  final String statusString;
  final String subStatusCode;
  final int? errorCode;
  final String? errorMsg;
  final int? rebootRequired;

  UserModifyResponse({
    this.requestURL,
    required this.statusCode,
    required this.statusString,
    required this.subStatusCode,
    this.errorCode,
    this.errorMsg,
    this.rebootRequired,
  });

  factory UserModifyResponse.fromJson(Map<String, dynamic> json) => UserModifyResponse(
    requestURL: json['requestURL'],
    statusCode: json['statusCode'],
    statusString: json['statusString'],
    subStatusCode: json['subStatusCode'],
    errorCode: json['errorCode'],
    errorMsg: json['errorMsg'],
    rebootRequired: json['rebootRequired'],
  );
}