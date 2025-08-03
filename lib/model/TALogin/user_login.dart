import 'dart:core';
import 'package:geocoding/geocoding.dart';

// import '../Masters/company.dart';
// import '../Masters/department.dart';
// import '../Masters/talocation.dart';
import 'user_forms.dart';
import 'user_type.dart';

class UserLogin {
  UserLogin() {
    _UserID = 0;
    _UserName = '';
    _UserLoginID = '';
    _UserPassword = '';
    _UserConfirmPassword = '';

    _lstCompany = [];
    _CompanyIDs = '';
    _lstDepartment = [];
    _DepartmentIDs = '';
    _lstLocation = [];
    _LocationIDs = '';

    _UserType = UserType.None;
    _lstUserInsigniaForms = [];

    _bCanAdd = false;
    _bCanEdit = false;
    _bCanDelete = false;
    _bCanView = false;
    _bCanApproveOrRejectManualAttendance = false;
    _bCanApproveOrRejectOutDoorDuty = false;
    _bCanApproveOrRejectLeave = false;
    _bCanAssignLeavePolicy = false;
    _bCanApproveOrRejectTour = false;
    _bCanApproveMobileToUse = false;
    _bCanDefineGeoFencingForOffice = false;
    _bCanChangeEmployeeLoginDetails = false;
    _bCanUpdateEmployeeInventoryDetails = false;
    _bResetPassword = false;
    _MarkedByUserID = '';
    _MarkedByUserLoginName = '';
    _MarkedOn = '';
  }

  int _UserID = 0;
  int get UserID => _UserID;
  set UserID(
      iUserID) // its identity column so only for Update and delete it will be use
  {
    _UserID = iUserID;
  }

  String _UserName = ''; //user name
  String get UserName => _UserName;
  set UserName(strUserName) {
    _UserName = strUserName;
  }

  String _UserLoginID = '';
  String get UserLoginID => _UserLoginID;
  set UserLoginID(strUserLoginID) {
    _UserLoginID = strUserLoginID;
  }

  String _UserPassword = '';
  String get UserPassword => _UserPassword;
  set UserPassword(strUserPassword) {
    _UserPassword = strUserPassword;
  }

  String _UserConfirmPassword = '';
  String get UserConfirmPassword => _UserConfirmPassword;
  set UserConfirmPassword(strUserConfirmPassword) {
    _UserConfirmPassword = strUserConfirmPassword;
  }

  //    List<Company> _lstCompany=[];
  // List<Company> get ListOfCompany => _lstCompany;
  // set ListOfCompany(List<Company> lstCompany)
  // {
  //     _lstCompany=lstCompany;
  // }
  List<dynamic> _lstCompany = [];
  List<dynamic> get ListOfCompany => _lstCompany;
  set ListOfCompany(List<dynamic> lstCompany) {
    _lstCompany = lstCompany;
  }

  //todo: Internal Encryption decryption needed- not implemented
  String _CompanyIDs = '';
  String get CompanyIDs => _CompanyIDs; // list of company IDs separated by ',
  set CompanyIDs(strCompanyIDs) //for save update  - not mandatory
  {
    _CompanyIDs = strCompanyIDs;
  }

  // List<Department> _lstDepartment=[];
  // List<Department> get ListOfDepartment => _lstDepartment;
  // set ListOfDepartment(List<Department> lstDepartment)
  // {
  //     _lstDepartment=lstDepartment;
  // }
  List<dynamic> _lstDepartment = [];
  List<dynamic> get ListOfDepartment => _lstDepartment;
  set ListOfDepartment(List<dynamic> lstDepartment) {
    _lstDepartment = lstDepartment;
  }

  //todo: Internal Encryption decryption needed- not implemented
  String _DepartmentIDs = '';
  String get DepartmentIDs =>
      _DepartmentIDs; // list of Department IDs separated by ',
  set DepartmentIDs(strDepartmentIDs) //for save update  - not mandatory
  {
    _DepartmentIDs = strDepartmentIDs;
  }

