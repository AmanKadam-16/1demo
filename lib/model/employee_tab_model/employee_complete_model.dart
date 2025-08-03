// region Enums (Dart equivalents for C# enums, for reference)

// From EmployeeProfessional
import 'package:time_attendance/Data/LoginInformation/AuthLogin.dart';

enum CsEmployeeStatus {
  Inactive, // 0
  Active,   // 1
  None      // 2
}

// From EmployeeRegularShifts
enum CsShiftType {
  // Fix = 1, AutoShift, Rotation (values would be 1, 2, 3)
  Fix,        // Represents 1
  AutoShift,  // Represents 2
  Rotation    // Represents 3
}

// From EmployeeWOff
enum CsSecondWOffDuration {
  HalfDay,
  FullDay
}

enum CsWeekDays {
  None,
  Sunday,
  Monday,
  Tuesday,
  Wednesday,
  Thursday,
  Friday,
  Saturday
}

// From EmployeeSettings
enum CsPunchType {
  // Single = 1, Double, Multiple (values would be 1, 2, 3)
  Single,   // Represents 1
  Double,   // Represents 2
  Multiple  // Represents 3
}

// From EmployeeGeneralSettings
enum CsLateComingAction {
  // None = 1, CutFullDayMinutes, CutHalfDayMinutes, MarkAbsent (values would be 1, 2, 3, 4)
  None,                 // Represents 1
  CutFullDayMinutes,    // Represents 2
  CutHalfDayMinutes,    // Represents 3
  MarkAbsent            // Represents 4
}

enum CsForcePunchOutType {
  // None = 1, ByDefault, ByShift, ByHalfDayMinutes (values would be 1, 2, 3, 4)
  None,                 // Represents 1
  ByDefault,            // Represents 2
  ByShift,              // Represents 3
  ByHalfDayMinutes      // Represents 4
}

enum CsOverTimeCalculation {
  // None = 1, HalfHourly, Hourly (values would be 1, 2, 3)
  None,       // Represents 1
  HalfHourly, // Represents 2
  Hourly      // Represents 3
}

// From EmpLogin
enum CsEmpLoginModeCreated {
  ViaTAWebOrUtility, // 0
  ViaApp             // 1
}

// endregion Enums

// region Model Classes

class Employee {
  final EmployeeProfessional? employeeProfessional;
  final EmployeePersonal? employeePersonal;
  final EmployeeRegularShifts? employeeRegularShift;
  final EmployeeWOff? employeeWOFF;
  final EmployeeSettings? employeeSetting;
  final EmployeeGeneralSettings? employeeGeneralSetting;
  final EmpLogin? employeeLogin;
  final String? SettingProfileID;

