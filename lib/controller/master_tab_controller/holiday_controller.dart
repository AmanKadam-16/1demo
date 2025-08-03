import 'package:get/get.dart';
import 'package:time_attendance/Data/LoginInformation/AuthLogin.dart';
import 'package:time_attendance/Data/LoginInformation/AuthLoginInfoDetails.dart';
import 'package:time_attendance/General/MTAResult.dart';
import 'package:time_attendance/model/Masters/branch.dart';
import 'package:time_attendance/model/Masters/holiday.dart';
import 'package:time_attendance/model/Masters/holidayDetails.dart';
// import 'package:time_attendance/model/TALogin/session_manager.dart';
import 'package:time_attendance/model/master_tab_model/holiday_model.dart';
import 'package:time_attendance/widgets/mtaToast.dart';
import 'package:time_attendance/model/TALogin/session_manager.dart'
    if (dart.library.html) 'package:time_attendance/model/TALogin/session_manager_web.dart'
    if (dart.library.io) 'package:time_attendance/model/TALogin/session_manager_mobile.dart';

class HolidaysController extends GetxController {
  final isLoading = false.obs;
  final holiday = <HolidayModel>[].obs;
  final filterHolidays = <HolidayModel>[].obs;
  final searchQuery = ''.obs;
  final sortColumn = Rx<String?>(null);
  final isSortAscending = true.obs;

  AuthLogin? _authLogin;

  @override
  void onInit() {
    super.onInit();
    initializeAuthHoliday();
  }

  Future<void> initializeAuthHoliday() async {
    try {
      MTAResult objResult = MTAResult();
      final userInfo = await PlatformSessionManager.getUserInfo();
      if (userInfo != null) {
        String companyCode = userInfo['CompanyCode'];
        String loginID = userInfo['LoginID'];
        String password = userInfo['Password'];
        _authLogin = await AuthLoginDetails()
            .LoginInformationForFirstLogin(companyCode, loginID, password);
        fetchHolidays();
      }
    } catch (e) {
      MTAToast().ShowToast(e.toString());
    }
  }

