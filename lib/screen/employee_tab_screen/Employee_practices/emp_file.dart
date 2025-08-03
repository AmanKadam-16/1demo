import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/employee_tab_controller/emp_practice_controller.dart';
import 'package:time_attendance/widget/reusable/filter/filter.dart';
import 'package:time_attendance/widget/reusable/filter/text_feaild.dart';
import 'package:time_attendance/widget/reusable/datetime/responsive_datepicker_widget.dart';

class EmployeeFilterScreen extends GetView<EmployeePracticeController> {
  const EmployeeFilterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    controller.fetchDepartments();
    controller.fetchDesignations();
    controller.fetchBranches();
    controller.fetchEmployeeTypes();
    controller.fetchShifts();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Search'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to add employee form
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // const ResponsiveDatePickerWidget(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: InlineTextField(
                        label: 'Employee Name',
                        onChanged: (value) => controller.employeeName.value = value,
                        value: controller.employeeName.value,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InlineTextField(
                        label: 'Employee ID',
                        onChanged: (value) => controller.employeeId.value = value,
                        value: controller.employeeId.value,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Department',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        value: controller.selectedDepartment.value.isEmpty ? null : controller.selectedDepartment.value,
                        items: [
                          const DropdownMenuItem<String>(
                            value: '',
                            child: Text('All Departments'),
                          ),
                          ...controller.departments.map((dept) => DropdownMenuItem<String>(
                            value: dept,
                            child: Text(dept),
                          )),
                        ],
                        onChanged: (value) => controller.selectedDepartment.value = value ?? '',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Shift',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        value: controller.selectedShift.value.isEmpty ? null : controller.selectedShift.value,
                        items: [
                          const DropdownMenuItem<String>(
                            value: '',
                            child: Text('All Shifts'),
                          ),
                          ...controller.shifts.map((shift) => DropdownMenuItem<String>(
                            value: shift,
                            child: Text(shift),
                          )),
                        ],
                        onChanged: (value) => controller.selectedShift.value = value ?? '',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InlineTextField(
                        label: 'Enroll ID',
                        onChanged: (value) => controller.enrollId.value = value,
                        value: controller.enrollId.value,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Employee Type',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        value: controller.selectedEmployeeType.value.isEmpty ? null : controller.selectedEmployeeType.value,
                        items: [
                          const DropdownMenuItem<String>(
                            value: '',
                            child: Text('All Types'),
                          ),
                          ...controller.employeeTypes.map((type) => DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          )),
                        ],
                        onChanged: (value) => controller.selectedEmployeeType.value = value ?? '',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Obx(() => ExpandableFilter(
                  filterOptions: controller.filterOptions.map((key, value) => MapEntry(key, value.map((option) => option.value).toList())),
                  onApplyFilters: (filters) {
                    controller.selectedCompany.value = filters['Company'] ?? '';
                    controller.selectedDepartment.value = filters['Department'] ?? '';
                    controller.selectedDesignation.value = filters['Designation'] ?? '';
                    controller.selectedShift.value = filters['Shift'] ?? '';
                  },
                  onClearFilters: controller.clearFilters,
                  isLoading: controller.isLoading.value,
                )),
              ],
            ),
          ),
          Expanded(
            child: Obx(() => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: controller.filteredEmployees.length,
                  itemBuilder: (context, index) {
                    final employee = controller.filteredEmployees[index];
                    return ListTile(
                      title: Text(employee.name),
                      subtitle: Text('${employee.designation} - ${employee.department}'),
                      trailing: Text(employee.status),
                    );
                  },
                ),
            ),
          ),
        ],
      ),
    );
  }
}