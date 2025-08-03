// add the megatransfer api model over here
class RightPlan1 {
  final int doorNo;
  final String planTemplateNo;

  RightPlan1({
    required this.doorNo,
    required this.planTemplateNo,
  });

  Map<String, dynamic> toJson() => {
    'doorNo': doorNo,  
    'planTemplateNo': planTemplateNo,
  };

  factory RightPlan1.fromJson(Map<String, dynamic> json) => RightPlan1(
    doorNo: json['doorNo'] as int,
    planTemplateNo: json['planTemplateNo'] as String,
  );
}

class ValidInfo {
  final bool enable;
  final String timeType;
  final String beginTime;
  final String endTime;

  ValidInfo({
    required this.enable,
    required this.timeType,
    required this.beginTime,
    required this.endTime,
  });

  Map<String, dynamic> toJson() => {
    'enable': enable,
    'timeType': timeType,
    'beginTime': beginTime,
    'endTime': endTime,
  };
}

class EmployeeTransferDetail {
  final String employeeNo;
  final int id;
  final String name;
  final String userType;
  final bool closeDelayEnabled;
  final ValidInfo valid;
  final String password;
  final String doorRight;
  final List<RightPlan1> rightPlan;
  final int maxOpenDoorTime;
  final int openDoorTime;
  final bool localUIRight;
  final String userVerifyMode;
  final int fingerPrintCount;
  final int cardCount;
  final String cardNo;

  EmployeeTransferDetail({
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

  Map<String, dynamic> toJson() => {
    'employeeNo': employeeNo,
    'id': id,
    'name': name,
    'userType': userType,
    'closeDelayEnabled': closeDelayEnabled,
    'Valid': valid.toJson(),
    'password': password,
    'doorRight': doorRight,
    'RightPlan': rightPlan.map((x) => x.toJson()).toList(),
    'maxOpenDoorTime': maxOpenDoorTime,
    'openDoorTime': openDoorTime,
    'localUIRight': localUIRight,
    'userVerifyMode': userVerifyMode,
    'fingerPrintCount': fingerPrintCount,
    'cardCount': cardCount,
    'cardNo': cardNo,
  };
}

class MegaTransferRequest {
  final List<EmployeeTransferDetail> empDetailsList;
  final List<String> targetDevIdList;
  final String hostDevIndex;

  MegaTransferRequest({
    required this.empDetailsList,
    required this.targetDevIdList,
    required this.hostDevIndex,
  });

  Map<String, dynamic> toJson() => {
    'empDetailsList': empDetailsList.map((x) => x.toJson()).toList(),
    'targetDevIdList': targetDevIdList,
    'hostDevIndex': hostDevIndex,
  };
}

class TransferStep {
  final String stepName;
  final String employeeNo;
  final bool success;
  final bool alreadyExists;
  final String? errorMessage;
  final String? details;

  TransferStep({
    required this.stepName,
    required this.employeeNo,
    required this.success,
    required this.alreadyExists,
    this.errorMessage,
    this.details,
  });

  factory TransferStep.fromJson(Map<String, dynamic> json) => TransferStep(
    stepName: json['StepName'] as String,
    employeeNo: json['EmployeeNo'] as String,
    success: json['Success'] as bool,
    alreadyExists: json['AlreadyExists'] as bool,
    errorMessage: json['ErrorMessage'] as String?,
    details: json['Details'] as String?,
  );
}

class TargetDeviceResult {
  final String deviceId;
  final String employeeNo;
  final bool success;
  final String? error;
  final List<TransferStep> steps;

  TargetDeviceResult({
    required this.deviceId,
    required this.employeeNo,
    required this.success,
    this.error,
    required this.steps,
  });

  factory TargetDeviceResult.fromJson(Map<String, dynamic> json) => TargetDeviceResult(
    deviceId: json['DeviceId'] as String,
    employeeNo: json['EmployeeNo'] as String,
    success: json['Success'] as bool,
    error: json['Error'] as String?,
    steps: (json['Steps'] as List).map((e) => TransferStep.fromJson(e as Map<String, dynamic>)).toList(),
  );
}

class ProcessedEmployeeResult {
  final String employeeNo;
  final String name;
  final bool overallSuccess;
  final String? error;
  final List<TargetDeviceResult> targetDeviceResults;

  ProcessedEmployeeResult({
    required this.employeeNo,
    required this.name,
    required this.overallSuccess,
    this.error,
    required this.targetDeviceResults,
  });

  factory ProcessedEmployeeResult.fromJson(Map<String, dynamic> json) => ProcessedEmployeeResult(
    employeeNo: json['EmployeeNo'] as String,
    name: json['Name'] as String,
    overallSuccess: json['OverallSuccess'] as bool,
    error: json['Error'] as String?,
    targetDeviceResults: (json['TargetDeviceResults'] as List)
        .map((e) => TargetDeviceResult.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

class MegaTransferResponse {
  final String hostDevIndex;
  final List<String> targetDevices;
  final int totalEmployees;
  final int totalTargetDevices;
  final int successfulEmployees;
  final List<ProcessedEmployeeResult> processedEmployees;
  final List<String> errors;
  final String startTime;
  final String endTime;
  final String totalProcessingTime;

  MegaTransferResponse({
    required this.hostDevIndex,
    required this.targetDevices,
    required this.totalEmployees,
    required this.totalTargetDevices,
    required this.successfulEmployees,
    required this.processedEmployees,
    required this.errors,
    required this.startTime,
    required this.endTime,
    required this.totalProcessingTime,
  });

  factory MegaTransferResponse.fromJson(Map<String, dynamic> json) => MegaTransferResponse(
    hostDevIndex: json['HostDevIndex'] as String,
    targetDevices: List<String>.from(json['TargetDevices']),
    totalEmployees: json['TotalEmployees'] as int,
    totalTargetDevices: json['TotalTargetDevices'] as int,
    successfulEmployees: json['SuccessfulEmployees'] as int,
    processedEmployees: (json['ProcessedEmployees'] as List)
        .map((e) => ProcessedEmployeeResult.fromJson(e as Map<String, dynamic>))
        .toList(),
    errors: List<String>.from(json['Errors']),
    startTime: json['StartTime'] as String,
    endTime: json['EndTime'] as String,
    totalProcessingTime: json['TotalProcessingTime'] as String,
  );
}