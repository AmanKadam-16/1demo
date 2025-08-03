import 'dart:convert';

import 'package:time_attendance/model/employee_tab_model/employee_search_model.dart';

// Add here API model over here.
List<EmployeeShiftMusterModel> employeeShiftMusterModelFromJson(String str) =>
    List<EmployeeShiftMusterModel>.from(
        json.decode(str).map((x) => EmployeeShiftMusterModel.fromJson(x)));

String employeeShiftMusterModelToJson(List<EmployeeShiftMusterModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EmployeeShiftMusterModel {
  final String employeeID;
  final String employeeName;
  final Map<String, dynamic> days;

  EmployeeShiftMusterModel({
    required this.employeeID,
    required this.employeeName,
    required this.days,
  });

  factory EmployeeShiftMusterModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> days = {};
    for (int i = 1; i <= 31; i++) {
      days['Day$i'] = json['Day$i'];
      days['ShiftIDOrWOffHolidayOrLeave$i'] = json['ShiftIDOrWOffHolidayOrLeave$i'];
      days['WeekDay$i'] = json['WeekDay$i'];
      days['Shift$i'] = json['Shift$i'];
    }
    return EmployeeShiftMusterModel(
      employeeID: json['EmployeeID'],
      employeeName: json['EmployeeName'],
      days: days,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['EmployeeID'] = employeeID;
    data['EmployeeName'] = employeeName;
    for (int i = 1; i <= 31; i++) {
      data['Day$i'] = days['Day$i'];
      data['ShiftIDOrWOffHolidayOrLeave$i'] = days['ShiftIDOrWOffHolidayOrLeave$i'];
      data['WeekDay$i'] = days['WeekDay$i'];
      data['Shift$i'] = days['Shift$i'];
    }
    return data;
  }
  
  @override
  String toString() {
    // Print the object as pretty-printed JSON
    return const JsonEncoder.withIndent('  ').convert(toJson());
  }
  
}

class ShiftMusterResponse {
  bool? isMultipleRecordsInJson;
  bool? isResultPass;
  int? totalRecordCount;
  String? resultMessage;
  List<EmployeeShiftMusterModel>? musterList;

  ShiftMusterResponse({
    this.isMultipleRecordsInJson,
    this.isResultPass,
    this.totalRecordCount,
    this.resultMessage,
    this.musterList,
  });
}

class ShiftMusterRequest {
  EmployeeView employeeView;
  String startDate;
  String endDate;
  InsigniaObjectListInRange insigniaObjectListInRange;

  ShiftMusterRequest({
    required this.employeeView,
    required this.startDate,
    required this.endDate,
    InsigniaObjectListInRange? insigniaObjectListInRange,
  }) : insigniaObjectListInRange = insigniaObjectListInRange ?? InsigniaObjectListInRange();

  Map<String, dynamic> toJson() {
    return {
      'EmployeeView': employeeView.toJson(),
      'StartDate': startDate,
      'EndDate': endDate,
      'InsigniaObjectListInRange': insigniaObjectListInRange.toJson(),
    };
  }
}

class EmpTemporaryShiftBulkRequest {
  String employeeID;
  String employeeName;
  String shiftID;
  String shiftName;
  String startDate;
  String endDate;

  EmpTemporaryShiftBulkRequest({
    required this.employeeID,
    required this.employeeName,
    required this.shiftID,
    required this.shiftName,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toJson() => {
    "EmployeeID": employeeID,
    "EmployeeName": employeeName,
    "ShiftID": shiftID,
    "ShiftName": shiftName,
    "StartDate": startDate,
    "EndDate": endDate,
  };
}

class EmpTemporaryShiftBulkResponse {
  bool? isMultipleRecordsInJson;
  bool? isResultPass;
  int? loginMode;
  String? resultMessage;
  int? resultRecordCount;
  String? resultRecordJson;
  int? totalRecordCount;

  EmpTemporaryShiftBulkResponse({
    this.isMultipleRecordsInJson,
    this.isResultPass,
    this.loginMode,
    this.resultMessage,
    this.resultRecordCount,
    this.resultRecordJson,
    this.totalRecordCount,
  });

  factory EmpTemporaryShiftBulkResponse.fromJson(Map<String, dynamic> json) => EmpTemporaryShiftBulkResponse(
    isMultipleRecordsInJson: json["IsMultipleRecordsInJson"],
    isResultPass: json["IsResultPass"],
    loginMode: json["LoginMode"],
    resultMessage: json["ResultMessage"],
    resultRecordCount: json["ResultRecordCount"],
    resultRecordJson: json["ResultRecordJson"],
    totalRecordCount: json["TotalRecordCount"],
  );
}