// inventory_main_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/data_enetry/inventry_controller.dart';
import 'package:time_attendance/controller/employee_tab_controller/emp_practice_controller.dart';
import 'package:time_attendance/model/dataEnetry/inventary_model.dart';
import 'package:time_attendance/screen/data_enetry/inventry_dialogbox.dart';
// import 'package:time_attendance/controller/master_tab_controller/inventory_controller.dart';
// import 'package:time_attendance/model/master_tab_model/inventory_model.dart';
import 'package:time_attendance/widget/reusable/button/custom_action_button.dart';
import 'package:time_attendance/widget/reusable/dialog/dialogbox.dart';
import 'package:time_attendance/widget/reusable/filter/filter.dart';
// import 'package:time_attendance/widget/reusable/list/reusable_list.dart';
import 'package:time_attendance/widget/reusable/pagination/pagination_widget.dart';
import 'package:time_attendance/widget/reusable/tooltip/help_tooltip_button.dart';
import 'package:time_attendance/widget/reusable/search/reusable_search_field.dart';

import '../../widget/reusable/devoice_table/devoice_table.dart';

class InventoryMainScreen extends StatelessWidget {
  InventoryMainScreen({Key? key}) : super(key: key);

  final InventoryController controller = Get.find<InventoryController>();
  final TextEditingController _searchController = TextEditingController();
   final EmployeePracticeController controller1 = Get.find<EmployeePracticeController>();
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
    _totalPages.value = (controller.filteredInventories.length / _itemsPerPage.value).ceil();
  }

  List<InventoryModel> _getPaginatedData() {
    final startIndex = (_currentPage.value - 1) * _itemsPerPage.value;
    final endIndex = startIndex + _itemsPerPage.value;
    if (startIndex >= controller.filteredInventories.length) return [];
    return controller.filteredInventories.sublist(
      startIndex,
      endIndex > controller.filteredInventories.length 
          ? controller.filteredInventories.length 
          : endIndex,
    );
  }

   Map<String, List<String>> getFilterOptions() {
    // Get all available options from controller
    final allOptions = controller1.filterOptions;
    
    // Create a new map with only the filters you want to show
    return {
      if (allOptions.containsKey('Department')) 
        'Department': allOptions['Department']!.map((option) => option.value).toList(),
      if (allOptions.containsKey('Designation')) 
        'Designation': allOptions['Designation']!.map((option) => option.value).toList(),
      if (allOptions.containsKey('Shift')) 
        'Shift': allOptions['Shift']!.map((option) => option.value).toList(),
        if (allOptions.containsKey('Branch')) 
        'Branch': allOptions['Branch']!.map((option) => option.value).toList(),
    };
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Management'),
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
           Obx(() => ExpandableFilter(
                  filterOptions: getFilterOptions(), // Use the custom filter options
                  onApplyFilters: (filters) {
                    // controller1.selectedDepartment.value = filters['Department'] ?? '';
                    // controller1.selectedDesignation.value = filters['Designation'] ?? '';
                    // controller1.selectedShift.value = filters['Shift'] ?? '';
                  },
                  onClearFilters: controller1.clearFilters,
                  isLoading: controller1.isLoading.value,
                )),
          const SizedBox(width: 8),
          CustomActionButton(
            label: 'Add Inventory',
            onPressed: () => _showInventoryDialog(context),
          ),
          const SizedBox(width: 8),
          HelpTooltipButton(
            tooltipMessage: 'Manage inventory items for your organization.',
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
                        final inventory = paginatedData[index];
                        return {
                          'Name': inventory.name ?? 'N/A',
                          'Laptop': inventory.laptop ?? 'N/A',
                          'Laptop Charger': inventory.laptopCharger ?? 'N/A',
                          'Mobile': inventory.mobile ?? 'N/A',
                          'Mobile Charger': inventory.mobileCharger ?? 'N/A',
                          'ID Card': inventory.idCard ?? 'N/A',
                          'Access Card': inventory.accessCard ?? 'N/A',
                          'Email ID': inventory.emailId ?? 'N/A',
                          'Record Update On': inventory.recordUpdateOn ?? 'N/A',
                          'By Senior': inventory.bySenior ?? 'N/A',
                          'By User Login': inventory.byUserLogin ?? 'N/A',
                          'Actions': 'Edit/Delete',
                        };
                      }),
                      headers: const [
                        'Name', 'Laptop', 'Laptop Charger', 'Mobile', 
                        'Mobile Charger', 'ID Card', 'Access Card', 
                        'Email ID', 'Record Update On', 'By Senior', 
                        'By User Login', 'Actions'
                      ],
                      visibleColumns: const [
                        'Name', 'Laptop', 'Laptop Charger', 'Mobile', 
                        'Mobile Charger', 'ID Card', 'Access Card', 
                        'Email ID', 'Record Update On', 'By Senior', 
                        'By User Login', 'Actions'
                      ],
                      onEdit: (row) {
                        final inventory = paginatedData.firstWhere(
                          (i) => i.name == row['Name'],
                        );
                        _showInventoryDialog(context, inventory);
                      },
                      onDelete: (row) {
                        final inventory = paginatedData.firstWhere(
                          (i) => i.name == row['Name'],
                          orElse: () => InventoryModel(),
                        );
                        if (inventory.inventoryId != null) {
                          _showDeleteConfirmationDialog(context, inventory);
                        }
                      },
                      onSort: (columnName, ascending) {
                        controller.sortInventories(columnName, ascending);
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
                    totalItems: controller.filteredInventories.length,
                  )),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showInventoryDialog(BuildContext context, [InventoryModel? inventory]) {
    showCustomDialog(
      context: context,
      dialogContent: [
        InventoryDialog(
          
        ),
      ],
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, InventoryModel inventory) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete ${inventory.name}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await controller.deleteInventory(inventory.inventoryId ?? '');
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

// Note: You'll need to create an InventoryDialog similar to BranchDialog

