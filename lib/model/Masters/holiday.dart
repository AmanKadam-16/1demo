import 'package:time_attendance/model/Masters/branch.dart';

class Holiday {
  String _HolidayID = "";
  String _HolidayName = "";
  String _HolidayDate = "";
  String _HolidayYear = "";
  String _BranchIDs = '';
  List<Branch> _lstBranch = [];

  List<Branch> get ListOfBranch => _lstBranch;
  set ListOfBranch(List<Branch> lstBranch) {
    _lstBranch = lstBranch;
  }

  String get HolidayID => _HolidayID;
  set HolidayID(String strHolidayID) {
    _HolidayID = strHolidayID;
  }

  String get HolidayName => _HolidayName;
  set HolidayName(String strHolidayName) {
    _HolidayName = strHolidayName;
  }

  String get HolidayDate => _HolidayDate;
  set HolidayDate(String strHolidayDate) {
    _HolidayDate = strHolidayDate;
  }

  String get HolidayYear => _HolidayYear;
  set HolidayYear(String strHolidayYear) {
    _HolidayYear = strHolidayYear;
  }

  String get BranchIDs => _BranchIDs;
  set BranchIDs(String strBranchIDs) {
    _BranchIDs = strBranchIDs;
  }

  Holiday() {
    _HolidayID = '';
    _HolidayName = '';
    _HolidayDate = '';
    _HolidayYear = '';
    _lstBranch = [];
    _BranchIDs = '';
  }

  Holiday.fromJson(Map<String, dynamic> json) {
    _HolidayID = json['HolidayID'] ?? '';
    _HolidayName = json['HolidayName'] ?? '';
    _HolidayDate = json['HolidayDate'] ?? '';
    _HolidayYear = json['HolidayYear'] ?? '';
    _BranchIDs = json['CompanyIDs'] ?? '';
    
    if (json['ListOfCompany'] != null) {
      _lstBranch = List<Branch>.from(
        (json['ListOfCompany'] as List).map((x) => Branch.fromJson(x))
        
      );
      print('number of branches: ${_lstBranch.length}');
    } else {
      _lstBranch = [];
    }
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['HolidayID'] = _HolidayID;
    map['HolidayName'] = _HolidayName;
    map['HolidayDate'] = _HolidayDate;
    map['HolidayYear'] = _HolidayYear;
    map['ListOfCompany'] = _lstBranch.map((branch) => branch.toJson()).toList();
    map['CompanyIDs'] = _BranchIDs;
    return map;
  }
}


/*

  


// import 'package:mta/Models/Masters/branchDetails.dart';
import 'package:time_attendance/model/Masters/branch.dart';
import 'branch.dart';

class Holiday
{
  String _HolidayID=""  ;
  String _HolidayName="";
  String _HolidayDate="";
  String _HolidayYear="";

  List<Branch> _lstBranch=[];


  String get HolidayID => _HolidayID;
  set HolidayID(strHolidayID){_HolidayID=strHolidayID;}
  String get HolidayName => _HolidayName;
  set HolidayName(strHolidayName){_HolidayName=strHolidayName;}
  String get HolidayDate => _HolidayDate;
  set HolidayDate(strHolidayDate){_HolidayDate=strHolidayDate;}
  String get HolidayYear => _HolidayYear;
  set HolidayYear(strHolidayYear){_HolidayYear=strHolidayYear;}
  List<Branch> get ListOfBranch => _lstBranch;
  set ListOfBranch(List<Branch> lstBranch)
  {
    _lstBranch=lstBranch;
  }

  bool _IsDataRetrieved=false;
  bool get IsDataRetrieved => _IsDataRetrieved;
  set  IsDataRetrieved(bool bIsDataRetrieved )
  {
    _IsDataRetrieved = _IsDataRetrieved;
  }



  Holiday()
  {
    _HolidayID=HolidayID  ;
    _HolidayName=HolidayName;
    _HolidayDate=HolidayDate;
    _HolidayYear=HolidayYear;
    _lstBranch=[];
    _IsDataRetrieved=false;
  }

  Holiday.fromJson (dynamic json) {
    _HolidayID=json['HolidayID']  ;
    _HolidayName=json['HolidayName'];
    _HolidayDate=json['HolidayDate'];
    _HolidayYear=json['HolidayYear'];
    _lstBranch= (json["ListOfCompany"] as List<dynamic>).cast<Branch>();
    print('number of companies by sonu ${_lstBranch.length}');
    _IsDataRetrieved=true;

  }
  Map<String, dynamic> toJson()
  {
    final map = <String, dynamic>{};
    map['HolidayID']= _HolidayID ;
    map['HolidayName']=_HolidayName;
    map['HolidayDate']=_HolidayDate;
    map['HolidayYear']=_HolidayYear;
    map['ListOfCompany']=_lstBranch;
    return map;
  }
}
 */