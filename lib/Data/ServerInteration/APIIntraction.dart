



import 'dart:convert';
import '../LoginInformation/AuthLogin.dart';
import '../LoginInformation/Constants.dart';
import 'Result.dart';
import 'ServerInteractionViaHttp.dart';


//ToDo: Add cryptography Later, code optimization pending
class APIInteraction {
  Future<Result> GetAllObjects(AuthLogin objLoginInfo, String strApiControllerName) async {
    Result objResult;
    final ApiInteraction objApiInteraction = ApiInteraction();
    try {

      String strEncrypted =  base64Encode(
          objLoginInfo.AuthEncryptedString.codeUnits);
      print(' strEncrypted:$strEncrypted');
      String strAPIUrl = ApiConstants.baseUrl + strApiControllerName;
      print(' strAPIUrl:$strAPIUrl');
      objResult = await objApiInteraction.GetCall(strEncrypted, strAPIUrl);
    }
    on Exception catch (e) {
      objResult = Result();
      objResult.ResultMessage = e.toString();
      objResult.IsResultPass = false;
      print('error caught: $e');
    }
    return objResult;
  }
  Future<Result> GetObjectByObjectID(AuthLogin objLoginInfo, String strObjectID,String strApiControllerName) async {
    Result objResult;
    final ApiInteraction objApiInteraction = ApiInteraction();
    try {
      String strEncrypted = await base64Encode(
          objLoginInfo.AuthEncryptedString.codeUnits);
      print(' strEncrypted:$strEncrypted');
      String strAPIUrl = ApiConstants.baseUrl + strApiControllerName ;
      print(' strAPIUrl:$strAPIUrl');
      objResult = await objApiInteraction.GetCallParameter(strEncrypted, strAPIUrl,strObjectID);
    }
    on Exception catch (e) {
      objResult = Result();
      objResult.ResultMessage = e.toString();
      objResult.IsResultPass = false;
      print('error caught: $e');
    }
    return objResult;
  }

  Future<Result> Save(AuthLogin objLoginInfo, String strJsonEncodedString ,String strApiControllerName )async
  {
    Result objResult;
    final ApiInteraction objApiInteraction= ApiInteraction();
    try
    {
      String? strEncrypted= await base64Encode( await objLoginInfo.AuthEncryptedString.codeUnits);
      print(' strEncrypted:$strEncrypted');
      String strAPIUrl= ApiConstants.baseUrl + strApiControllerName;
      String strJsonData= strJsonEncodedString;
      objResult=await objApiInteraction.PostCall(strEncrypted,strJsonData, strAPIUrl);

    }
    on Exception catch(e)
    {
      objResult = Result();
      objResult.ResultMessage = e.toString();
      objResult.IsResultPass = false;
      print('error caught: $e');
    }
    return objResult;
  }

  Future<Result> Update(AuthLogin objLoginInfo,String strJsonEncodedString ,String strApiControllerName )async
  {
    Result objResult;
    final ApiInteraction objApiInteraction = ApiInteraction();
    try {
      String? strEncrypted= await base64Encode( await objLoginInfo.AuthEncryptedString.codeUnits);
      print(' strEncrypted:$strEncrypted');
      String strAPIUrl = ApiConstants.baseUrl + strApiControllerName ;
      String strJsonData =strJsonEncodedString;
      objResult =  await objApiInteraction.PutCall(strEncrypted, strJsonData, strAPIUrl);
    }
    on Exception catch (e) {
      objResult = Result();
      objResult.ResultMessage = e.toString();
      objResult.IsResultPass = false;
      print('error caught: $e');
    }
    return objResult;
  }
  Future<Result> Delete(AuthLogin objLoginInfo, String strJsonEncodedString ,String strApiControllerName )async
  {
    Result objResult;
    final ApiInteraction objApiInteraction= ApiInteraction();
    try
    {
      String? strEncrypted= await base64Encode( await objLoginInfo.AuthEncryptedString.codeUnits);
      print(' strEncrypted:$strEncrypted');
      String strAPIUrl= ApiConstants.baseUrl + strApiControllerName ;
      String strJsonData = strJsonEncodedString;
      objResult=await objApiInteraction.DeleteCall(strEncrypted,strJsonData, strAPIUrl);
    }
    on Exception catch(e)
    {
      objResult = Result();
      objResult.ResultMessage = e.toString();
      objResult.IsResultPass = false;
      print('error caught: $e');
    }
    return objResult;
  }

}