import 'package:get/get.dart';
import 'package:time_attendance/Data/LoginInformation/AuthLogin.dart';
import 'package:time_attendance/Data/LoginInformation/AuthLoginInfoDetails.dart';
import 'package:time_attendance/General/MTAResult.dart';
import 'package:time_attendance/model/Masters/Shift.dart';
import 'package:time_attendance/model/Masters/shiftDetails.dart';
import 'package:time_attendance/model/sfift_tab_model/shift_details_model.dart';
import 'package:time_attendance/widgets/mtaToast.dart';
import 'package:time_attendance/model/TALogin/session_manager.dart'
    if (dart.library.html) 'package:time_attendance/model/TALogin/session_manager_web.dart'
    if (dart.library.io) 'package:time_attendance/model/TALogin/session_manager_mobile.dart';

class ShiftDetailsController extends GetxController {
  final isLoading = false.obs;
  final shifts = <SiftDetailsModel>[].obs;
  final filteredShifts = <SiftDetailsModel>[].obs;
  final searchQuery = ''.obs;
  final sortColumn = Rx<String?>(null);
  final defaultShift = Rx<Shift?>(null);
  final isSortAscending = true.obs;

  AuthLogin? _authLogin;

  @override
  void onInit() {
    super.onInit();
    initializeAuthShift();
  }

  Future<void> initializeAuthShift() async {
    try {
      MTAResult objResult = MTAResult();
      final userInfo = await PlatformSessionManager.getUserInfo();
      if (userInfo != null) {
        String companyCode = userInfo['CompanyCode'];
        String loginID = userInfo['LoginID'];
        String password = userInfo['Password'];
        _authLogin = await AuthLoginDetails()
            .LoginInformationForFirstLogin(companyCode, loginID, password);
        fetchShifts();
      }
    } catch (e) {
      MTAToast().ShowToast(e.toString());
    }
  }

