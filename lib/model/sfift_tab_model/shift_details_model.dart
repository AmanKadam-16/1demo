class SiftDetailsModel {
  String? _shiftID;
  String? _shiftName;
  String? _inTime;
  String? _outTime;
  bool? _isShiftEndNextDay;
  bool? _isShiftStartsPreviousDay;
  int? _fullDayMinutes;
  int? _halfDayMinutes;
  bool? _isOTAllowed;
  int? _oTStartMinutes;
  int? _oTGraceMinutes;
  bool? _isOTStartsAtShiftEnd;
  String? _lunchInTime;
  String? _lunchOutTime;
  int? _lunchMins;
  int? _otherBreakMins;
  String? _autoShiftInTimeStart;
  String? _autoShiftInTimeEnd;
  int? _autoShiftLapseTime;
  bool? _isShiftAutoAssigned;
  bool? _isDefaultShift;

  SiftDetailsModel(
      {String? shiftID,
      String? shiftName,
      String? inTime,
      String? outTime,
      bool? isShiftEndNextDay,
      bool? isShiftStartsPreviousDay,
      int? fullDayMinutes,
      int? halfDayMinutes,
      bool? isOTAllowed,
      int? oTStartMinutes,
      int? oTGraceMinutes,
      bool? isOTStartsAtShiftEnd,
      String? lunchInTime,
      String? lunchOutTime,
      int? lunchMins,
      int? otherBreakMins,
      String? autoShiftInTimeStart,
      String? autoShiftInTimeEnd,
      int? autoShiftLapseTime,
      bool? isShiftAutoAssigned,
      bool? isDefaultShift}) {
    if (shiftID != null) {
      this._shiftID = shiftID;
    }
    if (shiftName != null) {
      this._shiftName = shiftName;
    }
    if (inTime != null) {
      this._inTime = inTime;
    }
    if (outTime != null) {
      this._outTime = outTime;
    }
    if (isShiftEndNextDay != null) {
      this._isShiftEndNextDay = isShiftEndNextDay;
    }
    if (isShiftStartsPreviousDay != null) {
      this._isShiftStartsPreviousDay = isShiftStartsPreviousDay;
    }
    if (fullDayMinutes != null) {
      this._fullDayMinutes = fullDayMinutes;
    }
    if (halfDayMinutes != null) {
      this._halfDayMinutes = halfDayMinutes;
    }
    if (isOTAllowed != null) {
      this._isOTAllowed = isOTAllowed;
    }
    if (oTStartMinutes != null) {
      this._oTStartMinutes = oTStartMinutes;
    }
    if (oTGraceMinutes != null) {
      this._oTGraceMinutes = oTGraceMinutes;
    }
    if (isOTStartsAtShiftEnd != null) {
      this._isOTStartsAtShiftEnd = isOTStartsAtShiftEnd;
    }
    if (lunchInTime != null) {
      this._lunchInTime = lunchInTime;
    }
    if (lunchOutTime != null) {
      this._lunchOutTime = lunchOutTime;
    }
    if (lunchMins != null) {
      this._lunchMins = lunchMins;
    }
    if (otherBreakMins != null) {
      this._otherBreakMins = otherBreakMins;
    }
    if (autoShiftInTimeStart != null) {
      this._autoShiftInTimeStart = autoShiftInTimeStart;
    }
    if (autoShiftInTimeEnd != null) {
      this._autoShiftInTimeEnd = autoShiftInTimeEnd;
    }
    if (autoShiftLapseTime != null) {
      this._autoShiftLapseTime = autoShiftLapseTime;
    }
    if (isShiftAutoAssigned != null) {
      this._isShiftAutoAssigned = isShiftAutoAssigned;
    }
    if (isDefaultShift != null) {
      this._isDefaultShift = isDefaultShift;
    }
  }

  String? get shiftID => _shiftID;
  set shiftID(String? shiftID) => _shiftID = shiftID;
  String? get shiftName => _shiftName;
  set shiftName(String? shiftName) => _shiftName = shiftName;
  String? get inTime => _inTime;
  set inTime(String? inTime) => _inTime = inTime;
  String? get outTime => _outTime;
  set outTime(String? outTime) => _outTime = outTime;
  bool? get isShiftEndNextDay => _isShiftEndNextDay;
  set isShiftEndNextDay(bool? isShiftEndNextDay) =>
      _isShiftEndNextDay = isShiftEndNextDay;
  bool? get isShiftStartsPreviousDay => _isShiftStartsPreviousDay;
  set isShiftStartsPreviousDay(bool? isShiftStartsPreviousDay) =>
      _isShiftStartsPreviousDay = isShiftStartsPreviousDay;
  int? get fullDayMinutes => _fullDayMinutes;
  set fullDayMinutes(int? fullDayMinutes) => _fullDayMinutes = fullDayMinutes;
  int? get halfDayMinutes => _halfDayMinutes;
  set halfDayMinutes(int? halfDayMinutes) => _halfDayMinutes = halfDayMinutes;
  bool? get isOTAllowed => _isOTAllowed;
  set isOTAllowed(bool? isOTAllowed) => _isOTAllowed = isOTAllowed;
  int? get oTStartMinutes => _oTStartMinutes;
  set oTStartMinutes(int? oTStartMinutes) => _oTStartMinutes = oTStartMinutes;
  int? get oTGraceMinutes => _oTGraceMinutes;
  set oTGraceMinutes(int? oTGraceMinutes) => _oTGraceMinutes = oTGraceMinutes;
  bool? get isOTStartsAtShiftEnd => _isOTStartsAtShiftEnd;
  set isOTStartsAtShiftEnd(bool? isOTStartsAtShiftEnd) =>
      _isOTStartsAtShiftEnd = isOTStartsAtShiftEnd;
  String? get lunchInTime => _lunchInTime;
  set lunchInTime(String? lunchInTime) => _lunchInTime = lunchInTime;
  String? get lunchOutTime => _lunchOutTime;
  set lunchOutTime(String? lunchOutTime) => _lunchOutTime = lunchOutTime;
  int? get lunchMins => _lunchMins;
  set lunchMins(int? lunchMins) => _lunchMins = lunchMins;
  int? get otherBreakMins => _otherBreakMins;
  set otherBreakMins(int? otherBreakMins) => _otherBreakMins = otherBreakMins;
  String? get autoShiftInTimeStart => _autoShiftInTimeStart;
  set autoShiftInTimeStart(String? autoShiftInTimeStart) =>
      _autoShiftInTimeStart = autoShiftInTimeStart;
  String? get autoShiftInTimeEnd => _autoShiftInTimeEnd;
  set autoShiftInTimeEnd(String? autoShiftInTimeEnd) =>
      _autoShiftInTimeEnd = autoShiftInTimeEnd;
  int? get autoShiftLapseTime => _autoShiftLapseTime;
  set autoShiftLapseTime(int? autoShiftLapseTime) =>
      _autoShiftLapseTime = autoShiftLapseTime;
  bool? get isShiftAutoAssigned => _isShiftAutoAssigned;
  set isShiftAutoAssigned(bool? isShiftAutoAssigned) =>
      _isShiftAutoAssigned = isShiftAutoAssigned;
  bool? get isDefaultShift => _isDefaultShift;
  set isDefaultShift(bool? isDefaultShift) => _isDefaultShift = isDefaultShift;

  SiftDetailsModel.fromJson(Map<String, dynamic> json) {
    _shiftID = json['ShiftID'];
    _shiftName = json['ShiftName'];
    _inTime = json['InTime'];
    _outTime = json['OutTime'];
    _isShiftEndNextDay = json['IsShiftEndNextDay'];
    _isShiftStartsPreviousDay = json['IsShiftStartsPreviousDay'];
    _fullDayMinutes = json['FullDayMinutes'];
    _halfDayMinutes = json['HalfDayMinutes'];
    _isOTAllowed = json['IsOTAllowed'];
    _oTStartMinutes = json['OTStartMinutes'];
    _oTGraceMinutes = json['OTGraceMinutes'];
    _isOTStartsAtShiftEnd = json['IsOTStartsAtShiftEnd'];
    _lunchInTime = json['LunchInTime'];
    _lunchOutTime = json['LunchOutTime'];
    _lunchMins = json['LunchMins'];
    _otherBreakMins = json['OtherBreakMins'];
    _autoShiftInTimeStart = json['AutoShiftInTimeStart'];
    _autoShiftInTimeEnd = json['AutoShiftInTimeEnd'];
    _autoShiftLapseTime = json['AutoShiftLapseTime'];
    _isShiftAutoAssigned = json['IsShiftAutoAssigned'];
    _isDefaultShift = json['IsDefaultShift'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ShiftID'] = this._shiftID;
    data['ShiftName'] = this._shiftName;
    data['InTime'] = this._inTime;
    data['OutTime'] = this._outTime;
    data['IsShiftEndNextDay'] = this._isShiftEndNextDay;
    data['IsShiftStartsPreviousDay'] = this._isShiftStartsPreviousDay;
    data['FullDayMinutes'] = this._fullDayMinutes;
    data['HalfDayMinutes'] = this._halfDayMinutes;
    data['IsOTAllowed'] = this._isOTAllowed;
    data['OTStartMinutes'] = this._oTStartMinutes;
    data['OTGraceMinutes'] = this._oTGraceMinutes;
    data['IsOTStartsAtShiftEnd'] = this._isOTStartsAtShiftEnd;
    data['LunchInTime'] = this._lunchInTime;
    data['LunchOutTime'] = this._lunchOutTime;
    data['LunchMins'] = this._lunchMins;
    data['OtherBreakMins'] = this._otherBreakMins;
    data['AutoShiftInTimeStart'] = this._autoShiftInTimeStart;
    data['AutoShiftInTimeEnd'] = this._autoShiftInTimeEnd;
    data['AutoShiftLapseTime'] = this._autoShiftLapseTime;
    data['IsShiftAutoAssigned'] = this._isShiftAutoAssigned;
    data['IsDefaultShift'] = this._isDefaultShift;
    return data;
  }
}
