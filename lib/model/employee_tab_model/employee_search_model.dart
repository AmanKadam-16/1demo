import 'dart:convert';

class EmployeeView {
  String? employeeID;
  String? employeeName;
  String? enrollID;
  String? companyID;
  String? companyName;
  String? departmentID;
  String? departmentName;
  String? designationID;
  String? designationName;
  String? locationID;
  String? locationName;
  int? employeeStatus;
  String? employeeType;
  String? employeeTypeID;
  String? mobileNumber;
  String? emailID;
  String? dateOfEmployment;
  String? seniorEmployeeID;
  String? seniorEmployeeName;
  String? skipLevelSeniorEmployeeID;
  String? skipLevelSeniorEmployeeName;
  String? settingProfileID;
  String? settingProfileName;

  EmployeeView({
    this.employeeID = "",
    this.employeeName = "",
    this.enrollID = "",
    this.companyID = "",
    this.companyName = "",
    this.departmentID = "",
    this.departmentName = "",
    this.designationID = "",
    this.designationName = "",
    this.locationID = "",
    this.locationName = "",
    this.employeeStatus = 1,
    this.employeeType = "",
    this.employeeTypeID = "",
    this.mobileNumber = "",
    this.emailID = "",
    this.dateOfEmployment = "",
    this.seniorEmployeeID = "",
    this.seniorEmployeeName = "",
    this.skipLevelSeniorEmployeeID = "",
    this.skipLevelSeniorEmployeeName = "",
    this.settingProfileID = "",
    this.settingProfileName = "",
  });

  Map<String, dynamic> toJson() {
    return {
      'EmployeeID': employeeID,
      'EmployeeName': employeeName,
      'EnrollID': enrollID,
      'CompanyID': companyID,
      'CompanyName': companyName,
      'DepartmentID': departmentID,
      'DepartmentName': departmentName,
      'DesignationID': designationID,
      'DesignationName': designationName,
      'LocationID': locationID,
      'LocationName': locationName,
      'EmployeeStatus': employeeStatus,
      'EmployeeType': employeeType,
      'EmployeeTypeID': employeeTypeID,
      'MobileNumber': mobileNumber,
      'EmailID': emailID,
      'DateOfEmployment': dateOfEmployment,
      'SeniorEmployeeID': seniorEmployeeID,
      'SeniorEmployeeName': seniorEmployeeName,
      'SkipLevelSeniorEmployeeID': skipLevelSeniorEmployeeID,
      'SkipLevelSeniorEmployeeName': skipLevelSeniorEmployeeName,
      'SettingProfileID': settingProfileID,
      'SettingProfileName': settingProfileName,
    };
  }

  factory EmployeeView.fromJson(Map<String, dynamic> json) {
    return EmployeeView(
      employeeID: json['EmployeeID'] ?? "",
      employeeName: json['EmployeeName'] ?? "",
      enrollID: json['EnrollID'] ?? "",
      companyID: json['CompanyID'] ?? "",
      companyName: json['CompanyName'] ?? "",
      departmentID: json['DepartmentID'] ?? "",
      departmentName: json['DepartmentName'] ?? "",
      designationID: json['DesignationID'] ?? "",
      designationName: json['DesignationName'] ?? "",
      locationID: json['LocationID'] ?? "",
      locationName: json['LocationName'] ?? "",
      employeeStatus: json['EmployeeStatus'] ?? 1,
      employeeType: json['EmployeeType'] ?? "",
      employeeTypeID: json['EmployeeTypeID'] ?? "",
      mobileNumber: json['MobileNumber'] ?? "",
      emailID: json['EmailID'] ?? "",
      dateOfEmployment: json['DateOfEmployment'] ?? "",
      seniorEmployeeID: json['SeniorEmployeeID'] ?? "",
      seniorEmployeeName: json['SeniorEmployeeName'] ?? "",
      skipLevelSeniorEmployeeID: json['SkipLevelSeniorEmployeeID'] ?? "",
      skipLevelSeniorEmployeeName: json['SkipLevelSeniorEmployeeName'] ?? "",
      settingProfileID: json['SettingProfileID'] ?? "",
      settingProfileName: json['SettingProfileName'] ?? "",
    );
  }
}

class InsigniaObjectListInRange {
  int iStartIndex;
  int iRecordsPerPage;

  InsigniaObjectListInRange({
    this.iStartIndex = 0,
    this.iRecordsPerPage = 10,
  });

  Map<String, dynamic> toJson() {
    return {
      'iStartIndex': iStartIndex,
      'iRecordsPerPage': iRecordsPerPage,
    };
  }
}

class EmployeeSearchRequest {
  EmployeeView employeeView;
  InsigniaObjectListInRange insigniaObjectListInRange;

  EmployeeSearchRequest({
    required this.employeeView,
    InsigniaObjectListInRange? insigniaObjectListInRange,
  }) : insigniaObjectListInRange = insigniaObjectListInRange ?? InsigniaObjectListInRange();

  Map<String, dynamic> toJson() {
    return {
      'EmployeeView': employeeView.toJson(),
      'InsigniaObjectListInRange': insigniaObjectListInRange.toJson(),
    };
  }
}

class EmployeeSearchResponse {
  bool isMultipleRecordsInJson;
  bool isResultPass;
  int loginMode;
  String resultMessage;
  int resultRecordCount;
  String resultRecordJson;
  int totalRecordCount;
  List<EmployeeView> employees;

  EmployeeSearchResponse({
    this.isMultipleRecordsInJson = false,
    this.isResultPass = false,
    this.loginMode = 0,
    this.resultMessage = "",
    this.resultRecordCount = 0,
    this.resultRecordJson = "",
    this.totalRecordCount = 0,
    this.employees = const [],
  });

  factory EmployeeSearchResponse.fromJson(Map<String, dynamic> json) {
    List<EmployeeView> parseEmployees(String jsonString) {
      List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => EmployeeView.fromJson(json)).toList();
    }

    return EmployeeSearchResponse(
      isMultipleRecordsInJson: json['IsMultipleRecordsInJson'] ?? false,
      isResultPass: json['IsResultPass'] ?? false,
      loginMode: json['LoginMode'] ?? 0,
      resultMessage: json['ResultMessage'] ?? "",
      resultRecordCount: json['ResultRecordCount'] ?? 0,
      resultRecordJson: json['ResultRecordJson'] ?? "",
      totalRecordCount: json['TotalRecordCount'] ?? 0,
      employees: json['ResultRecordJson'] != null ? parseEmployees(json['ResultRecordJson']) : [],
    );
  }
}