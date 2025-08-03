import 'package:get/get.dart';
import 'package:time_attendance/Data/LoginInformation/AuthLogin.dart';
import 'package:time_attendance/Data/LoginInformation/AuthLoginInfoDetails.dart';
import 'package:time_attendance/General/MTAResult.dart';
import 'package:time_attendance/model/temp_weeklyOff_muster/temp_weeklyOff_details.dart';
import 'package:time_attendance/model/temp_weeklyOff_muster/temp_weeklyOff_model.dart';
import 'package:time_attendance/widgets/mtaToast.dart';
import 'package:time_attendance/model/TALogin/session_manager.dart'
    if (dart.library.html) 'package:time_attendance/model/TALogin/session_manager_web.dart'
    if (dart.library.io) 'package:time_attendance/model/TALogin/session_manager_mobile.dart';

class TempWeeklyOffController extends GetxController {
  final isLoading = false.obs;
  AuthLogin? _authLogin;

  @override
  void onInit() {
    super.onInit();
    initializeAuth();
  }

  Future<void> initializeAuth() async {
    try {
      final userInfo = await PlatformSessionManager.getUserInfo();
      if (userInfo != null) {
        String companyCode = userInfo['CompanyCode'];
        String loginID = userInfo['LoginID'];
        String password = userInfo['Password'];
        _authLogin = await AuthLoginDetails()
            .LoginInformationForFirstLogin(companyCode, loginID, password);
      }
    } catch (e) {
      MTAToast().ShowToast(e.toString());
    }
  }

  List<TempWeeklyOffModel> createWeeklyOffModels({
    required List<String> employeeIds,
    required String firstWOff,
    required String secondWOff,
    required bool isFullDay,
    required String wOffPattern,
    required DateTime startDate,
    required DateTime endDate,
    bool forDelete = false,
  }) {
    return employeeIds.map((employeeId) => TempWeeklyOffModel(
      employeeID: employeeId,
      employeeName: '',
      firstName: '',
      firstWOff: firstWOff,
      secondWOff: secondWOff,
      isFullDay: isFullDay,
      wOffPattern: wOffPattern,
      startDate: startDate.toIso8601String().split('T')[0],
      // startDateTime: startDate.toIso8601String(),
      endDate: endDate.toIso8601String().split('T')[0],
      // endDateTime: endDate.toIso8601String(),
      errorMessage: '',
      isErrorFound: false,
      recordNeedsToDelete: forDelete,
      recordNeedsToAdd: !forDelete,
    )).toList();
  }

  Future<bool> saveWeeklyOff(List<TempWeeklyOffModel> weeklyOffList) async {
    try {
      if (_authLogin == null) {
        throw Exception('Authentication not initialized');
      }

      isLoading.value = true;
      MTAResult result = MTAResult();
      
      bool success = await TempWeeklyOffDetails()
          .saveWeeklyOff(_authLogin!, weeklyOffList, result);

      if (success) {
        MTAToast().ShowToast(result.ResultMessage);
        return true;
      } else {
        MTAToast().ShowToast(result.ResultMessage);
        return false;
      }
    } catch (e) {
      MTAToast().ShowToast(e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteWeeklyOff(List<TempWeeklyOffModel> weeklyOffList) async {
    try {
      if (_authLogin == null) {
        throw Exception('Authentication not initialized');
      }

      isLoading.value = true;
      MTAResult result = MTAResult();
      
      bool success = await TempWeeklyOffDetails()
          .deleteWeeklyOff(_authLogin!, weeklyOffList, result);

      if (success) {
        MTAToast().ShowToast(result.ResultMessage);
        return true;
      } else {
        MTAToast().ShowToast(result.ResultMessage);
        return false;
      }
    } catch (e) {
      MTAToast().ShowToast(e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