  Employee({
    this.employeeProfessional,
    this.employeePersonal,
    this.employeeRegularShift,
    this.employeeWOFF,
    this.employeeSetting,
    this.employeeGeneralSetting,
    this.employeeLogin,
    this.SettingProfileID,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      employeeProfessional: json['EmployeeProfessional'] != null
          ? EmployeeProfessional.fromJson(json['EmployeeProfessional'])
          : null,
      employeePersonal: json['EmployeePersonal'] != null
          ? EmployeePersonal.fromJson(json['EmployeePersonal'])
          : null,
      employeeRegularShift: json['EmployeeRegularShifts'] != null
          ? EmployeeRegularShifts.fromJson(json['EmployeeRegularShifts'])
          : null,
      employeeWOFF: json['EmployeeWOFF'] != null
          ? EmployeeWOff.fromJson(json['EmployeeWOFF'])
          : null,
      employeeSetting: json['EmployeeSetting'] != null
          ? EmployeeSettings.fromJson(json['EmployeeSetting'])
          : null,
      employeeGeneralSetting: json['EmployeeGeneralSetting'] != null
          ? EmployeeGeneralSettings.fromJson(json['EmployeeGeneralSetting'])
          : null,
      employeeLogin: json['EmployeeLogin'] != null
          ? EmpLogin.fromJson(json['EmployeeLogin'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (employeeProfessional != null) 'EmployeeProfessional': employeeProfessional!.toJson(),
      if (employeePersonal != null) 'EmployeePersonal': employeePersonal!.toJson(),
      if (employeeRegularShift != null) 'EmployeeRegularShifts': employeeRegularShift!.toJson(),
      if (employeeWOFF != null) 'EmployeeWOFF': employeeWOFF!.toJson(),
      if (employeeSetting != null) 'EmployeeSetting': employeeSetting!.toJson(),
      if (employeeGeneralSetting != null) 'EmployeeGeneralSetting': employeeGeneralSetting!.toJson(),
      if (employeeLogin != null) 'EmployeeLogin': employeeLogin!.toJson(),
      if (SettingProfileID != null) 'SettingProfileID': SettingProfileID,
    };
  }
}

class EmployeeProfessional {
  final String enrollID;
  final String employeeID;
  final String employeeName;
  final String companyID;
  final String departmentID;
  final String designationID;
  final String locationID;
  final String employeeTypeID;
  final String employeeType;
  final int empStatus; // Corresponds to CsEmployeeStatus enum (0: Inactive, 1: Active, 2: None)
  final String dateOfEmployment;
  final String? dateOfLeaving;
  final String seniorEmployeeID;
  final String emailID;

  EmployeeProfessional({
    required this.enrollID,
    required this.employeeID,
    required this.employeeName,
    required this.companyID,
    required this.departmentID,
    required this.designationID,
    required this.locationID,
    required this.employeeTypeID,
    required this.employeeType,
    required this.empStatus,
    required this.dateOfEmployment,
    this.dateOfLeaving,
    required this.seniorEmployeeID,
    required this.emailID,
  });

  factory EmployeeProfessional.fromJson(Map<String, dynamic> json) {
    return EmployeeProfessional(
      enrollID: json['EnrollID'],
      employeeID: json['EmployeeID'],
      employeeName: json['EmployeeName'],
      companyID: json['CompanyID'],
      departmentID: json['DepartmentID'],
      designationID: json['DesignationID'],
      locationID: json['LocationID'],
      employeeTypeID: json['EmployeeTypeID'],
      employeeType: json['EmployeeType'],
      empStatus: json['EmpStatus'],
      dateOfEmployment: json['DateOfEmployment'],
      dateOfLeaving: json['DateOfLeaving'],
      seniorEmployeeID: json['SeniorEmployeeID'],
      emailID: json['EmailID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'EnrollID': enrollID,
      'EmployeeID': employeeID,
      'EmployeeName': employeeName,
      'CompanyID': companyID,
      'DepartmentID': departmentID,
      'DesignationID': designationID,
      'LocationID': locationID,
      'EmployeeTypeID': employeeTypeID,
      'EmployeeType': employeeType,
      'EmpStatus': empStatus,
      'DateOfEmployment': dateOfEmployment,
      'DateOfLeaving': dateOfLeaving,
      'SeniorEmployeeID': seniorEmployeeID,
      'EmailID': emailID,
    };
  }
}

class EmployeePersonal {
  final String employeeID;
  final String employeeName;
  final String localAddress;
  final String permanentAddress;
  final String gender;
  final String dateOfBirth;
  final String contactNo;
  final String mobileNumber;
  final String nationality;
  final String emailID;
  final String bloodGroup;

  EmployeePersonal({
    required this.employeeID,
    required this.employeeName,
    required this.localAddress,
    required this.permanentAddress,
    required this.gender,
    required this.dateOfBirth,
    required this.contactNo,
    required this.mobileNumber,
    required this.nationality,
    required this.emailID,
    required this.bloodGroup,
  });

  factory EmployeePersonal.fromJson(Map<String, dynamic> json) {
    return EmployeePersonal(
      employeeID: json['EmployeeID'],
      employeeName: json['EmployeeName'],
      localAddress: json['LocalAddress'],
      permanentAddress: json['PermanentAddress'],
      gender: json['Gender'],
      dateOfBirth: json['DateOfBirth'],
      contactNo: json['ContactNo'],
      mobileNumber: json['MobileNumber'],
      nationality: json['Nationality'],
      emailID: json['EmailID'],
      bloodGroup: json['BloodGroup'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'EmployeeID': employeeID,
      'EmployeeName': employeeName,
      'LocalAddress': localAddress,
      'PermanentAddress': permanentAddress,
      'Gender': gender,
      'DateOfBirth': dateOfBirth,
      'ContactNo': contactNo,
      'MobileNumber': mobileNumber,
      'Nationality': nationality,
      'EmailID': emailID,
      'BloodGroup': bloodGroup,
    };
  }
}

class EmployeeRegularShifts {
  final String employeeID;
  final String employeeName;
  final String startDate;
  final String startDateTime; // C# DateTime dtStartDateTime, serialized as ISO string
  final int type; // Corresponds to CsShiftType enum (1: Fix, 2: AutoShift, 3: Rotation)
  final String shiftID;
  final String shiftName;
  final String patternID;
  final String patternName;
  final String shiftConstantDays;

  EmployeeRegularShifts({
    required this.employeeID,
    required this.employeeName,
    required this.startDate,
    required this.startDateTime,
    required this.type,
    required this.shiftID,
    required this.shiftName,
    required this.patternID,
    required this.patternName,
    required this.shiftConstantDays,
  });

  factory EmployeeRegularShifts.fromJson(Map<String, dynamic> json) {
    return EmployeeRegularShifts(
      employeeID: json['EmployeeID'],
      employeeName: json['EmployeeName'],
      startDate: json['StartDate'],
      startDateTime: json['StartDateTime'],
      type: json['Type'],
      shiftID: json['ShiftID'],
      shiftName: json['ShiftName'],
      patternID: json['PatternID'],
      patternName: json['PatternName'],
      shiftConstantDays: json['ShiftConstantDays'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'EmployeeID': employeeID,
      'EmployeeName': employeeName,
      'StartDate': startDate,
      'StartDateTime': startDateTime,
      'Type': type,
      'ShiftID': shiftID,
      'ShiftName': shiftName,
      'PatternID': patternID,
      'PatternName': patternName,
      'ShiftConstantDays': shiftConstantDays,
    };
  }
}

class EmployeeWOff {
  final String employeeID;
  final String employeeName;
  final String firstName;
  final String firstWOff;
  final String secondWOff;
  final bool isFullDay;
  final String wOffPattern;

  EmployeeWOff({
    required this.employeeID,
    required this.employeeName,
    required this.firstName,
    required this.firstWOff,
    required this.secondWOff,
    required this.isFullDay,
    required this.wOffPattern,
  });

  factory EmployeeWOff.fromJson(Map<String, dynamic> json) {
    return EmployeeWOff(
      employeeID: json['EmployeeID'],
      employeeName: json['EmployeeName'],
      firstName: json['FirstName'],
      firstWOff: json['FirstWOff'],
      secondWOff: json['SecondWOff'],
      isFullDay: json['IsFullDay'],
      wOffPattern: json['WOffPattern'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'EmployeeID': employeeID,
      'EmployeeName': employeeName,
      'FirstName': firstName,
      'FirstWOff': firstWOff,
      'SecondWOff': secondWOff,
      'IsFullDay': isFullDay,
      'WOffPattern': wOffPattern,
    };
  }
}

class EmployeeSettings {
  // Constants from C#
  static const String taLeave = "Leave";
  static const String taHoliday = "Holiday";
  static const String taWOff = "WOff";
  static const String taCOff = "COff";
  static const String taOverTime = "OverTime";
  static const String taAWOff = "AWOff";
  static const String taAWOffA = "AWOffA";
  static const String taWOffA = "WOffA";
  static const String taPresent = "Present";
  static const String taAbsent = "Absent";
  static const String taYes = "Yes";
  static const String taNo = "No";
  static const String taMultiple = "Multiple";
  static const String taSingle = "Single";
  static const String taDouble = "Double";
  static const String taByShift = "ByShift";
  static const String taByEmployee = "ByEmployee";
  static const String taOtAfterShiftEnd = "AfterShiftEnd";
  static const String taOtAfterFullDay = "AfterFullDay";

  final String employeeID;
  final String employeeName;
  final int type; // Corresponds to CsPunchType enum (1: Single, 2: Double, 3: Multiple)
  final String singlePunchOutTime;
  final bool isWorkMinutesCalculationByShift;
  final int fullDayMinutes;
  final int halfDayMinutes;
  final bool isOverTimeAllowed;
  final int otStartMinutes;
  final int otGraceMins;
  final bool isOTStartsAtShiftEnd;
  final String presentOnWOffOrHoliday;
  final String leaveNWOffConsider;
  final String leaveNHolidayConsider;
  final String wOffNHolidayConsider;
  final int allowedLateComingMinutes;
  final int allowedEarlyGoingMinutes;
  final bool isAHolidayAMarkA;
  final bool isBreakAllowed;
  final double awoffDaysConstant; // C# float, Dart double
  final bool isAWoffAMarkA;
  final bool isAWOffMarkA;
  final bool isWOffAMarkA;

  EmployeeSettings({
    required this.employeeID,
    required this.employeeName,
    required this.type,
    required this.singlePunchOutTime,
    required this.isWorkMinutesCalculationByShift,
    required this.fullDayMinutes,
    required this.halfDayMinutes,
    required this.isOverTimeAllowed,
    required this.otStartMinutes,
    required this.otGraceMins,
    required this.isOTStartsAtShiftEnd,
    required this.presentOnWOffOrHoliday,
    required this.leaveNWOffConsider,
    required this.leaveNHolidayConsider,
    required this.wOffNHolidayConsider,
    required this.allowedLateComingMinutes,
    required this.allowedEarlyGoingMinutes,
    required this.isAHolidayAMarkA,
    required this.isBreakAllowed,
    required this.awoffDaysConstant,
    required this.isAWoffAMarkA,
    required this.isAWOffMarkA,
    required this.isWOffAMarkA,
  });

  factory EmployeeSettings.fromJson(Map<String, dynamic> json) {
    return EmployeeSettings(
      employeeID: json['EmployeeID'],
      employeeName: json['EmployeeName'],
      type: json['Type'],
      singlePunchOutTime: json['SinglePunchOutTime'],
      isWorkMinutesCalculationByShift: json['IsWorkMinutesCalculationByShift'],
      fullDayMinutes: json['FullDayMinutes'],
      halfDayMinutes: json['HalfDayMinutes'],
      isOverTimeAllowed: json['IsOverTimeAllowed'],
      otStartMinutes: json['OTStartMinutes'],
      otGraceMins: json['OTGraceMins'],
      isOTStartsAtShiftEnd: json['IsOTStartsAtShiftEnd'],
      presentOnWOffOrHoliday: json['PresentOnWOffOrHoliday'],
      leaveNWOffConsider: json['LeaveNWOffConsider'],
      leaveNHolidayConsider: json['LeaveNHolidayConsider'],
      wOffNHolidayConsider: json['WOffNHolidayConsider'],
      allowedLateComingMinutes: json['AllowedLateComingMinutes'],
      allowedEarlyGoingMinutes: json['AllowedEarlyGoingMinutes'],
      isAHolidayAMarkA: json['IsAHolidayAMarkA'],
      isBreakAllowed: json['IsBreakAllowed'],
      awoffDaysConstant: (json['AWOFFDaysConstant'] as num).toDouble(),
      isAWoffAMarkA: json['IsAWoffAMarkA'],
      isAWOffMarkA: json['IsAWOffMarkA'],
      isWOffAMarkA: json['IsWOffAMarkA'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'EmployeeID': employeeID,
      'EmployeeName': employeeName,
      'Type': type,
      'SinglePunchOutTime': singlePunchOutTime,
      'IsWorkMinutesCalculationByShift': isWorkMinutesCalculationByShift,
      'FullDayMinutes': fullDayMinutes,
      'HalfDayMinutes': halfDayMinutes,
      'IsOverTimeAllowed': isOverTimeAllowed,
      'OTStartMinutes': otStartMinutes,
      'OTGraceMins': otGraceMins,
      'IsOTStartsAtShiftEnd': isOTStartsAtShiftEnd,
      'PresentOnWOffOrHoliday': presentOnWOffOrHoliday,
      'LeaveNWOffConsider': leaveNWOffConsider,
      'LeaveNHolidayConsider': leaveNHolidayConsider,
      'WOffNHolidayConsider': wOffNHolidayConsider,
      'AllowedLateComingMinutes': allowedLateComingMinutes,
      'AllowedEarlyGoingMinutes': allowedEarlyGoingMinutes,
      'IsAHolidayAMarkA': isAHolidayAMarkA,
      'IsBreakAllowed': isBreakAllowed,
      'AWOFFDaysConstant': awoffDaysConstant,
      'IsAWoffAMarkA': isAWoffAMarkA,
      'IsAWOffMarkA': isAWOffMarkA,
      'IsWOffAMarkA': isWOffAMarkA,
    };
  }
}

class EmployeeGeneralSettings {
  final String employeeID;
  final String employeeName;
  final bool isComingLateNEarlyGoingCalculateOnWOff;
  final bool isBreakMinutesSubtractFromFullDayWork;
  final bool isBreakMinutesSubtractFromHalfDayWork;
  final int overTimeCalculations; // Corresponds to CsOverTimeCalculation enum (1: None, 2: HalfHourly, 3: Hourly)
  final int forcePunchOut; // Corresponds to CsForcePunchOutType enum (1: None, 2: ByDefault, ...)
  final String forcePunchDefaultOutTime;
  final bool isLateComingDeductionAllowed;
  final int lateComingDaysForCutOff;
  final int actionForLateComing; // Corresponds to CsLateComingAction enum (1: None, 2: CutFullDayMinutes, ...)
  final bool isRepeatLateComingAllowed;
  final bool isRotationalWeeklyOff;

  EmployeeGeneralSettings({
    required this.employeeID,
    required this.employeeName,
    required this.isComingLateNEarlyGoingCalculateOnWOff,
    required this.isBreakMinutesSubtractFromFullDayWork,
    required this.isBreakMinutesSubtractFromHalfDayWork,
    required this.overTimeCalculations,
    required this.forcePunchOut,
    required this.forcePunchDefaultOutTime,
    required this.isLateComingDeductionAllowed,
    required this.lateComingDaysForCutOff,
    required this.actionForLateComing,
    required this.isRepeatLateComingAllowed,
    required this.isRotationalWeeklyOff,
  });

  factory EmployeeGeneralSettings.fromJson(Map<String, dynamic> json) {
    return EmployeeGeneralSettings(
      employeeID: json['EmployeeID'],
      employeeName: json['EmployeeName'],
      isComingLateNEarlyGoingCalculateOnWOff: json['IsComingLateNEarlyGoingCalculateOnWOff'],
      isBreakMinutesSubtractFromFullDayWork: json['IsBreakMinutesSubtractFromFullDayWork'],
      isBreakMinutesSubtractFromHalfDayWork: json['IsBreakMinutesSubtractFromHalfDayWork'],
      overTimeCalculations: json['OverTimeCalculations'],
      forcePunchOut: json['ForcePunchOut'],
      forcePunchDefaultOutTime: json['ForcePunchDefaultOutTime'],
      isLateComingDeductionAllowed: json['IsLateComingDeductionAllowed'],
      lateComingDaysForCutOff: json['LateComingDaysForCutOff'],
      actionForLateComing: json['ActionForLateComing'],
      isRepeatLateComingAllowed: json['IsRepeatLateComingAllowed'],
      isRotationalWeeklyOff: json['IsRotationalWeeklyOff'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'EmployeeID': employeeID,
      'EmployeeName': employeeName,
      'IsComingLateNEarlyGoingCalculateOnWOff': isComingLateNEarlyGoingCalculateOnWOff,
      'IsBreakMinutesSubtractFromFullDayWork': isBreakMinutesSubtractFromFullDayWork,
      'IsBreakMinutesSubtractFromHalfDayWork': isBreakMinutesSubtractFromHalfDayWork,
      'OverTimeCalculations': overTimeCalculations,
      'ForcePunchOut': forcePunchOut,
      'ForcePunchDefaultOutTime': forcePunchDefaultOutTime,
      'IsLateComingDeductionAllowed': isLateComingDeductionAllowed,
      'LateComingDaysForCutOff': lateComingDaysForCutOff,
      'ActionForLateComing': actionForLateComing,
      'IsRepeatLateComingAllowed': isRepeatLateComingAllowed,
      'IsRotationalWeeklyOff': isRotationalWeeklyOff,
    };
  }
}

// Placeholder for EmpDeviceLogin. Its actual structure would depend on its C# definition
// and whether it's part of the serialized JSON.
class EmpDeviceLogin {
  final String mobileUserUniqueID;
  final String employeeID;
  final String employeeName;
  final String deviceInfo;
  final int deviceType; // Corresponds to CsDeviceType enum
  final String requestForApprovalOnDate;
  final String requestForApprovalOnDateDT; // C# DateTime, typically serialized as ISO 8601 string
  final bool isApproved;

  EmpDeviceLogin({
    required this.mobileUserUniqueID,
    required this.employeeID,
    required this.employeeName,
    required this.deviceInfo,
    required this.deviceType,
    required this.requestForApprovalOnDate,
    required this.requestForApprovalOnDateDT,
    required this.isApproved,
  });

  factory EmpDeviceLogin.fromJson(Map<String, dynamic> json) {
    return EmpDeviceLogin(
      mobileUserUniqueID: json['MobileUserUniqueID'] ?? "", // C# initializes with ""
      employeeID: json['EmployeeID'] ?? "", // C# initializes with string.Empty
      employeeName: json['EmployeeName'] ?? "", // C# initializes with string.Empty
      deviceInfo: json['DeviceInfo'] ?? "", // C# initializes with string.Empty
      deviceType: json['DeviceType'] ?? ApplicationType.Unknown.index, // Default to Unknown if not present
      requestForApprovalOnDate: json['RequestForApprovalOnDate'] ?? "", // C# initializes with string.Empty
      requestForApprovalOnDateDT: json['RequestForApprovalOnDateDT'] ?? DateTime.fromMillisecondsSinceEpoch(0).toIso8601String(), // C# DateTime.MinValue
      isApproved: json['IsApproved'] ?? false, // C# initializes with false
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MobileUserUniqueID': mobileUserUniqueID,
      'EmployeeID': employeeID,
      'EmployeeName': employeeName,
      'DeviceInfo': deviceInfo,
      'DeviceType': deviceType,
      'RequestForApprovalOnDate': requestForApprovalOnDate,
      'RequestForApprovalOnDateDT': requestForApprovalOnDateDT,
      'IsApproved': isApproved,
    };
  }
}

class EmpLogin {
  final String employeeID;
  final bool isPasswordSet;
  final String employeeName;
  final String employeePassword;
  final String employeePasswordConfirm; // Typically not part of a persisted model
  final String roleType;
  final bool isEnabled;
  final bool canPunchInGeoFence;
  final bool canPunchFromHome;
  final EmpDeviceLogin? empDeviceLogin; // Updated to use the detailed EmpDeviceLogin
  final bool canView;
  final bool canApplyForManualAttendance;
  final bool canApplyForLeave;
  final bool canApplyForTour;
  final bool? canApplyForOutDoor;
  final int empLoginModeCreated; // Corresponds to CsEmpLoginModeCreated enum
  final bool hasSubordinate;
  final String? roleAsSuperior;
  final String listOfSubordinatesEmployeeID;

  EmpLogin({
    required this.employeeID,
    required this.isPasswordSet,
    required this.employeeName,
    required this.employeePassword,
    required this.employeePasswordConfirm,
    required this.roleType,
    required this.isEnabled,
    required this.canPunchInGeoFence,
    required this.canPunchFromHome,
    this.empDeviceLogin,
    required this.canView,
    required this.canApplyForManualAttendance,
    required this.canApplyForLeave,
    required this.canApplyForTour,
    this.canApplyForOutDoor,
    required this.empLoginModeCreated,
    required this.hasSubordinate,
    this.roleAsSuperior,
    required this.listOfSubordinatesEmployeeID,
  });

  factory EmpLogin.fromJson(Map<String, dynamic> json) {
    return EmpLogin(
      employeeID: json['EmployeeID'],
      isPasswordSet: json['IsPasswordSet'],
      employeeName: json['EmployeeName'],
      employeePassword: json['EmployeePassword'],
      employeePasswordConfirm: json['EmployeePasswordConfirm'],
      roleType: json['RoleType'],
      isEnabled: json['IsEnabled'],
      canPunchInGeoFence: json['CanPunchInGeoFence'],
      canPunchFromHome: json['CanPunchFromHome'],
      empDeviceLogin: json['EmpDeviceLogin'] != null
          ? EmpDeviceLogin.fromJson(json['EmpDeviceLogin']) // Updated
          : null,
      canView: json['CanView'],
      canApplyForManualAttendance: json['CanApplyForManualAttendance'],
      canApplyForLeave: json['CanApplyForLeave'],
      canApplyForTour: json['CanApplyForTour'],
      canApplyForOutDoor: json.containsKey('CanApplyForOutDoor') ? json['CanApplyForOutDoor'] : null,
      empLoginModeCreated: json['EmpLoginModeCreated'],
      hasSubordinate: json['HasSubordinate'],
      roleAsSuperior: json.containsKey('RoleAsSuperior') ? json['RoleAsSuperior'] : null,
      listOfSubordinatesEmployeeID: json['ListOfSubordinatesEmployeeID'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'EmployeeID': employeeID,
      'IsPasswordSet': isPasswordSet,
      'EmployeeName': employeeName,
      'EmployeePassword': employeePassword,
      'EmployeePasswordConfirm': employeePasswordConfirm,
      'RoleType': roleType,
      'IsEnabled': isEnabled,
      'CanPunchInGeoFence': canPunchInGeoFence,
      'CanPunchFromHome': canPunchFromHome,
      if (empDeviceLogin != null) 'EmpDeviceLogin': empDeviceLogin!.toJson(), // Updated
      'CanView': canView,
      'CanApplyForManualAttendance': canApplyForManualAttendance,
      'CanApplyForLeave': canApplyForLeave,
      'CanApplyForTour': canApplyForTour,
      if (canApplyForOutDoor != null) 'CanApplyForOutDoor': canApplyForOutDoor,
      'EmpLoginModeCreated': empLoginModeCreated,
      'HasSubordinate': hasSubordinate,
      if (roleAsSuperior != null) 'RoleAsSuperior': roleAsSuperior,
      'ListOfSubordinatesEmployeeID': listOfSubordinatesEmployeeID,
    };
  }
}


// endregion Model Classes