  // List<TALocation> _lstLocation=[];
  // List<TALocation> get ListOfLocation => _lstLocation;
  // set ListOfLocation(List<TALocation> lstLocation)
  // {
  //     _lstLocation=lstLocation;
  // }
  List<dynamic> _lstLocation = [];
  List<dynamic> get ListOfLocation => _lstLocation;
  set ListOfLocation(List<dynamic> lstLocation) {
    _lstLocation = lstLocation;
  }

  //todo: Internal Encryption decryption needed- not implemented
  String _LocationIDs = '';
  String get LocationIDs =>
      _LocationIDs; // list of Location IDs separated by ',
  set LocationIDs(strLocationIDs) //for save update  - not mandatory
  {
    _LocationIDs = strLocationIDs;
  }

  UserType _UserType = UserType.None;
  UserType get Type => _UserType; // mandatory for Save update delete
  set Type(eUserType) {
    _UserType = eUserType;
  }

  List<UserInsigniaForms> _lstUserInsigniaForms = [];
  List<UserInsigniaForms> get ListOfUserInsigniaForms => _lstUserInsigniaForms;
  set ListOfUserInsigniaForms(List<UserInsigniaForms> lstUserInsigniaForms) {
    _lstUserInsigniaForms = lstUserInsigniaForms;
  }

  bool _bCanAdd = false;
  bool get CanAdd => _bCanAdd;
  set CanAdd(bCanAdd)

  /// save update non mandatory
  {
    _bCanAdd = bCanAdd;
  }

  bool _bCanEdit = false;
  bool get CanEdit => _bCanEdit;
  set CanEdit(bCanEdit)

  /// save update non mandatory
  {
    _bCanEdit = bCanEdit;
  }

  bool _bCanDelete = false;
  bool get CanDelete => _bCanDelete;
  set CanDelete(bCanDelete)

  /// save update non mandatory
  {
    _bCanDelete = bCanDelete;
  }

  bool _bCanView = false;
  bool get CanView => _bCanView;
  set CanView(bCanView)

  /// save update non mandatory
  {
    _bCanView = bCanView;
  }

  bool _bCanApproveOrRejectManualAttendance = false;
  bool get CanApproveOrRejectManualAttendance =>
      _bCanApproveOrRejectManualAttendance;
  set CanApproveOrRejectManualAttendance(bApproveOrRejectManualAttendance)

  /// save update non mandatory
  {
    _bCanApproveOrRejectManualAttendance = bApproveOrRejectManualAttendance;
  }

  bool _bCanApproveOrRejectOutDoorDuty = false;
  bool get CanApproveOrRejectOutDoorDuty => _bCanApproveOrRejectOutDoorDuty;
  set CanApproveOrRejectOutDoorDuty(bApproveOrRejectOutDoorDuty)

  /// save update non mandatory
  {
    _bCanApproveOrRejectOutDoorDuty = bApproveOrRejectOutDoorDuty;
  }

  bool _bCanApproveOrRejectLeave = false;
  bool get CanApproveOrRejectLeave => _bCanApproveOrRejectLeave;
  set CanApproveOrRejectLeave(bApproveOrRejectLeave)

  /// save update non mandatory
  {
    _bCanApproveOrRejectLeave = bApproveOrRejectLeave;
  }

  bool _bCanAssignLeavePolicy = false;
  bool get CanAssignedLeavePolicy => _bCanAssignLeavePolicy;
  set CanAssignedLeavePolicy(bAssignLeavePolicy)

  /// save update non mandatory
  {
    _bCanAssignLeavePolicy = bAssignLeavePolicy;
  }

  bool _bCanApproveOrRejectTour = false;
  bool get CanApproveOrRejectTour => _bCanApproveOrRejectTour;
  set CanApproveOrRejectTour(bApproveOrRejectTour)

  /// save update non mandatory
  {
    _bCanApproveOrRejectTour = bApproveOrRejectTour;
  }

  bool _bCanApproveMobileToUse = false;
  bool get CanApproveMobileToUse => _bCanApproveMobileToUse;
  set CanApproveMobileToUse(bCanApproveMobileToUse)

  /// save update non mandatory
  {
    _bCanApproveMobileToUse = bCanApproveMobileToUse;
  }

