import 'dart:convert';
import 'list_of_shift_model.dart'; // We'll create this file next

List<ShiftPatternModel> shiftPatternModelFromJson(String str) =>
    List<ShiftPatternModel>.from(
        json.decode(str).map((x) => ShiftPatternModel.fromJson(x)));

String shiftPatternModelToJson(List<ShiftPatternModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ShiftPatternModel {
  final int patternId;
  final String patternName;
  final String pattern; // Comma-separated shift IDs
  final List<String> shiftsInPattern; // List of shift IDs
  final List<ListOfShift> listOfShifts; // Detailed shift objects

  ShiftPatternModel({
    required this.patternId,
    required this.patternName,
    required this.pattern,
    required this.shiftsInPattern,
    required this.listOfShifts,
  });

  factory ShiftPatternModel.fromJson(Map<String, dynamic> json) =>
      ShiftPatternModel(
        patternId: json["PatternID"],
        patternName: json["PatternName"],
        pattern: json["Pattern"],
        shiftsInPattern:
            List<String>.from(json["ShiftsInPattern"].map((x) => x)),
        listOfShifts: List<ListOfShift>.from(
            json["ListOfShift"].map((x) => ListOfShift.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "PatternID": patternId,
        "PatternName": patternName,
        "Pattern": pattern,
        "ShiftsInPattern": List<dynamic>.from(shiftsInPattern.map((x) => x)),
        "ListOfShift": List<dynamic>.from(listOfShifts.map((x) => x.toJson())),
      };

  // Helper to get a display string for the pattern (e.g., showing shift names)
  String get patternDisplayString {
    return listOfShifts.map((s) => s.shiftName).join(' -> ');
  }
}