  Future<void> fetchShifts() async {
    try {
      if (_authLogin == null) {
        throw Exception('Authentication not initialized');
      }
      isLoading.value = true;
      MTAResult result = MTAResult();
      List<Shift> apiShifts =
          await ShiftDetails().GetAllShiftes(_authLogin!, result);

      shifts.value = apiShifts
          .map((s) => SiftDetailsModel(
              shiftID: s.ShiftID,
              shiftName: s.ShiftName,
              inTime: s.InTime,
              outTime: s.OutTime,
              isShiftEndNextDay: s.IsEndsInNextDay, // Added
              isShiftStartsPreviousDay: s.IsStartFromPreviousDay, // Added
              fullDayMinutes: s.FullDayMinutes,
              halfDayMinutes: s.HalfDayMinutes,
              isOTAllowed: s.IsOTAllowed,
              oTStartMinutes: s.OTStartMins, // Use OTStartMins
              oTGraceMinutes: s.OTGraceMinutes,
              isOTStartsAtShiftEnd: s.IsOTStartsAtShiftEnd,
              lunchInTime: s.LunchInTime,
              lunchOutTime: s.LunchOutTime,
              lunchMins: s.LunchMins,
              otherBreakMins: s.OtherBreakMins,
              autoShiftInTimeStart: s.AutoShiftInTimeStart,
              autoShiftInTimeEnd: s.AutoShiftInTimeEnd,
              autoShiftLapseTime: s.AutoShiftLapseTime,
              isShiftAutoAssigned: s.IsShiftAutoAssigned,
              isDefaultShift: s.IsDefaultShift))
          .toList();
    
      updateSearchQuery(searchQuery.value);
    } catch (e) {
      MTAToast().ShowToast(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> saveShift(SiftDetailsModel shift) async {
    try {
      if (_authLogin == null) {
        throw Exception('Authentication not initialized');
      }

      isLoading.value = true;
      MTAResult result = MTAResult();

      Shift apiShift = Shift()
        ..ShiftID = shift.shiftID ?? ''
        ..ShiftName = shift.shiftName ?? ''
        ..InTime = shift.inTime ?? ''
        ..OutTime = shift.outTime ?? ''
        ..IsEndsInNextDay = shift.isShiftEndNextDay ?? false
        ..IsStartFromPreviousDay = shift.isShiftStartsPreviousDay ?? false
        ..FullDayMinutes = shift.fullDayMinutes ?? 0
        ..HalfDayMinutes = shift.halfDayMinutes ?? 0
        ..IsOTAllowed = shift.isOTAllowed ?? false
        ..OTStartMins = shift.oTStartMinutes ?? 0
        ..OTGraceMinutes = shift.oTGraceMinutes ?? 0
        ..IsOTStartsAtShiftEnd = shift.isOTStartsAtShiftEnd ?? false
        ..LunchInTime = shift.lunchInTime ?? ''
        ..LunchOutTime = shift.lunchOutTime ?? ''
        ..LunchMins = shift.lunchMins ?? 0
        ..OtherBreakMins = shift.otherBreakMins ?? 0
        ..AutoShiftInTimeStart = shift.autoShiftInTimeStart ?? ''
        ..AutoShiftInTimeEnd = shift.autoShiftInTimeEnd ?? ''
        ..AutoShiftLapseTime = shift.autoShiftLapseTime ?? 0
        ..IsShiftAutoAssigned = shift.isShiftAutoAssigned ?? false
        ..IsDefaultShift = shift.isDefaultShift ?? false;

      bool success;
      if (shift.shiftID == null ||
          shift.shiftID!.isEmpty ||
          shift.shiftID == "0") {
        apiShift.ShiftID = "0";
        success = await ShiftDetails().Save(_authLogin!, apiShift, result);
      } else {
        success = await ShiftDetails().Update(_authLogin!, apiShift, result);
      }

      MTAToast().ShowToast(result.ResultMessage);
      if (success) {
        await fetchShifts();
      }
      return success;
    } catch (e) {
      MTAToast().ShowToast(e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch the default shift and expose it as an observable

  Future<void> fetchDefaultShift() async {
    try {
      if (_authLogin == null) {
        throw Exception('Authentication not initialized');
      }
      isLoading.value = true;
      MTAResult result = MTAResult();
      Shift? shift = await ShiftDetails().GetDefaultShift(_authLogin!, result);
      if (shift != null) {
        defaultShift.value = shift;
      } else {
        defaultShift.value = null;
      }
    } catch (e) {
      defaultShift.value = null;
      MTAToast().ShowToast(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteShift(String shiftId) async {
    try {
      if (_authLogin == null) {
        throw Exception('Authentication not initialized');
      }

      isLoading.value = true;
      MTAResult result = MTAResult();

      bool success = await ShiftDetails().Delete(_authLogin!, shiftId, result);

      if (success) {
        MTAToast().ShowToast(result.ResultMessage);
        await fetchShifts();
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

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredShifts.assignAll(shifts);
    } else {
      filteredShifts.assignAll(
        shifts.where((shift) =>
            (shift.shiftName?.toLowerCase().contains(query.toLowerCase()) ??
                false) ||
            (shift.inTime?.toLowerCase().contains(query.toLowerCase()) ??
                false) ||
            (shift.outTime?.toLowerCase().contains(query.toLowerCase()) ??
                false) ||
            (shift.lunchInTime?.toLowerCase().contains(query.toLowerCase()) ??
                false) ||
            (shift.lunchOutTime?.toLowerCase().contains(query.toLowerCase()) ??
                false)),
      );
    }
  }

  void sortShifts(String columnName, bool? ascending) {
    if (ascending != null) {
      isSortAscending.value = ascending;
    } else if (sortColumn.value == columnName) {
      isSortAscending.value = !isSortAscending.value;
    } else {
      isSortAscending.value = true;
    }

    sortColumn.value = columnName;

    filteredShifts.sort((a, b) {
      int comparison;
      switch (columnName) {
        case 'Shift Name':
          comparison = (a.shiftName ?? '').compareTo(b.shiftName ?? '');
          break;
        case 'In Time':
          comparison = (a.inTime ?? '').compareTo(b.inTime ?? '');
          break;
        case 'Out Time':
          comparison = (a.outTime ?? '').compareTo(b.outTime ?? '');
          break;
        case 'Full Day Minutes':
          comparison = (a.fullDayMinutes ?? 0).compareTo(b.fullDayMinutes ?? 0);
          break;
        case 'Half Day Minutes':
          comparison = (a.halfDayMinutes ?? 0).compareTo(b.halfDayMinutes ?? 0);
          break;
        case 'Lunch Minutes':
          comparison = (a.lunchMins ?? 0).compareTo(b.lunchMins ?? 0);
          break;
        case 'Other Break Minutes':
          comparison = (a.otherBreakMins ?? 0).compareTo(b.otherBreakMins ?? 0);
          break;
        default:
          comparison = 0;
      }
      return isSortAscending.value ? comparison : -comparison;
    });
  }
}
