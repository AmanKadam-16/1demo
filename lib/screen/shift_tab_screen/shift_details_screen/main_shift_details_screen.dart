import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/shift_tab_controller/shift_details_controller.dart';
import 'package:time_attendance/model/sfift_tab_model/shift_details_model.dart';
import 'package:time_attendance/screen/shift_tab_screen/shift_details_screen/shift_details_dialog_screen.dart';
import 'package:time_attendance/services/master_excel_report.dart';
import 'package:time_attendance/services/master_pdf_report.dart';
import 'package:time_attendance/widget/reusable/alert/export_alert.dart';
import 'package:time_attendance/widget/reusable/button/custom_action_button.dart';
import 'package:time_attendance/widget/reusable/dialog/dialogbox.dart';
import 'package:time_attendance/widget/reusable/list/reusable_list.dart';
import 'package:time_attendance/widget/reusable/pagination/pagination_widget.dart';
import 'package:time_attendance/widget/reusable/search/reusable_search_field.dart';
import 'package:time_attendance/widget/reusable/tooltip/help_tooltip_button.dart';

class MainShiftDetailsScreen extends StatelessWidget {
  MainShiftDetailsScreen({Key? key}) : super(key: key);

  final ShiftDetailsController controller = Get.put(ShiftDetailsController());
  final TextEditingController _searchController = TextEditingController();
  final RxInt _currentPage = 1.obs;
  final RxInt _itemsPerPage = 10.obs;
  final RxInt _totalPages = 1.obs;

  void _handlePageChange(int page) {
    _currentPage.value = page;
  }

  void _handleItemsPerPageChange(int value) {
    _itemsPerPage.value = value;
    _currentPage.value = 1;
    _calculateTotalPages();
  }

  void _calculateTotalPages() {
    _totalPages.value = (controller.filteredShifts.length / _itemsPerPage.value).ceil();
  }

