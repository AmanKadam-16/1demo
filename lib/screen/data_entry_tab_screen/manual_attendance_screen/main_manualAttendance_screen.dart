import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/Data_entry_tab_controller/manaulAttendance_controller.dart';
import 'package:time_attendance/controller/shift_tab_controller/shift_details_controller.dart';
import 'package:time_attendance/model/Data_entry_tab_model/manualAttendance_model.dart';
import 'package:time_attendance/model/sfift_tab_model/shift_details_model.dart';
import 'package:time_attendance/screen/data_entry_tab_screen/manual_attendance_screen/manualAttendanceCreateApprove_dialog_screen.dart';
import 'package:time_attendance/widget/reusable/button/custom_action_button.dart';
import 'package:time_attendance/widget/reusable/dialog/dialogbox.dart';
import 'package:time_attendance/widget/reusable/dialog/employee_selection_dialog.dart';
import 'package:time_attendance/widget/reusable/list/reusable_list.dart';
import 'package:time_attendance/widget/reusable/tooltip/help_tooltip_button.dart';
import 'package:time_attendance/widget/reusable/search/reusable_search_field.dart';
import 'package:time_attendance/widget/reusable/pagination/pagination_widget.dart';

class ManualAttendanceCreateScreen extends StatefulWidget {
  const ManualAttendanceCreateScreen({super.key});

  @override
  State<ManualAttendanceCreateScreen> createState() =>
      _ManualAttendanceCreateScreenState();
}

