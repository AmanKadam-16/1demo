import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/employee_tab_controller/employee_search_controller.dart';
import 'package:time_attendance/model/employee_tab_model/employee_search_model.dart';
import 'package:time_attendance/model/master_tab_model/company_model.dart';
import 'package:time_attendance/model/master_tab_model/department_model.dart';
import 'package:time_attendance/model/master_tab_model/designation_model.dart';
import 'package:time_attendance/model/master_tab_model/employee_type_model.dart';
import 'package:time_attendance/model/master_tab_model/location_model.dart';
import 'package:time_attendance/widget/reusable/list/reusable_list.dart';
import 'package:time_attendance/widget/reusable/pagination/pagination_widget.dart';

// Change EmployeeSelectionDialog to StatefulWidget
class EmployeeSelectionDialog extends StatefulWidget {
  final Function(EmployeeView) onEmployeeSelected;
  bool triggerAutoSearch;

  EmployeeSelectionDialog({
    Key? key,
    required this.onEmployeeSelected,
    this.triggerAutoSearch = false
  }) : super(key: key);

  @override
  _EmployeeSelectionDialogState createState() =>
      _EmployeeSelectionDialogState();
}

class _EmployeeSelectionDialogState extends State<EmployeeSelectionDialog> {
  final EmployeeSearchController controller =
      Get.put(EmployeeSearchController());
  bool _showFilter = true;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Select Employee',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(_showFilter
                          ? Icons.filter_alt_off
                          : Icons.filter_alt),
                      tooltip: _showFilter ? 'Hide Filter' : 'Show Filter',
                      onPressed: () {
                        setState(() {
                          _showFilter = !_showFilter;
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Filter Form (toggle visibility)
            if (_showFilter) ...[
              EmployeeFilterForm(controller: controller),
              const SizedBox(height: 16),
            ],

            // Results Table
            Expanded(
              // height: 350, // Set your default height here
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!controller.hasSearched.value) {
                  return const Center(
                    child: Text('Use the search filters to find employees'),
                  );
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
                            'Employee ID': controller
                                    .filteredEmployees[index].employeeID ??
                                '',
                            'Name': controller
                                    .filteredEmployees[index].employeeName ??
                                '',
                            'Enroll ID':
                                controller.filteredEmployees[index].enrollID ??
                                    '',
                            'Actions': controller
                                    .filteredEmployees[index].employeeID ??
                                '',
                          },
                        ),
                        headers: [
                          'Employee ID',
                          'Name',
                          'Enroll ID',
                          'Actions'
                        ],
                        visibleColumns: [
                          'Employee ID',
                          'Name',
                          'Enroll ID',
                          'Actions'
                        ],
                        onEdit: (row) {
                          final employee =
                              controller.filteredEmployees.firstWhere(
                            (e) => e.employeeID == row['Employee ID'],
                          );
                          widget.onEmployeeSelected(employee);
                          Navigator.of(context).pop();
                        },
                        // actionIcon: Icons.check_circle_outline,
                        // actionTooltip: 'Select Employee',
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
                            1,
                      ),
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
      ),
    );
  }
}

class EmployeeFilterForm extends StatefulWidget {
  final EmployeeSearchController controller;

