// Update this Form 

import 'package:flutter/material.dart';
import 'package:time_attendance/controller/device_management_controller/device_employee_controller.dart';
import 'package:time_attendance/controller/device_management_controller/device_employee_controller_HikeVision.dart';
import 'package:time_attendance/model/device_management_model/device_emloyee_edit_model.dart';
import 'package:time_attendance/model/device_management_model/device_employee_model.dart';
import 'package:time_attendance/widget/reusable/button/form_button.dart';

class DeviceEmployeeDialog extends StatefulWidget {
  final DeviceEmployeeInfo? employee;
  final DeviceEmployeeControllerHK? controller;
  final DeviceEmployeeController? controllerLocal;
  final String? deviceId;
  final List<String> deviceIds;

  const DeviceEmployeeDialog({
    super.key,
    this.employee,
    // controller
    this.controller,
    this.controllerLocal,
    this.deviceId,
    required this.deviceIds,
  });

  @override
  State<DeviceEmployeeDialog> createState() => _DeviceEmployeeDialogState();
}

class _DeviceEmployeeDialogState extends State<DeviceEmployeeDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _employeeNoController;
  late TextEditingController _nameController;
  DateTime? _beginTime;
  DateTime? _endTime;
  String _timeType = 'local';

  @override
  void initState() {
    super.initState();
    _employeeNoController = TextEditingController(text: widget.employee?.employeeNo ?? '');
    _nameController = TextEditingController(text: widget.employee?.name ?? '');
    if (widget.employee != null) {
      _beginTime = DateTime.tryParse(widget.employee!.valid.beginTime);
      _endTime = DateTime.tryParse(widget.employee!.valid.endTime);
      _timeType = widget.employee!.valid.timeType;
    }
  }

  @override
  void dispose() {
    _employeeNoController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime(bool isBeginTime) async {
    final DateTime? picked = await showDateTimePicker(
      context: context,
      initialDate: isBeginTime ? _beginTime ?? DateTime.now() : _endTime ?? DateTime.now(),
      firstDate: DateTime(1970),
      lastDate: DateTime(2037, 12, 31, 23, 59, 59),
    );


    if (picked != null) {
      setState(() {
        if (isBeginTime) {
          _beginTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Future<bool> _submitForm() async {
    bool success = false;
    String newBeginTime = _beginTime?.toString().split('.')[0] ?? '';
    String newEndTime = _endTime?.toString().split('.')[0] ?? '';
    if (_timeType.toLowerCase() == 'utc') {
      newBeginTime += '+05:30';
      newEndTime += '+05:30';
    }
        List<DeviceEmployeeAddRequest> empDetailsList = widget.deviceIds.map((deviceId) => 
      DeviceEmployeeAddRequest(
        devIndex: deviceId,
        employeeNo: _employeeNoController.text,
        name: _nameController.text,
        beginTime: newBeginTime,
        endTime: newEndTime,
        timeType: _timeType,
        userType: widget.employee?.userType ?? 'normal',
        closeDelayEnabled: widget.employee?.closeDelayEnabled ?? false,
        validEnable: widget.employee?.valid.enable ?? false,
        password: widget.employee?.password ?? '',
        doorRight: widget.employee?.doorRight ?? '',
        maxOpenDoorTime: widget.employee?.maxOpenDoorTime ?? 0,
        openDoorTime: widget.employee?.openDoorTime ?? 0,
        localUIRight: widget.employee?.localUIRight ?? false,
        userVerifyMode: widget.employee?.userVerifyMode ?? '',
        fingerPrintCount: widget.employee?.fingerPrintCount ?? 0,
        cardCount: widget.employee?.cardCount ?? 0,
        cardNo: widget.employee?.cardNo ?? '',
      )
    ).toList();
    if (_formKey.currentState?.validate() ?? false) {
      bool? result = await widget.controller?.modifyUserApi(
        employeeDetails: empDetailsList,
        enable: true,
        disableEmployee: false,
        enableEmployee: false
        );
      if (result == true) {
        success = true;
      }
    }
    return success;
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
                Text(
                  widget.employee == null ? 'Add New Employee' : 'Edit Employee',
                  style: const TextStyle(
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
                TextFormField(
                  controller: _employeeNoController,
                  decoration: InputDecoration(
                  labelText: 'Employee No.',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  hintText: 'Enter employee number',
                  ),
                  readOnly: true,
                  enabled: true,
                  validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter employee number';
                  }
                  return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    hintText: 'Enter employee name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _timeType,
                  decoration: InputDecoration(
                    labelText: 'Time Type',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    hintText: 'Select time type',
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'local',
                      child: Text('Local Time'),
                    ),
                    DropdownMenuItem(
                      value: 'UTC',
                      child: Text('UTC Time'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _timeType = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => _selectDateTime(true),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Begin Time',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      _beginTime != null
                          ? '${_beginTime!.day.toString().padLeft(2, '0')}-${_beginTime!.month.toString().padLeft(2, '0')}-${_beginTime!.year} ${_beginTime!.hour.toString().padLeft(2, '0')}:${_beginTime!.minute.toString().padLeft(2, '0')}'
                          : 'Select Begin Time',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => _selectDateTime(false),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'End Time',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text(
                      _endTime != null
                          ? '${_endTime!.day.toString().padLeft(2, '0')}-${_endTime!.month.toString().padLeft(2, '0')}-${_endTime!.year} ${_endTime!.hour.toString().padLeft(2, '0')}:${_endTime!.minute.toString().padLeft(2, '0')}'
                          : 'Select End Time',
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                CustomButtons(
                  onSavePressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (_beginTime == null || _endTime == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please select both begin and end times')),
                        );
                        return;
                      }
                      // Handle save logic here
                     bool success = await _submitForm();
                     if (success) {
                       Navigator.of(context).pop();
                       widget.controllerLocal?.getEmployeesByDevId(widget.deviceId ?? '');
                     }
                    }
                  },
                  onCancelPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Future<DateTime?> showDateTimePicker({
  required BuildContext context,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) async {
  final DateTime? date = await showDatePicker(
    context: context,
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
  );
  if (date == null) return null;

  final TimeOfDay? time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(initialDate),
  );
  if (time == null) return null;

  return DateTime(
    date.year,
    date.month,
    date.day,
    time.hour,
    time.minute,
  );
}