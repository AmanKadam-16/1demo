



class Branch
{
  String _BranchID=''  ;
  String _BranchName='';
  String _Address='';
  String _ContactNo='';
  String _FaxNo='';
  String _EmailID='';
  String _Website='';
  String _MastBranchID=''  ;
  String _MastBranchName='';

  String get BranchID => _BranchID;
  set BranchID(strBranchID){_BranchID=strBranchID;}

  String get BranchName => _BranchName;
  set BranchName(strBranchName){_BranchName=strBranchName;}

  String get Address => _Address;
  set Address(strAddress){_Address=strAddress;}

  String get ContactNo => _ContactNo;
  set ContactNo(strContactNo){_ContactNo=strContactNo;}

  String get FaxNo => _FaxNo;
  set FaxNo(strFaxNo){_FaxNo=strFaxNo;}

  String get EmailID => _EmailID;
  set EmailID(strEmailID){_EmailID=strEmailID;}

  String get Website => _Website;
  set Website(strWebsite){_Website=strWebsite;}


  String get MastBranchID => _MastBranchID;
  set  MastBranchID(String strMastBranchID )
  {
    _MastBranchID = strMastBranchID;
  }
  String get MastBranchName => _MastBranchName;
  set  MastBranchName(String strMastBranchName )
  {
    _MastBranchName = strMastBranchName;
  }
  bool _IsDataRetrieved=false;
  bool get IsDataRetrieved => _IsDataRetrieved;
  set  IsDataRetrieved(bool bIsDataRetrieved )
  {
    _IsDataRetrieved = _IsDataRetrieved;
  }


  Branch()
  {
     _BranchID=""  ;
     _BranchName='';
     _Address='';
     _ContactNo='';
     _FaxNo='';
     _EmailID='';
     _Website='';
     _MastBranchID='';
     _MastBranchName='';
     _IsDataRetrieved=false;
  }

  Branch.fromJson(dynamic json) {
    _BranchID=json['CompanyID']  ;
    _BranchName=json['CompanyName'];
    _Address=json['Address'];
    _ContactNo=json['ContactNo'];
    _FaxNo=json['FaxNo'];
    _EmailID=json['EmailID'];
    _Website=json['Website'];
    _MastBranchID=json['MastCompanyID'];
    _MastBranchName=json['MastCompanyName'];
    _IsDataRetrieved=true;
  }
  Map<String, dynamic> toJson()
  {
    final map = <String, dynamic>{};
    map['CompanyID']= _BranchID ;
    map['CompanyName']=_BranchName;
    map['Address']=_Address;
    map['ContactNo']=_ContactNo;
    map['FaxNo']=_FaxNo;
    map['EmailID']=_EmailID;
    map['Website']=_Website;
    map['MastCompanyID']=_MastBranchID;
    map['MastCompanyName']=_MastBranchName;
    return map;
  }

}