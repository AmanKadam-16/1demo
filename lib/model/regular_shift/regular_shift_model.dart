class RegularShiftModel {
  String employeeID;
  String employeeName;
  String startDate;
  String? startDateTime;
  int type;
  String shiftID;
  String shiftName;
  String patternID;
  String patternName;
  String shiftConstantDays;

  RegularShiftModel({
    required this.employeeID,
    required this.employeeName,
    required this.startDate,
    this.startDateTime,
    required this.type,
    required this.shiftID,
    required this.shiftName,
    required this.patternID,
    required this.patternName,
    required this.shiftConstantDays,
  });

  factory RegularShiftModel.fromJson(Map<String, dynamic> json) {
    return RegularShiftModel(
      employeeID: json['EmployeeID'] ?? '',
      employeeName: json['EmployeeName'] ?? '',
      startDate: json['StartDate'] ?? '',
      startDateTime: json['StartDateTime'],
      type: json['Type'] ?? 0,
      shiftID: json['ShiftID'] ?? '',
      shiftName: json['ShiftName'] ?? '',
      patternID: json['PatternID'] ?? '',
      patternName: json['PatternName'] ?? '',
      shiftConstantDays: json['ShiftConstantDays'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'EmployeeID': employeeID,
      'EmployeeName': employeeName,
      'StartDate': startDate,
      if (startDateTime != null) 'StartDateTime': startDateTime,
      'Type': type,
      'ShiftID': shiftID,
      'ShiftName': shiftName,
      'PatternID': patternID,
      'PatternName': patternName,
      'ShiftConstantDays': shiftConstantDays,
    };
  }
}
