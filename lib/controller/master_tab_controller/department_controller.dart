// department_controller.dart
import 'package:get/get.dart';
import 'package:time_attendance/Data/LoginInformation/AuthLogin.dart';
import 'package:time_attendance/Data/LoginInformation/AuthLoginInfoDetails.dart';
import 'package:time_attendance/General/MTAResult.dart';
import 'package:time_attendance/model/Masters/department.dart';
import 'package:time_attendance/model/Masters/departmentDetails.dart';
// import 'package:time_attendance/model/Masters/departmentDetails.dart';
import 'package:time_attendance/model/master_tab_model/department_model.dart';
import 'package:time_attendance/widgets/mtaToast.dart';
import 'package:time_attendance/model/TALogin/session_manager.dart'
    if (dart.library.html) 'package:time_attendance/model/TALogin/session_manager_web.dart'
    if (dart.library.io) 'package:time_attendance/model/TALogin/session_manager_mobile.dart';

class DepartmentController extends GetxController {
  // Lists for departments
  final departments = <DepartmentModel>[].obs;
  final filteredDepartments = <DepartmentModel>[].obs;
  final searchQuery = ''.obs;
  final isLoading = false.obs;
  
  // Sorting variables
  final sortColumn = RxString('DepartmentName');
  final isSortAscending = RxBool(true);

  // Authentication instance
  AuthLogin? _authLogin;

  @override
  void onInit() {
    super.onInit();
    initializeAuthDept();
  }

    Future<void> initializeAuthDept() async {
      try {
        MTAResult objResult = MTAResult();
        final userInfo = await PlatformSessionManager.getUserInfo();
        if (userInfo != null) {
          String companyCode = userInfo['CompanyCode'];
          String loginID = userInfo['LoginID'];
          String password = userInfo['Password'];
          _authLogin = await AuthLoginDetails().LoginInformationForFirstLogin(companyCode, loginID, password);
          fetchDepartments();
        }
      } catch (e) {
        MTAToast().ShowToast(e.toString());
      }
    }

  Future<void> fetchDepartments() async {
    try {
      if (_authLogin == null) {
        throw Exception('Authentication not initialized');
      }
      
      isLoading.value = true;
      
      MTAResult result = MTAResult();
      List<Department> apiDepartments = await DepartmentDetails().GetAllDepartmentes(
        _authLogin!,
        result
      );
      
      departments.value = apiDepartments.map((d) => DepartmentModel(
        departmentId: d.DepartmentID,
        departmentName: d.DepartmentName,
        masterDepartmentId: d.MasterDepartmentID,
        masterDepartmentName: d.MasterDepartmentName,
        isDataRetrieved: d.IsDataRetrieved,
      )).toList();
      
      updateSearchQuery('');
      
    } catch (e) {
      MTAToast().ShowToast(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveDepartment(DepartmentModel department) async {
    try {
      if (_authLogin == null) {
        throw Exception('Authentication not initialized');
      }

      MTAResult result = MTAResult();
      Department apiDepartment = Department()
        ..DepartmentName = department.departmentName
        ..MasterDepartmentID = department.masterDepartmentId;
      
      bool success;
      if (department.departmentId.isEmpty) {
        success = await DepartmentDetails().Save(_authLogin!, apiDepartment, result);
      } else {
        apiDepartment.DepartmentID = department.departmentId;
        success = await DepartmentDetails().Update(_authLogin!, apiDepartment, result);
      }

      if (success) {
    MTAToast().ShowToast(result.ResultMessage);
        await fetchDepartments();
      } else if (!result.IsResultPass) {
        MTAToast().ShowToast(result.ResultMessage);
        throw Exception(result.ErrorMessage);
      }
    } catch (e) {
      MTAToast().ShowToast(e.toString());
    }
  }

  Future<void> deleteDepartment(String departmentId) async {
    try {
      if (_authLogin == null) {
        throw Exception('Authentication not initialized');
      }
      
      MTAResult result = MTAResult();
      bool success = await DepartmentDetails().Delete(_authLogin!, departmentId, result);
      
      if (success) {
        MTAToast().ShowToast(result.ResultMessage);
        await fetchDepartments();
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
      filteredDepartments.assignAll(departments);
    } else {
      filteredDepartments.assignAll(
        departments.where((d) => 
          d.departmentName.toLowerCase().contains(query.toLowerCase()) ||
          d.masterDepartmentName.toLowerCase().contains(query.toLowerCase())
        )
      );
    }
  }

  void sortDepartments(String columnName, bool? ascending) {
    if (ascending != null) {
      isSortAscending.value = ascending;
    } else if (sortColumn.value == columnName) {
      isSortAscending.value = !isSortAscending.value;
    } else {
      isSortAscending.value = true;
    }
    
    sortColumn.value = columnName;

    filteredDepartments.sort((a, b) {
      int comparison;
      switch (columnName) {
        case 'Department':
          comparison = a.departmentName.compareTo(b.departmentName);
          break;
        case 'Master Department':
          comparison = a.masterDepartmentName.compareTo(b.masterDepartmentName);
          break;
        default:
          comparison = 0;
      }
      return isSortAscending.value ? comparison : -comparison;
    });
  }
}