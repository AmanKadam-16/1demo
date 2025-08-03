import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:time_attendance/controller/Data_entry_tab_controller/manaulAttendance_controller.dart';
import 'package:time_attendance/model/Data_entry_tab_model/manualAttendance_model.dart';
import 'package:time_attendance/model/sfift_tab_model/shift_details_model.dart';
import 'package:time_attendance/widget/reusable/button/form_button.dart';

class ManualAttendanceDialog extends StatefulWidget {
  final String employeeId;
  final DateTime shiftDateTime;
  ManualAttendanceModel? manualAttendance;
  final List<SiftDetailsModel>? shiftDetailsList;
  final ManualAttendanceController? manualAttController;
  ManualAttendanceDialog({
    super.key,
    required this.employeeId,
    required this.shiftDateTime,
    this.manualAttendance,
    required this.shiftDetailsList,
    required this.manualAttController,
  });

  @override
  State<ManualAttendanceDialog> createState() => _ManualAttendanceDialogState();
}

class _ManualAttendanceDialogState extends State<ManualAttendanceDialog> {
  final _formKey = GlobalKey<FormState>();
  bool _isByShift = true;
  String _selectedShift = '';
  String _attendanceType = 'half';
  String _halfDayType = 'first';
  String _status = 'rejected';
  bool _showLogs = false;
  DateTime? _selectedDate = DateTime.now();
  bool _shiftEndsNextDay = false;

  final TextEditingController _inTimeHrsController = TextEditingController();
  final TextEditingController _inTimeMinsController = TextEditingController();
  final TextEditingController _outTimeHrsController = TextEditingController();
  final TextEditingController _outTimeMinsController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _rejectedReasonController =
      TextEditingController();

  @override
  void dispose() {
    _inTimeHrsController.dispose();
    _inTimeMinsController.dispose();
    _outTimeHrsController.dispose();
    _outTimeMinsController.dispose();
    _reasonController.dispose();
    _rejectedReasonController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Initialize selected shift from the shift list
    if (widget.shiftDetailsList != null &&
        widget.shiftDetailsList!.isNotEmpty) {
      // Try to find the default shift first
      var defaultShift = widget.shiftDetailsList!.firstWhere(
        (shift) => shift.isDefaultShift == true,
        orElse: () => widget.shiftDetailsList!.first,
      );
      _selectedShift = defaultShift.shiftID ?? '';
    }

    _populateForm(widget.manualAttendance!);
  }

  void _populateForm(ManualAttendanceModel? attendance) {
    setState(() {
      if (attendance == null) {
        // Reset to default values
        _isByShift = true;
        _attendanceType = 'half';
        _halfDayType = 'first';
        _status = 'rejected';
        _shiftEndsNextDay = false;

        // Clear all text controllers
        _inTimeHrsController.clear();
        _inTimeMinsController.clear();
        _outTimeHrsController.clear();
        _outTimeMinsController.clear();
        _reasonController.clear();
        _rejectedReasonController.clear();
        widget.manualAttendance = null; // Reset Regularization
        return;
      }
      print('Populating form with attendance data: ${attendance.toJson()}');
      print('attendance reason: ${attendance.reason}');
      // Populate with attendance data
      _isByShift = attendance.type == ManualType.byShift;
      _selectedShift =
          attendance.shiftId.isNotEmpty ? attendance.shiftId : _selectedShift;
      _attendanceType =
          attendance.attendanceStatus == AttendanceStatus.presentFullDay
              ? 'full'
              : attendance.attendanceStatus == AttendanceStatus.presentHalfDay
                  ? 'half'
                  : 'absent';
      _halfDayType = attendance.attendanceFirstSession ? 'first' : 'second';
      _status = attendance.status == ManualStatus.approved
          ? 'approved'
          : attendance.status == ManualStatus.rejected
              ? 'rejected'
              : 'pending';
      _shiftEndsNextDay = attendance.isWorkEndsNextDay;
      // Reason
      _reasonController.text = attendance.reason;
      _rejectedReasonController.text = attendance.rejectionReason;
      _selectedDate = attendance.shiftDateTime;

      // Populate time controllers
      _inTimeHrsController.text =
          attendance.inDateTime.hour.toString().padLeft(2, '0');
      _inTimeMinsController.text =
          attendance.inDateTime.minute.toString().padLeft(2, '0');
      _outTimeHrsController.text =
          attendance.outDateTime.hour.toString().padLeft(2, '0');
      _outTimeMinsController.text =
          attendance.outDateTime.minute.toString().padLeft(2, '0');
    });
  }

