import 'package:get/get.dart';
import 'package:time_attendance/Data/LoginInformation/AuthLogin.dart';
import 'package:time_attendance/Data/LoginInformation/AuthLoginInfoDetails.dart';
import 'package:time_attendance/General/MTAResult.dart';
import 'package:time_attendance/model/regular_shift/regular_shift_details.dart';
import 'package:time_attendance/model/regular_shift/regular_shift_model.dart';
import 'package:time_attendance/widgets/mtaToast.dart';
import 'package:time_attendance/model/TALogin/session_manager.dart'
    if (dart.library.html) 'package:time_attendance/model/TALogin/session_manager_web.dart'
    if (dart.library.io) 'package:time_attendance/model/TALogin/session_manager_mobile.dart';

class RegularShiftController extends GetxController {
  // Public method to set last used parameters
  void setLastParams({required String employeeID, required String startDate, required String endDate}) {
    _lastEmployeeID = employeeID;
    _lastStartDate = startDate;
    _lastEndDate = endDate;
  }
  // Store last used fetch parameters
  String? _lastEmployeeID;
  String? _lastStartDate;
  String? _lastEndDate;
  final regularShifts = <RegularShiftModel>[].obs;
  final filteredRegularShifts = <RegularShiftModel>[].obs;
  final searchQuery = ''.obs;
  final isLoading = false.obs;

  AuthLogin? _authLogin;

  @override
  void onInit() {
    super.onInit();
    initializeAuthRegularShift();
  }

  Future<void> initializeAuthRegularShift() async {
    try {
      final userInfo = await PlatformSessionManager.getUserInfo();
      if (userInfo != null) {
        String companyCode = userInfo['CompanyCode'];
        String loginID = userInfo['LoginID'];
        String password = userInfo['Password'];
        _authLogin = await AuthLoginDetails().LoginInformationForFirstLogin(companyCode, loginID, password);
      }
    } catch (e) {
      MTAToast().ShowToast(e.toString());
    }
  }

  Future<void> fetchRegularShifts({
    required String employeeID,
    required String startDate,
    required String endDate,
  }) async {
    try {
      if (_authLogin == null) {
        throw Exception('Authentication not initialized');
      }
      isLoading.value = true;
      MTAResult result = MTAResult();
      // Store last used params
      _lastEmployeeID = employeeID;
      _lastStartDate = startDate;
      _lastEndDate = endDate;
      List<RegularShiftModel> apiShifts = await RegularShiftDetails().getEmployeeRegularShifts(
        authLogin: _authLogin!,
        employeeID: employeeID,
        startDate: startDate,
        endDate: endDate,
        mtaResult: result,
      );
      regularShifts.value = apiShifts;
      updateSearchQuery('');
      if (!result.IsResultPass) {
        MTAToast().ShowToast(result.ResultMessage);
      }
    } catch (e) {
      MTAToast().ShowToast(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredRegularShifts.assignAll(regularShifts);
    } else {
      filteredRegularShifts.assignAll(
        regularShifts.where((s) =>
          s.employeeName.toLowerCase().contains(query.toLowerCase()) ||
          s.shiftName.toLowerCase().contains(query.toLowerCase()) ||
          s.patternName.toLowerCase().contains(query.toLowerCase())
        )
      );
    }
  }

    /// Delete a regular shift for an employee by employeeID and shiftDate
  Future<void> deleteRegularShift({
    required String employeeID,
    required String shiftDate,
  }) async {
    try {
      if (_authLogin == null) {
        throw Exception('Authentication not initialized');
      }
      MTAResult result = MTAResult();
      bool success = await RegularShiftDetails().deleteEmpRegularShift(
        authLogin: _authLogin!,
        employeeID: employeeID,
        shiftDate: shiftDate,
        mtaResult: result,
      );
      if (success) {
        MTAToast().ShowToast(result.ResultMessage);
        // Refresh shifts after delete if last params are available
        if (_lastEmployeeID != null && _lastStartDate != null && _lastEndDate != null) {
          await fetchRegularShifts(
            employeeID: _lastEmployeeID!,
            startDate: _lastStartDate!,
            endDate: _lastEndDate!,
          );
        }
      } else if (!result.IsResultPass) {
        MTAToast().ShowToast(result.ResultMessage);
        throw Exception(result.ResultMessage);
      }
    } catch (e) {
      MTAToast().ShowToast(e.toString());
    }
  }

  // Add more methods for saving, updating, or deleting shifts as needed
  Future<void> saveOrUpdateRegularShift(RegularShiftModel shiftModel) async {
    try {
      if (_authLogin == null) {
        throw Exception('Authentication not initialized');
      }
      MTAResult result = MTAResult();
      bool success = await RegularShiftDetails().saveOrUpdateEmpRegularShift(
        authLogin: _authLogin!,
        shiftModel: shiftModel,
        mtaResult: result,
      );
      if (success) {
        MTAToast().ShowToast(result.ResultMessage);
        // Refresh shifts after save/update if last params are available
        if (_lastEmployeeID != null && _lastStartDate != null && _lastEndDate != null) {
          await fetchRegularShifts(
            employeeID: _lastEmployeeID!,
            startDate: _lastStartDate!,
            endDate: _lastEndDate!,
          );
        }
      } else if (!result.IsResultPass) {
        MTAToast().ShowToast(result.ResultMessage); 
        throw Exception(result.ResultMessage);
      }
    } catch (e) {
      MTAToast().ShowToast(e.toString());
    }
  }
}
