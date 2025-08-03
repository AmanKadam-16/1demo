

class EmpType
{
  String _EmpTypeID=""  ;
  String _EmpTypeName="";

  String get EmpTypeID => _EmpTypeID;
  set EmpTypeID(strEmpTypeID){_EmpTypeID=strEmpTypeID;}
  String get EmpTypeName => _EmpTypeName;
  set EmpTypeName(strEmpTypeName){_EmpTypeName=strEmpTypeName;}

  EmpType({ String EmpTypeID='',String EmpTypeName=''})
  {
    _EmpTypeID=EmpTypeID  ;
    _EmpTypeName=EmpTypeName;
  }

  EmpType.fromJson(dynamic json) {
    _EmpTypeID=json['EmpTypeID']  ;
    _EmpTypeName=json['EmpTypeName'];
  }
  Map<String, dynamic> toJson()
  {    final map = <String, dynamic>{};
    map['EmpTypeID']= _EmpTypeID ;
    map['EmpTypeName']=_EmpTypeName;
    return map;
  }
}