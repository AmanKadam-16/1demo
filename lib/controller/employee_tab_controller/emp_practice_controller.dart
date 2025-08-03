import 'package:get/get.dart';
import 'package:time_attendance/Data/LoginInformation/AuthLogin.dart';
import 'package:time_attendance/Data/LoginInformation/AuthLoginInfoDetails.dart';
import 'package:time_attendance/General/MTAResult.dart';
import 'package:time_attendance/model/Masters/branchDetails.dart';
import 'package:time_attendance/model/Masters/departmentDetails.dart';
import 'package:time_attendance/model/Masters/designationDetails.dart';
import 'package:time_attendance/model/Masters/empTypeDetails.dart';
import 'package:time_attendance/model/Masters/shiftDetails.dart';
import 'package:time_attendance/model/employee_tab_model/employee_practice_model.dart';

import 'package:time_attendance/model/reusable_widget_model/filter_model.dart';
import 'package:time_attendance/model/TALogin/session_manager.dart'
    if (dart.library.html) 'package:time_attendance/model/TALogin/session_manager_web.dart'
    if (dart.library.io) 'package:time_attendance/model/TALogin/session_manager_mobile.dart';
import 'package:time_attendance/widgets/mtaToast.dart';
class EmployeePracticeController extends GetxController {
  final employees = <EmployeeModel>[].obs;
  final filteredEmployees = <EmployeeModel>[].obs;
  final isLoading = false.obs;

  // Filter Options
  final companies = <String>[].obs;
  final departments = <String>[].obs;
  final designations = <String>[].obs;
  final branches = <String>[].obs;
  final employeeTypes = <String>[].obs;
  final shifts = <String>[].obs;
  final statusOptions = ['Active', 'Inactive'].obs;

  // Selected Values
  final selectedCompany = RxString('');
  final selectedDepartment = RxString('');
  final selectedDesignation = RxString('');
  final selectedBranch = RxString('');
  final selectedEmployeeType = RxString('');
  final selectedStatus = RxString('');
  final selectedShift = RxString('');

