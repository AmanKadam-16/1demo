import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for FilteringTextInputFormatter
import 'package:get/get.dart';
import 'package:time_attendance/model/employee_tab_model/settingprofile.dart';
import 'package:time_attendance/controller/employee_tab_controller/settingprofile_controller.dart';
import 'package:time_attendance/widget/reusable/tooltip/help_tooltip_button.dart';

// --- Enums for Radio Button Groups ---
enum PresentOnWeeklyOffHolidayOptions { overTime, compensatoryOff, present }

enum LeaveContainsWeeklyOffOptions { leave, weeklyOff }

enum LeaveContainsHolidayOptions { leave, holiday }

enum WeeklyOffHolidaySameDayOptions { weeklyOff, holiday }

enum AbsentBeforeAfterHolidayOptions { holiday, absent }

enum PunchTypeOptions { doubleFL, multipleEO, single }

enum WorkMinutesCalculationOptions { byShiftwise, byEmployeewise }

enum OverTimeStartOptions { afterFullDay, atExactShiftEnd }

// --- NEW: Enums for Additional Settings ---
enum OverTimeCalculationOptions { afterHour, afterHalfHour, none }

enum ForcePunchOutOptions {
  defaultTime,
  byShiftOutTime,
  byAddingHalfDayInTime,
  none
}

enum LateComingActionOptions { cutFullDay, markAbsent, none }

// --- NEW: Enums for Regular Shift, WeeklyOff, Login Details ---
enum ShiftStartDateOptions { employeeJoiningDate, startOfJoiningMonth }

enum ShiftTypeOptions { fix, rotation, autoAssign }

enum WeeklyOffTypeOptions { regular, rotating }

enum WeeklyOffAbsentMarkingOptions { prefix, postfix, aWoffA, none }

class AddEditSettingProfileScreen extends StatefulWidget {
  final SettingProfileModel? profile;

  const AddEditSettingProfileScreen({
    Key? key,
    this.profile,
  }) : super(key: key);

  @override
  State<AddEditSettingProfileScreen> createState() =>
      _AddEditSettingProfileScreenState();
}

