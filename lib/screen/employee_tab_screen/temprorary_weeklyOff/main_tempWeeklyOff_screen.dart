// temporary_weekly_off_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/employee_tab_controller/employee_search_controller.dart';
import 'package:time_attendance/controller/temp_weekly_off_controller/temp_weekly_off_controller.dart';
import 'package:time_attendance/screen/employee_tab_screen/employee_screen/employee_filter.dart';
import 'package:time_attendance/screen/employee_tab_screen/temprorary_weeklyOff/tempWeeklyOff_dialog_screen.dart';
import 'package:time_attendance/screen/employee_tab_screen/temprorary_weeklyOff/temp_weekly_off_grid.dart'; // Import the grid
import 'package:time_attendance/widget/reusable/button/custom_action_button.dart';
import 'package:time_attendance/widget/reusable/dialog/dialogbox.dart';
import 'package:time_attendance/widget/reusable/pagination/pagination_widget.dart';
import 'package:time_attendance/widget/reusable/tooltip/help_tooltip_button.dart';
import 'package:time_attendance/widgets/mtaToast.dart';

class TemporaryWeeklyOffScreen extends StatefulWidget {
  const TemporaryWeeklyOffScreen({super.key});

  @override
  State<TemporaryWeeklyOffScreen> createState() => _TemporaryWeeklyOffScreenState();
}

class _TemporaryWeeklyOffScreenState extends State<TemporaryWeeklyOffScreen> {
  final EmployeeSearchController employeeSearchController = Get.put(EmployeeSearchController());
  final TempWeeklyOffController tempWeeklyOffController = Get.put(TempWeeklyOffController());

  @override
  void initState() {
    super.initState();
    // Use a post-frame callback to safely modify controller state after the widget builds.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Set the search mode specifically for this screen
      employeeSearchController.searchMode.value = EmployeeSearchMode.weeklyOff;
      // Clear any previous search results or state
      employeeSearchController.hasSearched.value = false;
      employeeSearchController.weeklyOffList.clear();
      employeeSearchController.selectedEmployeeIDs.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Temporary WeeklyOff Muster'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          CustomActionButton(
            label: 'Assign WeeklyOff',
            onPressed: () => _showTempWeeklyOffDialog(context),
          ),
          CustomActionButton(
            label: 'Add Filter',
            onPressed: () => _showFilterDialog(context),
            icon: Icons.filter_list),
        // TODO: Implement Download and Upload functionality
        CustomActionButton(
          label: 'Download',
              onPressed: () => employeeSearchController.generateAndDownloadWeeklyOffCsv(),
          icon: Icons.download,
        ),
        CustomActionButton(
          label: 'Upload',
         onPressed: () => employeeSearchController.uploadWeeklyOffCsv(),
          icon: Icons.upload,
        ),
          const SizedBox(width: 8),
          HelpTooltipButton(
            tooltipMessage: 'Manage temporary weekly off assignments for employees. You can assign, edit, or delete weekly off schedules.',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // The main content area is now the grid
            Expanded(
              child: TempWeeklyOffGrid(
                controller: employeeSearchController,
              ),
            ),
            // Pagination widget that only shows when there are results
            Obx(() {
              if (employeeSearchController.weeklyOffList.isNotEmpty) {
                return PaginationWidget(
                  currentPage: employeeSearchController.currentPage.value + 1,
                  totalPages: (employeeSearchController.totalWeeklyOffRecords.value / employeeSearchController.recordsPerPage.value).ceil(),
                  onFirstPage: () => employeeSearchController.goToPage(0),
                  onPreviousPage: employeeSearchController.previousPage,
                  onNextPage: employeeSearchController.nextPage,
                  onLastPage: () {
                    int lastPage = (employeeSearchController.totalWeeklyOffRecords.value / employeeSearchController.recordsPerPage.value).ceil() - 1;
                    employeeSearchController.goToPage(lastPage);
                  },
                  onItemsPerPageChange: (value) {
                      employeeSearchController.updateRecordsPerPage(value);
                  },
                  itemsPerPage: employeeSearchController.recordsPerPage.value,
                  itemsPerPageOptions: const [10, 25, 50, 100],
                  totalItems: employeeSearchController.totalWeeklyOffRecords.value,
                );
              }
              return const SizedBox.shrink(); // Return an empty widget if there's no data
            }),
          ],
        ),
      ),
    );
  }

  /// Shows the filter dialog and triggers a search based on the selected criteria.
  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => EmployeeFilterDialog(
        searchMode: EmployeeSearchMode.weeklyOff, // Ensure the correct mode is passed
        onClose: () => Navigator.of(context).pop(),
        onFilter: (filterData) async {
          employeeSearchController.updateSearchFilter(
            employeeId: filterData['employeeId'] as String?,
            enrollId: filterData['enrollId'] as String?,
            employeeName: filterData['employeeName'] as String?,
            companyId: filterData['companyId'] as String?,
            departmentId: filterData['departmentId'] as String?,
            locationId: filterData['locationId'] as String?,
            designationId: filterData['designationId'] as String?,
            employeeTypeId: filterData['employeeTypeId'] as String?,
            employeeStatus: filterData['employeeStatus'] as int?,
            shiftEndDate: filterData['shiftEndDate'] as String?,
            shiftStartDate: filterData['shiftStartDate'] as String?,
          );
          employeeSearchController.startDate.value = filterData['shiftStartDate'] as String? ?? '';
          employeeSearchController.endDate.value = filterData['shiftEndDate'] as String? ?? '';
          // await shiftDetails.fetchDefaultShift();
        },
      ),
    );
  }

  /// Shows the dialog to assign a new temporary weekly off.
  void _showTempWeeklyOffDialog(BuildContext context) {
    // Prevent opening the dialog if no employees are selected from the grid.
    if (employeeSearchController.selectedEmployeeIDs.isEmpty) {
      MTAToast().ShowToast('Please select at least one employee to assign a weekly off.');
      return;
    }
    
    showCustomDialog(
      context: context,
      dialogContent: [
        TempWeeklyOffDialog(
          // Pass any necessary controllers or data to the dialog here
        ),
      ],
    );
  }
}