import 'dart:convert';

// Enums to match C# model
enum ManualType {
  byShift,
  byTimings,
  byOutTime
}

enum ManualStatus {
  pending,
  approved,
  rejected
}

// Match C# AttendanceStatus enum exactly
enum AttendanceStatus {
  absent,                    // 0
  presentFullDay,           // 1
  presentHalfDay,           // 2
  wOffFullday,             // 3
  wOffHalfDay,             // 4
  wOffPresentFullDay,      // 5
  wOffPresentHalfDay,      // 6
  holiday,                  // 7
  holidayPresentFullDay,   // 8
  holidayPresentHalfDay,   // 9
  compensatoryOffFullDay,  // 10
  compensatoryOffHalfDay,  // 11
  privilegeLeaveFullDay,   // 12
  privilegeLeaveHalfDay,   // 13
  sickLeaveFullDay,        // 14
  sickLeaveHalfDay,        // 15
  maternityLeaveFullDay,   // 16
  maternityLeaveHalfDay,   // 17
  casualLeaveFullDay,      // 18
  casualLeaveHalfDay,      // 19
  paidLeaveFullDay,        // 19 (same as casualLeaveHalfDay in C#)
  paidLeaveHalfDay,        // 20
  unpaidLeaveFullDay,      // 21
  unpaidLeaveHalfDay,      // 22
  leavePresentFullDay,     // 23
  leavePresentHalfDay,     // 24
  wOffAbsent,              // 25
}

// Base Attendance model matching C# Attendance class
class Attendance {
  String employeeId;
  String shiftDate;
  DateTime shiftDateTime;
  String inTime;
  String outTime;
  DateTime inDateTime;
  DateTime outDateTime;
  AttendanceStatus attStatus;
  String status;
  int workInMinutes;
  int lateComing;
  int earlyGoing;
  int grossMinutes;
  bool isNoOut;
  String shiftId;
  int otMinutes;
  bool isManuallAttendance;

