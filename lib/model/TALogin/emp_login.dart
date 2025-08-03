///Todo this may change

class EmpLogin {
  String _EmployeeID=""  ; //
  String _EmployeeName=""; //display setting
  String _EmployeePassword="";// TALogin ->Employee can Update this setting
  String _EmployeePasswordConfirm="";// TALogin ->Employee can Update this setting
  String _RoleType=""; //Onlu TALogin-> user can define this setting not Employee
  bool _IsEnabled=false;  //Onlu TALogin-> user can define this setting not Employee
  bool _CanPunchInGeoFence=false;  //Onlu TALogin-> user can define this setting not Employee
  bool _CanPunchFromHome=false;//Onlu TALogin-> user can define this setting not Employee
  bool _CanView=false;//Onlu TALogin-> user can define this setting not Employee
  bool _CanApplyForManualAttendance=false;//Onlu TALogin-> user can define this setting not Employee
  bool _CanApplyForLeave=false;//Onlu TALogin-> user can define this setting not Employee
  bool _CanApplyForTour=false;//Onlu TALogin-> user can define this setting not Employee


  String get EmployeeID => _EmployeeID;
  set EmployeeID(strEmployeeID)
  {
    _EmployeeID=strEmployeeID;
  }
  String get EmployeeName => _EmployeeName;
  String get EmployeePassword => _EmployeePassword;
  set EmployeePassword(strEmployeePassword)
  {
    _EmployeePassword=strEmployeePassword;
  }
  String get EmployeePasswordConfirm => _EmployeePasswordConfirm;
  set EmployeePasswordConfirm(strEmployeePasswordConfirm)
  {
    _EmployeePasswordConfirm=strEmployeePasswordConfirm;
  }
  String get RoleType => _RoleType;
  bool get IsEnabled => _IsEnabled;
  bool get CanPunchInGeoFence => _CanPunchInGeoFence;
  bool get CanPunchFromHome => _CanPunchFromHome;
  bool get CanView => _CanView;
  bool get CanApplyForManualAttendance => _CanApplyForManualAttendance;
  bool get CanApplyForLeave => _CanApplyForLeave;
  bool get CanApplyForTour => _CanApplyForTour;

  EmpLogin({ String EmployeeID="",String EmployeeName="",String EmployeePassword="",String EmployeePasswordConfirm="",String RoleType="",bool IsEnabled=false,
    bool CanPunchInGeoFence=false,bool CanPunchFromHome=false,bool CanView=false,bool CanApplyForManualAttendance=false,bool CanApplyForLeave=false,bool CanApplyForTour=false })
  {
    _EmployeeID=EmployeeID  ;
    _EmployeeName=EmployeeName;
    _EmployeePassword=EmployeePassword;
    _EmployeePasswordConfirm=EmployeePasswordConfirm;
    _RoleType=RoleType;
    _IsEnabled=IsEnabled;
    _CanPunchInGeoFence=CanPunchInGeoFence;
    _CanPunchFromHome=CanPunchFromHome;
    _CanView=CanView;
    _CanApplyForManualAttendance=CanApplyForManualAttendance;
    _CanApplyForLeave=CanApplyForLeave;
    _CanApplyForTour=CanApplyForTour;
  }

  EmpLogin.fromJson(dynamic json) {
    _EmployeeID=json['EmployeeID']  ;
    _EmployeeName=json['EmployeeName'];
    _EmployeePassword=json['EmployeePassword'];
    _EmployeePasswordConfirm=json['EmployeePasswordConfirm'];
    _RoleType=json['RoleType'];
    _IsEnabled=json['IsEnabled'];
    _CanPunchInGeoFence=json['CanPunchInGeoFence'];
    _CanPunchFromHome=json['CanPunchFromHome'];
    _CanView=json['CanView'];
    _CanApplyForManualAttendance=json['CanApplyForManualAttendance'];
    _CanApplyForLeave=json['CanApplyForLeave'];
    _CanApplyForTour=json['CanApplyForTour'];
  }
  Map<String, dynamic> toJson()
  {
    final map = <String, dynamic>{};
    map['EmployeeID']= _EmployeeID ;
    map['EmployeeName']=_EmployeeName;
    map['EmployeePassword']=_EmployeePassword;
    map['EmployeePasswordConfirm']=_EmployeePasswordConfirm;
    map['RoleType']=_RoleType;
    map['IsEnabled']=_IsEnabled;
    map['CanPunchInGeoFence']=_CanPunchInGeoFence;
    map['CanPunchFromHome']=_CanPunchFromHome;
    map['CanView']=_CanView;
    map['CanApplyForManualAttendance']=_CanApplyForManualAttendance;
    map['CanApplyForLeave']=_CanApplyForLeave;
    map['CanApplyForTour']=_CanApplyForTour;
    return map;
  }



}