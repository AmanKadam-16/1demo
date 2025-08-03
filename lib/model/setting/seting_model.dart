class EmployeeSettings {
  String punchType;
  String outTime;
  String lateComingMinutes;
  String earlyGoingMinutes;
  String calculationType;
  String fullDayMins;
  String halfDayMins;
  bool isOvertimeAllowed;
  String otGraceMins;
  String otCalculation;
  bool allowBreaks;
  bool deductBreakFullDay;
  bool deductBreakHalfDay;
  String weeklyOffType;
  String weeklyOffConsideration;
  String holidayConsideration;
  String sameDayConsideration;
  String absentHolidayMark;
  String absentDays;
  String absentMarkType;
  bool calculateLateEarlyMinutes;
  bool isWeeklyOffRotational;
  String forcePunchOut;
  bool considerLateDeduction;
  String lateComingDays;
  String lateComingAction;
  bool isRepeatLateDeduction;

  EmployeeSettings({
    this.punchType = 'single',
    this.outTime = '00:00',
    this.lateComingMinutes = '120',
    this.earlyGoingMinutes = '120',
    this.calculationType = 'employee',
    this.fullDayMins = '120',
    this.halfDayMins = '120',
    this.isOvertimeAllowed = false,
    this.otGraceMins = '0',
    this.otCalculation = 'none',
    this.allowBreaks = true,
    this.deductBreakFullDay = false,
    this.deductBreakHalfDay = false,
    this.weeklyOffType = 'compensatoryOff',
    this.weeklyOffConsideration = 'leave',
    this.holidayConsideration = 'leave',
    this.sameDayConsideration = 'holiday',
    this.absentHolidayMark = 'holiday',
    this.absentDays = '0',
    this.absentMarkType = 'prefix',
    this.calculateLateEarlyMinutes = false,
    this.isWeeklyOffRotational = false,
    this.forcePunchOut = 'none',
    this.considerLateDeduction = true,
    this.lateComingDays = '0',
    this.lateComingAction = 'none',
    this.isRepeatLateDeduction = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'punchType': punchType,
      'outTime': outTime,
      'lateComingMinutes': lateComingMinutes,
      'earlyGoingMinutes': earlyGoingMinutes,
      'calculationType': calculationType,
      'fullDayMins': fullDayMins,
      'halfDayMins': halfDayMins,
      'isOvertimeAllowed': isOvertimeAllowed,
      'otGraceMins': otGraceMins,
      'otCalculation': otCalculation,
      'allowBreaks': allowBreaks,
      'deductBreakFullDay': deductBreakFullDay,
      'deductBreakHalfDay': deductBreakHalfDay,
      'weeklyOffType': weeklyOffType,
      'weeklyOffConsideration': weeklyOffConsideration,
      'holidayConsideration': holidayConsideration,
      'sameDayConsideration': sameDayConsideration,
      'absentHolidayMark': absentHolidayMark,
      'absentDays': absentDays,
      'absentMarkType': absentMarkType,
      'calculateLateEarlyMinutes': calculateLateEarlyMinutes,
      'isWeeklyOffRotational': isWeeklyOffRotational,
      'forcePunchOut': forcePunchOut,
      'considerLateDeduction': considerLateDeduction,
      'lateComingDays': lateComingDays,
      'lateComingAction': lateComingAction,
      'isRepeatLateDeduction': isRepeatLateDeduction,
    };
  }

  factory EmployeeSettings.fromJson(Map<String, dynamic> json) {
    return EmployeeSettings(
      punchType: json['punchType'] ?? 'single',
      outTime: json['outTime'] ?? '00:00',
      lateComingMinutes: json['lateComingMinutes'] ?? '120',
      earlyGoingMinutes: json['earlyGoingMinutes'] ?? '120',
      calculationType: json['calculationType'] ?? 'employee',
      fullDayMins: json['fullDayMins'] ?? '120',
      halfDayMins: json['halfDayMins'] ?? '120',
      isOvertimeAllowed: json['isOvertimeAllowed'] ?? false,
      otGraceMins: json['otGraceMins'] ?? '0',
      otCalculation: json['otCalculation'] ?? 'none',
      allowBreaks: json['allowBreaks'] ?? true,
      deductBreakFullDay: json['deductBreakFullDay'] ?? false,
      deductBreakHalfDay: json['deductBreakHalfDay'] ?? false,
      weeklyOffType: json['weeklyOffType'] ?? 'compensatoryOff',
      weeklyOffConsideration: json['weeklyOffConsideration'] ?? 'leave',
      holidayConsideration: json['holidayConsideration'] ?? 'leave',
      sameDayConsideration: json['sameDayConsideration'] ?? 'holiday',
      absentHolidayMark: json['absentHolidayMark'] ?? 'holiday',
      absentDays: json['absentDays'] ?? '0',
      absentMarkType: json['absentMarkType'] ?? 'prefix',
      calculateLateEarlyMinutes: json['calculateLateEarlyMinutes'] ?? false,
      isWeeklyOffRotational: json['isWeeklyOffRotational'] ?? false,
      forcePunchOut: json['forcePunchOut'] ?? 'none',
      considerLateDeduction: json['considerLateDeduction'] ?? true,
      lateComingDays: json['lateComingDays'] ?? '0',
      lateComingAction: json['lateComingAction'] ?? 'none',
      isRepeatLateDeduction: json['isRepeatLateDeduction'] ?? true,
    );
  }
}