  // Text Field Values
  final employeeName = ''.obs;
  final employeeId = ''.obs;
  final enrollId = ''.obs;

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
        await Future.wait([
          fetchCompanies(),
          fetchDepartments(),
          fetchDesignations(),
          fetchBranches(),
          fetchEmployeeTypes(),
          fetchShifts(),
        ]);
        await fetchEmployees();
      }
    } catch (e) {
      MTAToast().ShowToast(e.toString());
    }
  }

  Future<void> fetchCompanies() async {
    try {
      if (_authLogin == null) return;
      final result = MTAResult();
      final companyList = await BranchDetails().GetAllBranches(_authLogin!, result);
      companies.value = companyList.map((c) => c.BranchName).toList();
    } catch (e) {
      MTAToast().ShowToast(e.toString());
    }
  }

  Future<void> fetchDepartments() async {
    try {
      if (_authLogin == null) return;
      final result = MTAResult();
      final deptList = await DepartmentDetails().GetAllDepartmentes(_authLogin!, result);
      departments.value = deptList.map((d) => d.DepartmentName).toList();
    } catch (e) {
      MTAToast().ShowToast(e.toString());
    }
  }

  Future<void> fetchDesignations() async {
    try {
      if (_authLogin == null) return;
      final result = MTAResult();
      final designationList = await DesignationDetails().GetAllDesignationes(_authLogin!, result);
      designations.value = designationList.map((d) => d.DesignationName).toList();
    } catch (e) {
      MTAToast().ShowToast(e.toString());
    }
  }

  Future<void> fetchBranches() async {
    try {
      if (_authLogin == null) return;
      final result = MTAResult();
      final branchList = await BranchDetails().GetAllBranches(_authLogin!, result);
      branches.value = branchList.map((b) => b.BranchName).toList();
    } catch (e) {
      MTAToast().ShowToast(e.toString());
    }
  }

  Future<void> fetchEmployeeTypes() async {
    try {
      if (_authLogin == null) return;
      final result = MTAResult();
      final typeList = await EmpTypeDetails().GetAllEmpTypees(_authLogin!, result);
      employeeTypes.value = typeList.map((t) => t.EmpTypeName).toList();
    } catch (e) {
      MTAToast().ShowToast(e.toString());
    }
  }
  Future<void> fetchShifts() async {
    try {
      if (_authLogin == null) return;
      final result = MTAResult();
      final shiftList = await ShiftDetails().GetAllShiftes(_authLogin!, result);
      shifts.value = shiftList.map((t) => t.ShiftName).toList();
    } catch (e) {
      MTAToast().ShowToast(e.toString());
    }
  }

  Future<void> fetchEmployees() async {
    try {
      if (_authLogin == null) return;
      isLoading.value = true;
      final result = MTAResult();
      final employeeList = await EmpTypeDetails().GetAllEmpTypees(_authLogin!, result);
      
      employees.value = employeeList.map((e) => EmployeeModel(
        id: e.EmpTypeID,
        name: e.EmpTypeName,
        company: '',
        department: '',
        designation: '',
        branch: '',
        employeeType: '',
        status: '',
        shift: '',
         enrollId: '',
        // company: c.c,
        // department: e.DepartmentName,
        // designation: e.DesignationName,
        // branch: e.BranchName,
        // employeeType: e.EmpTypeName,
        // status: e.Status,
      )).toList();
      
      applyFilters();
    } catch (e) {
      MTAToast().ShowToast(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilters() {
    filteredEmployees.value = employees.where((employee) {
      bool matchesCompany = selectedCompany.isEmpty || employee.company == selectedCompany.value;
      bool matchesDepartment = selectedDepartment.isEmpty || employee.department == selectedDepartment.value;
      bool matchesDesignation = selectedDesignation.isEmpty || employee.designation == selectedDesignation.value;
      bool matchesBranch = selectedBranch.isEmpty || employee.branch == selectedBranch.value;
      bool matchesType = selectedEmployeeType.isEmpty || employee.employeeType == selectedEmployeeType.value;
      bool matchesStatus = selectedStatus.isEmpty || employee.status == selectedStatus.value;
      bool matchesShift = selectedShift.isEmpty || employee.shift == selectedShift.value;
      bool matchesName = employeeName.isEmpty || employee.name.toLowerCase().contains(employeeName.value.toLowerCase());
      bool matchesId = employeeId.isEmpty || employee.id.toString().contains(employeeId.value);
      bool matchesEnrollId = enrollId.isEmpty || employee.enrollId.toString().contains(enrollId.value);

      return matchesCompany && matchesDepartment && matchesDesignation && 
             matchesBranch && matchesType && matchesStatus && matchesShift &&
             matchesName && matchesId && matchesEnrollId;
    }).toList();
  }

  void clearFilters() {
    selectedCompany.value = '';
    selectedDepartment.value = '';
    selectedDesignation.value = '';
    selectedBranch.value = '';
    selectedEmployeeType.value = '';
    selectedStatus.value = '';
    selectedShift.value = '';
    employeeName.value = '';
    employeeId.value = '';
    enrollId.value = '';
    applyFilters();
  }

  Map<String, List<FilterOption>> get filterOptions => {
    'Company': companies.map((c) => FilterOption(value: c, label: c)).toList(),
    'Department': departments.map((d) => FilterOption(value: d, label: d)).toList(),
    'Designation': designations.map((d) => FilterOption(value: d, label: d)).toList(),
    'Branch': branches.map((b) => FilterOption(value: b, label: b)).toList(),
    'Employee Type': employeeTypes.map((t) => FilterOption(value: t, label: t)).toList(),
    'Status': statusOptions.map((s) => FilterOption(value: s, label: s)).toList(),
    'Shift': shifts.map((s) => FilterOption(value: s, label: s)).toList(),
  };
}
