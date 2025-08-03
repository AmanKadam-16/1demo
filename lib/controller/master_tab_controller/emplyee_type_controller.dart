// department_controller.dart
import 'package:get/get.dart';
import 'package:time_attendance/Data/LoginInformation/AuthLogin.dart';
import 'package:time_attendance/Data/LoginInformation/AuthLoginInfoDetails.dart';
import 'package:time_attendance/General/MTAResult.dart';
import 'package:time_attendance/model/Masters/empType.dart';
import 'package:time_attendance/model/Masters/empTypeDetails.dart';
// import 'package:time_attendance/model/Masters/departmentDetails.dart';
import 'package:time_attendance/model/master_tab_model/employee_type_model.dart';
import 'package:time_attendance/widgets/mtaToast.dart';
import 'package:time_attendance/model/TALogin/session_manager.dart'
    if (dart.library.html) 'package:time_attendance/model/TALogin/session_manager_web.dart'
    if (dart.library.io) 'package:time_attendance/model/TALogin/session_manager_mobile.dart';

class EmplyeeTypeController extends GetxController {
  // Lists for departments
  final empTypeDetails = <EmployeeTypeModel>[].obs;
  final filteredEmployeeTypes = <EmployeeTypeModel>[].obs;
  final searchQuery = ''.obs;
  final isLoading = false.obs;
  
  // Sorting variables
  final sortColumn = RxString('Employee Type Name');
  final isSortAscending = RxBool(true);

  // Authentication instance
  AuthLogin? _authLogin;

  @override
  void onInit() {
    super.onInit();
    initializeAuthEmpType();
  }


  Future<void> initializeAuthEmpType() async {
    try {
      MTAResult objResult = MTAResult();
      final userInfo = await PlatformSessionManager.getUserInfo();
      if (userInfo != null) {
        String companyCode = userInfo['CompanyCode'];
        String loginID = userInfo['LoginID'];
        String password = userInfo['Password'];
        _authLogin = await AuthLoginDetails()
            .LoginInformationForFirstLogin(companyCode, loginID, password);
        fetchEmployeeTypes();
      }
    } catch (e) {
      MTAToast().ShowToast(e.toString());
    }
  }
  Future<void> fetchEmployeeTypes() async {
    try {
      if (_authLogin == null) {
        throw Exception('Authentication not initialized');
      }
      
      isLoading.value = true;
      
      MTAResult result = MTAResult();
      List<EmpType> apiEmployeeTypes = await EmpTypeDetails().GetAllEmpTypees(
        _authLogin!,
        result
      );
      
      empTypeDetails.value = apiEmployeeTypes.map((d) => EmployeeTypeModel(
        employeeTypeId: d.EmpTypeID,
        employeeTypeName: d.EmpTypeName,
        // isDataRetrieved: d.IsDataRetrieved,

      )).toList();
      
      updateSearchQuery('');
      
    } catch (e) {
      MTAToast().ShowToast(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveEmployeeType(EmployeeTypeModel employeeType) async {
    try {
      if (_authLogin == null) {
        throw Exception('Authentication not initialized');
      }

      MTAResult result = MTAResult();
      EmpType apiEmployeeType = EmpType()
        ..EmpTypeName = employeeType.employeeTypeName;
      
      bool success;
      if (employeeType.employeeTypeId.isEmpty || employeeType.employeeTypeId == 'W') {
        // For new records
        success = await EmpTypeDetails().Save(_authLogin!, apiEmployeeType, result);
      } else {
        // For updating existing records
        apiEmployeeType.EmpTypeID = employeeType.employeeTypeId;
        success = await EmpTypeDetails().Update(_authLogin!, apiEmployeeType, result);
      }

      if (success) {
        Get.snackbar(
          'Success',
          'Employee Type ${employeeType.employeeTypeId.isEmpty ? 'added' : 'updated'} successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
        await fetchEmployeeTypes();
      } else {
        throw Exception(result.ErrorMessage);
      }
    } catch (e) {
      MTAToast().ShowToast(e.toString());
    }
  }

  Future<void> deleteEmployeeType(String employeeTypeId) async {
    try {
      if (_authLogin == null) {
        throw Exception('Authentication not initialized');
      }
      
      MTAResult result = MTAResult();
      bool success = await EmpTypeDetails().Delete(_authLogin!, employeeTypeId, result);
      
      if (success) {
        MTAToast().ShowToast(result.ResultMessage);
        await fetchEmployeeTypes();
      } else if (!result.IsResultPass) {
        MTAToast().ShowToast(result.ResultMessage);
        throw Exception(result.ErrorMessage);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredEmployeeTypes.assignAll(empTypeDetails);
    } else {
      filteredEmployeeTypes.assignAll(
        empTypeDetails.where((d) => 
        
          d.employeeTypeName.toLowerCase().contains(query.toLowerCase())

        )
      );
    }
  }

  void sortEmployeeTypes(String columnName, bool? ascending) {
    if (ascending != null) {
      isSortAscending.value = ascending;
    } else if (sortColumn.value == columnName) {
      isSortAscending.value = !isSortAscending.value;
    } else {
      isSortAscending.value = true;
    }
    
    sortColumn.value = columnName;

    filteredEmployeeTypes.sort((a, b) {
      int comparison;
      switch (columnName) {
        case 'Employee Type':
          comparison = a.employeeTypeName.compareTo(b.employeeTypeName);
          break;
      
        default:
          comparison = 0;
      }
      return isSortAscending.value ? comparison : -comparison;
    });
  }
}