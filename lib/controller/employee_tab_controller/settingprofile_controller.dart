// lib/controller/employee_tab_controller/settingprofile_controller.dart

import 'package:get/get.dart';
import 'package:time_attendance/Data/LoginInformation/AuthLogin.dart';
import 'package:time_attendance/Data/LoginInformation/AuthLoginInfoDetails.dart';
import 'package:time_attendance/General/MTAResult.dart';
import 'package:time_attendance/model/employee_tab_model/settingprofile.dart';
import 'package:time_attendance/model/employee_tab_model/settingprofiledetails.dart';
import 'package:time_attendance/widgets/mtaToast.dart';
import 'package:time_attendance/model/TALogin/session_manager.dart'
    if (dart.library.html) 'package:time_attendance/model/TALogin/session_manager_web.dart'
    if (dart.library.io) 'package:time_attendance/model/TALogin/session_manager_mobile.dart';

class SettingProfileController extends GetxController {
  final settingProfiles = <SettingProfileModel>[].obs;
  final filteredSettingProfiles = <SettingProfileModel>[].obs;
  final searchQuery = ''.obs;
  final isLoading = false.obs;

  final sortColumn = RxString('ProfileName');
  final isSortAscending = RxBool(true);

  AuthLogin? _authLogin;

  @override
  void onInit() {
    super.onInit();
    initializeAuthProfile();
  }

  Future<void> initializeAuthProfile() async {
    try {
      final userInfo = await PlatformSessionManager.getUserInfo();
      if (userInfo != null) {
        String companyCode = userInfo['CompanyCode'];
        String loginID = userInfo['LoginID'];
        String password = userInfo['Password'];
        _authLogin = await AuthLoginDetails()
            .LoginInformationForFirstLogin(companyCode, loginID, password);
        fetchSettingProfiles();
      }
    } catch (e) {
      MTAToast().ShowToast(e.toString());
    }
  }

  Future<void> fetchSettingProfiles() async {
    try {
      if (_authLogin == null) {
        throw Exception('Authentication not initialized');
      }

      isLoading.value = true;

      MTAResult result = MTAResult();
      List<SettingProfileModel> apiSettingProfiles =
          await SettingProfileDetails().GetAllSettingProfiles(_authLogin!, result);

      settingProfiles.assignAll(apiSettingProfiles);
      updateSearchQuery('');
    } catch (e) {
      MTAToast().ShowToast(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredSettingProfiles.assignAll(settingProfiles);
    } else {
      filteredSettingProfiles.assignAll(settingProfiles
          .where((profile) =>
              profile.profileName.toLowerCase().contains(query.toLowerCase()) ||
              profile.description.toLowerCase().contains(query.toLowerCase()))
          .toList());
    }
  }

  void sortSettingProfiles(String columnName, bool? ascending) {
    if (ascending != null) {
      isSortAscending.value = ascending;
    } else if (sortColumn.value == columnName) {
      isSortAscending.value = !isSortAscending.value;
    } else {
      isSortAscending.value = true;
    }

    sortColumn.value = columnName;

    filteredSettingProfiles.sort((a, b) {
      int comparison;
      switch (columnName) {
        case 'Profile Name':
          comparison = a.profileName.compareTo(b.profileName);
          break;
        case 'Description':
          comparison = a.description.compareTo(b.description);
          break;
        default:
          comparison = 0;
      }
      return isSortAscending.value ? comparison : -comparison;
    });
  }

  Future<bool> createSettingProfile(SettingProfileModel profile) async {
    isLoading.value = true;
    try {
      if (_authLogin == null) {
        throw Exception('Authentication not initialized');
      }
      MTAResult result = MTAResult();
      bool success = await SettingProfileDetails().Save(_authLogin!, profile, result);
      
      MTAToast().ShowToast(result.ResultMessage);
      if(success) {
        await fetchSettingProfiles();
      }
      return success;
    } catch (e) {
      MTAToast().ShowToast(e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateSettingProfile(SettingProfileModel profile) async {
    isLoading.value = true;
    try {
      if (_authLogin == null) {
        throw Exception('Authentication not initialized');
      }
      MTAResult result = MTAResult();
      bool success = await SettingProfileDetails().Update(_authLogin!, profile, result);

      MTAToast().ShowToast(result.ResultMessage);
      if(success) {
        await fetchSettingProfiles();
      }
      return success;
    } catch (e) {
      MTAToast().ShowToast(e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteSettingProfile(String profileId) async {
    try {
      if (_authLogin == null) {
        throw Exception('Authentication not initialized');
      }

      MTAResult result = MTAResult();
      bool success =
          await SettingProfileDetails().Delete(_authLogin!, profileId, result);

      if (success) {
        MTAToast().ShowToast(result.ResultMessage);
        await fetchSettingProfiles();
      } else if (!result.IsResultPass) {
        MTAToast().ShowToast(result.ResultMessage);
        throw Exception(result.ErrorMessage);
      }
    } catch (e) {
      print(e.toString());
      MTAToast().ShowToast(e.toString());
    }
  }

  String get currentLoginId => _authLogin?.LoginID ?? '';
}