
import 'dart:convert';

import '../../model/TALogin/login.dart';
enum ApplicationType
{
  IOS,
  Android,
  Web,
  Window,
  Unknown
}



class AuthLogin
{

  String _CompanyCode=""  ;
  String _LoginID=""  ;
  String _Password="";
  String _UniqueID="";
  String _DeviceInfo="";
  String _AuthEncryptedString="";
  LoginMode _LoginMode=LoginMode.Unknown;
  ApplicationType _ApplicationType=ApplicationType.Unknown;
  bool _CanGoForBiometricLogin=false;
  bool _DoesBiometricUsedForLogin=false;


  AuthLogin(String strNewGuID)
  {
     _CompanyCode="";
     _LoginID=""  ;
     _Password="";
     _UniqueID= strNewGuID;
     _LoginMode=LoginMode.Unknown;
     _ApplicationType=ApplicationType.Unknown;
     _DeviceInfo="";
     _CanGoForBiometricLogin=false; // if valid login updated in file next time go for biometric to bypass login
     _DoesBiometricUsedForLogin=false;
  }

  String get CompanyCode => _CompanyCode;
  set CompanyCode(strCompanyCode)
  {
    _CompanyCode=strCompanyCode; // Company Code i.e. INS or NYK or 111 or AB1 etc
  }
  String get LoginID => _LoginID;
  set LoginID(strLoginID)
  {
    _LoginID=strLoginID; // LoginID
  }
  String get Password => _Password;
  set Password(strPassword)
  {
    _Password=strPassword; // password
  }
  String get UniqueID => _UniqueID;
  set UniqueID(strUniqueID)
  {
    _UniqueID=strUniqueID;  // to maintain unique employee id per employee (for mobile app)
  }

  LoginMode get Mode => _LoginMode;
  set Mode(eLoginMode)
  {
    _LoginMode=eLoginMode; // Login Mode: User or Employee
  }

  ApplicationType get AppType => _ApplicationType;
  set AppType(eApplicationType)
  {
    _ApplicationType=eApplicationType; // Application Type Android or IOS
  }

  String get DeviceInfo => _DeviceInfo;
  set DeviceInfo(strDeviceInfo)
  {
    _DeviceInfo=strDeviceInfo; // DeviceInfo
  }

  bool get CanGoForBiometricLogin => _CanGoForBiometricLogin;
  set CanGoForBiometricLogin(bCanGoForBiometricLogin)
  {
    _CanGoForBiometricLogin=bCanGoForBiometricLogin; // Can Go For Biometric Login
  }
  bool get DoesBiometricUsedForLogin => _DoesBiometricUsedForLogin;
  set DoesBiometricUsedForLogin(bDoesBiometricUsedForLogin)
  {
    _DoesBiometricUsedForLogin=bDoesBiometricUsedForLogin; //  Biometric bypass used instead of login
  }

 /* Todo:  Directly adding employee via App, code flow not define
  String get AddNewCompanyCodeViaApp// temporary out of development for direct adding users via app
  {
    String strSubString = 'INS';
    return strSubString;
  }
  //"aaabbb","xxxyyy"
  String get AddNewLoginIDViaApp // temporary out of development for direct adding users via app
  {
    String strSubString = 'xxxyyy';
    return strSubString;
  }

  String get AddNewPassIDViaApp
  {
    String strSubString = 'aaabbb'; // temporary out of development for direct adding users via app
    return strSubString;
  }
*/

  // following two properties (LoginInfoCombineStringForFile,LoginInfoCombineStringForAuth) are almost same may vary in future
  String get LoginInfoCombineStringForFile
  {
    String strLoginInfoCombineString='';
    String strJsonData = jsonEncode(this);
    strLoginInfoCombineString=strJsonData;
    return strLoginInfoCombineString;
  }

  String get LoginInfoCombineStringForAuth
  {

    String strLoginInfoCombineString='';
    String strJsonData = jsonEncode(this);
    strLoginInfoCombineString=strJsonData;
    return strLoginInfoCombineString;
  }


// todo: encryption correnlty not added after full project development this will be done
  String get AuthEncryptedString => _AuthEncryptedString;
  set AuthEncryptedString(strAuthEncryptedString)
  {
    _AuthEncryptedString=strAuthEncryptedString; // Encrypted String
  }



  AuthLogin.fromJson(dynamic json) {
    _CompanyCode=json['CompanyCode']  ;
    _LoginID=json['LoginID'];
    _Password=json['Password'];
    _UniqueID=json['UniqueID'];
    _DeviceInfo=json['DeviceInfo'];

    if(json['LoginMode']=="User") _LoginMode=LoginMode.User;
    if(json['LoginMode']=="UserForAPI") _LoginMode=LoginMode.UserForAPI;
    if(json['LoginMode']=="Employee") _LoginMode=LoginMode.Employee;
    if(json['LoginMode']=="Unknown") _LoginMode=LoginMode.Unknown;

    if(json['ApplicationType']=="Android") _ApplicationType=ApplicationType.Android;
    if(json['ApplicationType']=="IOS") _ApplicationType=ApplicationType.IOS;
    if(json['ApplicationType']=="Web") _ApplicationType=ApplicationType.Web;
    if(json['ApplicationType']=="Window") _ApplicationType=ApplicationType.Window;
    if(json['ApplicationType']=="Unknown") _ApplicationType=ApplicationType.Unknown;
    _DoesBiometricUsedForLogin=json['DoesBiometricUsedForLogin'];
  }
  Map<String, dynamic> toJson()
  {
    final map = <String, dynamic>{};
    map['CompanyCode']= _CompanyCode ;
    map['LoginID']=_LoginID;
    map['Password']=_Password;
    map['UniqueID']=_UniqueID;
    map['DeviceInfo']=_DeviceInfo;
    map['LoginMode']=_LoginMode.name  ;
    map['ApplicationType']=_ApplicationType.name;
    map['DoesBiometricUsedForLogin']=_DoesBiometricUsedForLogin;
    return map;
  }
}