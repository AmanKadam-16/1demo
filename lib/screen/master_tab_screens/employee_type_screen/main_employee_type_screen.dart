import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/master_tab_controller/emplyee_type_controller.dart';
import 'package:time_attendance/model/location_model/location_model.dart';
import 'package:time_attendance/model/master_tab_model/employee_type_model.dart';
import 'package:time_attendance/screen/master_tab_screens/employee_type_screen/employee_type_dialog.dart';
import 'package:time_attendance/services/master_excel_report.dart';
import 'package:time_attendance/services/master_pdf_report.dart';
import 'package:time_attendance/widget/reusable/alert/export_alert.dart';
import 'package:time_attendance/widget/reusable/button/custom_action_button.dart';
import 'package:time_attendance/widget/reusable/dialog/dialogbox.dart';
import 'package:time_attendance/widget/reusable/list/reusable_list.dart';
import 'package:time_attendance/widget/reusable/pagination/pagination_widget.dart';
import 'package:time_attendance/widget/reusable/tooltip/help_tooltip_button.dart';
import 'package:time_attendance/widget/reusable/search/reusable_search_field.dart';

class MainEmployeeTypeScreen extends StatelessWidget {
  MainEmployeeTypeScreen({super.key});

  final EmplyeeTypeController controller = Get.put(EmplyeeTypeController());
  final TextEditingController _searchController = TextEditingController();
  int _currentPage = 1;
  int _itemsPerPage = 10;
  int _totalPages = 1;

    void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ExportAlertDialog(
          onExport: (fileType) async {
            try {
              if (fileType == 'PDF') {
                // Call the PDF service
                await GenericPdfGeneratorService.generateSimplePdf<EmployeeTypeModel>(
                  data: controller.empTypeDetails,
                  headers: ['Employee Type Name'],
                  rowBuilder: (employeeType) => [
                    employeeType.employeeTypeName 
                  ],
                  reportTitle: 'Employee Type',
                );
              } else if (fileType == 'Excel') {
                await GenericExcelGeneratorService.generateExcel<EmployeeTypeModel>(
                  data: controller.empTypeDetails,
                  reportTitle: 'Employee Type Report',
                  headers: ['Employee Type Name'],
                  rowBuilder: (employeeType) => [
                    employeeType.employeeTypeName
                  ],
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
    // controller.fetchEmployeeTypes();
    controller.initializeAuthEmpType();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Types'),
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
            label: 'Add Employee Type',
            onPressed: () => _showEmployeeTypeDialog(context),
          ),
          CustomActionButton(
            label: 'Export',
            onPressed: () => _showExportDialog(context),
            icon: Icons.download,
          ),
          const SizedBox(width: 8),
          HelpTooltipButton(
            tooltipMessage: 'Manage employee types in this section.',
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

              return Column(
                children: [
                  Expanded(
                    child: ReusableTableAndCard(
                      data: List.generate(
                        controller.filteredEmployeeTypes.length,
                        (index) => {
                          'Employee Type': controller
                              .filteredEmployeeTypes[index].employeeTypeName,
                        },
                      ),
                      headers: ['Employee Type', 'Actions'],
                      visibleColumns: ['Employee Type', 'Actions'],
                      onEdit: (row) {
                        final employee =
                            controller.filteredEmployeeTypes.firstWhere(
                          (d) => d.employeeTypeName == row['Employee Type'],
                        );
                        _showEmployeeTypeDialog(context, employee);
                      },
                      onDelete: (row) {
                        final employee =
                            controller.filteredEmployeeTypes.firstWhere(
                          (d) => d.employeeTypeName == row['Employee Type'],
                        );
                        _showDeleteConfirmationDialog(context, employee);
                      },
                      onSort: (columnName, ascending) =>
                          controller.sortEmployeeTypes(columnName, ascending),
                    ),
                  ),
                  PaginationWidget(
                    currentPage: _currentPage,
                    totalPages: _totalPages,
                    onFirstPage: () => _handlePageChange(1),
                    onPreviousPage: () => _handlePageChange(_currentPage - 1),
                    onNextPage: () => _handlePageChange(_currentPage + 1),
                    onLastPage: () => _handlePageChange(_totalPages),
                    onItemsPerPageChange: _handleItemsPerPageChange,
                    itemsPerPage: _itemsPerPage,
                    itemsPerPageOptions: [10, 25, 50, 100],
                    totalItems: controller.filteredEmployeeTypes.length,
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showEmployeeTypeDialog(BuildContext context,
      [EmployeeTypeModel? employeeType]) {
    showCustomDialog(
      context: context,
      dialogContent: [
        EmployeeTypeDialog(
          controller: controller,
          employeeTypeModel: employeeType ??
              EmployeeTypeModel(
                // employeeTypeId: 0,
                employeeTypeName: '', employeeTypeId: '',
              ),
        ),
      ],
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, EmployeeTypeModel employeeType) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content:
              const Text('Are you sure you want to delete this employee type?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                controller.deleteEmployeeType(employeeType.employeeTypeId);
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

  void _handlePageChange(int page) {
    _currentPage = page;
    controller.update();
  }

  void _handleItemsPerPageChange(int itemsPerPage) {
    _itemsPerPage = itemsPerPage;
    _currentPage = 1;
    controller.update();
  }
}
