import 'package:get/get.dart';
import 'package:time_attendance/General/MTAResult.dart';
import 'package:time_attendance/model/device_management_model/device_employee_model.dart';
import 'package:time_attendance/model/device_management_model/device_employee_details.dart';
import 'package:time_attendance/widgets/mtaToast.dart';

class DeviceEmployeeController extends GetxController {
  final isLoading = false.obs;
  final employees = <DeviceEmployeeInfo>[].obs;
  final filteredEmployees = <DeviceEmployeeInfo>[].obs;
  final searchQuery = ''.obs;
  
  // Sorting variables
  final sortColumn = RxString('Name');
  final isSortAscending = RxBool(true);

  final DeviceEmployeeDetails _deviceEmployeeDetails = DeviceEmployeeDetails();
  // Additional getter for total employee count
  int get totalEmployeeCount => employees.length;

  Future<void> getEmployeesByDevId(String deviceId) async {
    try {
      isLoading.value = true;
      MTAResult result = MTAResult();

      final response = await _deviceEmployeeDetails.getEmployeesByDevId(deviceId, result);
      
      if (result.IsResultPass) {
        employees.assignAll(response.userInfo);
        updateSearchQuery(''); // This will initialize filteredEmployees
      } else {
        MTAToast().ShowToast(result.ErrorMessage);
      }
    } catch (e) {
      MTAToast().ShowToast('Error getting device employees: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
  void updateSearchQuery(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredEmployees.assignAll(employees);
    } else {
      filteredEmployees.assignAll(
        employees.where((emp) => 
          emp.name.toLowerCase().contains(query.toLowerCase()) ||
          emp.employeeNo.toLowerCase().contains(query.toLowerCase()) ||
          emp.cardNo.toLowerCase().contains(query.toLowerCase())
        )
      );
    }
  }
  void sortEmployees(String columnName, bool? ascending) {
    // Update sort direction
    if (ascending != null) {
      isSortAscending.value = ascending;
    } else if (sortColumn.value == columnName) {
      isSortAscending.value = !isSortAscending.value;
    } else {
      isSortAscending.value = true;
    }
    
    sortColumn.value = columnName;

    // Null-safe comparison function
    int compareNullableStrings(String? a, String? b) {
      if (a == null && b == null) return 0;
      if (a == null) return -1;
      if (b == null) return 1;
      return a.toLowerCase().compareTo(b.toLowerCase());
    }

    filteredEmployees.sort((a, b) {
      int comparison;
      switch (columnName) {
        case 'Employee No.':
          comparison = compareNullableStrings(a.employeeNo, b.employeeNo);
          break;
        case 'Name':
          comparison = compareNullableStrings(a.name, b.name);
          break;
        case 'User Type':
          comparison = compareNullableStrings(a.userType, b.userType);
          break;
        case 'Door Right':
          comparison = compareNullableStrings(a.doorRight, b.doorRight);
          break;
        case 'Status':
          // Compare based on valid.enable and valid.endTime
          if (a.valid.enable != b.valid.enable) {
            comparison = a.valid.enable ? 1 : -1;
          } else {
            comparison = a.valid.endTime.compareTo(b.valid.endTime);
          }
          break;
        case 'Card No.':
          // Handle 'N/A' case for card numbers
          String aCard = a.cardNo.isEmpty ? 'N/A' : a.cardNo;
          String bCard = b.cardNo.isEmpty ? 'N/A' : b.cardNo;
          comparison = compareNullableStrings(aCard, bCard);
          break;
        case 'FingerPrint':
          // Compare fingerprint counts numerically
          comparison = a.fingerPrintCount.compareTo(b.fingerPrintCount);
          break;
        default:
          comparison = 0;
      }
      return isSortAscending.value ? comparison : -comparison;
    });
  }
  void clearEmployees() {
    employees.clear();
    filteredEmployees.clear();
    searchQuery.value = '';
  }
}