class _AddEditSettingProfileScreenState
    extends State<AddEditSettingProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _profileNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isDefaultProfile = false;

  // --- Work Settings State ---
  PresentOnWeeklyOffHolidayOptions _presentOnWeeklyOffHoliday =
      PresentOnWeeklyOffHolidayOptions.compensatoryOff;
  LeaveContainsWeeklyOffOptions _leaveContainsWeeklyOff =
      LeaveContainsWeeklyOffOptions.leave;
  LeaveContainsHolidayOptions _leaveContainsHoliday =
      LeaveContainsHolidayOptions.leave;
  WeeklyOffHolidaySameDayOptions _weeklyOffHolidaySameDay =
      WeeklyOffHolidaySameDayOptions.holiday;
  AbsentBeforeAfterHolidayOptions _absentBeforeAfterHoliday =
      AbsentBeforeAfterHolidayOptions.holiday;
  final TextEditingController _absentDaysForWeeklyOffController =
      TextEditingController(text: "0");
  WeeklyOffAbsentMarkingOptions _weeklyOffAbsentMarking =
      WeeklyOffAbsentMarkingOptions.none;

  // --- Work Minutes State ---
  PunchTypeOptions _punchType = PunchTypeOptions.doubleFL;
  final TextEditingController _singlePunchOutTimeHHController =
      TextEditingController();
  final TextEditingController _singlePunchOutTimeMMController =
      TextEditingController();

  final TextEditingController _allowedLateComingMinutesController =
      TextEditingController(text: "15");
  final TextEditingController _allowedEarlyGoingMinutesController =
      TextEditingController(text: "15");

  WorkMinutesCalculationOptions _workMinutesCalculation =
      WorkMinutesCalculationOptions.byEmployeewise;

  // --- Work Details (By Employeewise) ---
  final TextEditingController _fullDayMinsController =
      TextEditingController(text: "480");
  final TextEditingController _halfDayMinsController =
      TextEditingController(text: "240");
  bool _isEmployeeAllowedToDoOverTime = true;
  final TextEditingController _otGraceMinsController =
      TextEditingController(text: "5");
  OverTimeStartOptions _overTimeCalculationStartsAt =
      OverTimeStartOptions.afterFullDay;
  final TextEditingController _otStartsMinsController =
      TextEditingController(text: "490");
  // --- NEW: Additional Settings State ---
  OverTimeCalculationOptions _additionalOverTimeCalcOption =
      OverTimeCalculationOptions
          .none; // Renamed to avoid conflict if any other OT calc exists
  bool _isEmployeeAllowedToTakeBreak = false;
  bool _subtractLunchFromFullDay = false;
  bool _subtractLunchFromHalfDay = false;
  bool _calculateLateEarlyOnWeeklyOff = false;

  ForcePunchOutOptions _forcePunchOutOption =
      ForcePunchOutOptions.byAddingHalfDayInTime;
  final TextEditingController _defaultForcePunchOutHHController =
      TextEditingController();
  final TextEditingController _defaultForcePunchOutMMController =
      TextEditingController();

  bool _isLateComingDeductionAllowed = false;
  final TextEditingController _lateComingForDaysController =
      TextEditingController(text: "-1"); // Default as per image
  LateComingActionOptions _lateComingAction = LateComingActionOptions.none;
  bool _isRepeatLateComingDeductionAllowed = false;

  // --- NEW: Regular Shift State ---
  ShiftStartDateOptions _shiftStartDateOption =
      ShiftStartDateOptions.startOfJoiningMonth;
  ShiftTypeOptions _shiftTypeOption = ShiftTypeOptions.autoAssign;
  String? _selectedFixShift; // For "Fix" shift type dropdown
  final TextEditingController _shiftConstantDaysController =
      TextEditingController();
  String? _selectedShiftPattern; // For "Rotation" shift type dropdown

  // --- NEW: WeeklyOff Details State ---
  WeeklyOffTypeOptions _weeklyOffTypeOption = WeeklyOffTypeOptions.regular;
  String? _selectedFirstWeeklyOff = "Sunday"; // Default as per image
  String? _selectedSecondWeeklyOff = "None"; // Default as per image
  String? _selectedFullDayHalfDay = "FullDay"; // Default as per image

  // --- NEW: Employee Login Details State ---
  bool _canUseNonBiometricDevice = false;
  bool _viewRights = true; // Default as per image
  bool _canApplyForLeave = false;
  bool _canApplyForTour = false;
  bool _canApplyForManualAttendance = false;
  bool _canApplyForOutDoorDuty = false;

  // Placeholder data for dropdowns - replace with actual data
  final List<String> _shiftsList = ["causal", "General Shift", "Night Shift"];
  final List<String> _shiftPatternsList = [
    "ShiftPatternName118",
    "Pattern A",
    "Pattern B"
  ];
  final List<String> _daysOfWeek = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"
  ];
  final List<String> _daysOfWeekWithNone = [
    "None",
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday"
  ];
  final List<String> _dayTypes = ["FullDay", "HalfDay"];

  @override
  void initState() {
    super.initState();
    if (widget.profile != null) {
      _profileNameController.text = widget.profile!.profileName;
      _descriptionController.text = widget.profile!.description;
      _isDefaultProfile = widget.profile!.isDefaultProfile;

      // Initialize the WeeklyOff absent marking option
      if (widget.profile?.employeeSetting != null) {
        // TODO: Set based on profile setting when API is available
        // _weeklyOffAbsentMarking = WeeklyOffAbsentMarkingOptions.aWoffA;
      }
    }
  }

  @override
  void dispose() {
    _profileNameController.dispose();
    _descriptionController.dispose();

    // Dispose new controllers
    _absentDaysForWeeklyOffController.dispose();
    _singlePunchOutTimeHHController.dispose();
    _singlePunchOutTimeMMController.dispose();
    _allowedLateComingMinutesController.dispose();
    _allowedEarlyGoingMinutesController.dispose();
    _fullDayMinsController.dispose();
    _halfDayMinsController.dispose();
    _otGraceMinsController.dispose();
    _otStartsMinsController.dispose();
    // --- NEW: Dispose Additional Settings controllers ---
    _defaultForcePunchOutHHController.dispose();
    _defaultForcePunchOutMMController.dispose();
    _lateComingForDaysController.dispose();
    // --- NEW: Dispose new controllers ---
    _shiftConstantDaysController.dispose();
    super.dispose();
  }

  // Helper widget for Radio Button Groups
  Widget _buildRadioWidget<T>({
    required String label,
    required T groupValue,
    required List<MapEntry<String, T>> options,
    required ValueChanged<T?> onChanged,
    bool isDense = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
          child: Text(label,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ),
        Row(
          children: options.map((entry) {
            return Expanded(
              child: InkWell(
                onTap: () => onChanged(entry.value),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Radio<T>(
                      value: entry.value,
                      groupValue: groupValue,
                      onChanged: onChanged,
                      materialTapTargetSize: isDense
                          ? MaterialTapTargetSize.shrinkWrap
                          : MaterialTapTargetSize.padded,
                      visualDensity: isDense
                          ? VisualDensity.compact
                          : VisualDensity.standard,
                    ),
                    Flexible(
                        child: Text(entry.key,
                            style: const TextStyle(fontSize: 14))),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Helper for Checkboxes in a row
  Widget _buildCheckboxRowItem(
      String title, bool value, ValueChanged<bool?> onChanged) {
    return Flexible(
      child: InkWell(
        onTap: () => onChanged(!value),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
                value: value,
                onChanged: onChanged,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 14),
                overflow: TextOverflow.ellipsis,
                maxLines: 4,
              ),
            ),
          ],
        ),
      ),  
    );
  }

  // Helper for labeled text fields (label above field)
  Widget _buildLabeledTextField(
      String label, TextEditingController controller, String hintText,
      {bool isNumeric = true, int? maxLength}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 14)), // Adjusted to 14 to match radio labels
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            border: const OutlineInputBorder(),
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          ),
          keyboardType: isNumeric
              ? const TextInputType.numberWithOptions(decimal: false)
              : TextInputType.text,
          inputFormatters: isNumeric
              ? [
                  FilteringTextInputFormatter.digitsOnly,
                  if (maxLength != null)
                    LengthLimitingTextInputFormatter(maxLength)
                ]
              : (maxLength != null
                  ? [LengthLimitingTextInputFormatter(maxLength)]
                  : []),
        ),
      ],
    );
  }

  // --- NEW: Helper for DropdownButtonFormField ---
  Widget _buildDropdownField<T>({
    required String label,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    String? hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) Text(label, style: const TextStyle(fontSize: 14)),
        if (label.isNotEmpty) const SizedBox(height: 4),
        DropdownButtonFormField<T>(
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10), // Adjusted for better dropdown appearance
            hintText: hintText,
          ),
          value: value,
          items: items,
          onChanged: onChanged,
          isExpanded: true, // Makes the dropdown take full available width
        ),
      ],
    );
  }

  Widget _buildWorkSettingsExpansionTile() {
    return ExpansionTile(
      title: const Text("Work Settings",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
      initiallyExpanded: true,
      childrenPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
      children: [
        _buildRadioWidget<PresentOnWeeklyOffHolidayOptions>(
          label: "If present on WeeklyOff or Holiday, calculate work as:",
          groupValue: _presentOnWeeklyOffHoliday,
          options: [
            MapEntry("Over Time", PresentOnWeeklyOffHolidayOptions.overTime),
            MapEntry("Compensatory Off",
                PresentOnWeeklyOffHolidayOptions.compensatoryOff),
            MapEntry("Present", PresentOnWeeklyOffHolidayOptions.present),
          ],
          onChanged: (val) => setState(() => _presentOnWeeklyOffHoliday = val!),
        ),
        _buildRadioWidget<LeaveContainsWeeklyOffOptions>(
          label:
              "If Leave application contains WeeklyOff, consider WeeklyOff as:",
          groupValue: _leaveContainsWeeklyOff,
          options: [
            MapEntry("Leave", LeaveContainsWeeklyOffOptions.leave),
            MapEntry("Weekly Off", LeaveContainsWeeklyOffOptions.weeklyOff),
          ],
          onChanged: (val) => setState(() => _leaveContainsWeeklyOff = val!),
        ),
        _buildRadioWidget<LeaveContainsHolidayOptions>(
          label: "If Leave application contains Holiday, consider Holiday as:",
          groupValue: _leaveContainsHoliday,
          options: [
            MapEntry("Leave", LeaveContainsHolidayOptions.leave),
            MapEntry("Holiday", LeaveContainsHolidayOptions.holiday),
          ],
          onChanged: (val) => setState(() => _leaveContainsHoliday = val!),
        ),
        _buildRadioWidget<WeeklyOffHolidaySameDayOptions>(
          label: "If WeeklyOff and Holiday on same day, consider it as:",
          groupValue: _weeklyOffHolidaySameDay,
          options: [
            MapEntry("Weekly Off", WeeklyOffHolidaySameDayOptions.weeklyOff),
            MapEntry("Holiday", WeeklyOffHolidaySameDayOptions.holiday),
          ],
          onChanged: (val) => setState(() => _weeklyOffHolidaySameDay = val!),
        ),
        _buildRadioWidget<AbsentBeforeAfterHolidayOptions>(
          label:
              "If Employee is Absent before and after Holiday, Mark Holiday as:",
          groupValue: _absentBeforeAfterHoliday,
          options: [
            MapEntry("Holiday", AbsentBeforeAfterHolidayOptions.holiday),
            MapEntry("Absent", AbsentBeforeAfterHolidayOptions.absent),
          ],
          onChanged: (val) => setState(() => _absentBeforeAfterHoliday = val!),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0, bottom: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Use Flexible for the long text to avoid overflow
              Flexible(
          child: Text(
            "Number of absent days that are either to be prefixed or postfixed to WeeklyOff",
            style: TextStyle(fontSize: 14),
            overflow: TextOverflow.ellipsis,
            maxLines: 4,
          ),
              ),
              const SizedBox(width: 8),
              SizedBox(
          width: 60,
          child: TextFormField(
            controller: _absentDaysForWeeklyOffController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
                contentPadding:
              EdgeInsets.symmetric(horizontal: 8, vertical: 10)),
            textAlign: TextAlign.left,
          ),
              ),
              const SizedBox(width: 8),
              // Use Flexible for the trailing text as well
              Flexible(
          child: Text(
            ', to mark WeeklyOff as "Absent" :',
            style: TextStyle(fontSize: 14),
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 12.0),
          child: _buildRadioWidget<WeeklyOffAbsentMarkingOptions>(
            label: "",
            groupValue: _weeklyOffAbsentMarking,
            isDense: true,
            options: [
              MapEntry("Prefix", WeeklyOffAbsentMarkingOptions.prefix),
              MapEntry("Postfix", WeeklyOffAbsentMarkingOptions.postfix),
              MapEntry("A-Woff-A", WeeklyOffAbsentMarkingOptions.aWoffA),
            ],
            onChanged: (val) => setState(() => _weeklyOffAbsentMarking = val!),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildWorkMinutesExpansionTile() {
    return ExpansionTile(
      title: const Text("Work Minutes",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
      initiallyExpanded: false,
      childrenPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
      children: [
        _buildRadioWidget<PunchTypeOptions>(
          label: "Punch Type:",
          groupValue: _punchType,
          isDense: true,
          options: [
            MapEntry("Double (First In Last Out)", PunchTypeOptions.doubleFL),
            MapEntry("Multiple (Even In Odd Out)", PunchTypeOptions.multipleEO),
            MapEntry("Single", PunchTypeOptions.single),
          ],
          onChanged: (val) => setState(() => _punchType = val!),
        ),
        if (_punchType == PunchTypeOptions.single)
          Padding(
            padding: const EdgeInsets.only(left: 24.0, top: 8.0, bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Out Time:* ", style: TextStyle(fontSize: 14)),
                SizedBox(
                  width: 55,
                  child: _buildLabeledTextField(
                      "", _singlePunchOutTimeHHController, "HH",
                      maxLength: 2),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(":",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  width: 55,
                  child: _buildLabeledTextField(
                      "", _singlePunchOutTimeMMController, "MM",
                      maxLength: 2),
                ),
                const SizedBox(width: 8),
                const Flexible(
                    child: Text("[in 24 Hour Format]",
                        style: TextStyle(fontSize: 12))),
              ],
            ),
          ),
        const SizedBox(height: 8),
        const Text("Allowed Late Coming Minutes and Early Going Minutes:",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
                child: _buildLabeledTextField("Late Coming Minutes:*",
                    _allowedLateComingMinutesController, "15")),
            const SizedBox(width: 16),
            Expanded(
                child: _buildLabeledTextField("Early Going Minutes:*",
                    _allowedEarlyGoingMinutesController, "15")),
          ],
        ),
        const SizedBox(height: 16),
        _buildRadioWidget<WorkMinutesCalculationOptions>(
          label:
              "Work Minutes Calculation by Minutes assign to Shift or Employee :",
          groupValue: _workMinutesCalculation,
          options: [
            MapEntry("By Shiftwise", WorkMinutesCalculationOptions.byShiftwise),
            MapEntry("By Employeewise",
                WorkMinutesCalculationOptions.byEmployeewise),
          ],
          onChanged: (val) => setState(() => _workMinutesCalculation = val!),
        ),
        if (_workMinutesCalculation ==
            WorkMinutesCalculationOptions.byEmployeewise)
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Work Details (By Employeewise):",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black87)),
                  const SizedBox(height: 12),
                  _buildLabeledTextField(
                      "Full Day Mins:*", _fullDayMinsController, "480"),
                  const SizedBox(height: 12),
                  _buildLabeledTextField(
                      "Half Day Mins:*", _halfDayMinsController, "240"),
                  const SizedBox(height: 4),
                  CheckboxListTile(
                    title: const Text("Is Employee Allowed to do OverTime.",
                        style: TextStyle(fontSize: 14)),
                    value: _isEmployeeAllowedToDoOverTime,
                    onChanged: (val) =>
                        setState(() => _isEmployeeAllowedToDoOverTime = val!),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                  ),
                  if (_isEmployeeAllowedToDoOverTime)
                    Padding(
                      padding: const EdgeInsets.only(left: 16.0, top: 0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildLabeledTextField(
                              "OT Grace Mins:", _otGraceMinsController, "5"),
                          const SizedBox(height: 12),
                          _buildRadioWidget<OverTimeStartOptions>(
                            label: "Over time calculation starts at:",
                            groupValue: _overTimeCalculationStartsAt,
                            isDense: true,
                            options: [
                              MapEntry("OT starts after FullDay minutes work",
                                  OverTimeStartOptions.afterFullDay),
                              MapEntry("OT starts at exact shift end time",
                                  OverTimeStartOptions.atExactShiftEnd),
                            ],
                            onChanged: (val) => setState(
                                () => _overTimeCalculationStartsAt = val!),
                          ),
                          if (_overTimeCalculationStartsAt ==
                              OverTimeStartOptions.afterFullDay)
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, left: 24.0),
                              child: _buildLabeledTextField("OTStarts Mins:",
                                  _otStartsMinsController, "490"),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 8),
      ],
    );
  }

  // --- NEW: Method to build Additional Settings ExpansionTile ---
  Widget _buildAdditionalSettingsExpansionTile() {
    return ExpansionTile(
      title: const Text("Additional Settings",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
      initiallyExpanded: false, // Set to true for easier development/testing
      childrenPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
      children: [
        // Over Time Calculations
        _buildRadioWidget<OverTimeCalculationOptions>(
          label: "Over Time Calculations:",
          groupValue: _additionalOverTimeCalcOption,
          isDense: true,
          options: [
            MapEntry("After Every Hour including Grace Minutes",
                OverTimeCalculationOptions.afterHour),
            MapEntry("After Every Half An Hour including Grace Minutes",
                OverTimeCalculationOptions.afterHalfHour),
            MapEntry("None", OverTimeCalculationOptions.none),
          ],
          onChanged: (val) =>
              setState(() => _additionalOverTimeCalcOption = val!),
        ),
        const SizedBox(height: 12),

        // Breaks
        Row(
          children: [
            const Text("Breaks:",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(width: 8), // Spacing between "Breaks:" and checkbox
            Checkbox(
              value: _isEmployeeAllowedToTakeBreak,
              onChanged: (val) =>
                  setState(() => _isEmployeeAllowedToTakeBreak = val!),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
            Expanded(
              child: InkWell(
                onTap: () => setState(() => _isEmployeeAllowedToTakeBreak =
                    !_isEmployeeAllowedToTakeBreak),
                child: const Text("Is Employee Allowed to take break.",
                    style: TextStyle(fontSize: 14)),
              ),
            ),
          ],
        ),
        if (_isEmployeeAllowedToTakeBreak)
          Padding(
            padding: const EdgeInsets.only(
                left: 24.0, top: 8.0), // Indent conditional part
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 4.0),
                  child: Text("Break Minutes:",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                ),
                Row(
                  children: [
                    _buildCheckboxRowItem(
                        "Subtract Lunch Minutes from Fullday Hours work.",
                        _subtractLunchFromFullDay,
                        (val) =>
                            setState(() => _subtractLunchFromFullDay = val!)),
                    const SizedBox(width: 16),
                    _buildCheckboxRowItem(
                        "Subtract Lunch Minutes from Halfday Hours work.",
                        _subtractLunchFromHalfDay,
                        (val) =>
                            setState(() => _subtractLunchFromHalfDay = val!)),
                  ],
                ),
              ],
            ),
          ),
        const SizedBox(height: 12),

        // Weekly Off Calculation
        Row(
          children: [
            Checkbox(
              value: _calculateLateEarlyOnWeeklyOff,
              onChanged: (val) =>
                  setState(() => _calculateLateEarlyOnWeeklyOff = val!),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
            Expanded(
              child: InkWell(
                onTap: () => setState(() => _calculateLateEarlyOnWeeklyOff =
                    !_calculateLateEarlyOnWeeklyOff),
                child: const Text(
                    "Calculate Late Coming Minutes and Early Going Minutes, If Employee present on Weekly Off",
                    style: TextStyle(fontSize: 14)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Force Punch Out
        _buildRadioWidget<ForcePunchOutOptions>(
          label: 'Force Punch Out, if "No-Out" occurs (No out log found) :',
          groupValue: _forcePunchOutOption,
          isDense: true,
          options: [
            MapEntry(
                "Default(Specific Time)", ForcePunchOutOptions.defaultTime),
            MapEntry("By Shift OutTime", ForcePunchOutOptions.byShiftOutTime),
            MapEntry("By Adding Half Day minutes in InTime",
                ForcePunchOutOptions.byAddingHalfDayInTime),
            MapEntry("None", ForcePunchOutOptions.none),
          ],
          onChanged: (val) => setState(() => _forcePunchOutOption = val!),
        ),
        if (_forcePunchOutOption == ForcePunchOutOptions.defaultTime)
          Padding(
            padding: const EdgeInsets.only(left: 24.0, top: 8.0, bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("Default Out Time:* ",
                    style: TextStyle(fontSize: 14)),
                SizedBox(
                  width: 55,
                  child: _buildLabeledTextField(
                      "", _defaultForcePunchOutHHController, "HH",
                      maxLength: 2),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(":",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  width: 55,
                  child: _buildLabeledTextField(
                      "", _defaultForcePunchOutMMController, "MM",
                      maxLength: 2),
                ),
              ],
            ),
          ),
        const SizedBox(height: 12),

        // Late Coming CutOff Label
        Padding(
          padding: const EdgeInsets.only(
              top: 0.0, bottom: 4.0), // Adjusted top padding
          child: Row(
            children: [
              const Text("Late Coming CutOff:",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(width: 4),
              Text("(Implementation pending)",
                  style: TextStyle(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey.shade600)),
            ],
          ),
        ),
        // Is Coming Late Deduction Allowed Checkbox
        Row(
          children: [
            Checkbox(
              value: _isLateComingDeductionAllowed,
              onChanged: (val) =>
                  setState(() => _isLateComingDeductionAllowed = val!),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
            Expanded(
              child: InkWell(
                onTap: () => setState(() => _isLateComingDeductionAllowed =
                    !_isLateComingDeductionAllowed),
                child: const Text("Is Coming Late Deduction Allowed",
                    style: TextStyle(fontSize: 14)),
              ),
            ),
          ],
        ),
        if (_isLateComingDeductionAllowed)
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("If coming late for",
                        style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 50,
                      height: 40,
                      child: _buildLabeledTextField(
                        "",
                        _lateComingForDaysController,
                        "",
                        maxLength: 3, // e.g. -99 to 999
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text("days:", style: TextStyle(fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 12),
                _buildRadioWidget<LateComingActionOptions>(
                  label: "Action Taken:",
                  groupValue: _lateComingAction,
                  isDense: true,
                  options: [
                    MapEntry("Cut Full Day Minutes",
                        LateComingActionOptions.cutFullDay),
                    MapEntry("Mark Absent", LateComingActionOptions.markAbsent),
                    MapEntry("None", LateComingActionOptions.none),
                  ],
                  onChanged: (val) => setState(() => _lateComingAction = val!),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Checkbox(
                      value: _isRepeatLateComingDeductionAllowed,
                      onChanged: (val) => setState(
                          () => _isRepeatLateComingDeductionAllowed = val!),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () => setState(() =>
                            _isRepeatLateComingDeductionAllowed =
                                !_isRepeatLateComingDeductionAllowed),
                        child: const Text(
                            "Is Repeat Late Coming Deduction Allowed (After action taken and condition occurs again.)",
                            style: TextStyle(fontSize: 14)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        const SizedBox(height: 8),
      ],
    );
  }

  // --- NEW: Regular Shift Expansion Tile ---
  Widget _buildRegularShiftExpansionTile() {
    return ExpansionTile(
      title: const Text("Regular Shift",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
      subtitle: const Text(
          "(Applicable only for New Employee at the time of enrollment)",
          style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
      initiallyExpanded: false,
      childrenPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
      children: [
        _buildRadioWidget<ShiftStartDateOptions>(
          label: "Shift Start Date :",
          groupValue: _shiftStartDateOption,
          isDense: true,
          options: [
            MapEntry("Employee's Joining Date",
                ShiftStartDateOptions.employeeJoiningDate),
            MapEntry("Start of the Joining month",
                ShiftStartDateOptions.startOfJoiningMonth),
          ],
          onChanged: (val) => setState(() => _shiftStartDateOption = val!),
        ),
        const SizedBox(height: 12),
        _buildRadioWidget<ShiftTypeOptions>(
          label: "Shift Type :",
          groupValue: _shiftTypeOption,
          isDense: true,
          options: [
            MapEntry("Fix", ShiftTypeOptions.fix),
            MapEntry("Rotation", ShiftTypeOptions.rotation),
            MapEntry("Auto Assign Shift", ShiftTypeOptions.autoAssign),
          ],
          onChanged: (val) => setState(() {
            _shiftTypeOption = val!;
            // Reset other options when type changes
            if (_shiftTypeOption != ShiftTypeOptions.fix)
              _selectedFixShift = null;
            if (_shiftTypeOption != ShiftTypeOptions.rotation)
              _selectedShiftPattern = null;
          }),
        ),
        const SizedBox(height: 12),
        if (_shiftTypeOption == ShiftTypeOptions.fix)
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDropdownField<String>(
                  label:
                      "Shift :*", // Added asterisk for required field indication
                  value: _selectedFixShift,
                  items: _shiftsList
                      .map((shift) =>
                          DropdownMenuItem(value: shift, child: Text(shift)))
                      .toList(),
                  onChanged: (val) => setState(() => _selectedFixShift = val),
                  hintText: "Select Shift",
                ),
                const SizedBox(height: 12),
                _buildLabeledTextField(
                    "Shift Constant Days :", _shiftConstantDaysController, "",
                    isNumeric: true, maxLength: 3),
              ],
            ),
          ),
        if (_shiftTypeOption == ShiftTypeOptions.rotation)
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: _buildDropdownField<String>(
              label: "Shift Pattern :*", // Added asterisk
              value: _selectedShiftPattern,
              items: _shiftPatternsList
                  .map((pattern) =>
                      DropdownMenuItem(value: pattern, child: Text(pattern)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedShiftPattern = val),
              hintText: "Select Shift Pattern",
            ),
          ),
        const SizedBox(height: 8),
      ],
    );
  }

  // --- NEW: WeeklyOff Details Expansion Tile ---
  Widget _buildWeeklyOffDetailsExpansionTile() {
    return ExpansionTile(
      title: const Text("WeeklyOff Details",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
      subtitle: const Text(
          "(Applicable only for New Employee at the time of enrollment)",
          style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
      initiallyExpanded: false,
      childrenPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
      children: [
        _buildRadioWidget<WeeklyOffTypeOptions>(
          label: "WeeklyOff Type :",
          groupValue: _weeklyOffTypeOption,
          isDense: true,
          options: [
            MapEntry("Regular", WeeklyOffTypeOptions.regular),
            MapEntry("Rotating", WeeklyOffTypeOptions.rotating),
          ],
          onChanged: (val) => setState(() {
            _weeklyOffTypeOption = val!;
            // Reset if not regular
            if (_weeklyOffTypeOption != WeeklyOffTypeOptions.regular) {
              _selectedFirstWeeklyOff =
                  "Sunday"; // Or null, depending on desired reset state
              _selectedSecondWeeklyOff = "None";
              _selectedFullDayHalfDay = "FullDay";
            }
          }),
        ),
        const SizedBox(height: 12),
        if (_weeklyOffTypeOption == WeeklyOffTypeOptions.regular)
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Column(
              children: [
                _buildDropdownField<String>(
                  label: "First Weekly OFF :",
                  value: _selectedFirstWeeklyOff,
                  items: _daysOfWeek
                      .map((day) =>
                          DropdownMenuItem(value: day, child: Text(day)))
                      .toList(),
                  onChanged: (val) =>
                      setState(() => _selectedFirstWeeklyOff = val),
                ),
                const SizedBox(height: 12),
                _buildDropdownField<String>(
                  label: "Secondly Weekly OFF :",
                  value: _selectedSecondWeeklyOff,
                  items: _daysOfWeekWithNone
                      .map((day) =>
                          DropdownMenuItem(value: day, child: Text(day)))
                      .toList(),
                  onChanged: (val) =>
                      setState(() => _selectedSecondWeeklyOff = val),
                ),
                const SizedBox(height: 12),
                _buildDropdownField<String>(
                  label: "Full Day/Half Day :",
                  value: _selectedFullDayHalfDay,
                  items: _dayTypes
                      .map((type) =>
                          DropdownMenuItem(value: type, child: Text(type)))
                      .toList(),
                  onChanged: (val) =>
                      setState(() => _selectedFullDayHalfDay = val),
                ),
              ],
            ),
          ),
        const SizedBox(height: 8),
      ],
    );
  }

  // --- NEW: Employee Login Details Expansion Tile ---
  Widget _buildEmployeeLoginDetailsExpansionTile() {
    return ExpansionTile(
      title: const Text("Employee Login Details",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
      subtitle: const Text(
          "(Applicable only for New Employee at the time of enrollment)",
          style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
      initiallyExpanded: false,
      childrenPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
      children: [
        Row(
          children: [
            Checkbox(
              value: _canUseNonBiometricDevice,
              onChanged: (val) =>
                  setState(() => _canUseNonBiometricDevice = val!),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
            ),
            Expanded(
              child: InkWell(
                onTap: () => setState(() =>
                    _canUseNonBiometricDevice = !_canUseNonBiometricDevice),
                child: const Text(
                    "Employee can use non-biometric device(e.g. mobile/web).",
                    style: TextStyle(fontSize: 14)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Set Rights:*",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildCheckboxRowItem("View Rights", _viewRights,
                      (val) => setState(() => _viewRights = val!)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  _buildCheckboxRowItem(
                      "Can Apply for Regularization",
                      _canApplyForManualAttendance,
                      (val) =>
                          setState(() => _canApplyForManualAttendance = val!)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  _buildCheckboxRowItem(
                      "Can Apply for Leave.",
                      _canApplyForLeave,
                      (val) => setState(() => _canApplyForLeave = val!)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  _buildCheckboxRowItem(
                      "Can Apply for Out Door Duty for a day",
                      _canApplyForOutDoorDuty,
                      (val) => setState(() => _canApplyForOutDoorDuty = val!)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  _buildCheckboxRowItem(
                      "Can Apply for Tour/Travelling",
                      _canApplyForTour,
                      (val) => setState(() => _canApplyForTour = val!)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.profile != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Setting Profile' : 'Add Setting Profile',
            style: const TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 1, // Slight elevation for definition
        shadowColor: Colors.grey.shade200,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          HelpTooltipButton(
            tooltipMessage:
                'Configure employee settings including profile name, description, default status, weekly off adjustments, and shift start settings.',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _profileNameController,
                decoration: const InputDecoration(
                  labelText: 'Profile Name*',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a profile name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description*',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text(
                    'Set as Default Profile (Applicable only for New Employee at the time of enrollment)',
                    style: TextStyle(fontSize: 14)),
                value: _isDefaultProfile,
                onChanged: (bool? value) {
                  setState(() {
                    _isDefaultProfile = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
              const SizedBox(height: 16), // Space before new sections

              // --- New Accordion Sections ---
              _buildWorkSettingsExpansionTile(),
              const SizedBox(height: 16),
              _buildWorkMinutesExpansionTile(),
              // --- End of New Accordion Sections ---
              const SizedBox(height: 16), // --- NEW ---
              _buildAdditionalSettingsExpansionTile(), // --- NEW ---
              const SizedBox(height: 16), // --- NEW ---
              _buildRegularShiftExpansionTile(), // --- NEW ---
              const SizedBox(height: 16), // --- NEW ---
              _buildWeeklyOffDetailsExpansionTile(), // --- NEW ---
              const SizedBox(height: 16), // --- NEW ---
              _buildEmployeeLoginDetailsExpansionTile(), // --- NEW ---
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  if (isEditing) ...[
                    const SizedBox(width: 16),
                    OutlinedButton(
                      onPressed: () {
                        // Save as logic: treat as new profile (clear id, etc.)
                        final controller = Get.find<SettingProfileController>();
                        final now = DateTime.now();
                        final profile = SettingProfileModel(
                          profileId: '', // New profile, so no id
                          profileName: _profileNameController.text,
                          description: _descriptionController.text,
                          isDefaultProfile: _isDefaultProfile,
                          isEmpWeeklyOffAdjustable: false,
                          isShiftStartFromJoiningDate: true,
                          changesDoneOn: now.toIso8601String(),
                          changesDoneOnDateTime: now,
                          changesDoneBy: controller.currentLoginId,
                          // TODO: Add new fields as needed
                        );
                        controller.createSettingProfile(profile);
                        Navigator.pop(context);
                      },
                      child: const Text('Save as'),
                    ),
                  ],
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _saveProfile,
                    child: Text(isEditing ? 'Save Changes' : 'Create Profile'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // TODO: Add validation for new fields if necessary
      // For example, HH/MM fields for Out Time should be valid time.

      final controller = Get.find<SettingProfileController>();
      final now = DateTime.now();
      final profile = SettingProfileModel(
        profileId: widget.profile?.profileId ?? '',
        profileName: _profileNameController.text,
        description: _descriptionController.text,
        isDefaultProfile: _isDefaultProfile,
        isEmpWeeklyOffAdjustable: false, // Default value from original code
        isShiftStartFromJoiningDate: true, // Default value from original code
        changesDoneOn: now.toIso8601String(),
        changesDoneOnDateTime: now,
        changesDoneBy: Get.find<SettingProfileController>().currentLoginId,
        // TODO: Add new fields from the UI to the SettingProfileModel and pass them here
        // e.g., presentOnWeeklyOffHoliday: _presentOnWeeklyOffHoliday.toString(),
        // absentDaysForWeeklyOff: int.tryParse(_absentDaysForWeeklyOffController.text) ?? 0,
        // punchType: _punchType.toString(),
        // ... and so on for all new fields
      );

      if (widget.profile != null) {
        controller.updateSettingProfile(profile);
      } else {
        controller.createSettingProfile(profile);
      }

      Navigator.pop(context);
    }
  }
}
