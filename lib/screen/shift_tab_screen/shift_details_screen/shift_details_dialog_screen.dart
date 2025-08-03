// lib/screen/shift_tab_screen/shift_details_screen/shift_details_dialog_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/shift_tab_controller/shift_details_controller.dart';
import 'package:time_attendance/model/sfift_tab_model/shift_details_model.dart';
import 'package:time_attendance/widget/reusable/button/form_button.dart'; // Assuming CustomButtons is here
import 'package:time_attendance/widget/reusable/cheakbox/reusable_checkbox.dart'; // Assuming CustomCheckbox is here
// pseudo-code for CustomCheckbox
// lib/widget/reusable/cheakbox/reusable_checkbox.dart
class CustomCheckbox extends StatelessWidget {
  final String label;
  final bool value; // Current value
  final ValueChanged<bool?>? onChanged; // Callback

  const CustomCheckbox({
    Key? key,
    required this.label,
    required this.value,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
        Flexible(child: Text(label)), // Flexible to prevent overflow
      ],
    );
  }
}
class ShiftConfigurationScreen extends StatefulWidget {
  final ShiftDetailsController controller;
  final SiftDetailsModel shiftdetails;

  const ShiftConfigurationScreen({
    super.key,
    required this.controller,
    required this.shiftdetails,
  });

  @override
  State<ShiftConfigurationScreen> createState() =>
      _ShiftConfigurationScreenState();
}

