// department_controller.dart
import 'package:get/get.dart';
import 'package:time_attendance/Data/LoginInformation/AuthLogin.dart';
import 'package:time_attendance/Data/LoginInformation/AuthLoginInfoDetails.dart';
import 'package:time_attendance/General/MTAResult.dart';
import 'package:time_attendance/model/Masters/list_of_shift_model.dart';
import 'package:time_attendance/model/Masters/shiftPattern.dart';
import 'package:time_attendance/model/Masters/shiftPatternDetails.dart';
import 'package:time_attendance/model/Masters/shiftDetails.dart';
import 'package:time_attendance/widgets/mtaToast.dart';
import 'package:time_attendance/model/TALogin/session_manager.dart'
    if (dart.library.html) 'package:time_attendance/model/TALogin/session_manager_web.dart'
    if (dart.library.io) 'package:time_attendance/model/TALogin/session_manager_mobile.dart';

class ShiftPatternController extends GetxController {
  final shiftPatterns = <ShiftPatternModel>[].obs; // UI Model
  final filteredShiftPatterns = <ShiftPatternModel>[].obs; // UI Model
  final searchQuery = ''.obs;
  final isLoading = false.obs;

  // Pagination variables
  final currentPage = RxInt(1);
  final itemsPerPage = RxInt(10);
  final totalItems = RxInt(0);

  // Holds all available shifts (ListOfShift UI model) to populate dropdowns in the dialog
  final shifts = <ListOfShift>[].obs;


  final sortColumn = RxString('PatternName');
  final isSortAscending = RxBool(true);

  AuthLogin? _authLogin;

  @override
  void onInit() {
    super.onInit();
    initializeAuthShiftPattern();
    
    // Listen to changes in pagination values
    ever(currentPage, (_) => _updateFilteredPatterns());
    ever(itemsPerPage, (_) => _updateFilteredPatterns());
  }

  Future<void> initializeAuthShiftPattern() async {
    try {
      final userInfo = await PlatformSessionManager.getUserInfo();
      if (userInfo != null) {
        String companyCode = userInfo['CompanyCode'];
        String loginID = userInfo['LoginID'];
        String password = userInfo['Password'];
        _authLogin = await AuthLoginDetails()
            .LoginInformationForFirstLogin(companyCode, loginID, password);
        await fetchShifts(); // Fetch shifts first
        await fetchShiftPatterns();
      }
    } catch (e) {
      MTAToast().ShowToast("Error initializing auth: ${e.toString()}");
    }
  }

 Future<void> fetchShiftPatterns() async {
  if (_authLogin == null) {
    MTAToast().ShowToast('Authentication not initialized for fetching patterns.');
    print('[DEBUG] _authLogin is null');
    return;
  }

  isLoading.value = true;
  print('[DEBUG] Fetching shift patterns started...');

  try {
    MTAResult mtaResult = MTAResult();
    
    List<ShiftPatternModel> apiMasterShiftPatterns =
        await ShiftPatternDetails().GetAllShiftPatterns(_authLogin!, mtaResult);      if (mtaResult.IsResultPass) {
        shiftPatterns.value = apiMasterShiftPatterns.map((masterPattern) {
          print('[DEBUG] Mapping shift pattern: ${masterPattern.toJson()}');
          return ShiftPatternModel.fromJson(masterPattern.toJson());
        }).toList();

        totalItems.value = shiftPatterns.length;
        _updateFilteredPatterns(); // Apply pagination on initial load
    } else {
      String error = mtaResult.ErrorMessage.isNotEmpty
          ? mtaResult.ErrorMessage
          : "Failed to fetch shift patterns.";
      MTAToast().ShowToast(error);
    }
  } catch (e) {
    MTAToast().ShowToast("Error fetching shift patterns: ${e.toString()}");
    shiftPatterns.clear();
    filteredShiftPatterns.clear();
  } finally {
    isLoading.value = false;
  }
}

