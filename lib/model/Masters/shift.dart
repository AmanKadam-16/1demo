
class Shift
{
  String _ShiftID=''  ;
  String _ShiftName='';
   String _InTime = '';
   String _OutTime = '';
   bool _IsEndsInNextDay = false;  //  e.g. shift '23-Dec-2024 10:00 pm' to '23-Dec-2024 6:00 am' then next day flag will be true
   bool _IsStartFromPreviousDay = false;  //  e.g. shift '23-Dec-2024 12:00 am' to '23-Dec-2024 8:00 am'
                                          // means it start actually actually  23-Dec-2024, but it night shift,
                                          //  in some companies attendance calculation is done for date 22-Dec-2024 so this flag will be true
   int _FullDayMinutes = 0;
   int _HalfDayMinutes = 0;
   bool _IsOTAllowed = false;
   int _OTStartMins = 0;
   int _OTGraceMinutes = 0;
   bool _IsOTStartsAtShiftEnd = false;
   String _LunchInTime = '';
   String _LunchOutTime = '';
   int _LunchMins = 0;
   int _OtherBreakMins = 0;
   String _AutoShiftInTimeStart = '';
   String _AutoShiftInTimeEnd = '';
   int _AutoShiftLapseTime = 0;
  bool _IsShiftAutoAssigned=false;
   bool _IsDefaultShift = false;


  String get ShiftID => _ShiftID;
  set ShiftID(strShiftID){_ShiftID=strShiftID;}

  String get ShiftName => _ShiftName;
  set ShiftName(strShiftName){_ShiftName=strShiftName;}

  String get InTime => _InTime;
  set InTime(strInTime){_InTime=strInTime;}

  String get OutTime => _OutTime;
  set OutTime(strOutTime){_OutTime=strOutTime;}

  bool get IsEndsInNextDay => _IsEndsInNextDay;
  set IsEndsInNextDay(bIsEndsInNextDay){_IsEndsInNextDay=bIsEndsInNextDay;}

  bool get IsStartFromPreviousDay => _IsStartFromPreviousDay;
  set IsStartFromPreviousDay(bIsStartFromPreviousDay){_IsStartFromPreviousDay=bIsStartFromPreviousDay;}

  int get FullDayMinutes => _FullDayMinutes;
  set FullDayMinutes(iFullDayMinutes){_FullDayMinutes=iFullDayMinutes;}
  int get HalfDayMinutes => _HalfDayMinutes;
  set  HalfDayMinutes(int iHalfDayMinutes )
  {
    _HalfDayMinutes = iHalfDayMinutes;
  }
  bool get IsOTAllowed => _IsOTAllowed;
  set  IsOTAllowed(bool iIsOTAllowed )
  {
    _IsOTAllowed = iIsOTAllowed;
  }
  int get OTStartMins => _OTStartMins;
  set OTStartMins(iOTStartMins){_OTStartMins=iOTStartMins;}
  
  int get OTGraceMinutes => _OTGraceMinutes;
  set OTGraceMinutes(iOTGraceMinutes){_OTGraceMinutes=iOTGraceMinutes;}
  
  bool get IsOTStartsAtShiftEnd => _IsOTStartsAtShiftEnd;
  set IsOTStartsAtShiftEnd(bIsOTStartsAtShiftEnd){_IsOTStartsAtShiftEnd=bIsOTStartsAtShiftEnd;}
  
  String get LunchInTime => _LunchInTime;
  set LunchInTime(strLunchInTime){_LunchInTime=strLunchInTime;}
  
  String get LunchOutTime => _LunchOutTime;
  set LunchOutTime(strLunchOutTime){_LunchOutTime=strLunchOutTime;}
  
  int get LunchMins => _LunchMins;
  set LunchMins(iLunchMins){_LunchMins=iLunchMins;}
  
  int get OtherBreakMins => _OtherBreakMins;
  set OtherBreakMins(iOtherBreakMins){_OtherBreakMins=iOtherBreakMins;}
  
  String get AutoShiftInTimeStart => _AutoShiftInTimeStart;
  set AutoShiftInTimeStart(strAutoShiftInTimeStart){_AutoShiftInTimeStart=strAutoShiftInTimeStart;}
  
  String get AutoShiftInTimeEnd => _AutoShiftInTimeEnd;
  set AutoShiftInTimeEnd(strAutoShiftInTimeEnd){_AutoShiftInTimeEnd=strAutoShiftInTimeEnd;}

