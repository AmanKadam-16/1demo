import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:time_attendance/controller/employee_tab_controller/employee_search_controller.dart';
import 'package:time_attendance/controller/shift_tab_controller/shift_details_controller.dart';

class ShiftMusterGrid extends StatefulWidget {
  final EmployeeSearchController controller;
  final ShiftDetailsController shiftDetails;

  const ShiftMusterGrid({
    super.key,
    required this.controller,
    required this.shiftDetails
  });

  @override
  State<ShiftMusterGrid> createState() => _ShiftMusterGridState();
}

class _ShiftMusterGridState extends State<ShiftMusterGrid> {
  late ScrollController _horizontalScrollController;  
  late ScrollController _verticalScrollController;
  
  List<Map<String, dynamic>> _dayHeaders = [];

  // Define column widths for consistent layout
  static const double checkboxColWidth = 50;
  static const double idColWidth = 120;
  static const double nameColWidth = 200;
  static const double dayColWidth = 80;

  @override
  void initState() {
    super.initState();
    _horizontalScrollController = ScrollController();
    _verticalScrollController = ScrollController();

    // Initial header generation if a search has already been performed.
    _updateHeaders();

    // Listen for search state changes to regenerate headers.
    // This handles both starting a search and resetting it.
    ever(widget.controller.hasSearched, (_) => _updateHeaders());
    // Also listen for changes to the dates themselves for subsequent filters
    everAll([widget.controller.startDate, widget.controller.endDate], (_) => _updateHeaders());
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  // --- THIS IS THE CORRECTED METHOD ---
  // Generates headers based on a date range, decoupled from employee data.
  List<Map<String, dynamic>> _generateDayHeadersFromDateRange(String? startStr, String? endStr) {
    if (startStr == null || startStr.isEmpty || endStr == null || endStr.isEmpty) {
      return [];
    }

    // A reliable map for converting the weekday integer to a short name.
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

      if (endDate.isBefore(startDate)) return []; // Invalid range

      List<Map<String, dynamic>> headers = [];
      int dayIndex = 1; // Backend data is indexed from Day1, Day2, ...
      DateTime currentDate = startDate;
      
      while (!currentDate.isAfter(endDate) && dayIndex <= 31) {
        // Use the reliable DateTime.weekday property and our map for conversion.
        final String weekDayName = weekDayMap[currentDate.weekday] ?? 'Err';

        headers.add({
          'dayIndex': dayIndex,
          'dayNum': currentDate.day,
          'weekDay': weekDayName,
          'displayText': '${currentDate.day.toString().padLeft(2, '0')} $weekDayName',
        });
        currentDate = currentDate.add(const Duration(days: 1));
        dayIndex++;
      }
      return headers;
    } catch (e) {
      debugPrint("Error parsing dates for header generation: $e");
      return [];
    }
  }

  void _updateHeaders() {
    if (!mounted) return;

    final hasSearched = widget.controller.hasSearched.value;
    if (hasSearched) {
      final startDate = widget.controller.startDate.value;
      final endDate = widget.controller.endDate.value;
       // Only update state if dates are valid to avoid empty headers during transition
      if(startDate.isNotEmpty && endDate.isNotEmpty){
        setState(() {
          _dayHeaders = _generateDayHeadersFromDateRange(startDate, endDate);
        });
      }
    } else {
      // If the search is reset, clear the headers.
      if (_dayHeaders.isNotEmpty) {
        setState(() {
          _dayHeaders = [];
        });
      }
    }
  }

String get defaultShiftName => widget.shiftDetails.defaultShift.value?.ShiftName ?? 'N/A';
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Obx(() {
        if (widget.controller.isShiftMusterLoading.value && widget.controller.shiftMusterList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!widget.controller.hasSearched.value) {
            return const Center(child: Text("Please add filters to search for employees."));
        }
        if (widget.controller.shiftMusterList.isEmpty) {
          return const Center(child: Text("No employees found for the selected criteria."));
        }
        if (_dayHeaders.isEmpty && widget.controller.hasSearched.value) {
          return const Center(child: Text("Could not generate date headers. Please check the filter's date range."));
        }
        
        return _buildSynchronizedTable();
      }),
    );
  }

  Widget _buildSynchronizedTable() {
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
                _buildFixedHeader(_dayHeaders),
                const Divider(height: 1, thickness: 1),
                Expanded(
                  child: ListView.separated(
                    controller: _verticalScrollController,
                    itemCount: widget.controller.shiftMusterList.length,
                    itemBuilder: (context, index) {
                      final employee = widget.controller.shiftMusterList[index];
                      return _buildFixedDataRow(employee, _dayHeaders);
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
  
  Widget _buildFixedHeader(List<Map<String, dynamic>> dayHeaders) {
    return Container(
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Row(
        children: [
          // Fixed Header Columns
          SizedBox(
            width: checkboxColWidth,
            child: Obx(() => Checkbox(
              value: widget.controller.selectedEmployeeIDs.length == widget.controller.shiftMusterList.length && widget.controller.shiftMusterList.isNotEmpty,
              onChanged: (bool? value) {
                widget.controller.toggleSelectAll(value ?? false);
              },
            )),
          ),
          SizedBox(width: idColWidth, child: _headerCell('Employee ID')),
          SizedBox(width: nameColWidth, child: _headerCell('Employee Name')),
          
          // Day Headers
          ...dayHeaders.map((header) => 
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

  Widget _buildFixedDataRow(dynamic employee, List<Map<String, dynamic>> dayHeaders) {
    const int tooltipLength = 10; // Set your desired length threshold
    return IntrinsicHeight(
      child: Row(
        children: [
          // Fixed Data Columns
          SizedBox(
            width: checkboxColWidth,
            child: Obx(() => Checkbox(
              value: widget.controller.selectedEmployeeIDs.contains(employee.employeeID),
              onChanged: (bool? value) {
                widget.controller.toggleEmployeeSelection(employee.employeeID);
              },
            )),
          ),
          SizedBox(width: idColWidth, child: _dataCell(employee.employeeID)),
          SizedBox(width: nameColWidth, child: _dataCell(employee.employeeName)),
          // Day Data Columns
          ...dayHeaders.map((header) {
            final dayIndex = header['dayIndex'];
            String displayText = employee.days['ShiftIDOrWOffHolidayOrLeave$dayIndex'] ?? '';
            if (displayText.isEmpty) {
              displayText = defaultShiftName;
            }
            int shiftType = employee.days['Shift$dayIndex'] ?? -1;
            final bool showTooltip = displayText.length > tooltipLength;
            Widget cellText = Text(
              displayText,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: _getTextColor(_getCellColor(shiftType)),
              ),
            );
            if (showTooltip) {
              cellText = Tooltip(
                message: displayText,
                child: cellText,
              );
            }
            return Container(
              width: dayColWidth,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
              color: _getCellColor(shiftType),
              child: cellText,
            );
          }),
        ],
      ),
    );
  }

  Color? _getCellColor(int shiftType) {
    switch (shiftType) {
      case 0: return Colors.blue[100];
      case 1: return Colors.orange[100];
      case 2: return Colors.green[100];
      default: return Colors.transparent; 
    }
  }

  Color _getTextColor(Color? backgroundColor) {
    if (backgroundColor == Colors.transparent || backgroundColor == null) {
      return Colors.black87;
    }
    return Colors.black87;
  }

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

  Widget _dataCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Text(text, overflow: TextOverflow.ellipsis),
    );
  }
}