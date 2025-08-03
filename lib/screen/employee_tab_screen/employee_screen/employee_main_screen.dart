import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/employee_tab_controller/employee_search_controller.dart';
import 'package:time_attendance/controller/employee_tab_controller/emplyoee_controller.dart';
import 'package:time_attendance/model/employee_tab_model/employee_complete_model.dart';
import 'package:time_attendance/model/employee_tab_model/employee_search_model.dart';
import 'package:time_attendance/widget/reusable/button/custom_action_button.dart';
import 'package:time_attendance/widget/reusable/dialog/employee_selection_dialog.dart';
import 'package:time_attendance/widget/reusable/list/reusable_list.dart';
import 'package:time_attendance/widget/reusable/tooltip/help_tooltip_button.dart';
import 'package:time_attendance/widget/reusable/search/reusable_search_field.dart';
import 'package:time_attendance/widget/reusable/pagination/pagination_widget.dart';
import 'package:time_attendance/screen/employee_tab_screen/employee_screen/employee_form_screen.dart';
import 'package:time_attendance/screen/employee_tab_screen/employee_screen/employee_filter.dart';
import 'package:time_attendance/widgets/mtaToast.dart';

class MainEmployeeScreen extends StatelessWidget {
  MainEmployeeScreen({super.key});

  final EmployeeSearchController controller =
      Get.put(EmployeeSearchController());

