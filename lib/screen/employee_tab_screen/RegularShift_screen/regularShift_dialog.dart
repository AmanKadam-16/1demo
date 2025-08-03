import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:time_attendance/controller/regular_shift_controller/regular_shift_controller.dart';
import 'package:time_attendance/controller/shift_tab_controller/shift_details_controller.dart';
import 'package:time_attendance/controller/shift_tab_controller/shift_pattern_controller.dart';
import 'package:time_attendance/model/Masters/shiftPattern.dart';
import 'package:time_attendance/model/regular_shift/regular_shift_model.dart';
import 'package:time_attendance/model/sfift_tab_model/shift_details_model.dart';
import 'package:time_attendance/widget/reusable/button/form_button.dart';

enum ShiftType { autoAssign, fix, rotation }

class RegularShiftDialog extends StatefulWidget {
  final RegularShiftController regularShiftController;
  final RegularShiftModel? initialShiftData;

  const RegularShiftDialog({
    super.key,
    required this.regularShiftController,
    this.initialShiftData,
  });

  @override
  State<RegularShiftDialog> createState() => _RegularShiftDialogState();
}

class _RegularShiftDialogState extends State<RegularShiftDialog> {
  // Get other necessary controllers
  final ShiftDetailsController shiftDetailsController = Get.put(ShiftDetailsController());
  final ShiftPatternController shiftPatternController = Get.put(ShiftPatternController());

  final _formKey = GlobalKey<FormState>();

  // Form fields state
  late DateTime _startDate;
  late ShiftType _selectedShiftType;
  SiftDetailsModel? _selectedShift;
  ShiftPatternModel? _selectedPattern;
  late TextEditingController _constantDaysController;

  @override
  void initState() {
    super.initState();
    // Initialize with default or existing data
    final data = widget.initialShiftData;

    if (data != null) {
      _startDate = DateFormat('yyyy-MM-dd').parse(data.startDateTime ?? data.startDate);
      _constantDaysController = TextEditingController(text: data.shiftConstantDays);
      switch (data.type) {
        case 1: _selectedShiftType = ShiftType.fix; break;
        case 2: _selectedShiftType = ShiftType.autoAssign; break;
        case 3: _selectedShiftType = ShiftType.rotation; break;
        default: _selectedShiftType = ShiftType.autoAssign;
      }
    } else {
      _startDate = DateTime.now();
      _selectedShiftType = ShiftType.autoAssign;
      _constantDaysController = TextEditingController(text: '2');
    }

    // Set default/initial shift once the list is loaded
    ever(shiftDetailsController.shifts, (List<SiftDetailsModel> shifts) {
          print('data: $data');
          print('checkthisout: ${data?.shiftID}');
      if (shifts.isNotEmpty) {
        SiftDetailsModel? shiftToSet;
        if (data?.type == 1) {
          shiftToSet = shifts.firstWhereOrNull((s) => s.shiftID == data!.shiftID);
        }
        shiftToSet ??= shifts.firstWhereOrNull((s) => s.isDefaultShift == true) ?? shifts.first;
        if (mounted) setState(() => _selectedShift = shiftToSet);
      }
    });

    // Set default/initial pattern once the list is loaded
    ever(shiftPatternController.shiftPatterns, (List<ShiftPatternModel> patterns) {
      if (patterns.isNotEmpty) {
        ShiftPatternModel? patternToSet;
        if (data?.type == 3) {
          patternToSet = patterns.firstWhereOrNull((p) => p.patternId.toString() == data!.patternID);
        }
        patternToSet ??= patterns.first;
        if (mounted) setState(() => _selectedPattern = patternToSet);
      }
    });

    // --- Fix: Set initial shift/pattern if already loaded ---
    final shifts = shiftDetailsController.shifts;
    if (shifts.isNotEmpty) {
      SiftDetailsModel? shiftToSet;
      if (data?.type == 1) {
        shiftToSet = shifts.firstWhereOrNull((s) => s.shiftID == data!.shiftID);
      }
      shiftToSet ??= shifts.firstWhereOrNull((s) => s.isDefaultShift == true) ?? shifts.first;
      _selectedShift = shiftToSet;
    }

    final patterns = shiftPatternController.shiftPatterns;
    if (patterns.isNotEmpty) {
      ShiftPatternModel? patternToSet;
      if (data?.type == 3) {
        patternToSet = patterns.firstWhereOrNull((p) => p.patternId.toString() == data!.patternID);
      }
      patternToSet ??= patterns.first;
      _selectedPattern = patternToSet;  
    }
  }
  