  bool _bCanDefineGeoFencingForOffice = false;
  bool get CanDefineGeoFencingForOffice => _bCanDefineGeoFencingForOffice;
  set CanDefineGeoFencingForOffice(bCanDefineGeoFencingForOffice)

  /// save update non mandatory
  {
    _bCanDefineGeoFencingForOffice = bCanDefineGeoFencingForOffice;
  }

  bool _bCanChangeEmployeeLoginDetails = false;
  bool get CanChangeEmployeeLoginDetails => _bCanChangeEmployeeLoginDetails;
  set CanChangeEmployeeLoginDetails(bCanChangeEmployeeLoginDetails)

  /// save update non mandatory
  {
    _bCanChangeEmployeeLoginDetails = bCanChangeEmployeeLoginDetails;
  }

  bool _bCanUpdateEmployeeInventoryDetails = false;
  bool get CanUpdateEmployeeInventoryDetails =>
      _bCanUpdateEmployeeInventoryDetails;
  set CanUpdateEmployeeInventoryDetails(bCanUpdateEmployeeInventoryDetails)

  /// save update non mandatory
  {
    _bCanUpdateEmployeeInventoryDetails = bCanUpdateEmployeeInventoryDetails;
  }

  bool _bResetPassword = false;
  bool get Reset => _bResetPassword;
  set Reset(
      bResetPassword) // // During Login if this is true, compulsory send for new password form , no by pass
  {
    _bResetPassword = bResetPassword;
  }

  String _MarkedByUserID = '';
  String get MarkedByUserID => _MarkedByUserID;
  set MarkedByUserID(
      String strMarkedByUserID) // display Only , it will add in rest api
  {
    _MarkedByUserID = strMarkedByUserID;
  }

  String _MarkedByUserLoginName = '';
  String get MarkedByUserLoginName => _MarkedByUserLoginName;
  set MarkedByUserLoginName(
      String strMarkedByUserLoginName) // display Only , it will add in rest api
  {
    _MarkedByUserLoginName = strMarkedByUserLoginName;
  }

  String _MarkedOn = '';
  String get MarkedOn => _MarkedOn;
  set MarkedOn(String strMarkedOn) // display Only , it will add in rest api
  {
    _MarkedOn = strMarkedOn;
  }

