// lib/controller/employee_tab_controller/employee_search_controller.dart
import 'package:get/get.dart';
import 'package:time_attendance/Data/LoginInformation/AuthLogin.dart';
import 'package:time_attendance/Data/LoginInformation/AuthLoginInfoDetails.dart';
import 'package:time_attendance/General/MTAResult.dart';
import 'package:time_attendance/controller/master_tab_controller/company_controller.dart';
import 'package:time_attendance/controller/master_tab_controller/emplyee_type_controller.dart';
import 'package:time_attendance/controller/shift_tab_controller/shift_details_controller.dart';
import 'package:time_attendance/controller/temp_weekly_off_controller/temp_weekly_off_controller.dart';
import 'package:time_attendance/model/employee_tab_model/employee_search_model.dart';
import 'package:time_attendance/model/employee_tab_model/employee_search_details.dart';
import 'package:time_attendance/model/master_tab_model/company_model.dart';
import 'package:time_attendance/model/master_tab_model/employee_type_model.dart';
import 'package:time_attendance/model/temp_weeklyOff_muster/temp_weeklyOff_model.dart';
import 'package:time_attendance/model/temp_weeklyOff_muster/temp_weeklyOff_details.dart';
import 'package:time_attendance/widgets/mtaToast.dart';
import 'package:time_attendance/model/TALogin/session_manager.dart'
    if (dart.library.html) 'package:time_attendance/model/TALogin/session_manager_web.dart'
    if (dart.library.io) 'package:time_attendance/model/TALogin/session_manager_mobile.dart';
import 'package:time_attendance/controller/master_tab_controller/department_controller.dart';
import 'package:time_attendance/controller/master_tab_controller/designation_controller.dart';
import 'package:time_attendance/controller/master_tab_controller/location_controller.dart';
import 'package:time_attendance/model/master_tab_model/department_model.dart';
import 'package:time_attendance/model/master_tab_model/designation_model.dart';
import 'package:time_attendance/model/master_tab_model/location_model.dart';
import 'package:time_attendance/model/shift_muster/shift_muster_details.dart';
import 'package:time_attendance/model/shift_muster/shift_muster_model.dart';

// Imports for CSV generation and download
import 'package:csv/csv.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:convert'; // for utf8.encode
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';

enum EmployeeSearchMode { employee, shiftMuster, weeklyOff }

class EmployeeSearchController extends GetxController {
  // Lists for employees
  final employees = <EmployeeView>[].obs;
  final filteredEmployees = <EmployeeView>[].obs;

  // Pagination variables
  final currentPage = 0.obs;
  final totalRecords = 0.obs;
  final recordsPerPage = 10.obs;
  final isLoading = false.obs;
  final isUploading = false.obs;

  // Search state
  final hasSearched = false.obs;

  final isApplyingShift = false.obs;

  // Search filters
  final searchEmployeeView = EmployeeView().obs;

  // Sorting variables
  final sortColumn = RxString('EmployeeName');
  final isSortAscending = RxBool(true);

  // Master data controllers
  final departmentController = Get.put(DepartmentController());
  final designationController = Get.put(DesignationController());
  final locationController = Get.put(LocationController());
  final branchController = Get.put(BranchController());
  final employeeTypeController = Get.put(EmplyeeTypeController());
  final shiftDetailsController = Get.put(ShiftDetailsController());

  // Master data lists
  final departments = <DepartmentModel>[].obs;
  final designations = <DesignationModel>[].obs;
  final locations = <Location>[].obs;
  final branches = <BranchModel>[].obs;
  final employeeTypes = <EmployeeTypeModel>[].obs;

  // Authentication instance
  AuthLogin? _authLogin;

  // Search mode
  final searchMode = EmployeeSearchMode.employee.obs;

  // Shift Muster specific inputs
  final startDate = ''.obs;
  final endDate = ''.obs;
  final shiftMusterList = <EmployeeShiftMusterModel>[].obs;
  final totalShiftMusterRecords = 0.obs;
  final isShiftMusterLoading = false.obs;
  final selectedEmployeeIDs = <String>{}.obs;

