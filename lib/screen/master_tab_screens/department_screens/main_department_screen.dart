// main_department_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/master_tab_controller/department_controller.dart';
import 'package:time_attendance/model/master_tab_model/department_model.dart';
import 'package:time_attendance/screen/master_tab_screens/department_screens/department_dialog_screen.dart';
import 'package:time_attendance/services/master_excel_report.dart';
import 'package:time_attendance/services/master_pdf_report.dart';
import 'package:time_attendance/widget/reusable/alert/export_alert.dart';
import 'package:time_attendance/widget/reusable/button/custom_action_button.dart';
import 'package:time_attendance/widget/reusable/dialog/dialogbox.dart';
import 'package:time_attendance/widget/reusable/list/reusable_list.dart';
import 'package:time_attendance/widget/reusable/pagination/pagination_widget.dart';
import 'package:time_attendance/widget/reusable/tooltip/help_tooltip_button.dart';
import 'package:time_attendance/widget/reusable/search/reusable_search_field.dart';

class MainDepartmentScreen extends StatelessWidget {
  MainDepartmentScreen({super.key});

  final DepartmentController controller = Get.put(DepartmentController());
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
                await GenericPdfGeneratorService.generateGroupedPdf<
                    DepartmentModel>(
                  data: controller.filteredDepartments,
                  groupBy: (department) => department.masterDepartmentName,
                  rowBuilder: (department) => [department.departmentName],
                  headers: ['Department'],
                  reportTitle: 'Department Report',
                  masterText: 'Master Department :',
                );
              } else if (fileType == 'Excel') {
                await GenericExcelGeneratorService.generateGroupedExcel<
                    DepartmentModel>(
                  data: controller.filteredDepartments,
                  reportTitle: 'Department Report',
                  headers: ['Department', 'Master Department'],
                  rowBuilder: (department) => [
                    department.departmentName,
                    department.masterDepartmentName
                  ],
                  groupBy: (department) => department.masterDepartmentName,
                  masterText: 'Master Department:',
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
    // controller.fetchDepartments();
    controller.initializeAuthDept();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Department'),
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
            label: 'Add Department',
            onPressed: () => _showDepartmentDialog(context),
          ),
          CustomActionButton(
            label: 'Export',
            onPressed: () => _showExportDialog(context),
            icon: Icons.download,
          ),
          const SizedBox(width: 8),
          HelpTooltipButton(
            tooltipMessage:
                'Manage departments and their hierarchies in this section.',
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
                        controller.filteredDepartments.length,
                        (index) => {
                          'Department': controller
                              .filteredDepartments[index].departmentName,
                          'Master Department': controller
                              .filteredDepartments[index].masterDepartmentName,
                        },
                      ),
                      headers: [
                        'Department',
                        'Master Department',
                        'Actions'
                      ],
                      visibleColumns: [
                        'Department',
                        'Master Department',
                        'Actions'
                      ],
                      onEdit: (row) {
                        final department =
                            controller.filteredDepartments.firstWhere(
                          (d) => d.departmentName == row['Department'],
                        );
                        _showDepartmentDialog(context, department);
                      },
                      onDelete: (row) {
                        final department =
                            controller.filteredDepartments.firstWhere(
                          (d) => d.departmentName == row['Department'],
                        );
                        _showDeleteConfirmationDialog(context, department);
                      },
                      onSort: (columnName, ascending) =>
                          controller.sortDepartments(columnName, ascending),
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
                    totalItems: controller.filteredDepartments.length,
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showDepartmentDialog(BuildContext context,
      [DepartmentModel? department]) {
    showCustomDialog(
      context: context,
      dialogContent: [
        DepartmentDialog(
          controller: controller,
          department: department ?? DepartmentModel(),
        ),
      ],
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, DepartmentModel department) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text(
              'Are you sure you want to delete the department "${department.departmentName}"?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                controller.deleteDepartment(department.departmentId);
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