  UserLogin.fromJson(dynamic json) {
    _UserID = json['UserID'];
    _UserName = json['UserName'];
    _UserLoginID = json['UserLoginID'];
    _UserPassword = json['UserPassword'];
    _UserConfirmPassword = json['UserConfirmPassword'];
    if (json['ListOfCompany'] != null) {
      _lstCompany = (json['ListOfCompany'] as List)
          .map((i) => i as Map<String, dynamic>)
          .toList();
    } else {
      _lstCompany = [];
    }
    if (json['CompanyIDs'] != null) {
      _CompanyIDs = json['CompanyIDs'];
    } else
      _CompanyIDs = '';

    if (json['ListOfDepartment'] != null) {
      _lstDepartment = (json['ListOfDepartment'] as List)
          .map((i) => i as Map<String, dynamic>)
          .toList();
    } else {
      _lstDepartment = [];
    }
    if (json['LocationIDs'] != null) {
      _DepartmentIDs = json['DepartmentIDs'];
    } else {
      _DepartmentIDs = '';
    }

    if (json['ListOfLocation'] != null) {
      _lstLocation = (json['ListOfLocation'] as List)
          .map((i) => i as Map<String, dynamic>)
          .toList();
    } else {
      _lstLocation = [];
    }
    if (json['LocationIDs'] != null) {
      _LocationIDs = json['LocationIDs'];
    } else {
      _LocationIDs = '';
    }

    if (json['Type'] == "Admin" || json['Type'] == 6)
      _UserType = UserType.Admin;
    if (json['Type'] == "HR" || json['Type'] == 7) _UserType = UserType.HR;
    if (json['Type'] == "Company" || json['Type'] == 1)
      _UserType = UserType.Company;
    if (json['Type'] == "CompanyNDepartment" || json['Type'] == 4)
      _UserType = UserType.CompanyNDepartment;
    if (json['Type'] == "Department" || json['Type'] == 2)
      _UserType = UserType.Department;
    if (json['Type'] == "Location" || json['Type'] == 5)
      _UserType = UserType.Location;
    if (json['Type'] == "Employee" || json['Type'] == 3)
      _UserType = UserType.Employee;
    if (json['Type'] == "DeviceManagement" || json['Type'] == 11)
      _UserType = UserType.DeviceManagement;
    // Fix: handle FormViews null or missing
    if (json["FormViews"] != null && json["FormViews"] is List) {
      _lstUserInsigniaForms = (json["FormViews"] as List<dynamic>).cast<UserInsigniaForms>();
    } else {
      _lstUserInsigniaForms = [];
    }
    _bCanAdd = json['CanAdd'];
    _bCanEdit = json['CanEdit'];
    _bCanDelete = json['CanDelete'];
    _bCanView = json['CanView'];
    _bCanApproveOrRejectManualAttendance =
        json['CanApproveOrRejectManualAttendance'];
    _bCanApproveOrRejectOutDoorDuty = json['CanApproveOrRejectOutDoorDuty'];
    _bCanApproveOrRejectLeave = json['CanApproveOrRejectLeave'];
    _bCanAssignLeavePolicy = json['CanAssignedLeavePolicy'];
    _bCanApproveOrRejectTour = json['CanApproveOrRejectTour'];
    _bCanApproveMobileToUse = json['CanApproveMobileToUse'];
    _bCanDefineGeoFencingForOffice = json['CanDefineGeoFencingForOffice'];
    _bCanChangeEmployeeLoginDetails = json['CanChangeEmployeeLoginDetails'];
    _bCanUpdateEmployeeInventoryDetails =
        json['CanUpdateEmployeeInventoryDetails'];
    _bResetPassword = json['Reset'];
    _MarkedByUserID = json['ByUserLoginID'] ?? '';
    _MarkedByUserLoginName = json['ByUserLoginName'] ?? '';
    _MarkedOn = json['MarkedOn'] ?? '';
  }
  Map<String, dynamic> toJson() {
    // not tested
    final map = <String, dynamic>{};
    map['UserID'] = _UserID;
    map['UserName'] = _UserName;
    map['UserLoginID'] = _UserLoginID;
    map['UserPassword'] = _UserPassword;
    map['UserConfirmPassword'] = _UserConfirmPassword;
    map['ListOfCompany'] = _lstCompany;
    map['CompanyIDs'] = _CompanyIDs;
    map['ListOfDepatment'] = _lstDepartment;
    map['DepartmentIDs'] = _DepartmentIDs;
    map['ListOfLocation'] = _lstLocation;
    map['LocationIDs'] = _LocationIDs;
    map['Type'] = _UserType.name;
    map['FormViews'] = _lstUserInsigniaForms;
    map['CanAdd'] = _bCanAdd;
    map['CanEdit'] = _bCanEdit;
    map['CanDelete'] = _bCanDelete;
    map['CanView'] = _bCanView;
    map['CanApproveOrRejectManualAttendance'] =
        _bCanApproveOrRejectManualAttendance;
    map['CanApproveOrRejectOutDoorDuty'] = _bCanApproveOrRejectOutDoorDuty;
    map['CanApproveOrRejectLeave'] = _bCanApproveOrRejectLeave;
    map['CanAssignedLeavePolicy'] = _bCanAssignLeavePolicy;
    map['CanApproveOrRejectTour'] = _bCanApproveOrRejectTour;
    map['CanApproveMobileToUse'] = _bCanApproveMobileToUse;
    map['CanDefineGeoFencingForOffice'] = _bCanDefineGeoFencingForOffice;
    map['CanChangeEmployeeLoginDetails'] = _bCanChangeEmployeeLoginDetails;
    map['CanUpdateEmployeeInventoryDetails'] =
        _bCanUpdateEmployeeInventoryDetails;
    map['Reset'] = _bResetPassword;
    map['ByUserLoginID'] = _MarkedByUserID;
    map['ByUserLoginName'] = _MarkedByUserLoginName;
    map['MarkedOn'] = _MarkedOn;

    return map;
  }
}
