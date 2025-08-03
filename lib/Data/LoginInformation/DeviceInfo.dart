import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

class DeviceInfo {
  Future<String> GetDeviceInformation() async {
    String strDeviceInofrmation = '';
    try {
      // Instantiating the plugin
      final deviceInfoPlugin = await DeviceInfoPlugin();
      if (kIsWeb) {
        
      } else if (Platform.isAndroid) {
        // android
        final result = await deviceInfoPlugin.androidInfo;
        String strDeviceInfo = _readAndroidBuildData(result);
        strDeviceInofrmation = strDeviceInfo;
      } else if (Platform.isIOS) {
        // IPhone
        final result = await deviceInfoPlugin.iosInfo;
        String strDeviceInfo = _readIosDeviceInfo(result);
        strDeviceInofrmation = strDeviceInfo;
      } else {
        // final result = await deviceInfoPlugin.webBrowserInfo;
        //Todo:Pending web Information
      }
    } on Exception catch (e) {
      strDeviceInofrmation = '';
      print('error caught: $e');
    }
    return strDeviceInofrmation;
  }

  // Device information from Android device
  String _readAndroidBuildData(AndroidDeviceInfo build) {
    String strDeviceInfo = '';
    try {
      // strDeviceInfo=strDeviceInfo+ 'version.securityPatch:'+ build.version.securityPatch.toString()+',';
      //strDeviceInfo=strDeviceInfo+'version.sdkInt:'+ build.version.sdkInt.toString()+',';
      //strDeviceInfo=strDeviceInfo+'version.release:'+ build.version.release.toString()+',';
      //strDeviceInfo=strDeviceInfo+'version.previewSdkInt:'+ build.version.previewSdkInt.toString()+',';
      //strDeviceInfo=strDeviceInfo+'version.incremental:'+ build.version.incremental.toString()+',';
      //strDeviceInfo=strDeviceInfo+'version.codename:'+ build.version.codename.toString()+',';
      //strDeviceInfo=strDeviceInfo+'version.baseOS:'+ build.version.baseOS.toString()+',';
      strDeviceInfo = '${strDeviceInfo}brand:${build.brand}, ';
      //strDeviceInfo=strDeviceInfo+'board:'+ build.board.toString()+',';
      //strDeviceInfo=strDeviceInfo+'bootloader:'+ build.bootloader.toString()+',';

      strDeviceInfo = '${strDeviceInfo}device:${build.device}, ';
      strDeviceInfo = '${strDeviceInfo}display:${build.display}, ';
      strDeviceInfo = '${strDeviceInfo}fingerprint:${build.fingerprint}, ';
      strDeviceInfo = '${strDeviceInfo}hardware:${build.hardware}, ';
      strDeviceInfo = '${strDeviceInfo}host:${build.host}, ';
      strDeviceInfo = '${strDeviceInfo}id:${build.id}, ';
      strDeviceInfo = '${strDeviceInfo}manufacturer:${build.manufacturer}, ';
      strDeviceInfo = '${strDeviceInfo}model:${build.model}, ';
      strDeviceInfo = '${strDeviceInfo}product:${build.product}, ';
      strDeviceInfo =
          '${strDeviceInfo}isPhysicalDevice:${build.isPhysicalDevice}';
    } on Exception catch (e) {
      strDeviceInfo = "";
      print('error caught: $e');
    }
    return strDeviceInfo;
  }

  // Device information from IOS device
  String _readIosDeviceInfo(IosDeviceInfo data) {
    String strDeviceInfo = '';
    try {
      strDeviceInfo = '${strDeviceInfo}name:${data.name},';
      strDeviceInfo = '${strDeviceInfo}systemName:${data.systemName}, ';
      strDeviceInfo = '${strDeviceInfo}systemVersion:${data.systemVersion}, ';
      strDeviceInfo = '${strDeviceInfo}model:${data.model}, ';
      strDeviceInfo = '${strDeviceInfo}localizedModel:${data.localizedModel}, ';
      strDeviceInfo =
          '${strDeviceInfo}identifierForVendor:${data.identifierForVendor}, ';
      strDeviceInfo =
          '${strDeviceInfo}isPhysicalDevice:${data.isPhysicalDevice}, ';
      strDeviceInfo =
          '${strDeviceInfo}utsname.sysname:${data.utsname.sysname}, ';
      strDeviceInfo =
          '${strDeviceInfo}utsname.nodename:${data.utsname.nodename}, ';
      strDeviceInfo =
          '${strDeviceInfo}utsname.release:${data.utsname.release}, ';
      strDeviceInfo =
          '${strDeviceInfo}utsname.version:${data.utsname.version}, ';
      strDeviceInfo =
          '${strDeviceInfo}utsname.machine:${data.utsname.machine}, ';
    } on Exception catch (e) {
      strDeviceInfo = "";
      print('error caught: $e');
    }
    return strDeviceInfo;
  }
}
