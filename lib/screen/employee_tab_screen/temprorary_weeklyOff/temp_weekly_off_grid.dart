import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:time_attendance/controller/employee_tab_controller/employee_search_controller.dart';
import 'package:time_attendance/model/temp_weeklyOff_muster/temp_weeklyOff_model.dart';

/// A helper class to hold the consolidated weekly off data for a single employee.
class _GroupedEmployeeData {
  final String id;
  final String name;
  final List<TempWeeklyOffModel> rules;

  _GroupedEmployeeData({required this.id, required this.name, required this.rules});
}

/// A widget that displays a grid of temporary weekly off data for employees.
///
/// This grid is designed to be horizontally and vertically scrollable, with
/// fixed columns for employee details and dynamic columns for each day in the
/// selected date range. It correctly groups multiple weekly off rules into a
/// single row per employee.
class TempWeeklyOffGrid extends StatefulWidget {
  final EmployeeSearchController controller;

  const TempWeeklyOffGrid({
    super.key,
    required this.controller,
  });

  @override
  State<TempWeeklyOffGrid> createState() => _TempWeeklyOffGridState();
}

class _TempWeeklyOffGridState extends State<TempWeeklyOffGrid> {
  late ScrollController _horizontalScrollController;
  late ScrollController _verticalScrollController;

  List<Map<String, dynamic>> _dayHeaders = [];

  // Define column widths for a consistent layout
  static const double checkboxColWidth = 50;
  static const double idColWidth = 120;
  static const double nameColWidth = 200;
  static const double dayColWidth = 80;

  @override
  void initState() {
    super.initState();
    _horizontalScrollController = ScrollController();
    _verticalScrollController = ScrollController();

    _updateHeaders(); // Initial header generation

    // Listen for changes in search state or date range to regenerate headers
    ever(widget.controller.hasSearched, (_) => _updateHeaders());
    everAll([widget.controller.startDate, widget.controller.endDate], (_) => _updateHeaders());
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }
  
  /// Generates date headers for the grid's columns based on a date range.
  List<Map<String, dynamic>> _generateDayHeadersFromDateRange(String? startStr, String? endStr) {
    if (startStr == null || startStr.isEmpty || endStr == null || endStr.isEmpty) {
      return [];
    }
    
    const Map<int, String> weekDayMap = {
      DateTime.monday: 'Mon',
      DateTime.tuesday: 'Tue',
      DateTime.wednesday: 'Wed',
      DateTime.thursday: 'Thu',
      DateTime.friday: 'Fri',
      DateTime.saturday: 'Sat',
      DateTime.sunday: 'Sun',
    };

    try {
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final DateTime startDate = formatter.parse(startStr);
      final DateTime endDate = formatter.parse(endStr);

      if (endDate.isBefore(startDate)) return [];

      List<Map<String, dynamic>> headers = [];
      DateTime currentDate = startDate;
      
      while (!currentDate.isAfter(endDate)) {
        final String weekDayName = weekDayMap[currentDate.weekday] ?? 'Err';
        headers.add({
          'date': currentDate, // Store the full date object for calculations
          'dayNum': currentDate.day,
          'weekDay': weekDayName,
          'displayText': '${currentDate.day.toString().padLeft(2, '0')} $weekDayName',
        });
        currentDate = currentDate.add(const Duration(days: 1));
      }
      return headers;
    } catch (e) {
      debugPrint("Error parsing dates for header generation: $e");
      return [];
    }
  }

