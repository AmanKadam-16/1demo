import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/employee_tab_controller/employee_search_controller.dart';
import 'package:time_attendance/model/master_tab_model/company_model.dart';
import 'package:time_attendance/model/master_tab_model/department_model.dart';
import 'package:time_attendance/model/master_tab_model/designation_model.dart';
import 'package:time_attendance/model/master_tab_model/employee_type_model.dart';
import 'package:time_attendance/model/master_tab_model/location_model.dart';

class EmployeeFilterDialog extends StatelessWidget {
  final Function()? onClose;
  final Function(Map<String, dynamic>)? onFilter;
  final EmployeeSearchMode searchMode;

  const EmployeeFilterDialog({
    Key? key,
    this.onClose,
    this.onFilter,
    this.searchMode = EmployeeSearchMode.employee,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: const EdgeInsets.fromLTRB(24, 16, 8, 0),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Filter Employees'),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: onClose ?? () => Navigator.of(context).pop(),
              iconSize: 24,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: FilterDialogContent(
          onFilter: onFilter,
          searchMode: searchMode,
        ),
      ),
    );
  }
}

class FilterDialogContent extends StatefulWidget {
  final Function(Map<String, dynamic>)? onFilter;
  final EmployeeSearchMode searchMode;

  const FilterDialogContent({
    Key? key,
    this.onFilter,
    this.searchMode = EmployeeSearchMode.employee,
  }) : super(key: key);

  @override
  FilterDialogContentState createState() => FilterDialogContentState();
}

class FilterDialogContentState extends State<FilterDialogContent> {
  final EmployeeSearchController controller = Get.find();

  // Text editing controllers
  final TextEditingController employeeIdController = TextEditingController();
  final TextEditingController enrollIdController = TextEditingController();
  final TextEditingController employeeNameController = TextEditingController();

