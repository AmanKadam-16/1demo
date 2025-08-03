// emplyoee_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/Data/LoginInformation/AuthLogin.dart';
import 'package:time_attendance/Data/LoginInformation/AuthLoginInfoDetails.dart';
import 'package:time_attendance/General/MTAResult.dart';
import 'package:time_attendance/controller/employee_tab_controller/employee_search_controller.dart';
import 'package:time_attendance/model/employee_tab_model/employee_complete_model.dart';
import 'package:time_attendance/model/employee_tab_model/settingprofile.dart';
// import 'package:time_attendance/model/employee_tab_model/employee_model.dart';
import 'package:time_attendance/model/employee_tab_model/employee_details.dart';
import 'package:time_attendance/widgets/mtaToast.dart';
import 'package:time_attendance/model/TALogin/session_manager.dart'
    if (dart.library.html) 'package:time_attendance/model/TALogin/session_manager_web.dart'
    if (dart.library.io) 'package:time_attendance/model/TALogin/session_manager_mobile.dart';
import 'package:time_attendance/controller/master_tab_controller/department_controller.dart';
import 'package:time_attendance/controller/master_tab_controller/designation_controller.dart';
import 'package:time_attendance/controller/master_tab_controller/location_controller.dart';
import 'package:time_attendance/controller/master_tab_controller/company_controller.dart';
import 'package:time_attendance/controller/master_tab_controller/emplyee_type_controller.dart';
import 'package:time_attendance/model/master_tab_model/company_model.dart';
import 'package:time_attendance/model/master_tab_model/department_model.dart';
import 'package:time_attendance/model/master_tab_model/designation_model.dart';
import 'package:time_attendance/model/master_tab_model/employee_type_model.dart';
import 'package:time_attendance/model/master_tab_model/location_model.dart';

class EmployeeController extends GetxController {
  // Lists for employees
  final employees = <Employee>[].obs;
  final filteredEmployees = <Employee>[].obs;
  final searchQuery = ''.obs;
  final isLoading = false.obs;

  // Setting profile variables
  final selectedSettingProfile = Rxn<SettingProfileModel>();

  // Sorting variables (adjust as needed for employee fields)
  final sortColumn = RxString('EmployeeName'); // Default sort column
  final isSortAscending = RxBool(true);

  // Authentication instance
  AuthLogin? _authLogin;

  // Form controllers - Professional Details
  final employeeIdController = TextEditingController();
  final enrollIdController = TextEditingController();
  final employeeNameController = TextEditingController();
  final designationFormController = TextEditingController();
  final employeeTypeFormController = TextEditingController();
  final dateOfJoiningController = TextEditingController();
  final dateOfLeavingController = TextEditingController();
  final seniorReportingController = TextEditingController();
  final seniorReportingNameController = TextEditingController();
  final officeEmailController = TextEditingController();

  // Form controllers - Personal Details
  final genderController = TextEditingController();
  final bloodGroupController = TextEditingController();
  final nationalityController = TextEditingController();
  final personalEmailController = TextEditingController();
  final mobileNoController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final localAddressController = TextEditingController();
  final permanentAddressController = TextEditingController();
  final contactNoController = TextEditingController();

  // Master data controllers
  final masterDepartmentController = Get.put(DepartmentController());
  final masterDesignationController = Get.put(DesignationController());
  final masterLocationController = Get.put(LocationController());
  final masterBranchController = Get.put(BranchController());
  final masterEmployeeTypeController = Get.put(EmplyeeTypeController());
  final employeeSearchController = Get.put(EmployeeSearchController());

  // Master data lists
  final companies = <BranchModel>[].obs;
  final departments = <DepartmentModel>[].obs;
  final locations = <Location>[].obs;
  final employeeStatuses = <String>['Active', 'Inactive'].obs;
  final employeeTypes = <EmployeeTypeModel>[].obs;
  final designations = <DesignationModel>[].obs;

