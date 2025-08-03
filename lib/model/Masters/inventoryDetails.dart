import 'dart:convert';

import '../../Data/LoginInformation/AuthLogin.dart';
import '../../Data/LoginInformation/Constants.dart';
import '../../Data/ServerInteration/APIIntraction.dart';
import '../../Data/ServerInteration/Result.dart';
import '../../General/MTAResult.dart';
import 'inventory.dart';

class InventoryDetails {
//ToDo:  code optimization pending
  Future<List<Inventory>> GetAllInventoryes(AuthLogin objAuthLogin,
      MTAResult objMTAResult) async {
    List<Inventory> lstInventory = [];

    try {
      Result objResult = await APIInteraction().GetAllObjects(
          objAuthLogin, ApiConstants.endpoint_Inventory);
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;

      if (objResult.IsResultPass) {
        if (objResult.IsMultipleRecordsInJson) {
          String strJson = objResult.ResultRecordJson;
          lstInventory = parseInventorys(objResult.ResultRecordJson);
        }
      }
    }
    on Exception catch (e) {
      lstInventory = [];
      print('error caught: $e');
    }
    return lstInventory;
  }

  List<Inventory> parseInventorys(String responseBody) {
    try {
      final parsed = (jsonDecode(responseBody) as List).cast<
          Map<String, dynamic>>();
      return parsed.map<Inventory>((json) => Inventory.fromJson(json))
          .toList();
    } catch (e) {
      //debugPrint(e.toString());
      return [];
    }
  }

  Future<Inventory> GetInventoryByInventoryID(AuthLogin objAuthLogin,
      String strInventoryID, MTAResult objMTAResult) async {
    Inventory objInventory = new Inventory();

    try {
      Result objResult = await APIInteraction().GetObjectByObjectID(
          objAuthLogin, strInventoryID, ApiConstants.endpoint_Inventory);
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;

      if (objResult.IsResultPass) {
        if (!objResult.IsMultipleRecordsInJson) {
          String strJson = objResult.ResultRecordJson;
          Map<String, dynamic> valueMap = json.decode(
              objResult.ResultRecordJson);

          objInventory = Inventory.fromJson(valueMap);
        }
      }
    }
    on Exception catch (e) {
      objInventory = new Inventory(); // not sure in dart
      print('error caught: $e');
    }
    return objInventory;
  }

  Future<bool> Save(AuthLogin objAuthLogin, Inventory objInventory,
      MTAResult objMTAResult) async {
    bool bResult = false;
    try {
      String strInventoryJson = jsonEncode(objInventory);
      Result objResult = await APIInteraction().Save(
          objAuthLogin, strInventoryJson, ApiConstants.endpoint_Inventory);
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;

      bResult = objResult.IsResultPass;
    }
    on Exception catch (e) {
      bResult = false;
      print('error caught: $e');
    }
    return bResult;
  }

  Future<bool> Update(AuthLogin objAuthLogin, Inventory objInventory,
      MTAResult objMTAResult) async {
    bool bResult = false;
    try {
      String strInventoryJson = jsonEncode(objInventory);
      Result objResult = await APIInteraction().Update(
          objAuthLogin, strInventoryJson, ApiConstants.endpoint_Inventory);
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;

      bResult = objResult.IsResultPass;
    }
    on Exception catch (e) {
      bResult = false;
      print('error caught: $e');
    }
    return bResult;
  }

  Future<bool> Delete(AuthLogin objAuthLogin, String strInventoryID,
      MTAResult objMTAResult) async {
    bool bResult = false;
    try {
      Inventory objInventory = new Inventory();
      objInventory.InventoryID = strInventoryID;

      String strInventoryJson = jsonEncode(objInventory);
      Result objResult = await APIInteraction().Delete(
          objAuthLogin, strInventoryJson, ApiConstants.endpoint_Inventory);
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;

      bResult = objResult.IsResultPass;
    }
    on Exception catch (e) {
      bResult = false;
      print('error caught: $e');
    }
    return bResult;
  }

}
