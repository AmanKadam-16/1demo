import 'dart:convert';
import 'package:time_attendance/Data/ServerInteration/Result.dart';

import '../../Data/LoginInformation/AuthLogin.dart';
import '../../Data/LoginInformation/Constants.dart';
import '../../Data/ServerInteration/ServerInteractionViaHttp.dart';

class LoginDetails {
  /// Validate Login and Get Menu List //TOdo:Emplyee menulist pending
  Future<Result> GetLogin(AuthLogin objLoginInfo) async {
    Result objResult;
    final ApiInteraction objApiInteraction = ApiInteraction();
    try {
      String strEncrypted =
          await base64Encode(objLoginInfo.AuthEncryptedString.codeUnits);
      print(' strEncrypted:$strEncrypted');
      String strAPIUrl = ApiConstants.baseUrl + ApiConstants.endpoint_Login;
      print(' strAPIUrl:$strAPIUrl');
      objResult = await objApiInteraction.GetCall(strEncrypted, strAPIUrl);
      if (objResult.IsResultPass) {
        String text = objResult.ResultRecordJson;
        print('FormViews: $text');
      }
    } on Exception catch (e) {
      objResult = Result();
      objResult.ResultMessage = e.toString();
      objResult.IsResultPass = false;
      print('error caught: $e');
    }
    return objResult;
  }
}
