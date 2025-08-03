import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/master_tab_controller/designation_controller.dart';
import 'package:time_attendance/model/master_tab_model/designation_model.dart';
import 'package:time_attendance/screen/master_tab_screens/designation_screens/designation_dialog_screen.dart';
import 'package:time_attendance/services/master_excel_report.dart';
import 'package:time_attendance/services/master_pdf_report.dart';
import 'package:time_attendance/widget/reusable/button/custom_action_button.dart';
import 'package:time_attendance/widget/reusable/dialog/dialogbox.dart';
import 'package:time_attendance/widget/reusable/list/reusable_list.dart';
import 'package:time_attendance/widget/reusable/pagination/pagination_widget.dart';
import 'package:time_attendance/widget/reusable/tooltip/help_tooltip_button.dart';
import 'package:time_attendance/widget/reusable/search/reusable_search_field.dart';
import 'package:time_attendance/widget/reusable/alert/export_alert.dart';

class MainDesignationScreen extends StatelessWidget {
  MainDesignationScreen({super.key});

  final DesignationController controller = Get.put(DesignationController());
  final TextEditingController _searchController = TextEditingController();
  // Make these observable
  final _currentPage = 1.obs;
  final _itemsPerPage = 10.obs;

  // Calculate total pages based on filtered items
  int get _totalPages {
    return (controller.filteredDesignations.length / _itemsPerPage.value)
        .ceil();
  }

  // Get paginated items
  List<DesignationModel> get _paginatedItems {
    final startIndex = (_currentPage.value - 1) * _itemsPerPage.value;
    final endIndex = startIndex + _itemsPerPage.value;
    return controller.filteredDesignations.sublist(
        startIndex,
        endIndex > controller.filteredDesignations.length
            ? controller.filteredDesignations.length
            : endIndex);
  }

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
                    DesignationModel>(
                  data: controller.filteredDesignations,
                  groupBy: (designation) => designation.masterDesignationName,
                  rowBuilder: (designation) => [designation.designationName],
                  headers: ['Designation'],
                  reportTitle: 'Designation Report',
                  masterText: 'Master Designation :',
                );
              } else if (fileType == 'Excel') {
                await GenericExcelGeneratorService.generateGroupedExcel<
                    DesignationModel>(
                  data: controller.filteredDesignations,
                  reportTitle: 'Designation Report',
                  headers: ['Designation', 'Master Designation'],
                  rowBuilder: (designation) => [
                    designation.designationName,
                    designation.masterDesignationName
                  ],
                  groupBy: (designation) => designation.masterDesignationName,
                  masterText: 'Master Designation:',
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
    // Ensure designations are fetched every time the screen is opened
    // controller.fetchDesignations();
    controller.initializeAuthDesignation();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Designation'),
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
            label: 'Add Designation',
            onPressed: () => _showDesignationDialog(context),
          ),
          CustomActionButton(
            label: 'Export',
            onPressed: () => _showExportDialog(context),
            icon: Icons.download,
          ),
          const SizedBox(width: 8),
          HelpTooltipButton(
            tooltipMessage:
                'Manage designations for employees or roles in this section.',
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
                        _paginatedItems.length,
                        (index) => {
                          'Designation':
                              _paginatedItems[index].designationName.isEmpty
                                  ? 'N/A'
                                  : _paginatedItems[index].designationName,
                          'Master Designation': _paginatedItems[index]
                                  .masterDesignationName
                                  .isEmpty
                              ? 'N/A'
                              : _paginatedItems[index].masterDesignationName,
                        },
                      ),
                      headers: [
                        'Designation',
                        'Master Designation',
                        'Actions'
                      ],
                      visibleColumns: [
                        'Designation',
                        'Master Designation',
                        'Actions'
                      ],
                      onEdit: (row) {
                        final designation =
                            controller.filteredDesignations.firstWhere(
                          (d) => d.designationName == row['Designation'],
                        );
                        _showDesignationDialog(context, designation);
                      },
                      onDelete: (row) {
                        final designation =
                            controller.filteredDesignations.firstWhere(
                          (d) => d.designationName == row['Designation'],
                        );
                        _showDeleteConfirmationDialog(context, designation);
                      },
                      onSort: (columnName, ascending) =>
                          controller.sortDesignations(columnName, ascending),
                    ),
                  ),
                  Obx(() => PaginationWidget(
                        currentPage: _currentPage.value,
                        totalPages: _totalPages,
                        onFirstPage: () => _handlePageChange(1),
                        onPreviousPage: () =>
                            _handlePageChange(_currentPage.value - 1),
                        onNextPage: () =>
                            _handlePageChange(_currentPage.value + 1),
                        onLastPage: () => _handlePageChange(_totalPages),
                        onItemsPerPageChange: _handleItemsPerPageChange,
                        itemsPerPage: _itemsPerPage.value,
                        itemsPerPageOptions: [10, 25, 50, 100],
                        totalItems: controller.filteredDesignations.length,
                      )),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showDesignationDialog(BuildContext context,
      [DesignationModel? designation]) {
    showCustomDialog(
      context: context,
      dialogContent: [
        DesignationDialog(
          controller: controller,
          designation: designation ?? DesignationModel(),
        ),
      ],
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, DesignationModel designation) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content:
              const Text('Are you sure you want to delete this designation?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                controller.deleteDesignation(designation.designationId);
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
    if (page < 1) page = 1;
    if (page > _totalPages) page = _totalPages;
    _currentPage.value = page;
  }

  void _handleItemsPerPageChange(int itemsPerPage) {
    _itemsPerPage.value = itemsPerPage;
    _currentPage.value = 1;
  }
}