  Future<void> fetchHolidays() async {
    try {
      if (_authLogin == null) {
        throw Exception('Authentication not initialized');
      }

      isLoading.value = true;

      MTAResult result = MTAResult();
      List<Holiday> apiHoliday =
          await HolidayDetails().GetAllHolidayes(_authLogin!, result);
      print('apiHoliday: $apiHoliday');
      holiday.value = apiHoliday
          .map((b) => HolidayModel(
                holidayID: b.HolidayID,
                holidayName: b.HolidayName,
                holidayDate: b.HolidayDate,
                holidayYear: b.HolidayYear,
                listOfCompany: b.ListOfBranch.map(
                        (xyz) => ListOfCompany.fromJson(xyz.toJson()))
                    .toList(),
              ))
          .toList();

      updateSearchQuery(searchQuery.value);
    } catch (e) {
      MTAToast().ShowToast(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filterHolidays.assignAll(holiday);
    } else {
      filterHolidays.assignAll(
        holiday.where((branch) =>
            (branch.holidayName?.toLowerCase().contains(query.toLowerCase()) ??
                false) ||
            (branch.holidayDate
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()) ??
                false) ||
            (branch.holidayYear
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()) ??
                false) ||
            (branch.listOfCompany
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()) ??
                false)),
      );
    }
  }

 Future<void> saveHoliday(HolidayModel holiday) async {
  try {
    if (_authLogin == null) {
      throw Exception('Authentication not initialized');
    }

    // Validate required fields
    if (holiday.holidayName?.isEmpty ?? true) {
      throw Exception('Holiday is required');
    }
    if (holiday.holidayDate?.isEmpty ?? true) {
      throw Exception('Holiday date is required');
    }
    if (holiday.listOfCompany?.isEmpty ?? true) {
      throw Exception('At least one company must be selected');
    }

    // Extract year from holiday date - Fix the date parsing
    String holidayYear;
    try {
      // Check if the date is in format DD-MMM-YYYY
      if (holiday.holidayDate!.contains('-')) {
        final parts = holiday.holidayDate!.split('-');
        if (parts.length == 3) {
          holidayYear = parts[2]; // Get the year part
        } else {
          // Fallback to current year if format doesn't match
          holidayYear = DateTime.now().year.toString();
        }
      } else {
        // If it's in ISO format, parse normally
        DateTime holidayDateTime = DateTime.parse(holiday.holidayDate!);
        holidayYear = holidayDateTime.year.toString();
      }
    } catch (e) {
      // Fallback to extracting year if the full date can't be parsed
      final dateRegex = RegExp(r'(\d{4})'); // Match any 4-digit year in the string
      final match = dateRegex.firstMatch(holiday.holidayDate!);
      holidayYear = match?.group(1) ?? DateTime.now().year.toString();
    }

    isLoading.value = true;
    MTAResult result = MTAResult();

    // Create Holiday object and convert list of companies to branches
    Holiday apiHoliday = Holiday()
      ..HolidayID = holiday.holidayID ?? '' // For new entries, this will be empty
      ..HolidayName = holiday.holidayName ?? ''
      ..HolidayDate = holiday.holidayDate ?? ''
      ..HolidayYear = holidayYear // Use the extracted year
      ..BranchIDs = holiday.listOfCompany
              ?.map((company) => company.companyID ?? '')
              .where((id) => id.isNotEmpty)
              .join(',') ??
          ''
      ..ListOfBranch = holiday.listOfCompany
              ?.map((company) => Branch()
                ..BranchID = company.companyID ?? ''
                ..BranchName = company.companyName ?? ''
                ..Address = company.address ?? ''
                ..ContactNo = company.contactNo ?? ''
                ..Website = company.website ?? '')
              .toList() ??
          [];

    bool success;
    if (holiday.holidayID == null || holiday.holidayID!.isEmpty) {
      // For new holiday
      success = await HolidayDetails().Save(_authLogin!, apiHoliday, result);
    } else {
      // For updating existing holiday
      success = await HolidayDetails().Update(_authLogin!, apiHoliday, result);
    }

    if (success) {
      MTAToast().ShowToast(result.ResultMessage);
      await fetchHolidays(); // Refresh the list after successful save
    } else {
      throw Exception(result.ErrorMessage.isNotEmpty
          ? result.ErrorMessage
          : 'Failed to save holiday');
    }
  } catch (e) {
    MTAToast().ShowToast(e.toString());
    rethrow; // Rethrow to handle in the UI if needed
  } finally {
    isLoading.value = false;
  }
}

  Future<void> deleteHoliday(String holidayID) async {
    try {
      if (_authLogin == null) {
        throw Exception('Authentication not initialized');
      }

      isLoading.value = true;
      MTAResult result = MTAResult();

      bool success =
          await HolidayDetails().Delete(_authLogin!, holidayID, result);

      if (success) {
        MTAToast().ShowToast(result.ResultMessage);
        await fetchHolidays();
      } else {
        MTAToast().ShowToast(result.ResultMessage);
        throw Exception(result.ErrorMessage);
      }
    } catch (e) {
      MTAToast().ShowToast(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void sortHolidays(String columnName, bool? ascending) {
    if (ascending != null) {
      isSortAscending.value = ascending;
    } else if (sortColumn.value == columnName) {
      isSortAscending.value = !isSortAscending.value;
    } else {
      isSortAscending.value = true;
    }

    sortColumn.value = columnName;

    filterHolidays.sort((a, b) {
      int comparison;
      switch (columnName) {
        case 'Holiday':
          comparison = (a.holidayName ?? '').compareTo(b.holidayName ?? '');
          break;
        case 'Holiday Date':
          comparison = (a.holidayDate ?? '').compareTo(b.holidayDate ?? '');
          break;
        case 'Holiday Year':
          comparison = (a.holidayYear ?? '').compareTo(b.holidayYear ?? '');
          break;
        case 'Branch Name':
          comparison = (a.holidayName ?? '')
              .toString()
              .compareTo((b.holidayName ?? '').toString());
          break;
        case 'Address':
          comparison = (a.holidayDate ?? '')
              .toString()
              .compareTo((b.holidayDate ?? '').toString());
          break;
        case 'Contact':
          comparison = (a.holidayYear ?? '')
              .toString()
              .compareTo((b.holidayYear ?? '').toString());
          break;
        case 'Website':
          comparison = (a.listOfCompany ?? '')
              .toString()
              .compareTo((b.listOfCompany ?? '').toString());
          break;

        default:
          comparison = 0;
      }
      return isSortAscending.value ? comparison : -comparison;
    });
  }

  Future<void> fetchHolidaysByYear(String year) async {
    try {
      if (_authLogin == null) {
        throw Exception('Authentication not initialized');
      }

      isLoading.value = true;
      MTAResult result = MTAResult();

      List<Holiday> apiHoliday = await HolidayDetails()
          .GetHolidayByHolidayYear(_authLogin!, year, result);

      holiday.value = apiHoliday
          .map((b) => HolidayModel(
                holidayID: b.HolidayID,
                holidayName: b.HolidayName,
                holidayDate: b.HolidayDate,
                holidayYear: b.HolidayYear,
                listOfCompany: b.ListOfBranch.map(
                        (branch) => ListOfCompany.fromJson(branch.toJson()))
                    .toList(),
              ))
          .toList();

      updateSearchQuery(searchQuery.value);
    } catch (e) {
      MTAToast().ShowToast(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchHolidaysByBranchIDAndYear(
      String branchID, String year) async {
    try {
      if (_authLogin == null) {
        throw Exception('Authentication not initialized');
      }

      isLoading.value = true;
      MTAResult result = MTAResult();

      List<Holiday> apiHoliday = await HolidayDetails()
          .GetHolidayByBranchIDNYear(_authLogin!, branchID, year, result);

      if (result.ErrorMessage.isNotEmpty) {
        MTAToast().ShowToast(result.ErrorMessage);
        return;
      }

      holiday.value = apiHoliday
          .map((b) => HolidayModel(
                holidayID: b.HolidayID,
                holidayName: b.HolidayName,
                holidayDate: b.HolidayDate,
                holidayYear: b.HolidayYear,
                listOfCompany: b.ListOfBranch.map(
                        (branch) => ListOfCompany.fromJson(branch.toJson()))
                    .toList(),
              ))
          .toList();

      updateSearchQuery(searchQuery.value);
    } catch (e) {
      MTAToast().ShowToast('Error fetching holidays: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
}
