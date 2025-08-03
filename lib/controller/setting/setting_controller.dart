import 'package:get/get.dart';
import 'package:time_attendance/model/setting/seting_model.dart';
// import '../models/employee_settings_model.dart';

class EmployeeSettingsController extends GetxController {
  final settings = EmployeeSettings().obs;
  
  void updatePunchType(String value) {
    settings.update((val) {
      val?.punchType = value;
    });
  }

  void updateOutTime(String value) {
    settings.update((val) {
      val?.outTime = value;
    });
  }

  void updateLateComingMinutes(String value) {
    settings.update((val) {
      val?.lateComingMinutes = value;
    });
  }

  void updateEarlyGoingMinutes(String value) {
    settings.update((val) {
      val?.earlyGoingMinutes = value;
    });
  }

  void updateCalculationType(String value) {
    settings.update((val) {
      val?.calculationType = value;
    });
  }

  void updateFullDayMins(String value) {
    settings.update((val) {
      val?.fullDayMins = value;
    });
  }

  void updateHalfDayMins(String value) {
    settings.update((val) {
      val?.halfDayMins = value;
    });
  }

  void toggleOvertimeAllowed(bool value) {
    settings.update((val) {
      val?.isOvertimeAllowed = value;
    });
  }

  void updateOtGraceMins(String value) {
    settings.update((val) {
      val?.otGraceMins = value;
    });
  }

  void updateOtCalculation(String value) {
    settings.update((val) {
      val?.otCalculation = value;
    });
  }

  void toggleAllowBreaks(bool value) {
    settings.update((val) {
      val?.allowBreaks = value;
    });
  }

  void toggleDeductBreakFullDay(bool value) {
    settings.update((val) {
      val?.deductBreakFullDay = value;
    });
  }

  void toggleDeductBreakHalfDay(bool value) {
    settings.update((val) {
      val?.deductBreakHalfDay = value;
    });
  }

  void updateWeeklyOffType(String value) {
    settings.update((val) {
      val?.weeklyOffType = value;
    });
  }

  void updateWeeklyOffConsideration(String value) {
    settings.update((val) {
      val?.weeklyOffConsideration = value;
    });
  }

  void updateHolidayConsideration(String value) {
    settings.update((val) {
      val?.holidayConsideration = value;
    });
  }

  void updateSameDayConsideration(String value) {
    settings.update((val) {
      val?.sameDayConsideration = value;
    });
  }

  void updateAbsentHolidayMark(String value) {
    settings.update((val) {
      val?.absentHolidayMark = value;
    });
  }

  void updateAbsentDays(String value) {
    settings.update((val) {
      val?.absentDays = value;
    });
  }

  void updateAbsentMarkType(String value) {
    settings.update((val) {
      val?.absentMarkType = value;
    });
  }

  void toggleCalculateLateEarlyMinutes(bool value) {
    settings.update((val) {
      val?.calculateLateEarlyMinutes = value;
    });
  }

  void toggleWeeklyOffRotational(bool value) {
    settings.update((val) {
      val?.isWeeklyOffRotational = value;
    });
  }

  void updateForcePunchOut(String value) {
    settings.update((val) {
      val?.forcePunchOut = value;
    });
  }

  void toggleConsiderLateDeduction(bool value) {
    settings.update((val) {
      val?.considerLateDeduction = value;
    });
  }

  void updateLateComingDays(String value) {
    settings.update((val) {
      val?.lateComingDays = value;
    });
  }

  void updateLateComingAction(String value) {
    settings.update((val) {
      val?.lateComingAction = value;
    });
  }

  void toggleRepeatLateDeduction(bool value) {
    settings.update((val) {
      val?.isRepeatLateDeduction = value;
    });
  }

  void saveSettings() {
    // Implement your save logic here
    print(settings.value.toJson());
    Get.snackbar('Success', 'Settings saved successfully');
  }

  void resetSettings() {
    settings(EmployeeSettings());
  }
}