  int get AutoShiftLapseTime => _AutoShiftLapseTime;
  set AutoShiftLapseTime(iAutoShiftLapseTime){_AutoShiftLapseTime=iAutoShiftLapseTime;}
  bool get IsShiftAutoAssigned => _IsShiftAutoAssigned;
  set IsShiftAutoAssigned(bIsShiftAutoAssigned){_IsShiftAutoAssigned=bIsShiftAutoAssigned;}

  bool get IsDefaultShift => _IsDefaultShift;
  set IsDefaultShift(bIsDefaultShift){_IsDefaultShift=bIsDefaultShift;}

  bool _IsDataRetrieved=false;
  bool get IsDataRetrieved => _IsDataRetrieved;
  set  IsDataRetrieved(bool bIsDataRetrieved )
  {
    _IsDataRetrieved = _IsDataRetrieved;
  }
  Shift()
  {
    _ShiftID=""  ;
    _ShiftName='';
    _InTime='';
    _OutTime='';
    _IsEndsInNextDay=false;
    _IsStartFromPreviousDay=false;
    _FullDayMinutes=0;
    _HalfDayMinutes=0;
    _IsOTAllowed=false;
    _OTStartMins = 0;
    _OTGraceMinutes = 0;
    _IsOTStartsAtShiftEnd = false;
    _LunchInTime = '';
    _LunchOutTime = '';
    _LunchMins = 0;
    _OtherBreakMins = 0;
    _AutoShiftInTimeStart = '';
    _AutoShiftInTimeEnd = '';
    _AutoShiftLapseTime = 0;
    _IsShiftAutoAssigned =false;
    _IsDefaultShift = false;
    _IsDataRetrieved=false;
  }

  Shift.fromJson(dynamic json) {
    _ShiftID=json['ShiftID']  ;
    _ShiftName=json['ShiftName'];
    _InTime=json['InTime'];
    _OutTime=json['OutTime'];
    _IsEndsInNextDay=json['IsShiftEndNextDay'];
    _IsStartFromPreviousDay=json['IsShiftStartsPreviousDay'];
    _FullDayMinutes=json['FullDayMinutes'];
    _HalfDayMinutes=json['HalfDayMinutes'];
    _IsOTAllowed=json['IsOTAllowed'];
    _OTStartMins=json['OTStartMinutes']  ;
    _OTGraceMinutes=json['OTGraceMinutes'];
    _IsOTStartsAtShiftEnd = json['IsOTStartsAtShiftEnd'];
    _LunchInTime =json['LunchInTime'];
    _LunchOutTime=json['LunchOutTime']  ;
    _LunchMins=json['LunchMins'];
    _OtherBreakMins = json['OtherBreakMins'];
    _AutoShiftInTimeStart =json['AutoShiftInTimeStart'];
    _AutoShiftInTimeEnd=json['AutoShiftInTimeEnd']  ;
    _AutoShiftLapseTime=json['AutoShiftLapseTime'];
    _IsShiftAutoAssigned=json['IsShiftAutoAssigned'];
    _IsDefaultShift=json['IsDefaultShift'];
    _IsDataRetrieved=true;
  }
  Map<String, dynamic> toJson()
  {
    final map = <String, dynamic>{};
    map['ShiftID']= _ShiftID ;
    map['ShiftName']=_ShiftName;
    map['InTime']=_InTime;
    map['OutTime']=_OutTime;
    map['IsShiftEndNextDay']=_IsEndsInNextDay;
    map['IsShiftStartsPreviousDay']=_IsStartFromPreviousDay;
    map['FullDayMinutes']=_FullDayMinutes;
    map['HalfDayMinutes']=_HalfDayMinutes;
    map['IsOTAllowed']=_IsOTAllowed;
    map['OTStartMinutes']= _OTStartMins ;
    map['OTGraceMinutes']=_OTGraceMinutes;
    map['IsOTStartsAtShiftEnd']=_IsOTStartsAtShiftEnd ;
    map['LunchInTime']=_LunchInTime;
    map['LunchOutTime']= _LunchOutTime ;
    map['LunchMins']=_LunchMins;
    map['OtherBreakMins']=_OtherBreakMins ;
    map['AutoShiftInTimeStart']=_AutoShiftInTimeStart;
    map['AutoShiftInTimeEnd']= _AutoShiftInTimeEnd ;
    map['AutoShiftLapseTime']=_AutoShiftLapseTime;
    map['IsShiftAutoAssigned']=_IsShiftAutoAssigned;
    map['IsDefaultShift']=_IsDefaultShift;
    return map;
  }

}