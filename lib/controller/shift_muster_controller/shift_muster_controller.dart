import 'package:get/get.dart';
import 'package:time_attendance/Data/LoginInformation/AuthLogin.dart';
import 'package:time_attendance/General/MTAResult.dart';
import 'package:time_attendance/model/shift_muster/shift_muster_details.dart';
import 'package:time_attendance/model/shift_muster/shift_muster_model.dart';
import 'package:time_attendance/model/employee_tab_model/employee_search_model.dart';

class ShiftMusterController extends GetxController {
  // Observables
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final musterList = <EmployeeShiftMusterModel>[].obs;
  final totalRecordCount = 0.obs;
  final isResultPass = false.obs;

  // Search filters
  final searchEmployeeView = Rx<EmployeeView?>(null);
  final startDate = ''.obs;
  final endDate = ''.obs;

  AuthLogin? _authLogin;

  // Set AuthLogin externally if needed
  void setAuthLogin(AuthLogin authLogin) {
    _authLogin = authLogin;
  }

  // Set search filters
  void setSearchFilters({
    required EmployeeView employeeView,
    required String start,
    required String end,
  }) {
    searchEmployeeView.value = employeeView;
    startDate.value = start;
    endDate.value = end;
  }

  // Fetch shift muster data
  Future<void> fetchShiftMuster() async {
    if (_authLogin == null) {
      errorMessage.value = 'Authentication not initialized';
      return;
    }
    isLoading.value = true;
    errorMessage.value = '';
    musterList.clear();
    try {
      final mtaResult = MTAResult();
      if (searchEmployeeView.value == null) {
        errorMessage.value = 'EmployeeView not set';
        isLoading.value = false;
        return;
      }
      final request = ShiftMusterRequest(
        employeeView: searchEmployeeView.value!,
        startDate: startDate.value,
        endDate: endDate.value,
      );
      final response = await ShiftMusterDetails().getEmployeeShiftMusterByEmployeeViewStartNEndDate(
        objAuthLogin: _authLogin!,
        request: request,
        objMTAResult: mtaResult,
      );
      if (response.isResultPass == true && response.musterList != null) {
        musterList.assignAll(response.musterList!);
        totalRecordCount.value = response.totalRecordCount ?? 0;
        isResultPass.value = true;
      } else {
        errorMessage.value = response.resultMessage ?? 'No records found.';
        isResultPass.value = false;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      isResultPass.value = false;
    } finally {
      isLoading.value = false;
    }
  }

    // Delete temporary shift for an employee
  Future<void> deleteTemporaryShift({
    required String employeeID,
    required String fromDate,
    required String toDate,
  }) async {
    if (_authLogin == null) {
      errorMessage.value = 'Authentication not initialized';
      return;
    }
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await ShiftMusterDetails().deleteTemporaryShift(
        objAuthLogin: _authLogin!,
        employeeID: employeeID,
        fromDate: fromDate,
        toDate: toDate,
      );
      if (response.isResultPass == true) {
        isResultPass.value = true;
        errorMessage.value = response.resultMessage ?? 'Deleted successfully.';
      } else {
        isResultPass.value = false;
        errorMessage.value = response.resultMessage ?? 'Delete failed.';
      }
    } catch (e) {
      isResultPass.value = false;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Save (bulk) temporary shift muster data
  Future<void> saveBulkTemporaryShift(List<EmpTemporaryShiftBulkRequest> requests) async {
    if (_authLogin == null) {
      errorMessage.value = 'Authentication not initialized';
      return;
    }
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final response = await ShiftMusterDetails().bulkTemporaryShift(
        _authLogin!,
        requests,
      );
      if (response.isResultPass == true) {
        isResultPass.value = true;
        errorMessage.value = response.resultMessage ?? 'Saved successfully.';
      } else {
        isResultPass.value = false;
        errorMessage.value = response.resultMessage ?? 'Save failed.';
      }
    } catch (e) {
      isResultPass.value = false;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}