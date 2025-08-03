// lib/screen/employee_tab_screen/temprorary_shift/temporary_shift_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/employee_tab_controller/employee_search_controller.dart';
import 'package:time_attendance/controller/shift_tab_controller/shift_details_controller.dart';
import 'package:time_attendance/screen/employee_tab_screen/employee_screen/employee_filter.dart';
import 'package:time_attendance/screen/employee_tab_screen/temprorary_shift/shift_muster_grid.dart';
import 'package:time_attendance/screen/employee_tab_screen/temprorary_shift/tempShift_dialog_screen.dart';
import 'package:time_attendance/widget/reusable/button/custom_action_button.dart';
import 'package:time_attendance/widget/reusable/dialog/dialogbox.dart';
import 'package:time_attendance/widget/reusable/pagination/pagination_widget.dart';
import 'package:time_attendance/widget/reusable/tooltip/help_tooltip_button.dart';
import 'package:time_attendance/widgets/mtaToast.dart';

class TemporaryShiftScreen extends StatefulWidget {
  const TemporaryShiftScreen({super.key});

  @override
  State<TemporaryShiftScreen> createState() => _TemporaryShiftScreenState();
}

class _TemporaryShiftScreenState extends State<TemporaryShiftScreen> {
  final ShiftDetailsController shiftDetails = Get.put(ShiftDetailsController());
  final EmployeeSearchController employeeSearchController = Get.put(EmployeeSearchController());

  @override
void initState() {
  super.initState();
  
  // FIX: Move state modifications to a post-frame callback.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    // Set the search mode for this screen
    employeeSearchController.searchMode.value = EmployeeSearchMode.shiftMuster;
    // Clear previous search results
    employeeSearchController.hasSearched.value = false;
    employeeSearchController.shiftMusterList.clear();
  });
}
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shift Roster'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          CustomActionButton(
            label: 'Assign Shift',
            onPressed: () => _showTempShiftDialog(context),
          ),
          CustomActionButton(
            label: 'Add Filter',
            onPressed: () => _showFilterDialog(context),
            icon: Icons.filter_list),
          CustomActionButton(
            label: 'Download',
            onPressed: () {
              print('Download button pressed');
              final String defaultShiftName = shiftDetails.defaultShift.value?.ShiftName ?? 'N/A';
              employeeSearchController.generateAndDownloadCsv(defaultShiftName);
            },
            icon: Icons.download,),
          CustomActionButton(
            label: 'Upload',
            onPressed: () => {
              // pass arg of <SiftDetailsModel>[]
              employeeSearchController.uploadShiftMusterCsv()
              },
            icon: Icons.upload,
          ),
          const SizedBox(width: 8),
          HelpTooltipButton(
            tooltipMessage: 'Manage temporary shifts for employees in this section.',
            onTap: () => _showNotesDialog(context),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Notes Card
            // Card(
            //   margin: const EdgeInsets.only(bottom: 16.0),
            //   elevation: 2,
            //   child: Container(
            //     width: double.infinity,
            //     padding: const EdgeInsets.all(12.0),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         const Text('Notes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            //         const SizedBox(height: 12),
            //         Wrap(
            //           spacing: 24, runSpacing: 8,
            //           children: [
            //             _buildNoteText(Colors.blue[700]!, 'Temporary Shift', ' is shown in blue color'),
            //             _buildNoteText(Colors.orange[700]!, 'Regular Shift', ' is shown in orange color'),
            //             _buildNoteText(Colors.green[700]!, 'Auto Shift', ' (is also regular shift) is shown in green color'),
            //             const Text('• Temporary Shift will always get first priority.', style: TextStyle(fontWeight: FontWeight.w500)),
            //           ],
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            
            Expanded(
              child: ShiftMusterGrid(controller: employeeSearchController, 
                shiftDetails: shiftDetails,
            )),
            
            Obx(() {
                if (employeeSearchController.shiftMusterList.isNotEmpty) {
                  return PaginationWidget(
                    currentPage: employeeSearchController.currentPage.value + 1,
                    totalPages: (employeeSearchController.totalShiftMusterRecords.value / employeeSearchController.recordsPerPage.value).ceil(),
                    onFirstPage: () => employeeSearchController.goToPage(0),
                    onPreviousPage: employeeSearchController.previousPage,
                    onNextPage: employeeSearchController.nextPage,
                    onLastPage: () {
                      int lastPage = (employeeSearchController.totalShiftMusterRecords.value / employeeSearchController.recordsPerPage.value).ceil() - 1;
                      employeeSearchController.goToPage(lastPage);
                    },
                    onItemsPerPageChange: (value) {
                       employeeSearchController.updateRecordsPerPage(value);
                    },
                    itemsPerPage: employeeSearchController.recordsPerPage.value,
                    itemsPerPageOptions: const [10, 25, 50, 100],
                    totalItems: employeeSearchController.totalShiftMusterRecords.value,
                  );
                }
                return const SizedBox.shrink();
              }
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteText(Color color, String boldText, String normalText) {
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: [
          const TextSpan(text: '• '),
          TextSpan(text: boldText, style: TextStyle(color: color, fontWeight: FontWeight.w500)),
          TextSpan(text: normalText),
        ],
      ),
    );
  }

  void _showNotesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notes'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 24, runSpacing: 8,
                children: [
                  _buildNoteText(Colors.blue[700]!, 'Temporary Shift', ' is shown in blue color'),
                  _buildNoteText(Colors.orange[700]!, 'Regular Shift', ' is shown in orange color'),
                  _buildNoteText(Colors.green[700]!, 'Auto Shift', ' (is also regular shift) is shown in green color'),
                  const Text('• Temporary Shift will always get first priority.', style: TextStyle(fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => EmployeeFilterDialog(
        searchMode: EmployeeSearchMode.shiftMuster,
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
          await shiftDetails.fetchDefaultShift();
        },
      ),
    );  
  }
                
 void _showTempShiftDialog(BuildContext context) {
    // *** ADDED ***: Check if any employees are selected before showing the dialog
    if (employeeSearchController.selectedEmployeeIDs.isEmpty) {
      MTAToast().ShowToast('Please select at least one employee to assign a shift.');
      return;
    }
    
    showCustomDialog(
      context: context,
      dialogContent: [
        TempShiftDialog(
          controller: shiftDetails,
          employeeSearchController: employeeSearchController, // *** ADDED ***: Pass the controller
          selectedShift: null,
        ),
      ],
    );
  }
}