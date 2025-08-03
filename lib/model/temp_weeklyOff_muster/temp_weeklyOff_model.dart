import 'dart:convert';
import 'package:time_attendance/model/employee_tab_model/employee_search_model.dart';

List<TempWeeklyOffModel> tempWeeklyOffModelFromJson(String str) =>
    List<TempWeeklyOffModel>.from(
        json.decode(str).map((x) => TempWeeklyOffModel.fromJson(x)));

String tempWeeklyOffModelToJson(List<TempWeeklyOffModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TempWeeklyOffModel {
  final String employeeID;
  final String employeeName;
  final String firstName;
  final String firstWOff;
  final String secondWOff;
  final bool isFullDay;
  final String wOffPattern;
  final String startDate;
  final String startDateTime;
  final String endDate;
  final String endDateTime;
  final String errorMessage;
  final bool isErrorFound;
  final bool recordNeedsToDelete;
  final bool recordNeedsToAdd;

  TempWeeklyOffModel({
    required this.employeeID,
    required this.employeeName,
    required this.firstName,
    required this.firstWOff,
    required this.secondWOff,
    required this.isFullDay,
    required this.wOffPattern,
    required this.startDate,
    required this.endDate,
    this.startDateTime = '',
    this.endDateTime = '',
    required this.errorMessage,
    required this.isErrorFound,
    this.recordNeedsToDelete = false,
    this.recordNeedsToAdd = false,
  });  
  
  factory TempWeeklyOffModel.fromJson(Map<String, dynamic> json) => TempWeeklyOffModel(
    employeeID: json['EmployeeID'] ?? '',
    employeeName: json['EmployeeName'] ?? '',
    firstName: json['FirstName'] ?? '',
    firstWOff: json['FirstWOff'] ?? '',
    secondWOff: json['SecondWOff'] ?? '',
    isFullDay: json['IsFullDay'] ?? false,
    wOffPattern: json['WOffPattern'] ?? '',
    startDate: json['StartDate'] ?? '',
    startDateTime: json['StartDateTime'] ?? '',
    endDate: json['EndDate'] ?? '',
    endDateTime: json['EndDateTime'] ?? '',
    errorMessage: json['ErrorMessage'] ?? '',
    isErrorFound: json['IsErrorFound'] ?? false,
    recordNeedsToDelete: json['RecordNeedsToDelete'] ?? false,
    recordNeedsToAdd: json['RecordNeedsToAdd'] ?? false,
  );

  Map<String, dynamic> toJson() => {
    'EmployeeID': employeeID,
    'EmployeeName': employeeName,
    'FirstName': firstName,
    'FirstWOff': firstWOff,
    'SecondWOff': secondWOff,
    'IsFullDay': isFullDay,
    'WOffPattern': wOffPattern,
    'StartDate': startDate,
    'EndDate': endDate,
    'ErrorMessage': errorMessage,
    'IsErrorFound': isErrorFound,
    'RecordNeedsToDelete': recordNeedsToDelete,
    'RecordNeedsToAdd': recordNeedsToAdd,
  };

  @override
  String toString() {
    return const JsonEncoder.withIndent('  ').convert(toJson());
  }
}

class TempWeeklyOffResponse {
  bool? isMultipleRecordsInJson;
  bool? isResultPass;
  int? loginMode;
  String? resultMessage;
  int? resultRecordCount;
  List<TempWeeklyOffModel>? weeklyOffList;
  int? totalRecordCount;

  TempWeeklyOffResponse({
    this.isMultipleRecordsInJson,
    this.isResultPass,
    this.loginMode,
    this.resultMessage,
    this.resultRecordCount,
    this.weeklyOffList,
    this.totalRecordCount,
  });
}

class TempWeeklyOffRequest {
  EmployeeView employeeView;
  String startDate;
  String endDate;
  InsigniaObjectListInRange insigniaObjectListInRange;

  TempWeeklyOffRequest({
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