  const EmployeeFilterForm({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  _EmployeeFilterFormState createState() => _EmployeeFilterFormState();
}

class _EmployeeFilterFormState extends State<EmployeeFilterForm> {
  final TextEditingController employeeIdController = TextEditingController();
  final TextEditingController employeeNameController = TextEditingController();
  final TextEditingController enrollIdController = TextEditingController();

  String? selectedCompany;
  String? selectedDepartment;
  String? selectedLocation;
  String? selectedDesignation;
  String? selectedType;
  int selectedStatus = 1; // Default Active

  @override
  void dispose() {
    employeeIdController.dispose();
    enrollIdController.dispose();
    employeeNameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Initialize controllers and values
    employeeIdController.text =
        widget.controller.searchEmployeeView.value.employeeID ?? '';
    enrollIdController.text =
        widget.controller.searchEmployeeView.value.enrollID ?? '';
    employeeNameController.text =
        widget.controller.searchEmployeeView.value.employeeName ?? '';
    selectedStatus =
        widget.controller.searchEmployeeView.value.employeeStatus ?? 1;

    selectedCompany = '';
    selectedDepartment = '';
    selectedLocation = '';
    selectedDesignation = '';
    selectedType = '';
  }

  void _clearFilters() {
    setState(() {
      employeeIdController.clear();
      enrollIdController.clear();
      employeeNameController.clear();
      selectedCompany = '';
      selectedDepartment = '';
      selectedLocation = '';
      selectedDesignation = '';
      selectedType = '';
      selectedStatus = 1;
    });
  }

  void _applyFilters() {
    widget.controller.updateSearchFilter(
      employeeId: employeeIdController.text,
      enrollId: enrollIdController.text,
      employeeName: employeeNameController.text,
      companyId: selectedCompany,
      departmentId: selectedDepartment,
      locationId: selectedLocation,
      designationId: selectedDesignation,
      employeeTypeId: selectedType,
      employeeStatus: selectedStatus,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Row 1: Employee ID and Enroll ID
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    'Employee ID',
                    employeeIdController,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    'Enroll ID',
                    enrollIdController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Row 2: Employee Name
            _buildTextField(
              'Employee Name',
              employeeNameController,
            ),
            const SizedBox(height: 16),

            // Row 3: Company and Department
            Row(
              children: [
                Expanded(
                  child: Obx(() => _buildDropdown(
                        'Company',
                        selectedCompany,
                        widget.controller.branches.toList(),
                        (value) {
                          setState(() => selectedCompany = value);
                        },
                      )),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Obx(() => _buildDropdown(
                        'Department',
                        selectedDepartment,
                        widget.controller.departments.toList(),
                        (value) {
                          setState(() => selectedDepartment = value);
                        },
                      )),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Row 4: Location and Designation
            // Row(
            //   children: [
            //     Expanded(
            //       child: Obx(() => _buildDropdown(
            //         'Location',
            //         selectedLocation,
            //         widget.controller.locations,
            //         (value) {
            //           setState(() => selectedLocation = value);
            //         },
            //       )),
            //     ),
            //     const SizedBox(width: 16),
            //     Expanded(
            //       child: Obx(() => _buildDropdown(
            //         'Designation',
            //         selectedDesignation,
            //         widget.controller.designations.toList(),
            //         (value) {
            //           setState(() => selectedDesignation = value);
            //         },
            //       )),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 16),

            // Row 5: Employee Type and Status
            Row(
              children: [
                Expanded(
                  child: Obx(() => _buildDropdown(
                        'Employee Type',
                        selectedType,
                        widget.controller.employeeTypes.toList(),
                        (value) {
                          setState(() => selectedType = value);
                        },
                      )),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDropdown(
                    'Status',
                    selectedStatus.toString(),
                    ['1', '0'],
                    (value) {
                      setState(() => selectedStatus = int.parse(value!));
                    },
                    labelMap: {'1': 'Active', '0': 'Inactive'},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Row 6: Search and Clear buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: _clearFilters,
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: _applyFilters,
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
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String? value,
    List<dynamic> items,
    void Function(String?) onChanged, {
    Map<String, String>? labelMap,
  }) {
    List<DropdownMenuItem<String>> dropdownItems = [];

    try {
      final Set<String> usedValues = {};

      dropdownItems = items
          .map((item) {
            String itemValue;
            String itemLabel;

            if (item is DepartmentModel) {
              itemValue = item.departmentId;
              itemLabel = item.departmentName;
            } else if (item is DesignationModel) {
              itemValue = item.designationId;
              itemLabel = item.designationName;
            } else if (item is Location) {
              itemValue = item.locationID ?? '';
              itemLabel = item.locationName ?? '';
            } else if (item is BranchModel) {
              itemValue = item.branchId ?? '';
              itemLabel = item.branchName ?? '';
            } else if (item is EmployeeTypeModel) {
              itemValue = item.employeeTypeId;
              itemLabel = item.employeeTypeName;
            } else if (item is String) {
              itemValue = item;
              itemLabel = labelMap?[item] ?? item;
            } else {
              itemValue = item.toString();
              itemLabel = item.toString();
            }

            if (usedValues.contains(itemValue)) return null;
            usedValues.add(itemValue);

            return DropdownMenuItem<String>(
              value: itemValue,
              child: Text(itemLabel),
            );
          })
          .whereType<DropdownMenuItem<String>>()
          .toList();

      dropdownItems.insert(
          0,
          const DropdownMenuItem<String>(
            value: '',
            child: Text('All'),
          ));
    } catch (e) {
      print('Error building dropdown items for $label: $e');
      dropdownItems = [
        const DropdownMenuItem<String>(
          value: '',
          child: Text('All'),
        ),
      ];
    }

    bool valueExists =
        value == '' || dropdownItems.any((item) => item.value == value);
    String? effectiveValue = valueExists ? value : '';

    return DropdownButtonFormField<String>(
      value: effectiveValue,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: dropdownItems,
      onChanged: onChanged,
      isExpanded: true,
    );
  }
}
