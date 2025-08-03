// main_inventory_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/employee_tab_controller/employee_search_controller.dart';
import 'package:time_attendance/controller/master_tab_controller/department_controller.dart';
import 'package:time_attendance/controller/shift_tab_controller/shift_details_controller.dart';
import 'package:time_attendance/model/master_tab_model/department_model.dart';
import 'package:time_attendance/screen/data_entry_tab_screen/inventory_screen/inventory_dialog_screen.dart';
import 'package:time_attendance/screen/employee_tab_screen/employee_screen/employee_filter.dart';
import 'package:time_attendance/widget/reusable/button/custom_action_button.dart';
import 'package:time_attendance/widget/reusable/dialog/dialogbox.dart';
import 'package:time_attendance/widget/reusable/list/reusable_list.dart';
import 'package:time_attendance/widget/reusable/pagination/pagination_widget.dart';
import 'package:time_attendance/widget/reusable/tooltip/help_tooltip_button.dart';
import 'package:time_attendance/widget/reusable/search/reusable_search_field.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();

}

class _InventoryScreenState extends State<InventoryScreen> {
  final DepartmentController controller = Get.put(DepartmentController());
  final TextEditingController _searchController = TextEditingController();
  final ShiftDetailsController shiftDetails = Get.put(ShiftDetailsController());
  final EmployeeSearchController employeeController = Get.put(EmployeeSearchController());
  int _currentPage = 1;
  int _itemsPerPage = 10;
  final int _totalPages = 1;
  Set<String> selectedEmployees = {};

  @override
  Widget build(BuildContext context) {
    // controller.fetchDepartments();
    controller.initializeAuthDept();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
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
            label: 'Add Asset',
            onPressed: () => _showTempShiftDialog(context),
          ),
                    CustomActionButton(
              label: 'Add Filter',
              onPressed: () => _showFilterDialog(context),
              icon: Icons.filter_list),
              //   CustomActionButton(
              // label: 'Dowload',
              // onPressed: () => {},
              // icon: Icons.download,),
              // // upload
              // CustomActionButton(
              //   label: 'Upload',
              //   onPressed: () => {},
              //   icon: Icons.upload,
              // ),
          const SizedBox(width: 8),
          HelpTooltipButton(
            tooltipMessage: 'Manage inventory items and their details in this section.',
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
                          'Employee ID': controller.filteredDepartments[index].departmentId,
                          'Name': controller.filteredDepartments[index].departmentName,
                          'Laptop': 'No',  // Replace with actual data
                          'Mobile': 'No',  // Replace with actual data
                          'ID Card': 'Yes',  // Replace with actual data
                        },
                      ),
                      headers: const ['Employee ID', 'Name', 'Laptop', 'Mobile', 'ID Card', 'Actions'],
                      visibleColumns: const ['Employee ID', 'Name', 'Laptop', 'Mobile', 'ID Card', 'Actions'],
                      showCheckboxes: true,
                      selectedItems: selectedEmployees,
                      idField: 'Employee ID',
                      onSelectAll: (bool? value) {
                        setState(() {
                          if (value ?? false) {
                            selectedEmployees = controller.filteredDepartments
                                .map((dept) => dept.departmentId)
                                .toSet();
                          } else {
                            selectedEmployees.clear();
                          }
                        });
                      },
                      onSelectItem: (String id, bool selected) {
                        setState(() {
                          if (selected) {
                            selectedEmployees.add(id);
                          } else {
                            selectedEmployees.remove(id);
                          }
                        });
                      },
                      onDelete: (row) {
                        final department = controller.filteredDepartments.firstWhere(
                          (d) => d.departmentId == row['Employee ID'],
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

    void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => EmployeeFilterDialog(
        onClose: () => Navigator.of(context).pop(),
        onFilter: (filterData) {
          // Handle filter data
          employeeController.updateSearchFilter(
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

  void _showTempShiftDialog(BuildContext context) {
    showCustomDialog(
      context: context,
      dialogContent: [
        InventoryDialog(),
      ],
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, DepartmentModel department) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete the department "${department.departmentName}"?'),
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
    setState(() {
      _currentPage = page;
    });
  }

  void _handleItemsPerPageChange(int itemsPerPage) {
    setState(() {
      _itemsPerPage = itemsPerPage;
      _currentPage = 1;
    });
  }
}