import 'dart:convert';

// It's generally good practice for this to be in its own file if it's complex
// or used elsewhere. For simplicity here, it's part of the shift_pattern_model logic.

class ListOfShift {
  final String shiftId;
  final String shiftName;
  final String inTime;
  final String outTime;
  final bool isShiftEndNextDay;
  final bool isShiftStartsPreviousDay;
  final int fullDayMinutes;
  final int halfDayMinutes;
  final bool isOTAllowed;
  final int otStartMinutes;
  final int otGraceMinutes;
  final bool isOTStartsAtShiftEnd;
  final String lunchInTime;
  final String lunchOutTime;
  final int lunchMins;
  final int otherBreakMins;
  final String autoShiftInTimeStart;
  final String autoShiftInTimeEnd;
  final int autoShiftLapseTime;
  final bool isShiftAutoAssigned;
  final bool isDefaultShift;
  // Added for UI interaction, not from JSON directly
  // final String shiftType; // You might want to determine this or pass it if needed

  ListOfShift({
    required this.shiftId,
    required this.shiftName,
    required this.inTime,
    required this.outTime,
    required this.isShiftEndNextDay,
    required this.isShiftStartsPreviousDay,
    required this.fullDayMinutes,
    required this.halfDayMinutes,
    required this.isOTAllowed,
    required this.otStartMinutes,
    required this.otGraceMinutes,
    required this.isOTStartsAtShiftEnd,
    required this.lunchInTime,
    required this.lunchOutTime,
    required this.lunchMins,
    required this.otherBreakMins,
    required this.autoShiftInTimeStart,
    required this.autoShiftInTimeEnd,
    required this.autoShiftLapseTime,
    required this.isShiftAutoAssigned,
    required this.isDefaultShift,
    // this.shiftType = "General", // Default value, adjust as needed
  });

  factory ListOfShift.fromJson(Map<String, dynamic> json) => ListOfShift(
        shiftId: json["ShiftID"],
        shiftName: json["ShiftName"],
        inTime: json["InTime"],
        outTime: json["OutTime"],
        isShiftEndNextDay: json["IsShiftEndNextDay"],
        isShiftStartsPreviousDay: json["IsShiftStartsPreviousDay"],
        fullDayMinutes: json["FullDayMinutes"],
        halfDayMinutes: json["HalfDayMinutes"],
        isOTAllowed: json["IsOTAllowed"],
        otStartMinutes: json["OTStartMinutes"],
        otGraceMinutes: json["OTGraceMinutes"],
        isOTStartsAtShiftEnd: json["IsOTStartsAtShiftEnd"],
        lunchInTime: json["LunchInTime"],
        lunchOutTime: json["LunchOutTime"],
        lunchMins: json["LunchMins"],
        otherBreakMins: json["OtherBreakMins"],
        autoShiftInTimeStart: json["AutoShiftInTimeStart"],
        autoShiftInTimeEnd: json["AutoShiftInTimeEnd"],
        autoShiftLapseTime: json["AutoShiftLapseTime"],
        isShiftAutoAssigned: json["IsShiftAutoAssigned"],
        isDefaultShift: json["IsDefaultShift"],
        // shiftType is not in the provided JSON for ListOfShift,
        // so you might need to derive it or handle it differently if it's crucial.
        // For now, I'll use a default or expect it to be set externally.
        // shiftType: json["ShiftType"] ?? "General", // Example: if ShiftType might be in JSON
      );

  Map<String, dynamic> toJson() => {
        "ShiftID": shiftId,
        "ShiftName": shiftName,
        "InTime": inTime,
        "OutTime": outTime,
        "IsShiftEndNextDay": isShiftEndNextDay,
        "IsShiftStartsPreviousDay": isShiftStartsPreviousDay,
        "FullDayMinutes": fullDayMinutes,
        "HalfDayMinutes": halfDayMinutes,
        "IsOTAllowed": isOTAllowed,
        "OTStartMinutes": otStartMinutes,
        "OTGraceMinutes": otGraceMinutes,
        "IsOTStartsAtShiftEnd": isOTStartsAtShiftEnd,
        "LunchInTime": lunchInTime,
        "LunchOutTime": lunchOutTime,
        "LunchMins": lunchMins,
        "OtherBreakMins": otherBreakMins,
        "AutoShiftInTimeStart": autoShiftInTimeStart,
        "AutoShiftInTimeEnd": autoShiftInTimeEnd,
        "AutoShiftLapseTime": autoShiftLapseTime,
        "IsShiftAutoAssigned": isShiftAutoAssigned,
        "IsDefaultShift": isDefaultShift,
        // "ShiftType": shiftType,
      };
}