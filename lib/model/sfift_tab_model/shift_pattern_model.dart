class ShiftPatternModel {
  final String patternId;
  final String patternName;
  final List<ListOfShift> listOfShifts;

  ShiftPatternModel({
    this.patternId = '',
    required this.patternName,
    this.listOfShifts = const [],
  });
}

class ListOfShift {
  final String shiftId;
  final String shiftName;
  final String shiftType;

  ListOfShift({
    required this.shiftId,
    required this.shiftName,
    required this.shiftType,
  });
}