  @override
  void dispose() {
    _constantDaysController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      final data = widget.initialShiftData;
      if (data == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Employee data missing.'), backgroundColor: Colors.red),
        );
        return;
      }

      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // Build RegularShiftModel from form and widget data
      RegularShiftModel shiftModel = RegularShiftModel(
        employeeID: data.employeeID,
        employeeName: data.employeeName,
        startDate: DateFormat('yyyy-MM-dd').format(_startDate), 
        type: _selectedShiftType == ShiftType.fix
            ? 1
            : _selectedShiftType == ShiftType.autoAssign
                ? 2
                : 3,
        shiftID: _selectedShiftType == ShiftType.fix ? (_selectedShift?.shiftID ?? '') : '',
        shiftName: _selectedShiftType == ShiftType.fix ? (_selectedShift?.shiftName ?? '') : '',
        patternID: _selectedShiftType == ShiftType.rotation ? (_selectedPattern?.patternId.toString() ?? '') : '',
        patternName: _selectedShiftType == ShiftType.rotation ? (_selectedPattern?.patternName ?? '') : '',
        shiftConstantDays: _selectedShiftType == ShiftType.rotation ? _constantDaysController.text : '',
      );

      widget.regularShiftController.saveOrUpdateRegularShift(shiftModel).then((_) {
        Navigator.of(context)
          ..pop() // Remove loading
          ..pop(); // Close dialog
      }).catchError((e) {
        Navigator.of(context).pop(); // Remove loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: $e'), backgroundColor: Colors.red),
        );
      });
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _startDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd-MMM-yyyy');
    final isEditing = widget.initialShiftData != null;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // --- DIALOG HEADER ---
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
                  isEditing ? 'Edit Shift Assignment' : 'Add Shift Assignment',
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
          
          // --- DIALOG CONTENT ---
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Start Date
                  TextFormField(
                    readOnly: true,
                    onTap: _selectDate,
                    decoration: InputDecoration(
                      labelText: 'Shift Start Date *',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                    controller: TextEditingController(text: dateFormat.format(_startDate)),
                  ),
                  const SizedBox(height: 20),

                  // Shift Type Radios
                  const Text('Shift Type *', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  ...ShiftType.values.map((type) => RadioListTile<ShiftType>(
                    title: Text(type.name.replaceAllMapped(RegExp(r'[A-Z]'), (m) => ' ${m.group(0)}').trim().capitalizeFirst!),
                    value: type,
                    groupValue: _selectedShiftType,
                    onChanged: (value) => setState(() => _selectedShiftType = value!),
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                  )),

                  // Dynamic content based on shift type
                  _buildShiftTypeContent(),

                  const SizedBox(height: 20),
                  // Note Section
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Text(
                      'Note: Please re-process attendance if the start date is in the past.',
                      style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic, color: Colors.orange.shade800),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 40),
                  // Action Buttons
                  CustomButtons(
                    onSavePressed: _handleSave,
                    onCancelPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // This helper method remains the same
  Widget _buildShiftTypeContent() {
    // ... Omitted for brevity, this is the same as in your previous file
     switch (_selectedShiftType) {
      case ShiftType.autoAssign:
        return const SizedBox.shrink(); // No extra fields needed

      case ShiftType.fix:
        return Obx(() {
          if (shiftDetailsController.isLoading.value && _selectedShift == null) {
            return const Center(child: Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()));
          }
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: DropdownButtonFormField<String>(
              value: _selectedShift?.shiftID,
              decoration: InputDecoration(
                labelText: 'Shift *',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              items: shiftDetailsController.shifts.map((shift) {
                return DropdownMenuItem<String>(
                  value: shift.shiftID,
                  child: Text(shift.shiftName ?? 'Unnamed Shift'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedShift = shiftDetailsController.shifts.firstWhere((s) => s.shiftID == value);
                });
              },
              validator: (v) => v == null ? 'Please select a shift' : null,
            ),
          );
        });

      case ShiftType.rotation:
        return Obx(() {
          if (shiftPatternController.isLoading.value && _selectedPattern == null) {
            return const Center(child: Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator()));
          }
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              children: [
                DropdownButtonFormField<int>(
                  value: _selectedPattern?.patternId,
                  decoration: InputDecoration(
                    labelText: 'Shift Pattern *',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  items: shiftPatternController.shiftPatterns.map((p) {
                    return DropdownMenuItem<int>(
                      value: p.patternId,
                      child: Text(p.patternName),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPattern = shiftPatternController.shiftPatterns.firstWhere((p) => p.patternId == value);
                    });
                  },
                  validator: (v) => v == null ? 'Please select a pattern' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _constantDaysController,
                  decoration: InputDecoration(
                    labelText: 'Shift Constant Days *',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Please enter days';
                    if (int.tryParse(v) == null || int.parse(v) <= 0) return 'Enter a valid number';
                    return null;
                  },
                ),
              ],
            ),
          );
        });
    }
  }
}