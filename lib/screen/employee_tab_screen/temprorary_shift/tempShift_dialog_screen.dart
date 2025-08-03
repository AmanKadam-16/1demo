import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:time_attendance/controller/shift_tab_controller/shift_details_controller.dart';
import 'package:time_attendance/model/sfift_tab_model/shift_details_model.dart';
import 'package:time_attendance/controller/employee_tab_controller/employee_search_controller.dart'; // *** ADDED ***
import 'package:time_attendance/widgets/mtaToast.dart'; // *** ADDED *** for toast messages

class TempShiftDialog extends StatefulWidget {
  final ShiftDetailsController controller;
  final EmployeeSearchController employeeSearchController; // *** ADDED ***
  final SiftDetailsModel? selectedShift;

  const TempShiftDialog({
    super.key, 
    required this.controller,
    required this.employeeSearchController,
    this.selectedShift,
  });

  @override
  State<TempShiftDialog> createState() => _TempShiftDialogState();
}

class _TempShiftDialogState extends State<TempShiftDialog> with SingleTickerProviderStateMixin {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  SiftDetailsModel? _selectedShift;
  final _formKey = GlobalKey<FormState>();
  late final AnimationController _refreshController;
  @override
  void initState() {
    super.initState();
    // Set initially selected shift - either passed in or find default
    _selectedShift = widget.selectedShift ?? widget.controller.shifts.firstWhereOrNull(
      (shift) => shift.isDefaultShift == true
    );
    _refreshController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
  void _handleRefresh() {
    _refreshController.forward().then((_) async {
      await widget.controller.fetchShifts();
      // After fetching, update the selected shift if needed
      if (_selectedShift != null) {
        _selectedShift = widget.controller.shifts.firstWhereOrNull(
          (shift) => shift.shiftID == _selectedShift?.shiftID
        );
        setState(() {}); // Update UI with refreshed data
      }
      _refreshController.reset();
    });
  }

  // *** MODIFIED ***: _handleSave method
  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedShift == null || _selectedShift!.shiftID == null) {
        MTAToast().ShowToast("Please select a valid shift.");
        return;
      }
      if (_endDate.isBefore(_startDate)) {
        MTAToast().ShowToast("End date cannot be before the start date.");
        return;
      }

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm Application'),
            content: const Text('Are you sure you want to apply this temporary shift to the selected employees?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () async {
                  final dateFormat = DateFormat('yyyy-MM-dd');
                  // Call the controller method with the required data
                  await widget.employeeSearchController.applyTemporaryShift(
                    shiftID: _selectedShift!.shiftID!,
                    shiftName: _selectedShift!.shiftName ?? 'N/A',
                    startDate: dateFormat.format(_startDate),
                    endDate: dateFormat.format(_endDate),
                  );
                  // Close both dialogs
                  Navigator.of(context).pop(); // Close confirmation dialog
                  Navigator.of(context).pop(); // Close temp shift dialog
                },
                child: const Text('Yes'),
              ),
            ],
          );
        },
      );
    }
  }

  void _handleDelete() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure to delete temporary shift of given date range of selected employees?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                // TODO: Implement delete logic for temporary shift
                Navigator.of(context).pop(); // Close confirmation dialog
                Navigator.of(context).pop(); // Close temp shift dialog
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate(bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('d MMM yyyy'); // Create date formatter

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
                  'Temporary Shift Assignment',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: RotationTransition(
                    turns: _refreshController,
                    child: const Icon(Icons.refresh, color: Colors.black87),
                  ),
                  onPressed: _handleRefresh,
                  tooltip: 'Refresh',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 8),
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
                        readOnly: true,
                        onTap: () => _selectDate(true),
                        decoration: InputDecoration(
                          labelText: 'Start Date *',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                        controller: TextEditingController(
                          text: dateFormat.format(_startDate),
                        ),
                        validator: (_) => null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        readOnly: true,
                        onTap: () => _selectDate(false),
                        decoration: InputDecoration(
                          labelText: 'End Date *',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                        controller: TextEditingController(
                          text: dateFormat.format(_endDate),
                        ),
                        validator: (_) => null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Shift Details:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Obx(() => DropdownButtonFormField<String>(
                        value: _selectedShift?.shiftID,
                        decoration: InputDecoration(
                          labelText: 'Shift *',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        items: widget.controller.shifts.map((shift) {
                          return DropdownMenuItem<String>(
                            value: shift.shiftID,
                            child: Text(shift.shiftName ?? ''),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedShift = widget.controller.shifts.firstWhere(
                              (shift) => shift.shiftID == value,
                              orElse: () => SiftDetailsModel(),
                            );
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a shift';
                          }
                          return null;
                        },
                      )),
                      if (_selectedShift != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          'In-Time : ${_selectedShift?.inTime ?? ''} - Out-Time : ${_selectedShift?.outTime ?? ''}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Obx(() => Row( // *** MODIFIED ***: Wrap Row with Obx
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: widget.employeeSearchController.isApplyingShift.value ? null : _handleDelete,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Delete Shift'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: widget.employeeSearchController.isApplyingShift.value ? null : _handleSave,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        // *** MODIFIED ***: Show loading indicator or text
                        child: widget.employeeSearchController.isApplyingShift.value 
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3,))
                          : const Text('Mark Shift'),
                      ),
                    ),
                  ],
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