class _ShiftConfigurationScreenState extends State<ShiftConfigurationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  late TextEditingController _shiftNameController;
  late TextEditingController _inTimeHrController;
  late TextEditingController _inTimeMinController;
  late TextEditingController _outTimeHrController;
  late TextEditingController _outTimeMinController;
  late TextEditingController _fullDayMinutesController;
  late TextEditingController _halfDayMinutesController;
  late TextEditingController _oTGraceMinutesController;
  late TextEditingController _oTStartsMinutesController; // Renamed for clarity
  late TextEditingController _lunchMinsController;
  late TextEditingController _otherBreakMinsController;
  late TextEditingController _lunchInTimeHrController;
  late TextEditingController _lunchInTimeMinController;
  late TextEditingController _lunchOutTimeHrController;
  late TextEditingController _lunchOutTimeMinController;
  late TextEditingController _autoShiftInTimeStartHrController;
  late TextEditingController _autoShiftInTimeStartMinController;
  late TextEditingController _autoShiftInTimeEndHrController;
  late TextEditingController _autoShiftInTimeEndMinController;
  late TextEditingController _autoShiftLapseTimeController;

  // Observable states
  final RxBool isDefaultShift = false.obs;
  final RxBool isShiftEndNextDay = false.obs;
  final RxBool isShiftStartsPreviousDay = false.obs;
  final RxBool isOTAllowed = false.obs;
  final RxString overtimeCalculationType = 'At ShiftEnd'.obs; // "At ShiftEnd" or "After Fullday Work"
  final RxBool enterLunchTime = false.obs;
  final RxBool isShiftConsideredForAutoAssign = false.obs;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _initializeStates();
  }

  void _initializeControllers() {
    _shiftNameController = TextEditingController(text: widget.shiftdetails.shiftName);

    List<String> inTimeParts = (widget.shiftdetails.inTime ?? "00:00").split(':');
    _inTimeHrController = TextEditingController(text: inTimeParts.isNotEmpty ? inTimeParts[0] : '00');
    _inTimeMinController = TextEditingController(text: inTimeParts.length > 1 ? inTimeParts[1] : '00');

    List<String> outTimeParts = (widget.shiftdetails.outTime ?? "00:00").split(':');
    _outTimeHrController = TextEditingController(text: outTimeParts.isNotEmpty ? outTimeParts[0] : '00');
    _outTimeMinController = TextEditingController(text: outTimeParts.length > 1 ? outTimeParts[1] : '00');

    _fullDayMinutesController = TextEditingController(text: widget.shiftdetails.fullDayMinutes?.toString() ?? '0');
    _halfDayMinutesController = TextEditingController(text: widget.shiftdetails.halfDayMinutes?.toString() ?? '0');
    _oTGraceMinutesController = TextEditingController(text: widget.shiftdetails.oTGraceMinutes?.toString() ?? '0');
    _oTStartsMinutesController = TextEditingController(text: widget.shiftdetails.oTStartMinutes?.toString() ?? '0');
    _lunchMinsController = TextEditingController(text: widget.shiftdetails.lunchMins?.toString() ?? '0');
    _otherBreakMinsController = TextEditingController(text: widget.shiftdetails.otherBreakMins?.toString() ?? '0');
    
    List<String> lunchInTimeParts = (widget.shiftdetails.lunchInTime ?? "00:00").split(':');
    _lunchInTimeHrController = TextEditingController(text: lunchInTimeParts.isNotEmpty ? lunchInTimeParts[0] : '00');
    _lunchInTimeMinController = TextEditingController(text: lunchInTimeParts.length > 1 ? lunchInTimeParts[1] : '00');

    List<String> lunchOutTimeParts = (widget.shiftdetails.lunchOutTime ?? "00:00").split(':');
    _lunchOutTimeHrController = TextEditingController(text: lunchOutTimeParts.isNotEmpty ? lunchOutTimeParts[0] : '00');
    _lunchOutTimeMinController = TextEditingController(text: lunchOutTimeParts.length > 1 ? lunchOutTimeParts[1] : '00');
    
    List<String> autoShiftStartParts = (widget.shiftdetails.autoShiftInTimeStart ?? "00:00").split(':');
    _autoShiftInTimeStartHrController = TextEditingController(text: autoShiftStartParts.isNotEmpty ? autoShiftStartParts[0] : '00');
    _autoShiftInTimeStartMinController = TextEditingController(text: autoShiftStartParts.length > 1 ? autoShiftStartParts[1] : '00');

    List<String> autoShiftEndParts = (widget.shiftdetails.autoShiftInTimeEnd ?? "00:00").split(':');
    _autoShiftInTimeEndHrController = TextEditingController(text: autoShiftEndParts.isNotEmpty ? autoShiftEndParts[0] : '00');
    _autoShiftInTimeEndMinController = TextEditingController(text: autoShiftEndParts.length > 1 ? autoShiftEndParts[1] : '00');

    _autoShiftLapseTimeController = TextEditingController(text: widget.shiftdetails.autoShiftLapseTime?.toString() ?? '0');
  }

  void _initializeStates() {
    isDefaultShift.value = widget.shiftdetails.isDefaultShift ?? false;
    isShiftEndNextDay.value = widget.shiftdetails.isShiftEndNextDay ?? false;
    isShiftStartsPreviousDay.value = widget.shiftdetails.isShiftStartsPreviousDay ?? false;
    isOTAllowed.value = widget.shiftdetails.isOTAllowed ?? false;
    overtimeCalculationType.value = (widget.shiftdetails.isOTStartsAtShiftEnd ?? true) ? 'At ShiftEnd' : 'After Fullday Work';
    
    // Determine initial state of enterLunchTime
    // If LunchInTime or LunchOutTime has a value, assume checkbox should be checked
    enterLunchTime.value = (widget.shiftdetails.lunchInTime != null && widget.shiftdetails.lunchInTime!.isNotEmpty) ||
                           (widget.shiftdetails.lunchOutTime != null && widget.shiftdetails.lunchOutTime!.isNotEmpty);

    isShiftConsideredForAutoAssign.value = widget.shiftdetails.isShiftAutoAssigned ?? false;
  }

  String? _validateNotEmpty(String? value, String fieldName) {
    if (value == null || value.isEmpty) return 'Please enter $fieldName';
    return null;
  }

  String? _validateNumber(String? value, String fieldName, {bool allowEmpty = false}) {
    if (value == null || value.isEmpty) {
      return allowEmpty ? null : 'Please enter $fieldName';
    }
    if (int.tryParse(value) == null) return 'Enter a valid number for $fieldName';
    return null;
  }

  String? _validateTimePart(String? value, String fieldName, int max) {
    if (value == null || value.isEmpty) return '$fieldName required';
    final num = int.tryParse(value);
    if (num == null) return 'Invalid $fieldName';
    if (num < 0 || num > max) return '$fieldName out of range (0-$max)';
    return null;
  }

  String _formatTime(TextEditingController hrController, TextEditingController minController) {
    String hr = hrController.text.padLeft(2, '0');
    String min = minController.text.padLeft(2, '0');
    return '$hr:$min';
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final updatedShift = SiftDetailsModel(
          shiftID: widget.shiftdetails.shiftID,
          shiftName: _shiftNameController.text,
          inTime: _formatTime(_inTimeHrController, _inTimeMinController),
          outTime: _formatTime(_outTimeHrController, _outTimeMinController),
          isShiftEndNextDay: isShiftEndNextDay.value,
          isShiftStartsPreviousDay: isShiftStartsPreviousDay.value,
          fullDayMinutes: int.tryParse(_fullDayMinutesController.text) ?? 0,
          halfDayMinutes: int.tryParse(_halfDayMinutesController.text) ?? 0,
          isOTAllowed: isOTAllowed.value,
          oTGraceMinutes: int.tryParse(_oTGraceMinutesController.text) ?? 0,
          isOTStartsAtShiftEnd: overtimeCalculationType.value == 'At ShiftEnd',
          oTStartMinutes: overtimeCalculationType.value == 'After Fullday Work'
              ? (int.tryParse(_oTStartsMinutesController.text) ?? 0)
              : 0,
          lunchMins: int.tryParse(_lunchMinsController.text) ?? 0,
          otherBreakMins: int.tryParse(_otherBreakMinsController.text) ?? 0,
          lunchInTime: enterLunchTime.value ? _formatTime(_lunchInTimeHrController, _lunchInTimeMinController) : '',
          lunchOutTime: enterLunchTime.value ? _formatTime(_lunchOutTimeHrController, _lunchOutTimeMinController) : '',
          isShiftAutoAssigned: isShiftConsideredForAutoAssign.value,
          autoShiftInTimeStart: isShiftConsideredForAutoAssign.value ? _formatTime(_autoShiftInTimeStartHrController, _autoShiftInTimeStartMinController) : '',
          autoShiftInTimeEnd: isShiftConsideredForAutoAssign.value ? _formatTime(_autoShiftInTimeEndHrController, _autoShiftInTimeEndMinController) : '',
          autoShiftLapseTime: isShiftConsideredForAutoAssign.value ? (int.tryParse(_autoShiftLapseTimeController.text) ?? 0) : 0,
          isDefaultShift: isDefaultShift.value,
        );

        widget.controller.saveShift(updatedShift).then((success) {
          if (success) {
            Navigator.of(context).pop();
          }
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving shift: ${e.toString()}')),
        );
      }
    }
  }

  @override
  void dispose() {
    _shiftNameController.dispose();
    _inTimeHrController.dispose();
    _inTimeMinController.dispose();
    _outTimeHrController.dispose();
    _outTimeMinController.dispose();
    _fullDayMinutesController.dispose();
    _halfDayMinutesController.dispose();
    _oTGraceMinutesController.dispose();
    _oTStartsMinutesController.dispose();
    _lunchMinsController.dispose();
    _otherBreakMinsController.dispose();
    _lunchInTimeHrController.dispose();
    _lunchInTimeMinController.dispose();
    _lunchOutTimeHrController.dispose();
    _lunchOutTimeMinController.dispose();
    _autoShiftInTimeStartHrController.dispose();
    _autoShiftInTimeStartMinController.dispose();
    _autoShiftInTimeEndHrController.dispose();
    _autoShiftInTimeEndMinController.dispose();
    _autoShiftLapseTimeController.dispose();
    super.dispose();
  }

  Widget _buildTimeInput(
      TextEditingController hrController,
      TextEditingController minController,
      String labelPrefix) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: hrController,
            decoration: InputDecoration(
              labelText: '$labelPrefix Hr',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              counterText: "", // Hides the counter
            ),
            keyboardType: TextInputType.number,
            maxLength: 2,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) => _validateTimePart(value, 'Hour', 23),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(':', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: TextFormField(
            controller: minController,
            decoration: InputDecoration(
              labelText: 'Min',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
               counterText: "", // Hides the counter
            ),
            keyboardType: TextInputType.number,
            maxLength: 2,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) => _validateTimePart(value, 'Minute', 59),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double dialogWidth = MediaQuery.of(context).size.width < 767
        ? MediaQuery.of(context).size.width * 0.9
        : MediaQuery.of(context).size.width * 0.6; // Adjusted width
    double dialogHeight = MediaQuery.of(context).size.height * 0.85; // Increased height

    return Container(
      child: SizedBox(
        width: dialogWidth,
        height: dialogHeight,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      (widget.shiftdetails.shiftID == null || widget.shiftdetails.shiftID!.isEmpty || widget.shiftdetails.shiftID == "0")
                          ? 'Add Shift'
                          : 'Edit Shift',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.black87),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() => CustomCheckbox(
                              label: 'Set This Shift As Default Shift',
                              value: isDefaultShift.value,
                              onChanged: (val) => isDefaultShift.value = val ?? false,
                            )),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _shiftNameController,
                          decoration: InputDecoration(
                            labelText: 'Shift Name *',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          validator: (value) => _validateNotEmpty(value, 'Shift name'),
                        ),
                        const SizedBox(height: 16),
                        const Text('Shift Timings [in 24 Hour Format]:', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(child: _buildTimeInput(_inTimeHrController, _inTimeMinController, 'In Time *')),
                            const SizedBox(width: 16),
                            Expanded(child: _buildTimeInput(_outTimeHrController, _outTimeMinController, 'Out Time *')),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: Obx(() => CustomCheckbox(
                                    label: 'Shift Continues till Next Day',
                                    value: isShiftEndNextDay.value,
                                    onChanged: (val) => isShiftEndNextDay.value = val ?? false,
                                  )),
                            ),
                            const SizedBox(width: 16),
                             Expanded(
                              child: Obx(() => CustomCheckbox(
                                    label: 'Shift Starts On Previous Day',
                                    value: isShiftStartsPreviousDay.value,
                                    onChanged: (val) => isShiftStartsPreviousDay.value = val ?? false,
                                  )),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text('Work Details:', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _fullDayMinutesController,
                                decoration: InputDecoration(
                                  labelText: 'Full Day Mins *',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                validator: (value) => _validateNumber(value, 'Full Day Mins'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _halfDayMinutesController,
                                decoration: InputDecoration(
                                  labelText: 'Half Day Mins *',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                validator: (value) => _validateNumber(value, 'Half Day Mins'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Obx(() => CustomCheckbox(
                              label: 'Is OverTime Allowed to do in this Shift',
                              value: isOTAllowed.value,
                              onChanged: (val) => isOTAllowed.value = val ?? false,
                            )),
                        Obx(() {
                          if (!isOTAllowed.value) return const SizedBox.shrink();
                          return Padding(
                            padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    controller: _oTGraceMinutesController,
                                    decoration: InputDecoration(
                                      labelText: 'OT Grace Mins',
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                    validator: (value) => _validateNumber(value, 'OT Grace Mins', allowEmpty: true),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text('Overtime Minutes Calculation Starts:'),
                                  RadioListTile<String>(
                                    title: const Text('At ShiftEnd'),
                                    value: 'At ShiftEnd',
                                    groupValue: overtimeCalculationType.value,
                                    onChanged: (val) => overtimeCalculationType.value = val!,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  RadioListTile<String>(
                                    title: const Text('After Fullday Work'),
                                    value: 'After Fullday Work',
                                    groupValue: overtimeCalculationType.value,
                                    onChanged: (val) => overtimeCalculationType.value = val!,
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  Obx(() {
                                    if (overtimeCalculationType.value != 'After Fullday Work') {
                                      return const SizedBox.shrink();
                                    }
                                    return TextFormField(
                                      controller: _oTStartsMinutesController,
                                      decoration: InputDecoration(
                                        labelText: 'OTStarts Mins',
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                      validator: (value) => _validateNumber(value, 'OTStarts Mins', allowEmpty: false),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: 16),
                        const Text('Break Details:', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _lunchMinsController,
                                decoration: InputDecoration(
                                  labelText: 'Lunch Break Mins',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                validator: (value) => _validateNumber(value, 'Lunch Break Mins', allowEmpty: true),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _otherBreakMinsController,
                                decoration: InputDecoration(
                                  labelText: 'Other Break Mins',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                validator: (value) => _validateNumber(value, 'Other Break Mins', allowEmpty: true),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Obx(() => CustomCheckbox(
                              label: 'Enter Lunch Time',
                              value: enterLunchTime.value,
                              onChanged: (val) => enterLunchTime.value = val ?? false,
                            )),
                        Obx(() {
                          if (!enterLunchTime.value) return const SizedBox.shrink();
                          return Padding(
                             padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                             child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                children: [
                                  Expanded(child: _buildTimeInput(_lunchInTimeHrController, _lunchInTimeMinController, 'Lunch InTime')),
                                  const SizedBox(width: 16),
                                  Expanded(child: _buildTimeInput(_lunchOutTimeHrController, _lunchOutTimeMinController, 'Lunch OutTime')),
                                ],
                              ),
                             ),
                          );
                        }),
                        const SizedBox(height: 16),
                        Obx(() => CustomCheckbox(
                              label: 'Is Shift Considered in Auto Shift Assigned Calculation.',
                              value: isShiftConsideredForAutoAssign.value,
                              onChanged: (val) => isShiftConsideredForAutoAssign.value = val ?? false,
                            )),
                        Obx(() {
                          if (!isShiftConsideredForAutoAssign.value) return const SizedBox.shrink();
                          return Padding(
                            padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(child: _buildTimeInput(_autoShiftInTimeStartHrController, _autoShiftInTimeStartMinController, 'Shift In-Time (Starts)')),
                                      const SizedBox(width: 16),
                                      Expanded(child: _buildTimeInput(_autoShiftInTimeEndHrController, _autoShiftInTimeEndMinController, 'Shift In-Time (Ends)')),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _autoShiftLapseTimeController,
                                    decoration: InputDecoration(
                                      labelText: 'Auto Shift Lapse Time in mins(Supposed to be end)',
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                    validator: (value) => _validateNumber(value, 'Auto Shift Lapse Time', allowEmpty: false),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: 24),
                        CustomButtons(
                          onSavePressed: _handleSave,
                          onCancelPressed: () => Navigator.of(context).pop(),
                        ),
                        const SizedBox(height: 16), // For bottom padding
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}