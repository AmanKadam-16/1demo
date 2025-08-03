import 'package:get/get.dart';
import 'package:time_attendance/General/MTAResult.dart';
import 'package:time_attendance/model/device_management_model/device_emloyee_edit_model.dart';
import 'package:time_attendance/model/device_management_model/device_employee_details.dart';
import 'package:time_attendance/model/device_management_model/device_employee_model_HikeVision.dart';
import 'package:time_attendance/model/device_management_model/device_employee_transfer_model.dart';
import 'package:time_attendance/model/device_management_model/device_employee_transfer_details.dart';
import 'package:time_attendance/model/device_management_model/mega_transfer_result.dart';
import 'package:time_attendance/widgets/mtaToast.dart';

// controller for device employee management
class DeviceEmployeeControllerHK extends GetxController {
  final isLoading = false.obs;
  final isTransferInProgress = false.obs;
  final employees = <UserInfo>[].obs;
  final DeviceEmployeeDetails _deviceEmployeeDetails = DeviceEmployeeDetails();

  // Search parameters
  final searchPosition = 0.obs;
  final maxResults = 100.obs;

  Future<void> searchDeviceUsers(String deviceIndex) async {
    try {
      isLoading.value = true;
      MTAResult result = MTAResult();

      // Create search request
      final searchRequest = UserSearchRequest(
        devIndex: deviceIndex,
        userInfoSearchCond: UserInfoSearchCond(
          searchID: DateTime.now().millisecondsSinceEpoch.toString(),
          searchResultPosition: searchPosition.value,
          maxResults: maxResults.value,
        ),
      );

      // TODO: Call the API service to search users
      // final response = await _deviceEmployeeService.searchUsers(searchRequest, result);

      // Process response
      // if (response != null) {
      //   employees.assignAll(response.userInfoSearch.userInfo);
      // }

      if (!result.IsResultPass) {
        MTAToast().ShowToast(result.ErrorMessage);
      }
    } catch (e) {
      MTAToast().ShowToast('Error searching device users: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteDeviceUsers(
      List<String> deviceIndexes, List<String> employeeNumbers) async {
    try {
      isLoading.value = true;
      MTAResult result = MTAResult();
      bool overallSuccess = true;

      // Process each device
      for (var deviceIndex in deviceIndexes) {
        // Process employees in batches of 10 for each device
        for (var i = 0; i < employeeNumbers.length; i += 10) {
          // Calculate the end index for current batch
          var end =
              (i + 10 < employeeNumbers.length) ? i + 10 : employeeNumbers.length;
          // Get current batch of employee numbers
          var batch = employeeNumbers.sublist(i, end);

          await _deviceEmployeeDetails.deleteDeviceUsers(
              deviceIndex, batch, result);
          if (!result.IsResultPass) {
            overallSuccess = false;
            MTAToast().ShowToast(
                'Error deleting batch ${(i / 10 + 1).floor()} from device $deviceIndex: ${result.ErrorMessage}');
            // Continue with next batch even if current fails
            continue;
          }
        }
      }

      if (overallSuccess) {
        MTAToast().ShowToast('Selected user(s) deleted successfully from selected device(s)');
        return true;
      } else {
        MTAToast().ShowToast('Some batches failed to delete');
        return true;
      }
    } catch (e) {
      MTAToast().ShowToast('Error deleting device users: ${e.toString()}');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  String _formatDateTime(String timeType, bool enableEmployee) {
    // Create fixed dates for enable/disable scenarios
    DateTime resultDate;
    if (enableEmployee) {
      resultDate = DateTime(2037, 12, 15); // December 15, 2037
    } else {
      resultDate =
          DateTime.now().subtract(const Duration(days: 30)); // Past month
    }

    if (timeType.toLowerCase() == 'utc') {
      return '${resultDate.toLocal().toString().split('.').first}+05:30';
    } else {
      // For local time format: "2017-08-01T17:30:08"
      return resultDate.toLocal().toString().split('.').first;
    }
  }

  String _getBeginTime( String timeType) {
    if (timeType.toLowerCase() == 'utc') {
      return '1970-01-01T05:30:00+05:30';
    } else {
      return '1970-01-01T05:30:00';
    }
    
  }

  Future<bool> modifyDeviceUser(Set<dynamic> set, {
    required DeviceEmployeeAddRequest employeeDetails,
    bool disableEmployee = false,
    bool enableEmployee = false,
  }) async {
    try {
      isLoading.value = true;
      MTAResult result = MTAResult();
      String updatedEndTime = '';
      if (disableEmployee) {
        updatedEndTime = _formatDateTime(employeeDetails.timeType, false);
      } else if (enableEmployee) {
        updatedEndTime =
            _formatDateTime(employeeDetails.timeType, true);
      } else {
        updatedEndTime = employeeDetails.endTime;
      }
      employeeDetails.endTime = updatedEndTime;
      await _deviceEmployeeDetails.modifyDeviceUser(
        employeeDetails.devIndex,
        employeeDetails.employeeNo,
        employeeDetails.name,
        employeeDetails.beginTime,
        updatedEndTime,
        true, // Assuming enable is always true for modification
        employeeDetails.timeType,
        result,
      );

      if (result.IsResultPass) {
        // MTAToast().ShowToast('User modified successfully');
        bool success = await _deviceEmployeeDetails.addDeviceEmployee(
          employeeDetails,
          result,
        );

        return success;
      } else {
        MTAToast().ShowToast(result.ErrorMessage);
        return false;
      }
    } catch (e) {
      MTAToast().ShowToast('Error modifying device user: ${e.toString()}');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> modifyUserApi({
    required List<DeviceEmployeeAddRequest> employeeDetails,
    bool enable = true,
    bool disableEmployee = false,
    bool enableEmployee = false,
  }) async {
    try {
      isLoading.value = true;
      MTAResult result = MTAResult();
      bool overallSuccess = true;

      // Process each employee in the list
      for (var employee in employeeDetails) {
        String updatedEndTime = '';
        if (disableEmployee) {
          updatedEndTime = _formatDateTime(employee.timeType, false);
        } else if (enableEmployee) {
          updatedEndTime = _formatDateTime(employee.timeType, true);
        } else {
          updatedEndTime = employee.endTime;
        }
        employee.endTime = updatedEndTime;
        employee.beginTime = (!enableEmployee && !disableEmployee) ? employee.beginTime : _getBeginTime(employee.timeType);

        // Modify device user
        await _deviceEmployeeDetails.modifyDeviceUser(
          employee.devIndex,
          employee.employeeNo,
          employee.name,
          employee.beginTime,
          updatedEndTime,
          enable,
          employee.timeType,
          result,
        );

        if (result.IsResultPass) {
          // Add device employee
          bool success = await _deviceEmployeeDetails.addDeviceEmployee(
            employee,
            result,
          );
          if (success) {
            MTAToast().ShowToast('Employee modified successfully: ${employee.employeeNo}');
          } else {
            MTAToast().ShowToast('Failed to add employee: ${employee.employeeNo}');
          }
          
          if (!success) {
            overallSuccess = false;
            MTAToast().ShowToast('Failed to add employee: ${employee.employeeNo}');
          }
        } else {
          overallSuccess = false;
          MTAToast().ShowToast('Failed to modify employee: ${employee.employeeNo} - ${result.ErrorMessage}');
        }
      }

      if (overallSuccess) {
        MTAToast().ShowToast('All employees modified successfully');
      } else {
        MTAToast().ShowToast('Some employees failed to be modified');
      }
      
      return overallSuccess;
    } catch (e) {
      MTAToast().ShowToast('Error modifying device users: ${e.toString()}');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> syncEmployeeBiometricDetails(String deviceIndex) async {
    try {
      isLoading.value = true;
      MTAResult result = MTAResult();

      final response = await _deviceEmployeeDetails.syncEmployeeBiometricDetails(
        deviceIndex,
        result,
      );

      if (result.IsResultPass) {
        MTAToast().ShowToast(
            'Sync completed: ${response.successfullyAdded} of ${response.totalProcessed} employees processed');
        return true;
      } else {
        MTAToast().ShowToast('Sync failed: ${result.ErrorMessage}');
        return false;
      }
    } catch (e) {
      MTAToast().ShowToast('Error syncing biometric details: ${e.toString()}');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void clearSearchResults() {
    employees.clear();
    searchPosition.value = 0;
  }

  void loadMoreResults(String deviceIndex) {
    searchPosition.value += maxResults.value;
    searchDeviceUsers(deviceIndex);
  }

  Future<MegaTransferResult> megaEmployeeBiometricDataTransferSync({
    required List<EmployeeTransferDetail> employeeDetails,
    required List<String> targetDevices,
    required String hostDeviceIndex,
  }) async {
    try {
      // isLoading.value = true;
      isTransferInProgress.value = true;
      MTAResult result = MTAResult();
      
      final request = MegaTransferRequest(
        empDetailsList: employeeDetails,
        targetDevIdList: targetDevices,
        hostDevIndex: hostDeviceIndex,
      );

      final deviceEmployeeTransfer = DeviceEmployeeTransferDetails();
      
      final response = await deviceEmployeeTransfer.transferEmployees(request, result);

      if (result.IsResultPass) {
        String successMessage = 'Sync completed: ${response.successfulEmployees} of ${response.totalEmployees} employees transferred to ${response.totalTargetDevices} devices';
        if (response.errors.isNotEmpty) {
          successMessage += '\nWith ${response.errors.length} errors';
        }
        MTAToast().ShowToast(successMessage);
        return MegaTransferResult(success: true, response: response);
      } else {
        MTAToast().ShowToast('Sync failed: ${result.ErrorMessage}');
        return MegaTransferResult(success: false);
      }
    } catch (e) {
      MTAToast().ShowToast('Error during mega sync: ${e.toString()}');
      return MegaTransferResult(success: false);
    } finally {
      // isLoading.value = false;
      isTransferInProgress.value = false;
    }
  }
}
