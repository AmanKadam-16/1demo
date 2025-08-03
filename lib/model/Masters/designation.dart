


class Designation
{
  String _DesignationID=""  ;
  String _DesignationName="";
  String _MasterDesignationID=""  ;
  String _MasterDesignationName="";


  String get DesignationID => _DesignationID;
  set DesignationID(strDesignationID){_DesignationID=strDesignationID;}
  String get DesignationName => _DesignationName;
  set DesignationName(strDesignationName){_DesignationName=strDesignationName;}
  String get MasterDesignationID => _MasterDesignationID;
  set MasterDesignationID(strMasterDesignationID){_MasterDesignationID=strMasterDesignationID;}
  String get MasterDesignationName => _MasterDesignationName;
  set MasterDesignationName(strMasterDesignationName){_MasterDesignationName=strMasterDesignationName;}
  bool _IsDataRetrieved=false;
  bool get IsDataRetrieved => _IsDataRetrieved;
  set  IsDataRetrieved(bool bIsDataRetrieved )
  {
    _IsDataRetrieved = _IsDataRetrieved;
  }


  Designation()
  {
    _DesignationID=''  ;
    _DesignationName='';
    _MasterDesignationID = '';
    _MasterDesignationName = '';
    _IsDataRetrieved=false;
  }

  Designation.fromJson(dynamic json) {
    _DesignationID=json['DesignationID']  ;
    _DesignationName=json['DesignationName'];
    _MasterDesignationID = json['MastDesignationID'];
    _MasterDesignationName =json['MastDesignationName'];
    _IsDataRetrieved=true;
  }
  Map<String, dynamic> toJson()
  {
    final map = <String, dynamic>{};
    map['DesignationID']= _DesignationID ;
    map['DesignationName']=_DesignationName;
    map['MastDesignationID']=_MasterDesignationID ;
    map['MastDesignationName']=_MasterDesignationName;
    return map;
  }
}