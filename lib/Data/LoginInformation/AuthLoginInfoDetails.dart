import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../model/TALogin/login.dart';
import '../../widgets/mtaToast.dart';

import 'AuthLogin.dart';
import 'DeviceInfo.dart';
import 'FileInteraction.dart';

class AuthLoginDetails {
//Intialise Login With Values
  Future<AuthLogin> InItAuthLogin() async {
    // one GUID will maintain from install to uninstall
    String strNewGuID = const Uuid().v4().toString(); // new GUID;

    //Init LoginInfo with values
    AuthLogin objLoginInfo = new AuthLogin(strNewGuID);
    try {
      //values which are needed during Passing
      if (kIsWeb) {
        objLoginInfo.AppType = ApplicationType.Web;
      } else if (Platform.isAndroid) {
        objLoginInfo.AppType = ApplicationType.Android;
      } else if (Platform.isIOS) {
        objLoginInfo.AppType = ApplicationType.IOS;
      } else if (Platform.isWindows) {
        objLoginInfo.AppType = ApplicationType.Window;
      }
      //todo Web is pending
      // //kIsWeb property from the foundation package or use device_info_plus confused::
      // else
      // {
      //   objLoginInfo.AppType=ApplicationType.Web;
      // }

      //Device Information
      String strDeviceInformation = await DeviceInfo().GetDeviceInformation();
      objLoginInfo.DeviceInfo = strDeviceInformation;

      objLoginInfo.Mode = LoginMode.Unknown;

      //Only for Mobile
      if (!kIsWeb) {
        if (Platform.isAndroid || Platform.isIOS) {
          //get Information from file
          final strFileData = await FileInteraction()
              .getDataFromFile(FileInteraction.MTAFileName);
          if (strFileData.toString().trim().length == 0) // file is not exists
          {
            // if file contains are null or file not exists
            // save LoginInfo in file with new GUID
            SaveLoginInformationInTheFile(objLoginInfo);
            print('data stored $objLoginInfo');
          } else if (strFileData.toString().trim().length > 0) {
            Map<String, dynamic> valueMap = json.decode(strFileData);
            print("File Data: $strFileData");
            MTAToast().ShowToast("File Exists");
            print("File Data: $strFileData");
            objLoginInfo = AuthLogin.fromJson(valueMap);
            if (objLoginInfo.Mode == LoginMode.Employee) {
              objLoginInfo.Mode = LoginMode.Employee;
            }
            if (objLoginInfo.Mode == LoginMode.User) {
              objLoginInfo.Mode = LoginMode.User;
            }

            if (objLoginInfo.LoginID.length == 0) {
              objLoginInfo.CanGoForBiometricLogin =
                  false; // means go for Login Screen
            }
            if (objLoginInfo.Password.length == 0) {
              objLoginInfo.CanGoForBiometricLogin =
                  false; // means go for Login Screen
            }
            objLoginInfo.DoesBiometricUsedForLogin = false;
            await InItAuthEncryptedString(
                objLoginInfo); // to get Encryption string
          }
        }
      }
    } on Exception catch (e) {
      objLoginInfo = new AuthLogin(strNewGuID); //with default values
      objLoginInfo.CanGoForBiometricLogin = false;
      print('error caught: $e');
    }
    return objLoginInfo;
  }

  Future<String> InItAuthEncryptedString(AuthLogin objLoginInfo) async {
    String strAuthEncryption = '';
    try {
      //TODo:Temporary Encryption Disabled , Undone it later
      String strAuthEncryption = jsonEncode(objLoginInfo);
      objLoginInfo.AuthEncryptedString = strAuthEncryption;
    } on Exception catch (e) {
      strAuthEncryption = "";
      MTAToast().ShowToast(e.toString());
    }
    return strAuthEncryption;
  }

// Clear loginInformation In file too (except GUID)
  Future<bool> ClearLoginInformationForLogOut() async {
    bool bResult = true;
    try {
      AuthLogin objLoginInfo = await InItAuthLogin(); // to retrieve old values
      objLoginInfo.CompanyCode = "";
      objLoginInfo.LoginID = "";
      objLoginInfo.Password = "";
      objLoginInfo.CanGoForBiometricLogin = false;
      objLoginInfo.DoesBiometricUsedForLogin = false;
      objLoginInfo.Mode = LoginMode.Unknown;
      await SaveLoginInformationInTheFile(
          objLoginInfo); // to clear loginID and password
    } on Exception catch (e) {
      bResult = false;
      print('error caught: $e');
    }
    return bResult;
  }

