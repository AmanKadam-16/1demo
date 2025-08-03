// model for modify / add employee details

class DeviceEmployeeAddRequest {
  final String employeeNo;
  final String name;
  final String userType;
  final bool closeDelayEnabled;
  final bool validEnable;
  final String timeType;
  String beginTime;
  String endTime;
  final String password;
  final String doorRight;
  final int maxOpenDoorTime;
  final int openDoorTime;
  final bool localUIRight;
  final String userVerifyMode;
  final int fingerPrintCount;
  final int cardCount;
  final String cardNo;
  final String devIndex;

  DeviceEmployeeAddRequest({
    required this.employeeNo,
    required this.name,
    required this.userType,
    required this.closeDelayEnabled,
    required this.validEnable,
    required this.timeType,
    required this.beginTime,
    required this.endTime,
    this.password = '',
    required this.doorRight,
    required this.maxOpenDoorTime,
    required this.openDoorTime,
    required this.localUIRight,
    required this.userVerifyMode,
    required this.fingerPrintCount,
    required this.cardCount,
    required this.cardNo,
    required this.devIndex,
  });

  Map<String, dynamic> toJson() {
    return {
      'EmployeeNo': employeeNo,
      'Name': name,
      'UserType': userType,
      'CloseDelayEnabled': closeDelayEnabled,
      'ValidEnable': validEnable,
      'TimeType': timeType,
      'BeginTime': beginTime,
      'EndTime': endTime,
      'Password': password,
      'DoorRight': doorRight,
      'MaxOpenDoorTime': maxOpenDoorTime,
      'OpenDoorTime': openDoorTime,
      'LocalUIRight': localUIRight,
      'UserVerifyMode': userVerifyMode,
      'FingerPrintCount': fingerPrintCount,
      'CardCount': cardCount,
      'CardNo': cardNo,
      'DevIndex': devIndex,
    };
  }
}