  List<SiftDetailsModel> _getPaginatedData() {
    final startIndex = (_currentPage.value - 1) * _itemsPerPage.value;
    final endIndex = startIndex + _itemsPerPage.value;
    if (startIndex >= controller.filteredShifts.length) return [];
    return controller.filteredShifts.sublist(
      startIndex,
      endIndex > controller.filteredShifts.length 
          ? controller.filteredShifts.length 
          : endIndex,
    );
  }

void _showExportDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ExportAlertDialog(
        onExport: (fileType) async {
          try {
            if (fileType == 'PDF') {
              await GenericPdfGeneratorService.generateSimplePdf<SiftDetailsModel>(
                data: controller.shifts ?? [],
                reportTitle: 'Shift Details Report', // Corrected title
                headers: [
                  'Shift Name', 'In  Time  ', 'Out Time', 'Ends Next Day', 'Full Day (Mins)', 
                  'Half Day (Mins)', 'OT Allowed', 'OT at Shift End', 'OT Start (Mins)', 
                  'OT Grace (Mins)', 'Lunch  In', 'Lunch  Out', 'Lunch (Mins)', 
                  'Other Break (Mins)', 'Default Shift'
                ],
                rowBuilder: (shift) => [
                  shift.shiftName ?? '',
                  shift.inTime ?? '',
                  shift.outTime ?? '',
                  (shift.isShiftEndNextDay ?? false) ? 'Yes' : 'No',
                  shift.fullDayMinutes?.toString() ?? '',
                  shift.halfDayMinutes?.toString() ?? '',
                  (shift.isOTAllowed ?? false) ? 'Yes' : 'No',
                  (shift.isOTStartsAtShiftEnd ?? false) ? 'Yes' : 'No',
                  shift.oTStartMinutes?.toString() ?? '',
                  shift.oTGraceMinutes?.toString() ?? '',
                  shift.lunchInTime ?? '',
                  shift.lunchOutTime ?? '',
                  shift.lunchMins?.toString() ?? '',
                  shift.otherBreakMins?.toString() ?? '',
                  (shift.isDefaultShift ?? false) ? 'Yes' : 'No',
                ],
              );
            } else if (fileType == 'Excel') {
              await GenericExcelGeneratorService.generateExcel<SiftDetailsModel>(
                data: controller.shifts ?? [], // Use the shift data
                reportTitle: 'Shift Details Report', // Set a relevant title
                headers: [
                  'Shift Name',
                  'In Time',
                  'Out Time',
                  'Ends Next Day',
                  'Full Day (Mins)',
                  'Half Day (Mins)',
                  'OT Allowed',
                  'OT at Shift End',
                  'OT Start (Mins)',
                  'OT Grace (Mins)',
                  'Lunch In Time',
                  'Lunch Out Time',
                  'Lunch (Mins)',
                  'Other Break (Mins)',
                  'Is Default Shift',
                  'Is Auto-Assigned',
                ],
                rowBuilder: (shift) {
                  // Return the actual data types instead of converting everything to string
                  return [
                    shift.shiftName ?? '',
                    shift.inTime ?? '',
                    shift.outTime ?? '',
                    // Convert boolean to a more readable "Yes" / "No"
                    (shift.isShiftEndNextDay ?? false) ? 'Yes' : 'No',
                    // Return numbers directly, not as strings
                    shift.fullDayMinutes, // This will be int/double or null
                    shift.halfDayMinutes, // This will be int/double or null
                    (shift.isOTAllowed ?? false) ? 'Yes' : 'No',
                    (shift.isOTStartsAtShiftEnd ?? false) ? 'Yes' : 'No',
                    shift.oTStartMinutes, // This will be int/double or null
                    shift.oTGraceMinutes, // This will be int/double or null
                    shift.lunchInTime ?? '',
                    shift.lunchOutTime ?? '',
                    shift.lunchMins, // This will be int/double or null
                    shift.otherBreakMins, // This will be int/double or null
                    (shift.isDefaultShift ?? false) ? 'Yes' : 'No',
                    (shift.isShiftAutoAssigned ?? false) ? 'Yes' : 'No',
                  ];
                },
              );
            }
          } catch (e) {
            // Show an error message if something goes wrong
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to generate report: $e')),
            );
            print(e);
          }
        },
      );
    },
  );
}
  @override
  Widget build(BuildContext context) {
    controller.initializeAuthShift();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shift Details'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          if (MediaQuery.of(context).size.width > 600)
            ReusableSearchField(
              searchController: _searchController,
              onSearchChanged: controller.updateSearchQuery,
            ),
          const SizedBox(width: 20),
          CustomActionButton(
            label: 'Add Shift',
            onPressed: () => _showShiftDetailsDialog(context),
          ),
          CustomActionButton(
            label: 'Export',
            onPressed: () => _showExportDialog(context),
            icon: Icons.download,
          ),
          const SizedBox(width: 8),
          HelpTooltipButton(
            tooltipMessage: 'Manage shift details for your organization.',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          if (MediaQuery.of(context).size.width <= 600)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ReusableSearchField(
                searchController: _searchController,
                onSearchChanged: controller.updateSearchQuery,
                responsiveWidth: false,
              ),
            ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              _calculateTotalPages();
              final paginatedData = _getPaginatedData();

              return Column(
                children: [
                  Expanded(
                    child: ReusableTableAndCard(
                      data: List.generate(paginatedData.length, (index) {
                        final shift = paginatedData[index];
                        return {
                          'Shift Name': shift.shiftName ?? 'N/A',
                          'In Time': shift.inTime ?? 'N/A',
                          'Out Time': shift.outTime ?? 'N/A',
                          'Full Day': shift.fullDayMinutes?.toString() ?? 'N/A',
                          'Half Day': shift.halfDayMinutes?.toString() ?? 'N/A',
                          'OT Allowed': shift.isOTAllowed == true ? 'Yes' : 'No',
                          'Lunch Minutes': shift.lunchMins?.toString() ?? 'N/A',
                          'Other Break': shift.otherBreakMins?.toString() ?? 'N/A',
                          'Default Shift': shift.isDefaultShift == true ? 'Yes' : 'No',
                          'Actions': 'Edit/Delete',
                        };
                      }),
                      headers: const [
                        'Shift Name',
                        'In Time',
                        'Out Time',
                        'Full Day',
                        'Half Day',
                        'OT Allowed',
                        'Lunch Minutes',
                        'Other Break',
                        'Default Shift',
                        'Actions'
                      ],
                      visibleColumns: const [
                        'Shift Name',
                        'In Time',
                        'Out Time',
                        'Full Day',
                        'Half Day',
                        'OT Allowed',
                        'Lunch Minutes',
                        'Other Break',
                        'Default Shift',
                        'Actions'
                      ],
                      onEdit: (row) {
                        final shift = paginatedData.firstWhere(
                          (s) => s.shiftName == row['Shift Name'],
                        );
                        _showShiftDetailsDialog(context, shift);
                      },
                      onDelete: (row) {
                        final shift = paginatedData.firstWhere(
                          (s) => s.shiftName == row['Shift Name'],
                          orElse: () => SiftDetailsModel(),
                        );
                        if (shift.shiftID != null) {
                          _showDeleteConfirmationDialog(context, shift);
                        }
                      },
                      onSort: (columnName, ascending) {
                        controller.sortShifts(columnName, ascending);
                      },
                    ),
                  ),
                  Obx(() => PaginationWidget(
                    currentPage: _currentPage.value,
                    totalPages: _totalPages.value,
                    onFirstPage: () => _handlePageChange(1),
                    onPreviousPage: () => _handlePageChange(_currentPage.value - 1),
                    onNextPage: () => _handlePageChange(_currentPage.value + 1),
                    onLastPage: () => _handlePageChange(_totalPages.value),
                    onItemsPerPageChange: _handleItemsPerPageChange,
                    itemsPerPage: _itemsPerPage.value,
                    itemsPerPageOptions: const [10, 25, 50, 100],
                    totalItems: controller.filteredShifts.length,
                  )),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showShiftDetailsDialog(BuildContext context, [SiftDetailsModel? shift]) {
    showCustomDialog(
      context: context,
      dialogContent: [
        ShiftConfigurationScreen(
          controller: controller,
          shiftdetails: shift ?? SiftDetailsModel(),
        ),
      ],
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, SiftDetailsModel shift) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete ${shift.shiftName}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await controller.deleteShift(shift.shiftID ?? '');
                if (context.mounted) Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}