  final EmployeeController employeeController = Get.put(EmployeeController());
  final TextEditingController _searchController = TextEditingController();
  void showEmployeeSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => EmployeeSelectionDialog(
        onEmployeeSelected: (selectedEmployee) {
          // Handle the selected employee here
          print('Selected Employee ID: ${selectedEmployee.employeeID}');
          print('Selected Employee Name: ${selectedEmployee.employeeName}');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employees'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          if (MediaQuery.of(context).size.width > 600)
            ReusableSearchField(
              searchController: _searchController,
              onSearchChanged: (value) =>
                  controller.updateSearchFilter(employeeName: value),
            ),
          const SizedBox(width: 20),
          CustomActionButton(
              label: 'Add Filter',
              onPressed: () => _showFilterDialog(context),
              icon: Icons.filter_list),
          CustomActionButton(
            label: 'Add Employee',
            onPressed: () {
              //  showEmployeeSelectionDialog(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EmployeeForm()),
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
          if (MediaQuery.of(context).size.width <= 600)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ReusableSearchField(
                responsiveWidth: false,
                searchController: _searchController,
                onSearchChanged: (value) =>
                    controller.updateSearchFilter(employeeName: value),
              ),
            ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!controller.hasSearched.value) {
                return const Center(
                    child: Text(
                        'Use the search or filter options to find employees'));
              }

              if (controller.filteredEmployees.isEmpty) {
                return const Center(child: Text('No employees found'));
              }

              return Column(
                children: [
                  Expanded(
                    child: ReusableTableAndCard(
                      data: List.generate(
                        controller.filteredEmployees.length,
                        (index) => {
                          'Employee ID':
                              controller.filteredEmployees[index].employeeID ??
                                  '',
                          'Name': controller
                                  .filteredEmployees[index].employeeName ??
                              '',
                          'Enroll ID':
                              controller.filteredEmployees[index].enrollID ??
                                  '',
                          'Company':
                              controller.filteredEmployees[index].companyName ??
                                  '',
                          'Department': controller
                                  .filteredEmployees[index].departmentName ??
                              '',
                          'Designation': controller
                                  .filteredEmployees[index].designationName ??
                              '',
                          'Type': controller
                                  .filteredEmployees[index].employeeType ??
                              '',
                        },
                      ),
                      headers: [
                        'Employee ID',
                        'Name',
                        'Enroll ID',
                        'Company',
                        'Department',
                        'Designation',
                        'Type',
                        'Actions'
                      ],
                      visibleColumns: [
                        'Employee ID',
                        'Name',
                        'Enroll ID',
                        'Company',
                        'Department',
                        'Designation',
                        'Type',
                        'Actions'
                      ],
                      onEdit: (row) async {
                        final employeeId = row['Employee ID'] ?? '';
                        if (employeeId.isNotEmpty) {
                          try {
                            final employee = await employeeController
                                .getEmployeeDetailsById(employeeId);
                            if (employee.employeeProfessional != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EmployeeForm(employee: employee),
                                ),
                              );
                            }
                          } catch (e) {
                            MTAToast().ShowToast(
                                'Error loading employee details: ${e.toString()}');
                          }
                        }
                      },
                      onDelete: (row) {
                        final employee =
                            controller.filteredEmployees.firstWhere(
                          (e) => e.employeeID == row['Employee ID'],
                        );
                        _showDeleteConfirmationDialog(context, employee);
                      },
                      onSort: (columnName, ascending) =>
                          controller.sortEmployees(columnName, ascending),
                    ),
                  ),
                  PaginationWidget(
                    currentPage: controller.currentPage.value + 1,
                    totalPages: (controller.totalRecords.value /
                            controller.recordsPerPage.value)
                        .ceil(),
                    onFirstPage: () => controller.goToPage(0),
                    onPreviousPage: () => controller.previousPage(),
                    onNextPage: () => controller.nextPage(),
                    onLastPage: () => controller.goToPage(
                        (controller.totalRecords.value /
                                    controller.recordsPerPage.value)
                                .ceil() -
                            1),
                    onItemsPerPageChange: (value) =>
                        controller.updateRecordsPerPage(value),
                    itemsPerPage: controller.recordsPerPage.value,
                    itemsPerPageOptions: const [10, 25, 50, 100],
                    totalItems: controller.totalRecords.value,
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    controller.searchMode.value = EmployeeSearchMode.employee;
    showDialog(
      context: context,
      builder: (context) => EmployeeFilterDialog(
        onClose: () => Navigator.of(context).pop(),
        onFilter: (filterData) {
          // Handle filter data
          controller.updateSearchFilter(
            employeeId: filterData['employeeId'] as String?,
            enrollId: filterData['enrollId'] as String?,
            employeeName: filterData['employeeName'] as String?,
            companyId: filterData['companyId'] as String?,
            departmentId: filterData['departmentId'] as String?,
            locationId: filterData['locationId'] as String?,
            designationId: filterData['designationId'] as String?,
            employeeTypeId: filterData['employeeTypeId'] as String?,
            employeeStatus: filterData['employeeStatus'] as int?,
          );
        },
      ),
    );  
  }
}

void _showDeleteConfirmationDialog(
    BuildContext context, EmployeeView employee) {
  final EmployeeController employeeController = Get.find<EmployeeController>();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text(employee.employeeStatus == 1
            ? 'Are you sure you want to mark "${employee.employeeName}" as "Inactive"?'
            : 'Are you sure you want to delete the employee "${employee.employeeName}"?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              // EmployeeProfessional
              final EmployeeProfessional employeeProfessionalObj =
                  EmployeeProfessional(
                enrollID: employee.enrollID ?? '',
                employeeID: employee.employeeID ?? '',
                employeeName: employee.employeeName ?? '',
                companyID: employee.companyID ?? '',
                departmentID: employee.departmentID ?? '',
                designationID: employee.designationID ?? '',
                locationID: employee.locationID ?? '',
                employeeTypeID: employee.employeeTypeID ?? '',
                employeeType: employee.employeeType ?? '',
                empStatus: employee.employeeStatus ?? 1,
                dateOfEmployment: employee.dateOfEmployment ?? '',
                dateOfLeaving: '',
                seniorEmployeeID: employee.seniorEmployeeID ?? '',
                emailID: employee.emailID ?? '',
              );
              employeeController.deleteEmployee(employeeProfessionalObj);
              Navigator.of(context).pop();
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

// FilterDialogContent moved to employee_filter.dart