  // Weekly Off specific data
  final weeklyOffList = <TempWeeklyOffModel>[].obs;
  final totalWeeklyOffRecords = 0.obs;
  final isWeeklyOffLoading = false.obs;

  void toggleEmployeeSelection(String employeeID) {
    if (selectedEmployeeIDs.contains(employeeID)) {
      selectedEmployeeIDs.remove(employeeID);
    } else {
      selectedEmployeeIDs.add(employeeID);
    }
  }

  /// Toggles the selection of all visible employees.
  ///
  /// This method is designed to work with grids that pass the list of currently
  /// visible, unique employee IDs. It maintains backward compatibility for older
  /// widgets that do not pass this list.
  void toggleSelectAll(bool isSelected, [List<String>? allVisibleEmployeeIds]) {
    if (isSelected) {
      List<String> idsToSelect;

      if (allVisibleEmployeeIds != null) {
        // New path: Use the provided list of unique IDs from the grid. This is more efficient.
        idsToSelect = allVisibleEmployeeIds;
      } else {
        // Fallback path: Maintain old logic for compatibility with other screens.
        if (searchMode.value == EmployeeSearchMode.shiftMuster) {
          idsToSelect = shiftMusterList.map((emp) => emp.employeeID).toList();
        } else if (searchMode.value == EmployeeSearchMode.weeklyOff) {
          // The old logic was buggy here. Corrected by ensuring IDs are unique.
          idsToSelect = weeklyOffList.map((emp) => emp.employeeID).toSet().toList();
        } else {
          idsToSelect = [];
        }
      }
      selectedEmployeeIDs.addAll(idsToSelect);
    } else {
      // Un-selecting clears all selections.
      selectedEmployeeIDs.clear();
    }
  }

