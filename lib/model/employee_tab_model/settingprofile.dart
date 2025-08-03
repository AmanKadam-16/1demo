import 'dart:convert';
import 'package:time_attendance/model/employee_tab_model/employee_complete_model.dart';

List<SettingProfileModel> settingProfileModelFromJson(String str) =>
    List<SettingProfileModel>.from(
        json.decode(str).map((x) => SettingProfileModel.fromJson(x)));

String settingProfileModelToJson(List<SettingProfileModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SettingProfileModel {
  final String profileId;
  final String profileName;
  final String description;
  final bool isDefaultProfile;
  final bool isEmpWeeklyOffAdjustable;
  final bool isShiftStartFromJoiningDate;
  final EmployeeRegularShifts? employeeRegularShift;
  final EmployeeWOff? employeeWOFF;
  final EmployeeSettings? employeeSetting;
  final EmployeeGeneralSettings? employeeGeneralSetting;
  final EmpLogin? employeeLogin;
  final String changesDoneOn;
  final DateTime changesDoneOnDateTime;
  final String changesDoneBy;

  SettingProfileModel({
    required this.profileId,
    required this.profileName,
    required this.description,
    required this.isDefaultProfile,
    required this.isEmpWeeklyOffAdjustable,
    required this.isShiftStartFromJoiningDate,
    this.employeeRegularShift,
    this.employeeWOFF,
    this.employeeSetting,
    this.employeeGeneralSetting,
    this.employeeLogin,
    required this.changesDoneOn,
    required this.changesDoneOnDateTime,
    required this.changesDoneBy,
  });

  factory SettingProfileModel.fromJson(Map<String, dynamic> json) =>
      SettingProfileModel(
        profileId: json["ProfileID"],
        profileName: json["ProfileName"],
        description: json["Description"],
        isDefaultProfile: json["IsDefaultProfile"],
        isEmpWeeklyOffAdjustable: json["IsEmpWeeklyOffAdjustable"],
        isShiftStartFromJoiningDate: json["IsShiftStartFromJoiningDate"],
        employeeRegularShift: json["EmployeeRegularShift"] == null
            ? null
            : EmployeeRegularShifts.fromJson(json["EmployeeRegularShift"]),
        employeeWOFF: json["EmployeeWOFF"] == null
            ? null
            : EmployeeWOff.fromJson(json["EmployeeWOFF"]),
        employeeSetting: json["EmployeeSetting"] == null
            ? null
            : EmployeeSettings.fromJson(json["EmployeeSetting"]),
        employeeGeneralSetting: json["EmployeeGeneralSetting"] == null
            ? null
            : EmployeeGeneralSettings.fromJson(json["EmployeeGeneralSetting"]),
        employeeLogin: json["EmployeeLogin"] == null
            ? null
            : EmpLogin.fromJson(json["EmployeeLogin"]),
        changesDoneOn: json["ChangesDoneOn"],
        changesDoneOnDateTime: DateTime.parse(json["ChangesDoneOnDateTime"]),
        changesDoneBy: json["ChangesDoneBy"],
      );

  Map<String, dynamic> toJson() => {
        "ProfileID": profileId,
        "ProfileName": profileName,
        "Description": description,
        "IsDefaultProfile": isDefaultProfile,
        "IsEmpWeeklyOffAdjustable": isEmpWeeklyOffAdjustable,
        "IsShiftStartFromJoiningDate": isShiftStartFromJoiningDate,
        "EmployeeRegularShift": employeeRegularShift?.toJson(),
        "EmployeeWOFF": employeeWOFF?.toJson(),
        "EmployeeSetting": employeeSetting?.toJson(),
        "EmployeeGeneralSetting": employeeGeneralSetting?.toJson(),
        "EmployeeLogin": employeeLogin?.toJson(),
        "ChangesDoneOn": changesDoneOn,
        "ChangesDoneOnDateTime": changesDoneOnDateTime.toIso8601String(),
        "ChangesDoneBy": changesDoneBy,
      };
}