  // Login Info after LogOut
  Future<AuthLogin> LoginInformationForFirstLogin(
      String strCompanyCode, String strLoginID, String strPassword) async {
    AuthLogin objLoginInfo = new AuthLogin(""); //GUID will not change
    bool bResult = true;

    try {
      print('password $strPassword and loginID $strLoginID');
      objLoginInfo =
          await InItAuthLogin(); // to retreive old values along with GUID
      objLoginInfo.CompanyCode = strCompanyCode;
      objLoginInfo.LoginID = strLoginID;
      objLoginInfo.Password = strPassword;
      objLoginInfo.CanGoForBiometricLogin = false;
      objLoginInfo.DoesBiometricUsedForLogin = false;
      objLoginInfo.Mode = LoginMode.Unknown;
      String strLoginInfoCombineString =
          objLoginInfo.LoginInfoCombineStringForAuth;
      await InItAuthEncryptedString(
          objLoginInfo); // to get Encryption string after value changed
    } on Exception catch (e) {
      bResult = false;
      print('error caught: $e');

      MTAToast().ShowToast(e.toString());
    }
    return objLoginInfo;
  }

  // Login Info after LogOut for using Add new user
  // This function is used for adding employee via app , temporary out of development
  Future<AuthLogin> LoginInformationForFirstLoginViaApp() async {
    AuthLogin objLoginInfo = new AuthLogin(""); //GUID will not change
    bool bResult = true;
    try {
      /*objLoginInfo= await InItLoginInfo(); // to retreive old values along with GUID
      objLoginInfo.CompanyCode=objLoginInfo.AddNewLoginIDViaApp; // this logic will change in future
      objLoginInfo.LoginID=objLoginInfo.AddNewLoginIDViaApp; // this logic will change in future
      objLoginInfo.Password=objLoginInfo.AddNewPassIDViaApp;
      objLoginInfo.CanGoForBiometricLogin=false;
      objLoginInfo.DoesBiometricUsedForLogin=false;
      objLoginInfo.Mode=LoginMode.Employee;
      await InItAuthEncryptedString(objLoginInfo); // to get Encryption string
      */
    } on Exception catch (e) {
      bResult = false;
      print('error caught: $e');
    }
    return objLoginInfo;
  }

  //Update File For successful attempt so next time logins infor retrive from file and go for biometric
  Future<AuthLogin> UpdateSuccessFullLoginInformation(String strCompanyCode,
      String strLoginID, String strPassword, LoginMode objLoginMode) async {
    AuthLogin objLoginInfo = new AuthLogin('');
    try {
      objLoginInfo =
          await InItAuthLogin(); // to retrieve old values and other informations
      objLoginInfo.CompanyCode = strCompanyCode;
      objLoginInfo.LoginID = strLoginID;
      objLoginInfo.Password = strPassword;
      objLoginInfo.DoesBiometricUsedForLogin = false;
      objLoginInfo.CanGoForBiometricLogin = true;
      objLoginInfo.Mode = objLoginMode;
      await SaveLoginInformationInTheFile(objLoginInfo);
    } on Exception catch (e) {
      print('error caught: $e');
    }
    return objLoginInfo;
  }

  /// saving data in file
  Future<bool> SaveLoginInformationInTheFile(AuthLogin objLoginInfo) async {
    bool bResult = true;
    try {
      // only for employee - mobile
      if (Platform.isAndroid || Platform.isIOS) {
        String strJsonData = jsonEncode(objLoginInfo);
        await FileInteraction()
            .saveDataInFile(strJsonData, FileInteraction.MTAFileName);
      }
    } on Exception catch (e) {
      bResult = false;
      print('error caught: $e');
    }
    return bResult;
  }
}