  @override
  void onInit() {
    super.onInit();
    initializeAuth();
     _performInitialLoad();
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

    void _performInitialLoad() async {
    // First, fetch the required master data like departments, designations, etc.
    // The fetchMasterData method already handles its own loading indicator.
    await fetchMasterData();

    // After master data is loaded, update the filter to default to
    // 'Active' employees and trigger the search.
    // The updateSearchFilter method will set the filter and call fetch().
    updateSearchFilter(employeeStatus: 1);
  }

  Future<void> fetchMasterData() async {
    try {
      if (_authLogin == null) {
        await initializeAuth();
      }

      isLoading.value = true;
      await employeeTypeController.fetchEmployeeTypes();
      employeeTypes.assignAll(employeeTypeController.empTypeDetails);
      await branchController.fetchBranches();
      branches.assignAll(branchController.branches);
      await departmentController.fetchDepartments();
      departments.assignAll(departmentController.departments);
      await designationController.fetchDesignations();
      designations.assignAll(designationController.designations);
      await locationController.fetchLocation();
      locations.assignAll(locationController.locations);
    } catch (e) {
      MTAToast().ShowToast('Error fetching master data: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchEmployees({bool resetPage = false}) async {
    try {
      if (_authLogin == null) {
        throw Exception('Authentication not initialized');
      }

      isLoading.value = true;
      hasSearched.value = true;

      if (resetPage) {
        currentPage.value = 0;
      }

      MTAResult result = MTAResult();

      final searchRequest = EmployeeSearchRequest(
          employeeView: searchEmployeeView.value,
          insigniaObjectListInRange: InsigniaObjectListInRange(
              iStartIndex: currentPage.value * recordsPerPage.value,
              iRecordsPerPage: recordsPerPage.value));

      final response = await EmployeeSearchDetails()
          .getEmployeesByRange(_authLogin!, searchRequest, result);
      employees.value = response.employees;
      filteredEmployees.value = response.employees;
      totalRecords.value = response.totalRecordCount;
      hasSearched.value = true;
    } catch (e) {
      MTAToast().ShowToast(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetch({bool resetPage = false}) async {
    selectedEmployeeIDs.clear();
    if (searchMode.value == EmployeeSearchMode.employee) {
      await fetchEmployees(resetPage: resetPage);
    } else if (searchMode.value == EmployeeSearchMode.shiftMuster) {
      await fetchShiftMusterEmployees(resetPage: resetPage);
    } else if (searchMode.value == EmployeeSearchMode.weeklyOff) {
      await fetchWeeklyOffEmployees(resetPage: resetPage);
    }
  }

  Future<void> fetchWeeklyOffEmployees({bool resetPage = false}) async {
    try {
      if (_authLogin == null) {
        throw Exception('Authentication not initialized');
      }
      if (startDate.value.isEmpty || endDate.value.isEmpty) {
        throw Exception('Start date and end date are required for weekly off search');
      }
      isWeeklyOffLoading.value = true;
      if (resetPage) {
        currentPage.value = 0;
      }
      MTAResult result = MTAResult();
      final request = TempWeeklyOffRequest(
        employeeView: searchEmployeeView.value,
        startDate: startDate.value,
        endDate: endDate.value,
        insigniaObjectListInRange: InsigniaObjectListInRange(
          iStartIndex: currentPage.value * recordsPerPage.value,
          iRecordsPerPage: recordsPerPage.value,
        ),
      );
      final response = await TempWeeklyOffDetails()
          .getEmployeeWeeklyOffByEmployeeViewStartNEndDate(
        objAuthLogin: _authLogin!,
        request: request,
        objMTAResult: result,
      );
      weeklyOffList.value = response.weeklyOffList ?? [];
      totalWeeklyOffRecords.value = response.totalRecordCount ?? 0;
      hasSearched.value = true;
    } catch (e) {
      MTAToast().ShowToast(e.toString());
    } finally {
      isWeeklyOffLoading.value = false;
    }
  }

  Future<void> fetchShiftMusterEmployees({bool resetPage = false}) async {
    try {
      if (_authLogin == null) {
        throw Exception('Authentication not initialized');
      }
      if (startDate.value.isEmpty || endDate.value.isEmpty) {
        throw Exception(
            'Start date and end date are required for shift muster search');
      }
      isShiftMusterLoading.value = true;
      if (resetPage) {
        currentPage.value = 0;
      }
      MTAResult result = MTAResult();
      final request = ShiftMusterRequest(
        employeeView: searchEmployeeView.value,
        startDate: startDate.value,
        endDate: endDate.value,
        insigniaObjectListInRange: InsigniaObjectListInRange(
          iStartIndex: currentPage.value * recordsPerPage.value,
          iRecordsPerPage: recordsPerPage.value,
        ),
      );
      final response = await ShiftMusterDetails()
          .getEmployeeShiftMusterByEmployeeViewStartNEndDate(
        objAuthLogin: _authLogin!,
        request: request,
        objMTAResult: result,
      );
      shiftMusterList.value = response.musterList ?? [];
      totalShiftMusterRecords.value = response.totalRecordCount ?? 0;
      hasSearched.value = true;
    } catch (e) {
      MTAToast().ShowToast(e.toString());
    } finally {
      isShiftMusterLoading.value = false;
    }
  }

  Future<void> applyTemporaryShift({
    required String shiftID,
    required String shiftName,
    required String startDate,
    required String endDate,
  }) async {
    if (selectedEmployeeIDs.isEmpty) {
      MTAToast().ShowToast('No employees selected.');
      return;
    }

    isApplyingShift.value = true;
    try {
      // Find the names of the selected employees.
      // This is more robust than passing names around.
      final selectedEmployees = shiftMusterList
          .where((emp) => selectedEmployeeIDs.contains(emp.employeeID))
          .toList();

      // Create the bulk request payload
      final List<EmpTemporaryShiftBulkRequest> requests =
          selectedEmployees.map((emp) {
        return EmpTemporaryShiftBulkRequest(
          employeeID: emp.employeeID,
          employeeName: emp.employeeName, // Get the name from the fetched list
          shiftID: shiftID,
          shiftName: shiftName,
          startDate: startDate,
          endDate: endDate,
        );
      }).toList();

      // Reuse the existing bulk save method
      await _saveBulkTemporaryShift(requests);
    } catch (e) {
      MTAToast().ShowToast('Failed to apply shift: ${e.toString()}');
    } finally {
      isApplyingShift.value = false;
    }
  }

  Future<void> generateAndDownloadCsv(String defaultShiftName) async {
    if (selectedEmployeeIDs.isEmpty) {
      MTAToast().ShowToast('Please select at least one employee to download.');
      return;
    }
    if (startDate.value.isEmpty || endDate.value.isEmpty) {
      MTAToast().ShowToast('Date range is not selected. Please filter again.');
      return;
    }

    final selectedEmployees = shiftMusterList
        .where((emp) => selectedEmployeeIDs.contains(emp.employeeID))
        .toList();

    try {
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final DateTime start = formatter.parse(startDate.value);
      final DateTime end = formatter.parse(endDate.value);

      List<String> dateHeaders = [];
      DateTime tempDate = start;
      while (!tempDate.isAfter(end)) {
        dateHeaders.add(formatter.format(tempDate));
        tempDate = tempDate.add(const Duration(days: 1));
      }

      List<dynamic> headerRow = [
        'Employee ID',
        'Employee Name',
        ...dateHeaders
      ];
      List<List<dynamic>> csvData = [headerRow];

      for (var employee in selectedEmployees) {
        List<dynamic> employeeRow = [
          employee.employeeID,
          employee.employeeName
        ];

        Map<String, String> shiftMapForEmployee = {};
        DateTime currentDate = start;
        int dayIndex = 1;
        while (!currentDate.isAfter(end)) {
          String shiftName =
              employee.days['ShiftIDOrWOffHolidayOrLeave$dayIndex'] ?? '';
          if (shiftName.isEmpty) {
            shiftName = defaultShiftName;
          }
          shiftMapForEmployee[formatter.format(currentDate)] = shiftName;

          currentDate = currentDate.add(const Duration(days: 1));
          dayIndex++;
        }

        for (String dateHeader in dateHeaders) {
          employeeRow.add(shiftMapForEmployee[dateHeader] ?? defaultShiftName);
        }

        csvData.add(employeeRow);
      }

      final String csvString = const ListToCsvConverter().convert(csvData);

      final bytes = utf8.encode(csvString);
      final blob = html.Blob([bytes], 'text/csv;charset=utf-8');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download",
            'temporary_shift_muster_pivoted_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.csv')
        ..click();
      html.Url.revokeObjectUrl(url);
    } catch (e) {
      MTAToast().ShowToast('Failed to generate CSV: ${e.toString()}');
    }
  }

   /// Generates and downloads a CSV file for the selected employees' temporary weekly off data.
  /// If no employees are selected, it downloads a blank template with only the header row.
  Future<void> generateAndDownloadWeeklyOffCsv() async {
    try {
      // Define the header as per the requirement.
      List<dynamic> headerRow = [
        'EmployeeID*',
        'EmployeeName(optional)',
        'StartDate*(dd-MMM-yyyy)',
        'EndDate*(dd-MMM-yyyy)',
        'FirstWOff*',
        'SecondWOff(Default Value=\'None\' or blank)',
        'IsSecondWeeklyFullDay(Default value=false or blank)',
        'SecondWOffPattern(Month\'s WeekNo e.g. \'2-4\' or \'1-2-3-4-5\' or blank)',
        'ErrorMessage'
      ];

      List<List<dynamic>> csvData = [headerRow];
      final DateFormat outputFormatter = DateFormat('dd-MMM-yyyy');

      // Only add data rows if employees have been selected.
      if (selectedEmployeeIDs.isNotEmpty) {
        final recordsToDownload = weeklyOffList
            .where((record) => selectedEmployeeIDs.contains(record.employeeID))
            .toList();

        for (var record in recordsToDownload) {
          // Parse the date string from the model (assuming it's in 'yyyy-MM-dd' format)
          final DateTime startDate = DateTime.parse(record.startDate);
          final DateTime endDate = DateTime.parse(record.endDate);

          List<dynamic> dataRow = [
            record.employeeID,
            record.employeeName ?? '',
            outputFormatter.format(startDate),
            outputFormatter.format(endDate),
            record.firstWOff,
            record.secondWOff ?? 'None', // Default value if null
            record.isFullDay.toString(), // Convert boolean to string ('true' or 'false')
            record.wOffPattern ?? '',
            record.errorMessage ?? '' // Assuming ErrorMessage is for upload, so it's blank here
          ];
          csvData.add(dataRow);
        }
      }

      // Use the existing CSV generation and download logic
      final String csvString = const ListToCsvConverter().convert(csvData);
      final bytes = utf8.encode(csvString);
      final blob = html.Blob([bytes], 'text/csv;charset=utf-8');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", 'temporary_weekly_off_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.csv')
        ..click();
      html.Url.revokeObjectUrl(url);

    } catch (e) {
      MTAToast().ShowToast('Failed to generate CSV: ${e.toString()}');
    }
  }

    /// Handles the upload of a CSV file for bulk assigning temporary weekly offs.
  Future<void> uploadWeeklyOffCsv() async {
    isUploading.value = true;
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null && result.files.single.bytes != null) {
        final bytes = result.files.single.bytes!;
        final csvString = utf8.decode(bytes);

        // Parse the CSV content into a list of models.
        final List<TempWeeklyOffModel> weeklyOffModels = _parseWeeklyOffCsvData(csvString);

        if (weeklyOffModels.isEmpty) {
          MTAToast().ShowToast('CSV is empty or does not contain valid data. Please check the file.');
        } else {
          // Find the controller and call the save method.
          final tempWeeklyOffController = Get.find<TempWeeklyOffController>();
          final success = await tempWeeklyOffController.saveWeeklyOff(weeklyOffModels);

          if (success) {
            // Refresh the grid to show the newly added data.
            await fetch(resetPage: false);
          }
        }
      } else {
        MTAToast().ShowToast('No file selected.');
      }
    } catch (e) {
      MTAToast().ShowToast('Upload failed: ${e.toString()}');
    } finally {
      isUploading.value = false;
    }
  }

  /// Parses the CSV string and converts it into a list of [TempWeeklyOffModel].
  List<TempWeeklyOffModel> _parseWeeklyOffCsvData(String csvString) {
    final List<List<dynamic>> csvTable;
    try {
      // Use a converter that doesn't attempt to parse numbers automatically.
      csvTable = const CsvToListConverter(shouldParseNumbers: false).convert(csvString);
    } catch (e) {
      throw Exception('Invalid CSV format. Please ensure the file is correctly formatted.');
    }

    if (csvTable.length < 2) {
      return []; // No data rows in the CSV.
    }

    final header = csvTable.first.map((e) => e.toString().trim()).toList();
    
    // Define expected headers
    final expectedHeaders = [
        'EmployeeID*',
        'EmployeeName(optional)',
        'StartDate*(dd-MMM-yyyy)',
        'EndDate*(dd-MMM-yyyy)',
        'FirstWOff*',
        'SecondWOff(Default Value=\'None\' or blank)',
        'IsSecondWeeklyFullDay(Default value=false or blank)',
        'SecondWOffPattern(Month\'s WeekNo e.g. \'2-4\' or \'1-2-3-4-5\' or blank)',
    ];

    // Check if essential headers are present
    for(String expectedHeader in expectedHeaders) {
      if(!header.contains(expectedHeader) && expectedHeader.endsWith('*')) {
        throw Exception('Invalid CSV header. Missing required column: $expectedHeader');
      }
    }

    // Create a map of header names to their column index for robust parsing.
    final colMap = { for (var i = 0; i < header.length; i++) header[i] : i };

    final dataRows = csvTable.sublist(1);
    final List<TempWeeklyOffModel> models = [];

    final DateFormat csvDateFormat = DateFormat('dd-MMM-yyyy');
    final DateFormat apiDateFormat = DateFormat('yyyy-MM-dd');

    for (final row in dataRows) {
      // Ensure row has enough columns to avoid range errors
      if(row.length < expectedHeaders.length -1) continue;

      final employeeID = row[colMap['EmployeeID*']!].toString().trim();
      if (employeeID.isEmpty) continue; // Skip rows without an Employee ID.

      final employeeName = row[colMap['EmployeeName(optional)']!].toString().trim();

      // Date parsing
      final startDateStr = row[colMap['StartDate*(dd-MMM-yyyy)']!].toString().trim();
      final endDateStr = row[colMap['EndDate*(dd-MMM-yyyy)']!].toString().trim();
      
      if (startDateStr.isEmpty || endDateStr.isEmpty) {
        throw Exception('Date fields cannot be empty for Employee ID: $employeeID');
      }
      
      final DateTime startDate = csvDateFormat.parseStrict(startDateStr);
      final DateTime endDate = csvDateFormat.parseStrict(endDateStr);

      // Weekly Off days
      final firstWOff = row[colMap['FirstWOff*']!].toString().trim();
      if (firstWOff.isEmpty) {
        throw Exception('FirstWOff cannot be empty for Employee ID: $employeeID');
      }

      String secondWOff = row[colMap['SecondWOff(Default Value=\'None\' or blank)']!].toString().trim();
      if (secondWOff.isEmpty) {
        secondWOff = 'None';
      }

      // Boolean and pattern
      final isFullDayStr = row[colMap['IsSecondWeeklyFullDay(Default value=false or blank)']!].toString().trim().toLowerCase();
      final isFullDay = isFullDayStr == 'true';
      
      final wOffPattern = row[colMap['SecondWOffPattern(Month\'s WeekNo e.g. \'2-4\' or \'1-2-3-4-5\' or blank)']!].toString().trim();

      models.add(TempWeeklyOffModel(
        employeeID: employeeID,
        employeeName: employeeName,
        startDate: apiDateFormat.format(startDate),
        endDate: apiDateFormat.format(endDate),
        firstWOff: firstWOff,
        secondWOff: secondWOff,
        isFullDay: isFullDay,
        wOffPattern: wOffPattern,
        recordNeedsToAdd: true,
        recordNeedsToDelete: false,
        isErrorFound: false,
        errorMessage: '',
        firstName: '', // Not available in CSV
      ));
    }
    return models;
  }

  void nextPage() {
    final total = _getTotalRecords();
    if ((currentPage.value + 1) * recordsPerPage.value < total) {
      currentPage.value++;
      fetch();
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
      fetch();
    }
  }

  void goToPage(int page) {
    final total = _getTotalRecords();
    if (page >= 0 && page * recordsPerPage.value < total) {
      currentPage.value = page;
      fetch();
    }
  }

  int _getTotalRecords() {
    switch (searchMode.value) {
      case EmployeeSearchMode.employee:
        return totalRecords.value;
      case EmployeeSearchMode.shiftMuster:
        return totalShiftMusterRecords.value;
      case EmployeeSearchMode.weeklyOff:
        return totalWeeklyOffRecords.value;
    }
  }

  void updateSearchFilter({
    String? employeeId,
    String? employeeName,
    String? enrollId,
    String? companyId,
    String? departmentId,
    String? designationId,
    String? locationId,
    int? employeeStatus,
    String? employeeTypeId,
    String? shiftStartDate,
    String? shiftEndDate,
  }) {
    if (employeeId != null) searchEmployeeView.value.employeeID = employeeId;
    if (employeeName != null) {
      searchEmployeeView.value.employeeName = employeeName;
    }
    if (enrollId != null) searchEmployeeView.value.enrollID = enrollId;
    if (companyId != null) searchEmployeeView.value.companyID = companyId;
    if (departmentId != null) {
      searchEmployeeView.value.departmentID = departmentId;
    }
    if (designationId != null) {
      searchEmployeeView.value.designationID = designationId;
    }
    if (locationId != null) searchEmployeeView.value.locationID = locationId;
    if (employeeStatus != null) {
      searchEmployeeView.value.employeeStatus = employeeStatus;
    }
    if (employeeTypeId != null) {
      searchEmployeeView.value.employeeTypeID = employeeTypeId;
    }
    if (shiftStartDate != null) startDate.value = shiftStartDate;
    if (shiftEndDate != null) endDate.value = shiftEndDate;
    fetch(resetPage: true);
  }

  void clearFilters() {
    searchEmployeeView.value = EmployeeView();
    startDate.value = '';
    endDate.value = '';
    fetch(resetPage: true);
  }

  void sortEmployees(String columnName, bool? ascending) {
    if (ascending != null) {
      isSortAscending.value = ascending;
    } else if (sortColumn.value == columnName) {
      isSortAscending.value = !isSortAscending.value;
    } else {
      isSortAscending.value = true;
    }

    sortColumn.value = columnName;

    filteredEmployees.sort((a, b) {
      int comparison;
      switch (columnName) {
        case 'EmployeeName':
          comparison = (a.employeeName ?? '').compareTo(b.employeeName ?? '');
          break;
        case 'EnrollID':
          comparison = (a.enrollID ?? '').compareTo(b.enrollID ?? '');
          break;
        case 'DepartmentName':
          comparison =
              (a.departmentName ?? '').compareTo(b.departmentName ?? '');
          break;
        case 'DesignationName':
          comparison =
              (a.designationName ?? '').compareTo(b.designationName ?? '');
          break;
        case 'LocationName':
          comparison = (a.locationName ?? '').compareTo(b.locationName ?? '');
          break;
        default:
          comparison = 0;
      }
      return isSortAscending.value ? comparison : -comparison;
    });
  }

  void updateRecordsPerPage(int newRecordsPerPage) {
    recordsPerPage.value = newRecordsPerPage;
    fetch(resetPage: true);
  }

  Future<void> uploadShiftMusterCsv() async {
    isUploading.value = true;
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null && result.files.single.bytes != null) {
        final bytes = result.files.single.bytes!;
        final csvString = utf8.decode(bytes);

        final List<EmpTemporaryShiftBulkRequest> requests =
            _parseAndGroupCsvData(csvString);

        if (requests.isEmpty) {
          MTAToast().ShowToast(
              'CSV is empty or could not be parsed. Please check the file format.');
        } else {
          await _saveBulkTemporaryShift(requests);
        }
      } else {
        MTAToast().ShowToast('No file selected.');
      }
    } catch (e) {
      MTAToast().ShowToast('Upload failed: ${e.toString()}');
    } finally {
      isUploading.value = false;
    }
  }

  DateTime? _parseDate(String dateStr) {
    final formats = [
      DateFormat('yyyy-MM-dd'),
      DateFormat('dd-MM-yyyy'),
      DateFormat('MM/dd/yyyy'),
      DateFormat('M/d/yyyy'),
    ];
    for (var format in formats) {
      try {
        return format.parseStrict(dateStr);
      } catch (e) {
        // Continue
      }
    }
    return null;
  }

  List<EmpTemporaryShiftBulkRequest> _parseAndGroupCsvData(String csvString) {
    final List<List<dynamic>> csvTable;
    try {
      csvTable = const CsvToListConverter(shouldParseNumbers: false)
          .convert(csvString);
    } catch (e) {
      throw Exception(
          'Invalid CSV format. Please ensure the file is a valid CSV.');
    }

    if (csvTable.length < 2) {
      return []; // No data rows
    }

    final shiftMap = {
      for (var shift in shiftDetailsController.shifts)
        if (shift.shiftName != null && shift.shiftID != null)
          shift.shiftName!.toLowerCase(): shift.shiftID!
    };

    final DateFormat apiDateFormat = DateFormat('yyyy-MM-dd');
    final header = csvTable.first.map((e) => e.toString().trim()).toList();
    if (header.length < 3 ||
        header[0] != 'Employee ID' ||
        header[1] != 'Employee Name') {
      throw Exception(
          'Invalid CSV headers. Expected "Employee ID", "Employee Name", and at least one date column.');
    }

    final dateHeaders = header.sublist(2);
    final dataRows = csvTable.sublist(1);
    final List<EmpTemporaryShiftBulkRequest> allRequests = [];

    for (var row in dataRows) {
      final employeeID = row[0].toString().trim();
      final employeeName = row[1].toString().trim();

      if (employeeID.isEmpty) continue;

      String? currentShiftId;
      String? currentShiftName;
      String? groupStartDateStr;
      DateTime? groupEndDate;

      void addCurrentGroup() {
        if (currentShiftId != null &&
            currentShiftName != null &&
            groupStartDateStr != null &&
            groupEndDate != null) {
          allRequests.add(EmpTemporaryShiftBulkRequest(
              employeeID: employeeID,
              employeeName: employeeName,
              shiftID: currentShiftId!,
              shiftName: currentShiftName!,
              startDate: groupStartDateStr!,
              endDate: apiDateFormat.format(groupEndDate!)));
        }
      }

      for (int i = 0; i < dateHeaders.length; i++) {
        final rawDateHeader = dateHeaders[i];
        final currentDate = _parseDate(rawDateHeader);
        if (currentDate == null) continue;

        final formattedCurrentDateStr = apiDateFormat.format(currentDate);
        final shiftNameFromCsv = row[i + 2].toString().trim();

        if (shiftNameFromCsv.isEmpty) {
          addCurrentGroup();
          currentShiftId = null;
          currentShiftName = null;
          continue;
        }

        final String? foundShiftId = shiftMap[shiftNameFromCsv.toLowerCase()];

        if (foundShiftId == null) {
          throw Exception(
              "Shift name '$shiftNameFromCsv' from the CSV file was not found. Please correct the file or add the shift in the Shift Master.");
        }

        if (currentShiftId == null) {
          currentShiftId = foundShiftId;
          currentShiftName = shiftNameFromCsv;
          groupStartDateStr = formattedCurrentDateStr;
          groupEndDate = currentDate;
        } else if (foundShiftId == currentShiftId &&
            currentDate.difference(groupEndDate!).inDays == 1) {
          groupEndDate = currentDate;
        } else {
          addCurrentGroup();
          currentShiftId = foundShiftId;
          currentShiftName = shiftNameFromCsv;
          groupStartDateStr = formattedCurrentDateStr;
          groupEndDate = currentDate;
        }
      }

      addCurrentGroup();
    }
    return allRequests;
  }

  Future<void> _saveBulkTemporaryShift(
      List<EmpTemporaryShiftBulkRequest> requests) async {
    if (_authLogin == null) {
      MTAToast().ShowToast('Authentication error. Please sign in again.');
      return;
    }
    try {
      final response = await ShiftMusterDetails().bulkTemporaryShift(
        _authLogin!,
        requests,
      );
      if (response.isResultPass == true) {
        MTAToast().ShowToast('Shifts updated successfully.');
        fetch(resetPage: false);
      } else {
        MTAToast().ShowToast(response.resultMessage ??
            'Save failed. Please check the data in your file.');
      }
    } catch (e) {
      MTAToast().ShowToast('An error occurred during save: ${e.toString()}');
    }
  }
}