  Future<void> fetchShifts() async {
    if (_authLogin == null) {
      MTAToast().ShowToast('Authentication not initialized for fetching shifts.');
      print('[DEBUG] _authLogin is null');
      return;
    }

    isLoading.value = true;
    print('[DEBUG] Fetching shifts started...');

    try {
      MTAResult mtaResult = MTAResult();
      final apiShifts = await ShiftDetails().GetAllShiftes(_authLogin!, mtaResult);
      
      if (mtaResult.IsResultPass) {
        shifts.value = apiShifts.map((shift) => ListOfShift(
          shiftId: shift.ShiftID,
          shiftName: shift.ShiftName,
          inTime: shift.InTime,
          outTime: shift.OutTime,
          isShiftEndNextDay: false, // Set default value
          isShiftStartsPreviousDay: false, // Set default value
          fullDayMinutes: shift.FullDayMinutes,
          halfDayMinutes: shift.HalfDayMinutes,
          isOTAllowed: shift.IsOTAllowed,
          otStartMinutes: 0, // Set default value
          otGraceMinutes: shift.OTGraceMinutes,
          isOTStartsAtShiftEnd: shift.IsOTStartsAtShiftEnd,
          lunchInTime: shift.LunchInTime,
          lunchOutTime: shift.LunchOutTime,
          lunchMins: shift.LunchMins,
          otherBreakMins: shift.OtherBreakMins,
          autoShiftInTimeStart: shift.AutoShiftInTimeStart,
          autoShiftInTimeEnd: shift.AutoShiftInTimeEnd,
          autoShiftLapseTime: shift.AutoShiftLapseTime,
          isShiftAutoAssigned: shift.IsShiftAutoAssigned,
          isDefaultShift: shift.IsDefaultShift,
        )).toList();
        print('[DEBUG] Fetched ${shifts.length} shifts');
      } else {
        String error = mtaResult.ErrorMessage.isNotEmpty
            ? mtaResult.ErrorMessage
            : "Failed to fetch shifts.";
        MTAToast().ShowToast(error);
      }
    } catch (e) {
      MTAToast().ShowToast("Error fetching shifts: ${e.toString()}");
      shifts.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    currentPage.value = 1; // Reset to first page when searching
    _updateFilteredPatterns();
  }
  void _updateFilteredPatterns() {
    // First, apply search filter to get the full filtered list
    var fullFilteredList = searchQuery.value.isEmpty
        ? List<ShiftPatternModel>.from(shiftPatterns)
        : shiftPatterns.where((pattern) =>
            (pattern.patternName.toLowerCase().contains(searchQuery.value.toLowerCase())) ||
            (pattern.patternDisplayString.toLowerCase().contains(searchQuery.value.toLowerCase()))
          ).toList();
    
    // Update total items count
    totalItems.value = fullFilteredList.length;
    
    // Apply pagination
    int startIndex = (currentPage.value - 1) * itemsPerPage.value;
    if (startIndex >= fullFilteredList.length) {
      // If current page would be empty, go back to first page
      currentPage.value = 1;
      startIndex = 0;
    }
    
    int endIndex = startIndex + itemsPerPage.value;
    if (endIndex > fullFilteredList.length) {
      endIndex = fullFilteredList.length;
    }
    
    // Update the filtered list with paginated results
    filteredShiftPatterns.assignAll(fullFilteredList.sublist(startIndex, endIndex));
  }

  void sortShiftPatterns(String columnName, bool? ascending) {
    if (ascending != null) {
      isSortAscending.value = ascending;
    } else if (sortColumn.value == columnName) {
      isSortAscending.value = !isSortAscending.value;
    } else {
      isSortAscending.value = true;
    }
    
    sortColumn.value = columnName;

    filteredShiftPatterns.sort((a, b) {
      int comparison;
      switch (columnName) {
        case 'Pattern Name':
          comparison = a.patternName.compareTo(b.patternName);
          break;
        case 'Shifts':
          // Sort by the concatenated shift names
          String shiftsA = a.listOfShifts.map((s) => s.shiftName).join(', ');
          String shiftsB = b.listOfShifts.map((s) => s.shiftName).join(', ');
          comparison = shiftsA.compareTo(shiftsB);
          break;
        default:
          comparison = 0;
      }
      return isSortAscending.value ? comparison : -comparison;
    });

    _updateFilteredPatterns(); // Apply pagination after sorting
  }

  Future<void> deleteShiftPattern(String patternId) async {
    try {
      if (_authLogin == null) {
        throw Exception('Authentication not initialized');
      }
      
      MTAResult result = MTAResult();
      bool success = await ShiftPatternDetails().Delete(_authLogin!, patternId, result);
      
      if (success) {
        MTAToast().ShowToast(result.ResultMessage);
        await fetchShiftPatterns(); // Refresh the list after successful deletion
      } else if (!result.IsResultPass) {
        MTAToast().ShowToast(result.ResultMessage);
        throw Exception(result.ErrorMessage);
      }
    } catch (e) {
      MTAToast().ShowToast("Error deleting shift pattern: ${e.toString()}");
      print(e.toString());
    }
  }

  Future<bool> saveShiftPattern(String patternName, List<String> selectedShiftIds) async {
    try {
      if (_authLogin == null) {
        throw Exception('Authentication not initialized');
      }

      MTAResult result = MTAResult();
      bool success = await ShiftPatternDetails().Save(
        _authLogin!,
        patternName,
        selectedShiftIds,
        result
      );

      if (success) {
        MTAToast().ShowToast(result.ResultMessage);
      } else if (!result.IsResultPass) {
        MTAToast().ShowToast(result.ResultMessage);
        throw Exception(result.ErrorMessage);
      }
      
      return success;
    } catch (e) {
      MTAToast().ShowToast("Error saving shift pattern: ${e.toString()}");
      print(e.toString());
      return false;
    }
  }

  Future<bool> updateShiftPattern(int patternId, String patternName, List<String> selectedShiftIds) async {
    try {
      if (_authLogin == null) {
        throw Exception('Authentication not initialized');
      }

      MTAResult result = MTAResult();
      bool success = await ShiftPatternDetails().Update(
        _authLogin!,
        patternId,
        patternName,
        selectedShiftIds,
        result
      );

      if (success) {
        MTAToast().ShowToast(result.ResultMessage);
      } else if (!result.IsResultPass) {
        MTAToast().ShowToast(result.ResultMessage);
        throw Exception(result.ErrorMessage);
      }
      
      return success;
    } catch (e) {
      MTAToast().ShowToast("Error updating shift pattern: ${e.toString()}");
      print(e.toString());
      return false;
    }
  }

}