class _ManualAttendanceCreateScreenState
    extends State<ManualAttendanceCreateScreen> {
  // ManualAttendanceController
  final ManualAttendanceController manualAttendanceController =
      Get.put(ManualAttendanceController());
  final ShiftDetailsController shiftDetailsController =
      Get.put(ShiftDetailsController());
  final TextEditingController _searchController = TextEditingController();
  final _currentPage = 1.obs;
  final _itemsPerPage = 10.obs;
  final _totalPages = 1.obs;

  // Observable variables for selected employee details
  final selectedEmpName = ''.obs;
  final selectedEmpId = ''.obs;
  final selectedDesignation = ''.obs;
  final selectedDepartment = ''.obs;
  final selectedCompany = ''.obs;
  final selectedLocation = ''.obs;

  // New observable variables for filters
  final selectedMonth = DateTime.now().month.obs;
  final selectedYear = DateTime.now().year.obs;
  final selectedStatus = 'Approved'.obs;

  // Lists for dropdowns
  final List<Map<String, dynamic>> months = [
    {'name': 'January', 'value': 1},
    {'name': 'February', 'value': 2},
    {'name': 'March', 'value': 3},
    {'name': 'April', 'value': 4},
    {'name': 'May', 'value': 5},
    {'name': 'June', 'value': 6},
    {'name': 'July', 'value': 7},
    {'name': 'August', 'value': 8},
    {'name': 'September', 'value': 9},
    {'name': 'October', 'value': 10},
    {'name': 'November', 'value': 11},
    {'name': 'December', 'value': 12},
  ];

  final List<String> statusList = [
    'Approved',
    'Pending',
    'Rejected',
  ];

  List<int> get years =>
      List.generate(61, (index) => 1995 + index); // 1995 to 2055

  void showEmployeeSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => EmployeeSelectionDialog(
        onEmployeeSelected: (selectedEmployee) {
          // Update all employee details
          selectedEmpName.value = selectedEmployee.employeeName ?? '';
          selectedEmpId.value = selectedEmployee.employeeID ?? '';
          selectedDesignation.value = selectedEmployee.designationName ?? '';
          selectedDepartment.value = selectedEmployee.departmentName ?? '';
          selectedCompany.value = selectedEmployee.companyName ?? '';
          selectedLocation.value = selectedEmployee.locationName ?? '';
        },
      ),
    );
  }

  void _showManualAttendanceDialog(BuildContext context,
      [ManualAttendanceModel? existingAttendance]) async {
    // If existingAttendance is not provided, try to fetch it
    final DateTime selectShiftDate =
        existingAttendance?.shiftDateTime ?? DateTime.now();
    if (selectedEmpId.value.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('No Employee Selected'),
            content: const Text('Please select at least one employee.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
      return;
    } else {
      await manualAttendanceController.getAttendanceRegularization(
        selectedEmpId.value,
        selectShiftDate,
      );
    }
    // selectedAttendanceRegularization
    ManualAttendanceModel? manualAttendance =
        manualAttendanceController.selectedAttendanceRegularization.value;
    List<SiftDetailsModel>? shiftDetailsList =
        shiftDetailsController.shifts;

    showCustomDialog(
      context: context,
      dialogContent: [
        ManualAttendanceDialog(
          employeeId: selectedEmpId.value,
          shiftDateTime: manualAttendance?.shiftDateTime ?? DateTime.now(),
          manualAttendance: manualAttendance,
          shiftDetailsList: shiftDetailsList,
          manualAttController: manualAttendanceController,
        ),
      ],
    );
  }

  void _handlePageChange(int page) {
    _currentPage.value = page;
    manualAttendanceController.update();
  }

  void _handleItemsPerPageChange(int itemsPerPage) {
    _itemsPerPage.value = itemsPerPage;
    _currentPage.value = 1;
    manualAttendanceController.update();
  }

  @override
  void dispose() {
    // Reset all selected employee details
    selectedEmpName.value = '';
    selectedEmpId.value = '';
    selectedDesignation.value = '';
    selectedDepartment.value = '';
    selectedCompany.value = '';
    selectedLocation.value = '';

    // Reset the controller state
    manualAttendanceController.resetState();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee's Regularization"),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (MediaQuery.of(context).size.width > 600)
            ReusableSearchField(
              searchController: _searchController,
              onSearchChanged: (value) =>
                  manualAttendanceController.updateSearchQuery(value),
            ),
          const SizedBox(width: 20),
          CustomActionButton(
              label: 'Select Employee',
              onPressed: () => showEmployeeSelectionDialog(context),
              icon: Icons.person_search),
          CustomActionButton(
            label: 'Add/Update',
            onPressed: () {
              _showManualAttendanceDialog(
                context,
              );
            },
          ),
          HelpTooltipButton(
            tooltipMessage:
                'Manage employee information and records in this section.',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Employee Details Card
          Obx(() => selectedEmpName.value.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 2,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 20,
                            runSpacing: 16,
                            children: [
                              _buildInfoItem('Employee Name',
                                  selectedEmpName.value, Icons.person, context),
                              _buildInfoItem(
                                  'Designation',
                                  selectedDesignation.value,
                                  Icons.work,
                                  context),
                              _buildInfoItem(
                                  'Department',
                                  selectedDepartment.value,
                                  Icons.business,
                                  context),
                              _buildInfoItem('Company', selectedCompany.value,
                                  Icons.apartment, context),
                              _buildInfoItem('Location', selectedLocation.value,
                                  Icons.location_on, context),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 20,
                            runSpacing: 16,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              // Month Dropdown
                              SizedBox(
                                width: 150,
                                child: Obx(() => DropdownButtonFormField<int>(
                                      decoration: const InputDecoration(
                                        labelText: 'Month',
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                      ),
                                      value: selectedMonth.value,
                                      items: months
                                          .map((month) => DropdownMenuItem<int>(
                                                value: month['value'],
                                                child: Text(month['name']),
                                              ))
                                          .toList(),
                                      onChanged: (value) =>
                                          selectedMonth.value = value!,
                                    )),
                              ),
                              // Year Dropdown
                              SizedBox(
                                width: 120,
                                child: Obx(() => DropdownButtonFormField<int>(
                                      decoration: const InputDecoration(
                                        labelText: 'Year',
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                      ),
                                      value: selectedYear.value,
                                      items: years
                                          .map((year) => DropdownMenuItem<int>(
                                                value: year,
                                                child: Text(year.toString()),
                                              ))
                                          .toList(),
                                      onChanged: (value) =>
                                          selectedYear.value = value!,
                                    )),
                              ),
                              // Status Dropdown
                              SizedBox(
                                width: 150,
                                child:
                                    Obx(() => DropdownButtonFormField<String>(
                                          decoration: const InputDecoration(
                                            labelText: 'Status',
                                            border: OutlineInputBorder(),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 8),
                                          ),
                                          value: selectedStatus.value,
                                          items: statusList
                                              .map((status) =>
                                                  DropdownMenuItem<String>(
                                                    value: status,
                                                    child: Text(status),
                                                  ))
                                              .toList(),
                                          onChanged: (value) =>
                                              selectedStatus.value = value!,
                                        )),
                              ),
                              // Search Button
                              ElevatedButton.icon(
                                onPressed: () async {
                                  // TODO: Implement search functionality
                                  manualAttendanceController.updateFilters(
                                    month: selectedMonth.value.toString(),
                                    year: selectedYear.value.toString(),
                                    status: selectedStatus.value,
                                    employeeId: selectedEmpId.value,
                                  );
                                },
                                icon: const Icon(Icons.search),
                                label: const Text('Search'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink()),
          if (MediaQuery.of(context).size.width <= 600)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ReusableSearchField(
                responsiveWidth: false,
                searchController: _searchController,
                onSearchChanged: (value) =>
                    manualAttendanceController.updateSearchQuery(value),
              ),
            ),
          Expanded(
            child: Obx(() {
              if (manualAttendanceController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              } // Check if employee is selected and no records found
              if (selectedEmpId.value.isNotEmpty &&
                  manualAttendanceController.manualAttendances.isEmpty) {
                return const Center(
                    child: Text('No records found for selected employee'));
              }

              // Check if no employee is selected
              if (selectedEmpId.value.isEmpty &&
                  manualAttendanceController.manualAttendances.isEmpty) {
                return const Center(
                    child:
                        Text('Please select an employee and perform search'));
              }

              return Column(
                children: [
                  Expanded(
                    child: ReusableTableAndCard(
                      data: List.generate(
                        manualAttendanceController
                            .filteredManualAttendances.length,
                        (index) {
                          final record = manualAttendanceController
                              .filteredManualAttendances[index];
                          return {
                            'Employee ID': record.employeeId,
                            'Employee Name': record.employeeName,
                            'Shift Date': record.shiftDate,
                            'ShiftDateTime': record.shiftDateTime.toString(),
                            'ShiftName': record.shiftName,
                            'Attendance Status': record.attendanceStatus
                                .toString()
                                .split('.')
                                .last,
                            'Present_FullDay':
                                record.attendanceFirstSession ? 'Yes' : 'No',
                            'Status': record.status.toString().split('.').last,
                            'BySenior': record.seniorEmployeeName,
                            'ByUserLogin': record.userLoginName,
                            'Actions': 'actions'
                          };
                        },
                      ),
                      headers: [
                        'Employee ID',
                        // 'Employee Name',
                        'Shift Date',
                        'ShiftDateTime',
                        'ShiftName',
                        'Attendance Status',
                        'Present_FullDay',
                        // 'Status',
                        'BySenior',
                        'ByUserLogin',
                        'Actions'
                      ],
                      visibleColumns: [
                        'Employee ID',
                        // 'Employee Name',
                        'Shift Date',
                        'ShiftName',
                        'Attendance Status',
                        'Present_FullDay',
                        // 'Status',
                        'BySenior',
                        'ByUserLogin',
                        'Actions'
                      ],
                      onEdit: (row) async {
                        // TODO: Implement edit functionality
                        _showManualAttendanceDialog(
                          context,
                          manualAttendanceController.filteredManualAttendances
                              .firstWhere(
                            (attendance) =>
                                attendance.employeeId == row['Employee ID'] &&
                                attendance.shiftDateTime.toString() ==
                                    row['ShiftDateTime'],
                          ),
                        );
                      },
                      onDelete: (row) {
                        // TODO: Implement delete functionality
                        _showDeleteConfirmationDialog(
                          context,
                          manualAttendanceController.filteredManualAttendances
                              .firstWhere(
                            (attendance) =>
                                attendance.employeeId == row['Employee ID'] &&
                                attendance.shiftDate == row['Shift Date'],
                          ),
                        );
                        () => {};
                      },
                      onSort: (columnName, ascending) =>
                          manualAttendanceController.sortManualAttendances(
                              columnName, ascending),
                    ),
                  ),
                  Obx(() => PaginationWidget(
                        currentPage: _currentPage.value,
                        totalPages: _totalPages.value,
                        onFirstPage: () => _handlePageChange(1),
                        onPreviousPage: () =>
                            _handlePageChange(_currentPage.value - 1),
                        onNextPage: () =>
                            _handlePageChange(_currentPage.value + 1),
                        onLastPage: () => _handlePageChange(_totalPages.value),
                        onItemsPerPageChange: _handleItemsPerPageChange,
                        itemsPerPage: _itemsPerPage.value,
                        itemsPerPageOptions: const [10, 25, 50, 100],
                        totalItems: manualAttendanceController
                            .filteredManualAttendances.length,
                      )),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, ManualAttendanceModel manualAttendance) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text(
              'Are you sure you want to delete the Regularization record for "${manualAttendance.employeeName}" on ${manualAttendance.shiftDate}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                // deleteAttendance(String employeeId, DateTime shiftDate)
                final success =
                    await manualAttendanceController.deleteAttendance(
                  manualAttendance.employeeId,
                  manualAttendance.shiftDateTime,
                );
                if (success) {
                  manualAttendanceController.updateFilters(
                    month: selectedMonth.value.toString(),
                    year: selectedYear.value.toString(),
                    status: selectedStatus.value,
                    employeeId: selectedEmpId.value,
                  );
                }
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon, context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 200),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  value.isEmpty ? 'N/A' : value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
