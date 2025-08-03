import 'package:time_attendance/General/MTAResult.dart';
import 'package:time_attendance/model/device_tab_model/device.dart';
import '../../Data/LoginInformation/AuthLogin.dart';
import '../../Data/LoginInformation/Constants.dart';
import '../../Data/ServerInteration/APIIntraction.dart';
import '../../Data/ServerInteration/Result.dart';

class DeviceDetails {
  Future<List<DeviceModel>> getAllDevices(AuthLogin objAuthLogin, MTAResult objMTAResult) async {
    List<DeviceModel> lstDevices = [];
    try {
      Result objResult = await APIInteraction().GetAllObjects(
          objAuthLogin, ApiConstants.endpoint_Device);
      objMTAResult.IsResultPass = objResult.IsResultPass;
      objMTAResult.ResultMessage = objResult.ResultMessage;
      if (objResult.IsResultPass) {
        if (objResult.IsMultipleRecordsInJson) {
          String strJson = objResult.ResultRecordJson;
          lstDevices = deviceModelFromJson(strJson);
        }
      }
    } on Exception catch (e) {
      lstDevices = [];
      print('error caught: $e');
    }
    return lstDevices;
  }
}