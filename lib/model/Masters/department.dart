



class Department
{
  String _DepartmentID=""  ;
  String _DepartmentName="";
  String _MasterDepartmentID=""  ;
  String _MasterDepartmentName="";


  String get DepartmentID => _DepartmentID;
  set DepartmentID(strDepartmentID){_DepartmentID=strDepartmentID;}
  String get DepartmentName => _DepartmentName;
  set DepartmentName(strDepartmentName){_DepartmentName=strDepartmentName;}
  String get MasterDepartmentID => _MasterDepartmentID;
  set MasterDepartmentID(strMasterDepartmentID){_MasterDepartmentID=strMasterDepartmentID;}
  String get MasterDepartmentName => _MasterDepartmentName;
  set MasterDepartmentName(strMasterDepartmentName){_MasterDepartmentName=strMasterDepartmentName;}

  bool _IsDataRetrieved=false;
  bool get IsDataRetrieved => _IsDataRetrieved;
  set  IsDataRetrieved(bool bIsDataRetrieved )
  {
    _IsDataRetrieved = _IsDataRetrieved;
  }

  Department({ String DepartmentID='',String DepartmentName='',String MasterDepartmentID='',
    String MasterDepartmentName=''})
  {
    _DepartmentID=DepartmentID  ;
    _DepartmentName=DepartmentName;
    _MasterDepartmentID = MasterDepartmentID;
    _MasterDepartmentName = MasterDepartmentName;
    _IsDataRetrieved=false;
  }

  Department.fromJson(dynamic json) {
    _DepartmentID=json['DepartmentID']  ;
    _DepartmentName=json['DepartmentName'];
    _MasterDepartmentID = json['MastDepartmentID'];
    _MasterDepartmentName =json['MastDepartmentName'];
    _IsDataRetrieved=true;
  }
  Map<String, dynamic> toJson()
  {
    final map = <String, dynamic>{};
    map['DepartmentID']= _DepartmentID ;
    map['DepartmentName']=_DepartmentName;
    map['MastDepartmentID']=_MasterDepartmentID ;
    map['MastDepartmentName']=_MasterDepartmentName;
    return map;
  }
}