  String _getSelectedShiftInTime() {
    if (widget.shiftDetailsList == null) return '';
    final selectedShift = widget.shiftDetailsList!.firstWhere(
      (shift) => shift.shiftID == _selectedShift,
      orElse: () => SiftDetailsModel(),
    );
    return selectedShift.inTime ?? '';
  }

  String _getSelectedShiftOutTime() {
    if (widget.shiftDetailsList == null) return '';
    final selectedShift = widget.shiftDetailsList!.firstWhere(
      (shift) => shift.shiftID == _selectedShift,
      orElse: () => SiftDetailsModel(),
    );
    return selectedShift.outTime ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
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
                const Text(
                  'Add/Update Regularization',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Attendance Date *',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        readOnly: true,
                        controller: TextEditingController(
                          text: _selectedDate != null
                              ? DateFormat('dd-MMM-yyyy').format(_selectedDate!)
                              : '',
                        ),
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null && picked != _selectedDate) {
                            setState(() {
                              _selectedDate = picked;
                            });
                            // Call getAttendanceRegularization with the selected date
                            final ManualAttendanceModel? attendanceDetails =
                                await widget.manualAttController
                                    ?.getAttendanceRegularization(
                              widget.employeeId,
                              picked,
                            );
                            if (attendanceDetails != null) {
                              _populateForm(attendanceDetails);
                            } else {
                              // Reset form if no attendance found
                              _populateForm(null);
                            }
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _showLogs = !_showLogs;
                        });
                      },
                      child: Text(
                          _showLogs ? 'Hide Logs' : 'Show Logs (if exists)'),
                    ),
                  ],
                ),
                if (_showLogs) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        const Text('Attendance Logs',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        // Add your logs table here using DataTable or ListView
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                Row(
                  children: [
                    Radio(
                      value: true,
                      groupValue: _isByShift,
                      onChanged: (value) {
                        setState(() {
                          _isByShift = value as bool;
                        });
                      },
                    ),
                    const Text('By Shift'),
                    const SizedBox(width: 16),
                    Radio(
                      value: false,
                      groupValue: _isByShift,
                      onChanged: (value) {
                        setState(() {
                          _isByShift = value as bool;
                        });
                      },
                    ),
                    const Text('By Timings'),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedShift,
                  decoration: InputDecoration(
                    labelText: 'Shift *',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  items: widget.shiftDetailsList
                          ?.map((shift) => DropdownMenuItem<String>(
                                value: shift.shiftID,
                                child: Text(shift.shiftName ?? ''),
                              ))
                          .toList() ??
                      [],
                  onChanged: (value) {
                    setState(() {
                      _selectedShift = value!;
                      // Update in/out time info based on selected shift
                      final selectedShift = widget.shiftDetailsList?.firstWhere(
                        (shift) => shift.shiftID == value,
                        orElse: () => SiftDetailsModel(),
                      );
                      if (selectedShift != null) {
                        // Update the In-Time -- Out-Time text with the shift details
                        _shiftEndsNextDay =
                            selectedShift.isShiftEndNextDay ?? false;
                      }
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a shift';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                if (_selectedShift.isNotEmpty) ...[
                  Text(
                    'In-Time:${_getSelectedShiftInTime()} -- Out-Time:${_getSelectedShiftOutTime()}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
                if (!_isByShift) ...[
                  const SizedBox(height: 16),
                  const Text('Enter Timings [in 24 Hour Format]:',
                      style: TextStyle(decoration: TextDecoration.underline)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('In Time:* ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(
                        width: 50,
                        child: TextFormField(
                          controller: _inTimeHrsController,
                          maxLength: 2,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            counterText: '',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const Text(' : '),
                      SizedBox(
                        width: 50,
                        child: TextFormField(
                          controller: _inTimeMinsController,
                          maxLength: 2,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            counterText: '',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text('Out Time:* ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(
                        width: 50,
                        child: TextFormField(
                          controller: _outTimeHrsController,
                          maxLength: 2,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            counterText: '',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const Text(' : '),
                      SizedBox(
                        width: 50,
                        child: TextFormField(
                          controller: _outTimeMinsController,
                          maxLength: 2,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            counterText: '',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: _shiftEndsNextDay,
                        onChanged: (bool? value) {
                          setState(() {
                            _shiftEndsNextDay = value!;
                          });
                        },
                      ),
                      const Text('Work Continues till Next Day',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                const Text('Mark Attendance as *'),
                Row(
                  children: [
                    Radio(
                      value: 'full',
                      groupValue: _attendanceType,
                      onChanged: (value) {
                        setState(() {
                          _attendanceType = value.toString();
                        });
                      },
                    ),
                    const Text('FullDay Present'),
                    Radio(
                      value: 'half',
                      groupValue: _attendanceType,
                      onChanged: (value) {
                        setState(() {
                          _attendanceType = value.toString();
                        });
                      },
                    ),
                    const Text('HalfDay Present'),
                    Radio(
                      value: 'absent',
                      groupValue: _attendanceType,
                      onChanged: (value) {
                        setState(() {
                          _attendanceType = value.toString();
                        });
                      },
                    ),
                    const Text('Absent'),
                  ],
                ),
                if (_attendanceType == 'half')
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: 'first',
                        groupValue: _halfDayType,
                        onChanged: (value) {
                          setState(() {
                            _halfDayType = value.toString();
                          });
                        },
                      ),
                      const Text('First Half'),
                      const SizedBox(width: 16),
                      Radio(
                        value: 'second',
                        groupValue: _halfDayType,
                        onChanged: (value) {
                          setState(() {
                            _halfDayType = value.toString();
                          });
                        },
                      ),
                      const Text('Second Half'),
                    ],
                  ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _reasonController,
                  decoration: InputDecoration(
                    labelText: 'Reason *',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    hintText: 'Enter reason',
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter reason';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text('Status:'),
                Row(
                  children: [
                    Radio(
                      value: 'approved',
                      groupValue: _status,
                      onChanged: (value) {
                        setState(() {
                          _status = value.toString();
                        });
                      },
                    ),
                    const Text('Approved'),
                    const SizedBox(width: 16),
                    Radio(
                      value: 'rejected',
                      groupValue: _status,
                      onChanged: (value) {
                        setState(() {
                          _status = value.toString();
                        });
                      },
                    ),
                    const Text('Rejected'),
                  ],
                ),
                if (_status == 'rejected')
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: TextFormField(
                      controller: _rejectedReasonController,
                      decoration: InputDecoration(
                        labelText: 'Rejected Reason *',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                        hintText: 'Enter rejection reason',
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (_status == 'rejected' &&
                            (value == null || value.trim().isEmpty)) {
                          return 'Please enter rejection reason';
                        }
                        return null;
                      },
                    ),
                  ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(width: 16),
                    CustomButtons(
                      onSavePressed: () => {},
                      onCancelPressed: () => Navigator.of(context).pop(),
                      saveButtonText:
                          widget.manualAttendance == null ? 'Save' : 'Update',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
