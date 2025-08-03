import 'dart:convert';
// import 'package:mta/Data/ServerInteration/APIIntraction.dart';
// import 'package:mta/General/MTAResult.dart';
import 'package:time_attendance/Data/ServerInteration/APIIntraction.dart';
import 'package:time_attendance/General/MTAResult.dart';

import '../../Data/LoginInformation/AuthLogin.dart';
import '../../Data/LoginInformation/Constants.dart';
import '../../Data/ServerInteration/Result.dart';
import 'branch.dart';

class BranchDetails
{
//ToDo:  code optimization pending
  Future<List<Branch>> GetAllBranches(AuthLogin objAuthLogin,MTAResult objMTAResult ) async {
    List<Branch> lstBranch=[];

    try {
      Result objResult=await APIInteraction().GetAllObjects(objAuthLogin,ApiConstants.endpoint_Branch);
      objMTAResult.IsResultPass=objResult.IsResultPass;
      objMTAResult.ResultMessage=objResult.ResultMessage;

      if(objResult.IsResultPass) {
        if (objResult.IsMultipleRecordsInJson) {
          String strJson = objResult.ResultRecordJson;
              lstBranch=parseBranches(objResult.ResultRecordJson);
        }
      }
    }
    on Exception catch (e) {
      lstBranch=[];
      print('error caught: $e');
    }
    return lstBranch;
  }
  List<Branch> parseBranches(String responseBody) {
    try {
      final parsed = (jsonDecode(responseBody) as List).cast<Map<String, dynamic>>();
      return parsed.map<Branch>((json) => Branch.fromJson(json)).toList();
    } catch (e) {
      //debugPrint(e.toString());
      return [];
    }
  }
  Future<Branch> GetBranchByBranchID(AuthLogin objAuthLogin, String strBranchID,MTAResult objMTAResult ) async {
    Branch objBranch=new Branch();

    try {
      Result objResult=await APIInteraction().GetObjectByObjectID(objAuthLogin,strBranchID,ApiConstants.endpoint_Branch);
      objMTAResult.IsResultPass=objResult.IsResultPass;
      objMTAResult.ResultMessage=objResult.ResultMessage;

      if(objResult.IsResultPass) {
        if (!objResult.IsMultipleRecordsInJson) {
          String strJson = objResult.ResultRecordJson;
          Map<String, dynamic> valueMap = json.decode(
              objResult.ResultRecordJson);

          objBranch = Branch.fromJson(valueMap);

        }
      }
    }
    on Exception catch (e) {
      objBranch=new Branch(); // not sure in dart
      print('error caught: $e');
    }
    return objBranch;
  }

  Future<bool> Save(AuthLogin objAuthLogin, Branch objBranch,MTAResult objMTAResult ) async {
    bool bResult=false;
    try {

      String strBranchJson=  jsonEncode(objBranch);
      Result objResult=await APIInteraction().Save(objAuthLogin,strBranchJson, ApiConstants.endpoint_Branch);
      objMTAResult.IsResultPass=objResult.IsResultPass;
      objMTAResult.ResultMessage=objResult.ResultMessage;

      bResult=objResult.IsResultPass;
    }
    on Exception catch (e) {
      bResult=false;
      print('error caught: $e');
    }
    return bResult;
  }

  Future<bool> Update(AuthLogin objAuthLogin, Branch objBranch,MTAResult objMTAResult) async {
    bool bResult=false;
    try {
      String strBranchJson=  jsonEncode(objBranch);
      Result objResult=await APIInteraction().Update(objAuthLogin, strBranchJson, ApiConstants.endpoint_Branch  );
      objMTAResult.IsResultPass=objResult.IsResultPass;
      objMTAResult.ResultMessage=objResult.ResultMessage;

      bResult=objResult.IsResultPass;
    }
    on Exception catch (e) {
      bResult=false;
      print('error caught: $e');
    }
    return bResult;
  }

  Future<bool> Delete(AuthLogin objAuthLogin, String strBranchID,MTAResult objMTAResult ) async {
    bool bResult=false;
    try {

      Branch objBranch= new Branch();
      objBranch.BranchID=strBranchID;

      String strBranchJson=  jsonEncode(objBranch);
      Result objResult=await APIInteraction().Delete(objAuthLogin,strBranchJson, ApiConstants.endpoint_Branch);
      objMTAResult.IsResultPass=objResult.IsResultPass;
      objMTAResult.ResultMessage=objResult.ResultMessage;

      bResult=objResult.IsResultPass;
    }
    on Exception catch (e) {
      bResult=false;
      print('error caught: $e');
    }
    return bResult;
  }


}