  Attendance({
    this.employeeId = '',
    this.shiftDate = '',
    required this.shiftDateTime,
    this.inTime = '',
    this.outTime = '',
    required this.inDateTime,
    required this.outDateTime,
    this.attStatus = AttendanceStatus.absent,
    this.status = '',
    this.workInMinutes = 0,
    this.lateComing = 0,
    this.earlyGoing = 0,
    this.grossMinutes = 0,
    this.isNoOut = false,
    this.shiftId = '0',
    this.otMinutes = 0,
    this.isManuallAttendance = false,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
        employeeId: json["EmployeeID"] ?? '',
        shiftDate: json["ShiftDate"] ?? '',
        shiftDateTime: DateTime.parse(json["ShiftDateTime"]),
        inTime: json["InTime"] ?? '',
        outTime: json["OutTime"] ?? '',
        inDateTime: DateTime.parse(json["InDateTime"]),
        outDateTime: DateTime.parse(json["OutDateTime"]),
        attStatus: AttendanceStatus.values[json["AttStatus"] ?? 0],
        status: json["Status"] ?? '',
        workInMinutes: json["WorkInMinutes"] ?? 0,
        lateComing: json["LateComing"] ?? 0,
        earlyGoing: json["EarlyGoing"] ?? 0,
        grossMinutes: json["GrossMinutes"] ?? 0,
        isNoOut: json["IsNoOut"] ?? false,
        shiftId: json["ShiftID"] ?? '0',
        otMinutes: json["OTMinutes"] ?? 0,
        isManuallAttendance: json["IsManuallAttendance"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "EmployeeID": employeeId,
        "ShiftDate": shiftDate,
        "ShiftDateTime": shiftDateTime.toIso8601String(),
        "InTime": inTime,
        "OutTime": outTime,
        "InDateTime": inDateTime.toIso8601String(),
        "OutDateTime": outDateTime.toIso8601String(),
        "AttStatus": attStatus.index,
        "Status": status,
        "WorkInMinutes": workInMinutes,
        "LateComing": lateComing,
        "EarlyGoing": earlyGoing,
        "GrossMinutes": grossMinutes,
        "IsNoOut": isNoOut,
        "ShiftID": shiftId,
        "OTMinutes": otMinutes,
        "IsManuallAttendance": isManuallAttendance,
      };
}

List<ManualAttendanceModel> manualAttendanceModelFromJson(String str) =>
    List<ManualAttendanceModel>.from(
        json.decode(str).map((x) => ManualAttendanceModel.fromJson(x)));

String manualAttendanceModelToJson(List<ManualAttendanceModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ManualAttendanceModel {
  String employeeId;
  String employeeName;
  String shiftDate;
  DateTime shiftDateTime;
  ManualType type;
  String shiftId;
  String shiftName;
  String inTime;
  String outTime;
  DateTime inDateTime;
  DateTime outDateTime;
  bool isWorkEndsNextDay;
  AttendanceStatus attendanceStatus;
  bool attendanceFirstSession;
  String reason;
  String rejectionReason;
  ManualStatus status;
  String approvedOrRejectedOn;
  DateTime approvedOrRejectedOnDateTime;
  String seniorEmployeeId;
  String seniorEmployeeName;
  String userLoginId;
  String userLoginName;
  bool includeWeeklyOffNHoliday;

  ManualAttendanceModel({
    this.employeeId = '',
    this.employeeName = '',
    this.shiftDate = '',
    required this.shiftDateTime,
    this.type = ManualType.byShift,
    this.shiftId = '0',
    this.shiftName = '',
    this.inTime = '',
    this.outTime = '',
    required this.inDateTime,
    required this.outDateTime,
    this.isWorkEndsNextDay = false,
    this.attendanceStatus = AttendanceStatus.absent,
    this.attendanceFirstSession = false,
    this.reason = '',
    this.rejectionReason = '',
    this.status = ManualStatus.pending,
    this.approvedOrRejectedOn = '',
    required this.approvedOrRejectedOnDateTime,
    this.seniorEmployeeId = '',
    this.seniorEmployeeName = '',
    this.userLoginId = '',
    this.userLoginName = '',
    this.includeWeeklyOffNHoliday = false,
  });

  factory ManualAttendanceModel.fromJson(Map<String, dynamic> json) =>
      ManualAttendanceModel(
        employeeId: json["EmployeeID"] ?? '',
        employeeName: json["EmployeeName"] ?? '',
        shiftDate: json["ShiftDate"] ?? '',
        shiftDateTime: DateTime.parse(json["ShiftDateTime"]),
        type: ManualType.values[json["Type"] ?? 0],
        shiftId: json["ShiftID"] ?? '0',
        shiftName: json["ShiftName"] ?? '',
        inTime: json["InTime"] ?? '',
        outTime: json["OutTime"] ?? '',
        inDateTime: DateTime.parse(json["InDateTime"]),
        outDateTime: DateTime.parse(json["OutDateTime"]),
        isWorkEndsNextDay: json["IsWorkEndsNextDay"] ?? false,
        attendanceStatus: AttendanceStatus.values[json["AttendanceStatus"] ?? 0],
        attendanceFirstSession: json["AttendanceFirstSession"] ?? false,
        reason: json["Reason"] ?? '',
        rejectionReason: json["RejectionReason"] ?? '',
        status: ManualStatus.values[json["Status"] ?? 0],
        approvedOrRejectedOn: json["ApprovedOrRejectedOn"] ?? '',
        approvedOrRejectedOnDateTime: DateTime.parse(json["ApprovedOrRejectedOnDateTime"]),
        seniorEmployeeId: json["SeniorEmployeeID"] ?? '',
        seniorEmployeeName: json["SeniorEmployeeName"] ?? '',
        userLoginId: json["UserLoginID"] ?? '',
        userLoginName: json["UserLoginName"] ?? '',
        includeWeeklyOffNHoliday: json["IncludeWeeklyOffNHoliday"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "EmployeeID": employeeId,
        "EmployeeName": employeeName,
        "ShiftDate": shiftDate,
        "ShiftDateTime": shiftDateTime.toIso8601String(),
        "Type": type.index,
        "ShiftID": shiftId,
        "ShiftName": shiftName,
        "InTime": inTime,
        "OutTime": outTime,
        "InDateTime": inDateTime.toIso8601String(),
        "OutDateTime": outDateTime.toIso8601String(),
        "IsWorkEndsNextDay": isWorkEndsNextDay,
        "AttendanceStatus": attendanceStatus.index,
        "AttendanceFirstSession": attendanceFirstSession,
        "Reason": reason,
        "RejectionReason": rejectionReason,
        "Status": status.index,
        "ApprovedOrRejectedOn": approvedOrRejectedOn,
        "ApprovedOrRejectedOnDateTime": approvedOrRejectedOnDateTime.toIso8601String(),
        "SeniorEmployeeID": seniorEmployeeId,
        "SeniorEmployeeName": seniorEmployeeName,
        "UserLoginID": userLoginId,
        "UserLoginName": userLoginName,
        "IncludeWeeklyOffNHoliday": includeWeeklyOffNHoliday,
      };
}