  // Selected values
  final selectedCompany = RxString('');
  final selectedDepartment = RxString('');
  final selectedLocation = RxString('');
  final selectedEmployeeStatus = RxString('Active');
  final selectedEmployeeType = RxString('');

  // Radio button value
  final shiftType = RxString('Fix');

  void updateShiftType(String value) {
    shiftType.value = value;
  }

  @override
  void onInit() {
    super.onInit();
    initializeAuthEmployee().then((_) => fetchMasterData());
  }

  Future<void> initializeAuthEmployee() async {
    try {
      final userInfo = await PlatformSessionManager.getUserInfo();
      if (userInfo != null) {
        String companyCode = userInfo['CompanyCode'];
        String loginID = userInfo['LoginID'];
        String password = userInfo['Password'];
        _authLogin = await AuthLoginDetails()
            .LoginInformationForFirstLogin(companyCode, loginID, password);
        await fetchMasterData(); // Fetch master data after authentication
      } else {
        MTAToast()
            .ShowToast("User information not found. Please log in again.");
      }
    } catch (e) {
      MTAToast()
          .ShowToast("Error initializing authentication: ${e.toString()}");
    }
  }

  Future<void> fetchMasterData() async {
    try {
      if (_authLogin == null) {
        await initializeAuthEmployee();
        if (_authLogin == null) throw Exception('Authentication failed');
      }

      isLoading.value = true;

      // Fetch Employee Types
      await masterEmployeeTypeController.fetchEmployeeTypes();
      employeeTypes.assignAll(masterEmployeeTypeController.empTypeDetails);

      // Fetch Company / Branch
      await masterBranchController.fetchBranches();
      companies.assignAll(masterBranchController.branches);

      // Fetch departments
      await masterDepartmentController.fetchDepartments();
      departments.assignAll(masterDepartmentController.departments);

      // Fetch designations
      await masterDesignationController.fetchDesignations();
      designations.assignAll(masterDesignationController.designations);

      // Fetch locations
      await masterLocationController.fetchLocation();
      locations.assignAll(masterLocationController.locations);
    } catch (e) {
      MTAToast().ShowToast('Error fetching master data: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
  Future<bool> saveEmployee({bool isEdit = false}) async {
    try {
      if (_authLogin == null) {
        MTAToast()
            .ShowToast('Authentication not initialized. Cannot save employee.');
        // Attempt to re-initialize auth if it's null
        await initializeAuthEmployee();
        if (_authLogin == null) {
          throw Exception('Authentication failed to initialize.');
        }
        return false;
      }

      isLoading.value = true;
      MTAResult result = MTAResult();
      bool success = false;

      // Create employee object from form data      
      // Get the selected setting profile
      print('Selected Setting Profile: ${selectedSettingProfile.value?.toJson()}');
      final settingProfile = selectedSettingProfile.value;
      if (settingProfile == null) {
        MTAToast().ShowToast('Please select a setting profile before saving.');
        return false;
      }

      // Get the employee ID that will be used
      final employeeId = employeeIdController.text;

      // Create new instances of setting profile objects with the updated employee ID
      final updatedRegularShift = settingProfile.employeeRegularShift == null ? null :
          EmployeeRegularShifts.fromJson({
            ...settingProfile.employeeRegularShift!.toJson(),
            'EmployeeID': employeeId
          });

      final updatedWOFF = settingProfile.employeeWOFF == null ? null :
          EmployeeWOff.fromJson({
            ...settingProfile.employeeWOFF!.toJson(),
            'EmployeeID': employeeId
          });

      final updatedSetting = settingProfile.employeeSetting == null ? null :
          EmployeeSettings.fromJson({
            ...settingProfile.employeeSetting!.toJson(),
            'EmployeeID': employeeId
          });

      final updatedGeneralSetting = settingProfile.employeeGeneralSetting == null ? null :
          EmployeeGeneralSettings.fromJson({
            ...settingProfile.employeeGeneralSetting!.toJson(),
            'EmployeeID': employeeId
          });

      final updatedLogin = settingProfile.employeeLogin == null ? null :
          EmpLogin.fromJson({
            ...settingProfile.employeeLogin!.toJson(),
            'EmployeeID': employeeId
          });

      Employee employee = Employee(
          employeeProfessional: EmployeeProfessional(
            enrollID: enrollIdController.text,
            employeeID: employeeId,
            employeeName: employeeNameController.text,
            companyID: selectedCompany.value,
            departmentID: selectedDepartment.value,
            designationID: designationFormController.text,
            locationID: selectedLocation.value,
            employeeTypeID: selectedEmployeeType.value,
            employeeType: employeeTypeFormController.text,
            empStatus: selectedEmployeeStatus.value == 'Active' ? 1 : 0,
            dateOfEmployment: dateOfJoiningController.text,
            dateOfLeaving: dateOfLeavingController.text,
            seniorEmployeeID: seniorReportingController.text,
            emailID: officeEmailController.text,
          ),
          employeePersonal: EmployeePersonal(
            employeeID: employeeIdController.text,
            employeeName: employeeNameController.text,
            localAddress: localAddressController.text,
            permanentAddress: permanentAddressController.text,
            gender: genderController.text,
            dateOfBirth: dateOfBirthController.text,
            contactNo: contactNoController.text,
            mobileNumber: mobileNoController.text,
            nationality: nationalityController.text,
            emailID: personalEmailController.text,
            bloodGroup: bloodGroupController.text,
          ),
          SettingProfileID: settingProfile.profileId,
          // employeeRegularShift: updatedRegularShift,
          // employeeWOFF: updatedWOFF,
          // employeeSetting: updatedSetting,
          // employeeGeneralSetting: updatedGeneralSetting,
          // employeeLogin: updatedLogin

          );      // Use Update for editing, Save for adding new employee
      if (isEdit) {
        success = await EmployeeDetails().Update(_authLogin!, [employee], result);
      } else {
        success = await EmployeeDetails().Save(_authLogin!, employee, result);
      }
      
      if (success) {
        MTAToast().ShowToast(result.ResultMessage.isNotEmpty
            ? result.ResultMessage
            : isEdit ? "Employee updated successfully." : "Employee saved successfully.");
        return true;
      } else {
        MTAToast().ShowToast(result.ResultMessage.isNotEmpty
            ? result.ResultMessage
            : "Failed to save employee.");
        if (result.ErrorMessage.isNotEmpty) {
          throw Exception(result.ErrorMessage);
        }
        return false;
      }
    } catch (e) {
      MTAToast().ShowToast("Error saving employee: ${e.toString()}");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

    Future<void> applySettingProfileToEmployees(
      List<String> employeeIds, String profileId) async {
    try {
      if (_authLogin == null) {
        MTAToast()
            .ShowToast('Authentication not initialized. Please try again.');
        await initializeAuthEmployee();
        if (_authLogin == null) {
          throw Exception('Authentication failed to initialize.');
        }
      }

      isLoading.value = true;
      int successCount = 0;
      int failureCount = 0;

      for (String employeeId in employeeIds) {
        MTAResult result = MTAResult();
        // 1. Fetch the full employee details
        Employee employeeToUpdate = await getEmployeeDetailsById(employeeId);

        if (employeeToUpdate.employeeProfessional?.employeeID == null ||
            employeeToUpdate.employeeProfessional!.employeeID.isEmpty) {
          MTAToast()
              .ShowToast('Could not fetch details for employee $employeeId. Skipping.');
          failureCount++;
          continue;
        }

        // 2. Create a new Employee object with the updated profile ID
        Employee updatedEmployee = Employee(
          employeeProfessional: employeeToUpdate.employeeProfessional,
          employeePersonal: employeeToUpdate.employeePersonal,
          SettingProfileID: profileId, // Update the profile ID
          // employeeRegularShift: employeeToUpdate.employeeRegularShift,
          // employeeWOFF: employeeToUpdate.employeeWOFF,
          // employeeSetting: employeeToUpdate.employeeSetting,
          // employeeGeneralSetting: employeeToUpdate.employeeGeneralSetting,
          // employeeLogin: employeeToUpdate.employeeLogin,
        );

        // 3. Call the update method
        bool success =
            await EmployeeDetails().Update(_authLogin!, [updatedEmployee], result);

        if (success) {
          successCount++;
        } else {
          failureCount++;
          MTAToast().ShowToast(result.ResultMessage.isNotEmpty
              ? 'Failed for employee $employeeId: ${result.ResultMessage}'
              : 'Failed to update settings for employee $employeeId.');
        }
      }

      MTAToast().ShowToast(
          'Settings applied. Success: $successCount, Failed: $failureCount.');

      // Refresh the employee list to show updated data
      await employeeSearchController.fetchEmployees();
    } catch (e) {
      MTAToast()
          .ShowToast('An error occurred while applying settings: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteEmployee(EmployeeProfessional employeeProfessional) async {
    try {
      if (_authLogin == null) {
        MTAToast().ShowToast('Authentication not initialized');
        await initializeAuthEmployee();
        if (_authLogin == null) {
          throw Exception('Authentication failed to initialize');
        }
      }

      isLoading.value = true;
      MTAResult result = MTAResult();

      bool success = await EmployeeDetails()
          .Delete(_authLogin!, employeeProfessional, result);

      if (success) {
        MTAToast().ShowToast(result.ResultMessage.isNotEmpty
            ? result.ResultMessage
            : 'Employee deleted successfully');
        // Refresh the employee list after deletion
        await employeeSearchController.fetchEmployees(resetPage: true);
      } else {
        MTAToast().ShowToast(result.ResultMessage.isNotEmpty
            ? result.ResultMessage
            : 'Failed to delete employee');
        if (result.ErrorMessage.isNotEmpty) {
          throw Exception(result.ErrorMessage);
        }
      }
    } catch (e) {
      MTAToast().ShowToast('Error deleting employee: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Method to get employee details by ID
  Future<Employee> getEmployeeDetailsById(String employeeId) async {
    try {
      if (_authLogin == null) {
        MTAToast().ShowToast('Authentication not initialized');
        await initializeAuthEmployee();
        if (_authLogin == null) {
          throw Exception('Authentication failed to initialize');
        }
      }
      isLoading.value = true;
      MTAResult result = MTAResult();

      Employee employee = await EmployeeDetails()
          .GetEmployeeDetailsByID(_authLogin!, employeeId, result);

      if (result.IsResultPass) {
        return employee;
      } else {
        MTAToast().ShowToast(result.ResultMessage.isNotEmpty
            ? result.ResultMessage
            : 'Failed to fetch employee details');
        if (result.ErrorMessage.isNotEmpty) {
          throw Exception(result.ErrorMessage);
        }
        return Employee(); // Return an empty Employee object on failure
      }
    } catch (e) {
      MTAToast().ShowToast('Error fetching employee details: ${e.toString()}');
      return Employee(); // Return an empty Employee object on error
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    // Dispose all controllers
    employeeIdController.dispose();
    enrollIdController.dispose();
    employeeNameController.dispose();
    designationFormController.dispose();
    employeeTypeFormController.dispose();
    dateOfJoiningController.dispose();
    dateOfLeavingController.dispose();
    seniorReportingController.dispose();
    officeEmailController.dispose();
    genderController.dispose();
    bloodGroupController.dispose();
    nationalityController.dispose();
    personalEmailController.dispose();
    mobileNoController.dispose();
    dateOfBirthController.dispose();
    localAddressController.dispose();
    permanentAddressController.dispose();
    contactNoController.dispose();
    super.onClose();
  }
}