  /// Triggers a state update to rebuild the headers when search parameters change.
  void _updateHeaders() {
    if (!mounted) return;
    final hasSearched = widget.controller.hasSearched.value;
    if (hasSearched) {
      final startDate = widget.controller.startDate.value;
      final endDate = widget.controller.endDate.value;
      if (startDate.isNotEmpty && endDate.isNotEmpty) {
        setState(() {
          _dayHeaders = _generateDayHeadersFromDateRange(startDate, endDate);
        });
      }
    } else {
      if (_dayHeaders.isNotEmpty) {
        setState(() {
          _dayHeaders = [];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Obx(() {
        if (widget.controller.isWeeklyOffLoading.value && widget.controller.weeklyOffList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!widget.controller.hasSearched.value) {
            return const Center(child: Text("Please add filters and search to view the weekly off muster."));
        }
        if (widget.controller.weeklyOffList.isEmpty) {
          return const Center(child: Text("No employee weekly off data found for the selected criteria."));
        }
        if (_dayHeaders.isEmpty && widget.controller.hasSearched.value) {
          return const Center(child: Text("Could not generate date headers. Please check the filter's date range."));
        }
        
        return _buildSynchronizedTable();
      }),
    );
  }

  /// Builds the main table with synchronized horizontal and vertical scrolling.
  Widget _buildSynchronizedTable() {
    // 1. Group the raw list of rules by employee ID.
    final Map<String, List<TempWeeklyOffModel>> groupedByEmployee = {};
    for (var record in widget.controller.weeklyOffList) {
      groupedByEmployee.putIfAbsent(record.employeeID, () => []).add(record);
    }

    // 2. Create a final list of unique employees with their associated rules.
    final List<_GroupedEmployeeData> uniqueEmployees = groupedByEmployee.entries.map((entry) {
      return _GroupedEmployeeData(
        id: entry.key,
        name: entry.value.first.employeeName, // Name is the same across all rules for one employee
        rules: entry.value,
      );
    }).toList();
    
    // Optional: Sort the list by employee ID for a consistent display order.
    uniqueEmployees.sort((a, b) => a.id.compareTo(b.id));

    final scrollableWidth = _dayHeaders.length * dayColWidth;
    final fixedWidth = checkboxColWidth + idColWidth + nameColWidth;

    return Scrollbar(
      controller: _verticalScrollController,
      thumbVisibility: true,
      child: Scrollbar(
        controller: _horizontalScrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: _horizontalScrollController,
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: fixedWidth + scrollableWidth,
            child: Column(
              children: [
                _buildFixedHeader(uniqueEmployees),
                const Divider(height: 1, thickness: 1),
                Expanded(
                  // 3. The ListView now builds one row per unique employee.
                  child: ListView.separated(
                    controller: _verticalScrollController,
                    itemCount: uniqueEmployees.length,
                    itemBuilder: (context, index) {
                      final employeeData = uniqueEmployees[index];
                      return _buildFixedDataRow(employeeData);
                    },
                    separatorBuilder: (context, index) => const Divider(height: 1, thickness: 1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  /// Builds the header row of the grid.
  Widget _buildFixedHeader(List<_GroupedEmployeeData> employees) {
    return Container(
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Row(
        children: [
          // Fixed Header Columns
          SizedBox(
            width: checkboxColWidth,
            child: Obx(() => Checkbox(
              value: employees.isNotEmpty && widget.controller.selectedEmployeeIDs.length == employees.length,
              onChanged: (bool? value) {
                widget.controller.toggleSelectAll(value ?? false, employees.map((e) => e.id).toList());
              },
            )),
          ),
          SizedBox(width: idColWidth, child: _headerCell('Employee ID')),
          SizedBox(width: nameColWidth, child: _headerCell('Employee Name')),
          
          // Dynamic Day Headers
          ..._dayHeaders.map((header) => 
            SizedBox(
              width: dayColWidth,
              child: _headerCell(
                header['displayText'],
                isCentered: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a single data row for an employee, using their grouped data.
  Widget _buildFixedDataRow(_GroupedEmployeeData employeeData) {
    return IntrinsicHeight(
      child: Row(
        children: [
          // Fixed Data Columns
          SizedBox(
            width: checkboxColWidth,
            child: Obx(() => Checkbox(
              value: widget.controller.selectedEmployeeIDs.contains(employeeData.id),
              onChanged: (bool? value) {
                widget.controller.toggleEmployeeSelection(employeeData.id);
              },
            )),
          ),
          SizedBox(width: idColWidth, child: _dataCell(employeeData.id)),
          SizedBox(width: nameColWidth, child: _dataCell(employeeData.name)),

          // Dynamic Day Data Columns
          ..._dayHeaders.map((header) {
            final DateTime cellDate = header['date'];
            // Pass the employee's entire list of rules to the logic function.
            String displayText = _getWeeklyOffForDay(employeeData.rules, cellDate);
            
            return Container(
              width: dayColWidth,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              alignment: Alignment.center,
              child: Text(
                displayText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: displayText.isNotEmpty ? Theme.of(context).colorScheme.primary : null,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
  
  /// Determines the display text for a day's cell by checking all of an employee's rules.
  ///
  /// This function iterates through all weekly off rules for an employee. For each rule, it checks
  /// if the given date falls within the rule's active period, matches the designated weekday,
  /// and satisfies the occurrence pattern (if one is defined).
  ///
  /// Returns "WOF" (Full Day), "WOH" (Half Day), or an empty string if no rule applies.
  String _getWeeklyOffForDay(List<TempWeeklyOffModel> rules, DateTime cellDate) {
    try {
      final normalizedCellDate = DateTime(cellDate.year, cellDate.month, cellDate.day);

      // Iterate through every rule assigned to the employee.
      for (final record in rules) {
        final DateFormat recordDateFormat = DateFormat('dd-MMM-yyyy', 'en_US');
        final DateTime ruleStartDate = recordDateFormat.parse(record.startDate);
        final DateTime ruleEndDate = recordDateFormat.parse(record.endDate);

        // 1. Check if the cell's date is within the current rule's active period.
        if (normalizedCellDate.isBefore(ruleStartDate) || normalizedCellDate.isAfter(ruleEndDate)) {
          continue; // This rule is not active on this day, check the next rule.
        }

        final String cellWeekdayName = DateFormat('EEEE').format(cellDate).toLowerCase();
        final String firstWOffDay = record.firstWOff.toLowerCase();
        final String secondWOffDay = record.secondWOff.toLowerCase();
        
        bool isMatchFound = false;

        // 2. Check if the day matches one of the designated weekly off days for this rule.
        if (firstWOffDay == cellWeekdayName || (secondWOffDay != 'none' && secondWOffDay == cellWeekdayName)) {
          
          // 3. If a pattern is defined, the day must satisfy it.
          if (record.wOffPattern.isNotEmpty) {
            final int weekOccurrenceInMonth = (cellDate.day - 1) ~/ 7 + 1;
            final List<String> pattern = record.wOffPattern.split('-');
            if (pattern.contains(weekOccurrenceInMonth.toString())) {
              isMatchFound = true;
            }
          } else {
            // If no pattern is defined, the day being a designated weekly off day is sufficient.
            isMatchFound = true;
          }
        }
        
        // 4. If a match was found, return the result and stop checking other rules.
        if (isMatchFound) {
          return record.isFullDay ? "WOF" : "WOH";
        }
      }
    } catch (e) {
      debugPrint("Error processing weekly off for date $cellDate: $e");
      return ""; // Return empty on any processing or parsing error.
    }

    // 5. If after checking all rules, no match was found for this date.
    return "";
  }

  /// Helper widget for styling header cells.
  Widget _headerCell(String text, {bool isCentered = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Text(
        text,
        textAlign: isCentered ? TextAlign.center : TextAlign.start,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  /// Helper widget for styling data cells.
  Widget _dataCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Text(text, overflow: TextOverflow.ellipsis),
    );
  }
}