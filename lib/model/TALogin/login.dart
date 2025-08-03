

import 'emp_login.dart';
import 'user_login.dart';

enum LoginMode
  {
    User ,
    UserForAPI , //User which will be created by New Development using Web Api
    Employee ,
    Unknown
  }

  class Login {
    // this is only to get Login related settings

    LoginMode _LoginMode = LoginMode.Unknown;

    LoginMode get Mode => _LoginMode;

    set Mode(strLoginMode) {
      _LoginMode = strLoginMode;
    }

    EmpLogin _EmpLogin = new EmpLogin();
    EmpLogin get CurrentEmpLogin => _EmpLogin;
    set CurrentEmpLogin(objEmpLogin) {
      _EmpLogin = objEmpLogin;
    }
    UserLogin _UserLogin = new UserLogin();
    UserLogin get CurrentUserLogin => _UserLogin;
    set CurrentUserLogin(objUserLogin) {
      _UserLogin = objUserLogin;
    }

    Login.fromJson(dynamic json) {
      if(json['LoginMode']=="UserForAPI" || json['LoginMode']==5) _LoginMode=LoginMode.UserForAPI;
      if(json['LoginMode']=="Employee" || json['LoginMode']==1) _LoginMode=LoginMode.Employee;
      if(json['LoginMode']=="Unknown" || json['LoginMode']==4) _LoginMode=LoginMode.Unknown;
      if(_LoginMode==LoginMode.UserForAPI) {
        _UserLogin = UserLogin.fromJson(json['CurrentUserLoginForAPI']);
      }
      if(_LoginMode==LoginMode.Employee) {
        _EmpLogin = EmpLogin.fromJson(json['CurrentEmpLogin']);

      }

    }
    Map<String, dynamic> toJson()
    {
      //not tested
      final map = <String, dynamic>{};
      map['LoginMode']= _LoginMode.name ;
      map['CurrentUserLoginForAPI']=_UserLogin;
      map['CurrentEmpLogin']=_EmpLogin;
      return map;
    }




  }