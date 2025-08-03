class DeviceEmployeeDetailsResponse {
  String searchID;
  String responseStatusStrg;
  int numOfMatches;
  int totalMatches;
  List<DeviceEmployeeInfo> userInfo;

  DeviceEmployeeDetailsResponse({
    required this.searchID,
    required this.responseStatusStrg,
    required this.numOfMatches,
    required this.totalMatches,
    required this.userInfo,
  });

  factory DeviceEmployeeDetailsResponse.fromJson(Map<String, dynamic> json) =>
      DeviceEmployeeDetailsResponse(
        searchID: json['searchID'] ?? '',
        responseStatusStrg: json['responseStatusStrg'] ?? '',
        numOfMatches: json['numOfMatches'] ?? 0,
        totalMatches: json['totalMatches'] ?? 0,
        userInfo: (json['UserInfo'] as List)
            .map((user) => DeviceEmployeeInfo.fromJson(user))
            .toList(),
      );
}

class DeviceEmployeeInfo {
  String employeeNo;
  int id;
  String name;
  String userType;
  bool closeDelayEnabled;
  DeviceEmployeeValid valid;
  String password;
  String doorRight;
  List<RightPlan> rightPlan;
  int maxOpenDoorTime;
  int openDoorTime;
  bool localUIRight;
  String userVerifyMode;
  int fingerPrintCount;
  int cardCount;
  String cardNo;

  DeviceEmployeeInfo({
    required this.employeeNo,
    required this.id,
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
    required this.fingerPrintCount,
    required this.cardCount,
    required this.cardNo,
  });

  factory DeviceEmployeeInfo.fromJson(Map<String, dynamic> json) =>
      DeviceEmployeeInfo(
        employeeNo: json['employeeNo'] ?? '',
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        userType: json['userType'] ?? '',
        closeDelayEnabled: json['closeDelayEnabled'] ?? false,
        valid: DeviceEmployeeValid.fromJson(json['Valid'] ?? {}),
        password: json['password'] ?? '',
        doorRight: json['doorRight'] ?? '',
        rightPlan: ((json['RightPlan'] ?? []) as List)
            .map((plan) => RightPlan.fromJson(plan))
            .toList(),
        maxOpenDoorTime: json['maxOpenDoorTime'] ?? 0,
        openDoorTime: json['openDoorTime'] ?? 0,
        localUIRight: json['localUIRight'] ?? false,
        userVerifyMode: json['userVerifyMode'] ?? '',
        fingerPrintCount: json['fingerPrintCount'] ?? 0,
        cardCount: json['cardCount'] ?? 0,
        cardNo: json['cardNo'] ?? '',
      );
}

class DeviceEmployeeValid {
  bool enable;
  String timeType;
  String beginTime;
  String endTime;

  DeviceEmployeeValid({
    required this.enable,
    required this.timeType,
    required this.beginTime,
    required this.endTime,
  });

  factory DeviceEmployeeValid.fromJson(Map<String, dynamic> json) =>
      DeviceEmployeeValid(
        enable: json['enable'] ?? false,
        timeType: json['timeType'] ?? '',
        beginTime: json['beginTime'] ?? '',
        endTime: json['endTime'] ?? '',
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
        doorNo: json['doorNo'] ?? 0,
        planTemplateNo: json['planTemplateNo'] ?? '',
      );
}