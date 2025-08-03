// main_company_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/master_tab_controller/company_controller.dart';
import 'package:time_attendance/model/master_tab_model/company_model.dart';
import 'package:time_attendance/screen/master_tab_screens/company_screens/company_dialog_screen.dart';
import 'package:time_attendance/services/master_excel_report.dart';
import 'package:time_attendance/services/master_pdf_report.dart';
import 'package:time_attendance/widget/reusable/alert/export_alert.dart';
import 'package:time_attendance/widget/reusable/button/custom_action_button.dart';
import 'package:time_attendance/widget/reusable/dialog/dialogbox.dart';
import 'package:time_attendance/widget/reusable/list/reusable_list.dart';
import 'package:time_attendance/widget/reusable/pagination/pagination_widget.dart';
import 'package:time_attendance/widget/reusable/tooltip/help_tooltip_button.dart';
import 'package:time_attendance/widget/reusable/search/reusable_search_field.dart';

class MainCompanyScreen extends StatelessWidget {
  MainCompanyScreen({Key? key}) : super(key: key);

  final BranchController controller = Get.put(BranchController());
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
    _totalPages.value = (controller.filteredBranches.length / _itemsPerPage.value).ceil();
  }

  List<BranchModel> _getPaginatedData() {
    final startIndex = (_currentPage.value - 1) * _itemsPerPage.value;
    final endIndex = startIndex + _itemsPerPage.value;
    if (startIndex >= controller.filteredBranches.length) return [];
    return controller.filteredBranches.sublist(
      startIndex,
      endIndex > controller.filteredBranches.length 
          ? controller.filteredBranches.length 
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
                // Call the PDF service
                await GenericPdfGeneratorService.generateGroupedPdf<
                    BranchModel>(
                  data: controller.filteredBranches,
                  groupBy: (branch) => branch.masterBranch ?? '',
                  rowBuilder: (branch) => [branch.branchName ?? ''],
                  headers: ['Branch Name'],
                  reportTitle: 'Branch Report',
                  masterText: 'Master Branch :',
                );
              } else if (fileType == 'Excel') {
                await GenericExcelGeneratorService.generateGroupedExcel<
                    BranchModel>(
                  data: controller.filteredBranches,
                  reportTitle: 'Branch Report',
                  headers: ['Branch Name', 'Master Branch'],
                  rowBuilder: (branch) => [
                    branch.branchName ?? '',
                    branch.masterBranch ?? '',
                  ],
                  groupBy: (branch) => branch.masterBranch ?? '',
                  masterText: 'Master Branch:',
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
    controller.initializeAuthBranch();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Branches'),
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
            label: 'Add Branch',
            onPressed: () => _showBranchDialog(context),
          ),
          CustomActionButton(
            label: 'Export',
            onPressed: () => _showExportDialog(context),
            icon: Icons.download,
          ),
          const SizedBox(width: 8),
          HelpTooltipButton(
            tooltipMessage: 'Manage branches for your organization in this section.',
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
                        final branch = paginatedData[index];
                        return {
                          'Branch Name': branch.branchName?.isEmpty == true ? 'N/A' : branch.branchName ?? 'N/A',
                          'Address': branch.address?.isEmpty == true ? 'N/A' : branch.address ?? 'N/A',
                          'Contact': branch.contact?.isEmpty == true ? 'N/A' : branch.contact ?? 'N/A',
                          'Website': branch.website?.isEmpty == true ? 'N/A' : branch.website ?? 'N/A',
                          'Master Branch': branch.masterBranch?.isEmpty == true ? 'N/A' : branch.masterBranch ?? 'N/A',
                          'Actions': 'Edit/Delete',
                        };
                      }),
                      headers: const [
                        'Branch Name',
                        'Address',
                        'Contact',
                        'Website',
                        'Master Branch',
                        'Actions'
                      ],
                      visibleColumns: const [
                        'Branch Name',
                        'Address',
                        'Contact',
                        'Website',
                        'Master Branch',
                        'Actions'
                      ],
                      onEdit: (row) {
                        final branch = paginatedData.firstWhere(
                          (b) => b.branchName == row['Branch Name'],
                        );
                        _showBranchDialog(context, branch);
                      },
                      onDelete: (row) {
                        final branch = paginatedData.firstWhere(
                          (b) => b.branchName == row['Branch Name'],
                          orElse: () => BranchModel(),
                        );
                        if (branch.branchId != null) {
                          _showDeleteConfirmationDialog(context, branch);
                        }
                      },
                      onSort: (columnName, ascending) {
                        controller.sortBranches(columnName, ascending);
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
                    totalItems: controller.filteredBranches.length,
                  )),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showBranchDialog(BuildContext context, [BranchModel? branch]) {
    showCustomDialog(
      context: context,
      dialogContent: [
        BranchDialog(
          controller: controller,
          branch: branch ?? BranchModel(),
        ),
      ],
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, BranchModel branch) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete ${branch.branchName}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await controller.deleteBranch(branch.branchId ?? '');
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