  // Selected values
  String? selectedCompany;
  String? selectedDepartment;
  String? selectedLocation;
  String? selectedDesignation;
  String? selectedType;
  int selectedStatus = 1; // Default Active
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _initializeValues();
  }

  void _initializeValues() {
    // Initialize text controllers with current filter values if any
    employeeIdController.text = controller.searchEmployeeView.value.employeeID ?? '';
    enrollIdController.text = controller.searchEmployeeView.value.enrollID ?? '';
    employeeNameController.text = controller.searchEmployeeView.value.employeeName ?? '';
    selectedStatus = controller.searchEmployeeView.value.employeeStatus ?? 1;

    // Initialize dropdown values with empty string as default
    selectedCompany = '';
    selectedDepartment = '';
    selectedLocation = '';
    selectedDesignation = '';
    selectedType = '';

    // Set values from searchEmployeeView if they exist
    if (controller.searchEmployeeView.value.departmentID?.isNotEmpty == true) {
      selectedDepartment = controller.searchEmployeeView.value.departmentID;
    }
    if (controller.searchEmployeeView.value.designationID?.isNotEmpty == true) {
      selectedDesignation = controller.searchEmployeeView.value.designationID;
    }
  }

  void _handleFilter() {
    final filterData = {
      'employeeId': employeeIdController.text,
      'enrollId': employeeIdController.text,
      'employeeName': employeeNameController.text,
      'companyId': selectedCompany,
      'departmentId': selectedDepartment,
      'locationId': selectedLocation,
      'designationId': selectedDesignation,
      'employeeTypeId': selectedType,
      'employeeStatus': selectedStatus,
    };
    if (widget.searchMode == EmployeeSearchMode.shiftMuster || widget.searchMode == EmployeeSearchMode.weeklyOff) {
      final startDate = DateTime(selectedYear, selectedMonth, 1);
      final endDate = DateTime(selectedYear, selectedMonth + 1, 0);
      filterData['shiftStartDate'] = "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-01";
      filterData['shiftEndDate'] = "${endDate.year.toString().padLeft(4, '0')}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}";
    }
    if (widget.onFilter != null) {
      widget.onFilter!(filterData);
    }
    controller.updateSearchFilter(
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
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.searchMode == EmployeeSearchMode.shiftMuster || widget.searchMode == EmployeeSearchMode.weeklyOff)
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: DropdownButtonFormField<int>(
                      value: selectedMonth,
                      decoration: const InputDecoration(
                        labelText: 'Month',
                        border: OutlineInputBorder(),
                      ),
                      items: List.generate(12, (i) => DropdownMenuItem(
                        value: i + 1,
                        child: Text([
                          'January', 'February', 'March', 'April', 'May', 'June',
                          'July', 'August', 'September', 'October', 'November', 'December'
                        ][i]),
                      )),
                      onChanged: (val) => setState(() => selectedMonth = val ?? DateTime.now().month),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: DropdownButtonFormField<int>(
                      value: selectedYear,
                      decoration: const InputDecoration(
                        labelText: 'Year',
                        border: OutlineInputBorder(),
                      ),
                      items: List.generate(10, (i) {
                        int year = DateTime.now().year - 5 + i;
                        return DropdownMenuItem(
                          value: year,
                          child: Text(year.toString()),
                        );
                      }),
                      onChanged: (val) => setState(() => selectedYear = val ?? DateTime.now().year),
                    ),
                  ),
                ),
              ],
            ),

          // Row 1: Company and Department
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Obx(() {
                    final companies = controller.branches;
                    return _buildDropdown(
                      'Company',
                      selectedCompany,
                      companies.toList(),
                      (value) => setState(() => selectedCompany = value),
                      labelMap: {'': 'Select Company'},
                    );
                  }),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Obx(() {
                    final depts = controller.departments;
                    return _buildDropdown(
                      'Department',
                      selectedDepartment,
                      depts.toList(),
                      (value) => setState(() => selectedDepartment = value),
                    );
                  }),
                ),
              ),
            ],
          ),

          // Row 2: Location and Designation
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Obx(() {
                    final locs = controller.locations;
                    return _buildDropdown(
                      'Location',
                      selectedLocation,
                      locs,
                      (value) => setState(() => selectedLocation = value),
                    );
                  }),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Obx(() {
                    final desigs = controller.designations;
                    return _buildDropdown(
                      'Designation',
                      selectedDesignation,
                      desigs.toList(),
                      (value) => setState(() => selectedDesignation = value),
                    );
                  }),
                ),
              ),
            ],
          ),

          // Row 3: Type and Status
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Obx(() {
                    final empType = controller.employeeTypes;
                    return _buildDropdown(
                      'Employee Type',
                      selectedType,
                      empType.toList(),
                      (value) => setState(() => selectedType = value),
                    );
                  }),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: _buildDropdown(
                    'Status',
                    selectedStatus.toString(),
                    ['1', '0'],
                    (value) => setState(() => selectedStatus = int.parse(value!)),
                    labelMap: {'1': 'Active', '0': 'Inactive'},
                  ),
                ),
              ),
            ],
          ),

          // Row 4: Employee ID and Enroll ID
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: _buildTextField('Employee ID', employeeIdController),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: _buildTextField('Enroll ID', enrollIdController),
                ),
              ),
            ],
          ),

          // Row 5: Employee Name (full width)
          _buildTextField('Employee Name', employeeNameController),

          // Buttons
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: _handleFilter,
                icon: const Icon(Icons.search, size: 20),
                label: const Text('Search'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
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
    // Ensure we have items to show
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextFormField(
          enabled: false,
          decoration: InputDecoration(
            labelText: '$label (Loading...)',
            border: const OutlineInputBorder(),
          ),
        ),
      );
    }

    // For department and designation, make sure we have valid items
    List<DropdownMenuItem<String>> dropdownItems = [];
    try {
      // Create a set to track used values and prevent duplicates
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

            // Skip if this value is already used
            if (usedValues.contains(itemValue)) {
              return null;
            }
            usedValues.add(itemValue);

            return DropdownMenuItem<String>(
              value: itemValue,
              child: Text(itemLabel),
            );
          })
          .whereType<DropdownMenuItem<String>>() // Remove null items
          .toList();

      // Add an initial "Select" item only for non-Status dropdowns
      if (label != 'Status') {
        dropdownItems.insert(
          0,
          const DropdownMenuItem<String>(
            value: '',
            child: Text('All'),
          ),
        );
      }
    } catch (e) {
      print('Error building dropdown items for $label: $e');
      dropdownItems = [
        DropdownMenuItem<String>(
          value: label == 'Status' ? '1' : '',
          child: Text(label == 'Status' ? 'Active' : 'All'),
        )
      ];
    }

    // Make sure the current value exists in the items
    bool valueExists = value == '' || dropdownItems.any((item) => item.value == value);
    String? effectiveValue = valueExists ? value : '';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: effectiveValue,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: dropdownItems,
        onChanged: onChanged,
        isExpanded: true,
      ),
    );
  }

  @override
  void dispose() {
    employeeIdController.dispose();
    enrollIdController.dispose();
    employeeNameController.dispose();
    super.dispose();
  }
}