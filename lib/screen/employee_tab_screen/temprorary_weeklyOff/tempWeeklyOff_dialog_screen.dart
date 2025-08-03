// Temporary Weekly Off dialog screen
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:time_attendance/controller/employee_tab_controller/employee_search_controller.dart';
import 'package:time_attendance/controller/temp_weekly_off_controller/temp_weekly_off_controller.dart';

class TempWeeklyOffDialog extends StatefulWidget {
  const TempWeeklyOffDialog({super.key});

  @override
  State<TempWeeklyOffDialog> createState() => _TempWeeklyOffDialogState();
}

class _TempWeeklyOffDialogState extends State<TempWeeklyOffDialog>
    with SingleTickerProviderStateMixin {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  late final AnimationController _refreshController;

  // Weekly off selections
  String _firstWeeklyOff = 'Sunday';
  String _secondWeeklyOff = 'None';
  String _dayType = 'HalfDay';

  // Week selections
  bool week1 = false;
  bool week2 = false;
  bool week3 = false;
  bool week4 = false;
  bool week5 = false;

  // Lists for dropdowns
  final List<String> _daysOfWeek = [
    'None',
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];
  final List<String> _daysOfWeekWithNone = [
    'None',
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];
  final List<String> _dayTypes = ['HalfDay', 'FullDay'];

  @override
  void initState() {
    super.initState();
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
      // Implement refresh logic here
      _refreshController.reset();
    });
  }

  void _handleDelete() {
    if (_formKey.currentState?.validate() ?? false) {
      final weeklyOffController = Get.find<TempWeeklyOffController>();
      final employeeSearchController = Get.find<EmployeeSearchController>();
      
      // Build week pattern based on selected weeks
      List<String> selectedWeeks = [];
      if (week1) selectedWeeks.add('1');
      if (week2) selectedWeeks.add('2');
      if (week3) selectedWeeks.add('3');
      if (week4) selectedWeeks.add('4');
      if (week5) selectedWeeks.add('5');
      final wOffPattern = selectedWeeks.join('-');

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm Deletion'),
            content: const Text(
                'Are you sure to delete temporary weekly off of given date range of selected employees?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () async {
                  // Create weekly off models for selected employees with forDelete=true
                  final weeklyOffModels = weeklyOffController.createWeeklyOffModels(
                    employeeIds: employeeSearchController.selectedEmployeeIDs.toList(),
                    firstWOff: _firstWeeklyOff,
                    secondWOff: _secondWeeklyOff,
                    isFullDay: _dayType == 'FullDay',
                    wOffPattern: wOffPattern,
                    startDate: _startDate,
                    endDate: _endDate,
                    forDelete: true  // Set delete flag to true
                  );

                  // Delete the weekly off assignments
                  final success = await weeklyOffController.deleteWeeklyOff(weeklyOffModels);
                  
                  if (success) {
                    // Refresh the grid if delete was successful
                    await employeeSearchController.fetchWeeklyOffEmployees(resetPage: true);
                  }
                  
                  // Close both dialogs
                  Navigator.of(context).pop(); // Close confirmation dialog
                  Navigator.of(context).pop(); // Close temp weekly off dialog
                },
                child: const Text('Yes'),
              ),
            ],
          );
        },
      );
    }
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      final weeklyOffController = Get.find<TempWeeklyOffController>();
      final employeeSearchController = Get.find<EmployeeSearchController>();
      
      // Build week pattern based on selected weeks
      List<String> selectedWeeks = [];
      if (week1) selectedWeeks.add('1');
      if (week2) selectedWeeks.add('2');
      if (week3) selectedWeeks.add('3');
      if (week4) selectedWeeks.add('4');
      if (week5) selectedWeeks.add('5');
      final wOffPattern = selectedWeeks.join('-');
      
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm Application'),
            content: const Text(
                'Are you sure to mark weekly off for the given date range to selected employees?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () async {
                  // Create weekly off models for selected employees
                  final weeklyOffModels = weeklyOffController.createWeeklyOffModels(
                    employeeIds: employeeSearchController.selectedEmployeeIDs.toList(),
                    firstWOff: _firstWeeklyOff,
                    secondWOff: _secondWeeklyOff,
                    isFullDay: _dayType == 'FullDay',
                    wOffPattern: wOffPattern,
                    startDate: _startDate,
                    endDate: _endDate,
                  );

                  // Save the weekly off assignments
                  final success = await weeklyOffController.saveWeeklyOff(weeklyOffModels);
                  
                  if (success) {
                    // Refresh the grid if save was successful
                    await employeeSearchController.fetchWeeklyOffEmployees(resetPage: true);
                  }
                  
                  // Close both dialogs
                  Navigator.of(context).pop(); // Close confirmation dialog
                  Navigator.of(context).pop(); // Close temp weekly off dialog
                },
                child: const Text('Yes'),
              ),
            ],
          );
        },
      );
    }
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
    final dateFormat = DateFormat('d MMM yyyy');

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
                  'Temporary Weekly Off',
                  style: TextStyle(
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
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
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
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
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
                        'Weekly Off Details:',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: _firstWeeklyOff,
                        decoration: InputDecoration(
                          labelText: 'First Weekly Off *',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        items: _daysOfWeek
                            .map((day) =>
                                DropdownMenuItem(value: day, child: Text(day)))
                            .toList(),
                        onChanged: (value) {
                          setState(() {                            _firstWeeklyOff = value!;
                            // If first weekly off is None, cascade the effect
                            if (value == 'None') {
                              _secondWeeklyOff = 'None';
                            }
                          });
                        },
                      ),                      const SizedBox(height: 12),
                      AbsorbPointer(
                        absorbing: _firstWeeklyOff == 'None',
                        child: Opacity(
                          opacity: _firstWeeklyOff == 'None' ? 0.5 : 1.0,
                          child: DropdownButtonFormField<String>(
                            value: _secondWeeklyOff,
                            decoration: InputDecoration(
                              labelText: 'Secondly Weekly Off',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            items: _daysOfWeekWithNone
                                .map((day) =>
                                    DropdownMenuItem(value: day, child: Text(day)))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _secondWeeklyOff = value!;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),                      AbsorbPointer(
                        absorbing: _secondWeeklyOff == 'None' || _firstWeeklyOff == 'None' || (_firstWeeklyOff == _secondWeeklyOff && _firstWeeklyOff != 'None'),
                        child: Opacity(
                          opacity: (_secondWeeklyOff == 'None' || _firstWeeklyOff == 'None' || (_firstWeeklyOff == _secondWeeklyOff && _firstWeeklyOff != 'None')) ? 0.5 : 1.0,
                          child: DropdownButtonFormField<String>(
                            value: _dayType,
                            decoration: InputDecoration(
                              labelText: 'Full Day/Half Day',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            items: _dayTypes
                                .map((type) => DropdownMenuItem(
                                    value: type, child: Text(type)))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                _dayType = value!;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_secondWeeklyOff != 'None' && _firstWeeklyOff != 'None' && _firstWeeklyOff != _secondWeeklyOff) ...[
                        Row(
                          children: [
                            Expanded(
                              child: CheckboxListTile(
                                title: const Text('1st Week'),
                                value: week1,
                                onChanged: (val) => setState(() => week1 = val!),
                                controlAffinity: ListTileControlAffinity.leading,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                            Expanded(
                              child: CheckboxListTile(
                                title: const Text('2nd Week'),
                                value: week2,
                                onChanged: (val) => setState(() => week2 = val!),
                                controlAffinity: ListTileControlAffinity.leading,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: CheckboxListTile(
                                title: const Text('3rd Week'),
                                value: week3,
                                onChanged: (val) => setState(() => week3 = val!),
                                controlAffinity: ListTileControlAffinity.leading,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                            Expanded(
                              child: CheckboxListTile(
                                title: const Text('4th Week'),
                                value: week4,
                                onChanged: (val) => setState(() => week4 = val!),
                                controlAffinity: ListTileControlAffinity.leading,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        ),
                        CheckboxListTile(
                          title: const Text('5th Week'),
                          value: week5,
                          onChanged: (val) => setState(() => week5 = val!),
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _handleDelete,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Delete WeeklyOff'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _handleSave,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Mark WeeklyOff'),
                      ),
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
