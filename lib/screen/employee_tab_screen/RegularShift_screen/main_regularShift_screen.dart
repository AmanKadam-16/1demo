import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:time_attendance/controller/regular_shift_controller/regular_shift_controller.dart';
import 'package:time_attendance/model/regular_shift/regular_shift_model.dart';
import 'package:time_attendance/screen/employee_tab_screen/RegularShift_screen/regularShift_dialog.dart';
import 'package:time_attendance/widget/reusable/button/custom_action_button.dart';
import 'package:time_attendance/widget/reusable/dialog/dialogbox.dart';
import 'package:time_attendance/widget/reusable/dialog/employee_selection_dialog.dart';
import 'package:time_attendance/widget/reusable/list/reusable_list.dart';
import 'package:time_attendance/widget/reusable/pagination/pagination_widget.dart';
import 'package:time_attendance/widget/reusable/search/reusable_search_field.dart';
import 'package:time_attendance/widget/reusable/tooltip/help_tooltip_button.dart';
import 'package:time_attendance/widgets/mtaToast.dart';

class MainRegularShiftScreen extends StatefulWidget {
  const MainRegularShiftScreen({super.key});

  @override
  State<MainRegularShiftScreen> createState() => _MainRegularShiftScreenState();
}

class _MainRegularShiftScreenState extends State<MainRegularShiftScreen> {
  final RegularShiftController controller = Get.put(RegularShiftController());
  final TextEditingController _searchController = TextEditingController();
  final selectedEmpName = ''.obs;
  final selectedEmpId = ''.obs;
  final selectedDesignation = ''.obs;
  final selectedDepartment = ''.obs;
  final selectedCompany = ''.obs;
  final selectedLocation = ''.obs;
  final selectedMonth = DateTime.now().month.obs;
  final selectedYear = DateTime.now().year.obs;
  final _currentPage = 1.obs;
  final _itemsPerPage = 10.obs;
  final List<Map<String, dynamic>> months = [
    {'name': 'January', 'value': 1},
    {'name': 'February', 'value': 2},
    {'name': 'March', 'value': 3},
    {'name': 'April', 'value': 4},
    {'name': 'May', 'value': 5},
    {'name': 'June', 'value': 6},
    {'name': 'July', 'value': 7},
    {'name': 'August', 'value': 8},
    {'name': 'September', 'value': 9},
    {'name': 'October', 'value': 10},
    {'name': 'November', 'value': 11},
    {'name': 'December', 'value': 12},
  ];

  List<int> get years =>
      List.generate(61, (index) => DateTime.now().year - 30 + index);

  @override
  void initState() {
    super.initState();
    controller.regularShifts.clear();
    controller.updateSearchQuery('');
  }

  void _showEmployeeSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => EmployeeSelectionDialog(
        onEmployeeSelected: (employee) {
          // Update all employee details
          selectedEmpName.value = employee.employeeName ?? '';
          selectedEmpId.value = employee.employeeID ?? '';
          selectedDesignation.value = employee.designationName ?? '';
          selectedDepartment.value = employee.departmentName ?? '';
          selectedCompany.value = employee.companyName ?? '';
          selectedLocation.value = employee.locationName ?? '';

          // Set controller's last params (emp id, start date, end date)
          final lastDayOfMonth = DateTime(selectedYear.value, selectedMonth.value + 1, 0).day;
          final startDate = DateTime(selectedYear.value, selectedMonth.value, 1);
          final endDate = DateTime(selectedYear.value, selectedMonth.value, lastDayOfMonth);
          final formatter = DateFormat('yyyy-MM-dd');
          controller.setLastParams(
            employeeID: selectedEmpId.value,
            startDate: formatter.format(startDate),
            endDate: formatter.format(endDate),
          );

          // Clear previous results
          controller.regularShifts.clear();
          controller.updateSearchQuery('');
          _currentPage.value = 1;
        },
      ),
    );
  }

  void _fetchRegularShifts() {
    if (selectedEmpId.value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an employee first.')),
      );
      return;
    }
    final lastDayOfMonth =
        DateTime(selectedYear.value, selectedMonth.value + 1, 0).day;
    final startDate = DateTime(selectedYear.value, selectedMonth.value, 1);
    final endDate =
        DateTime(selectedYear.value, selectedMonth.value, lastDayOfMonth);
    final formatter = DateFormat('yyyy-MM-dd');

    controller.fetchRegularShifts(
      employeeID: selectedEmpId.value,
      startDate: formatter.format(startDate),
      endDate: formatter.format(endDate),
    );
  }

  void _showRegularShiftDialog(BuildContext context,
      [RegularShiftModel? shift]) {
    if (selectedEmpId.value.isEmpty && shift == null) {
      MTAToast().ShowToast('Please select an employee first to add a shift.');
      return;
    }
    shift ??= RegularShiftModel(
      employeeID: selectedEmpId.value,
      employeeName: selectedEmpName.value,
      startDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      type: 1, // Default to Fix type
      shiftID: '',
      shiftName: '',
      patternID: '',
      patternName: '',
      shiftConstantDays: '0',
    );

    showCustomDialog(context: context, dialogContent: [
      RegularShiftDialog(
        regularShiftController: controller,
        initialShiftData: shift,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee's Regular Shift"),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (MediaQuery.of(context).size.width > 600)
            ReusableSearchField(
              searchController: _searchController,
              onSearchChanged: controller.updateSearchQuery,
            ),
          const SizedBox(width: 20),
          CustomActionButton(
            label: 'Select Employee',
            onPressed: _showEmployeeSelectionDialog,
            icon: Icons.person_search,
          ),
          CustomActionButton(
            label: 'Add Shift',
            onPressed: () => _showRegularShiftDialog(context),
          ),
          const HelpTooltipButton(
            tooltipMessage: 'Manage employee regular shifts.',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          _buildEmployeeDetailsCard(),
          if (MediaQuery.of(context).size.width <= 600)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
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
              if (selectedEmpId.value.isEmpty) {
                return const Center(
                    child: Text('Please select an employee to begin.'));
              }
              if (controller.regularShifts.isEmpty) {
                return const Center(
                    child: Text('No records found. Please perform a search.'));
              }
              if (controller.filteredRegularShifts.isEmpty) {
                return const Center(
                    child: Text('No shifts match the current search query.'));
              }

              final totalItems = controller.filteredRegularShifts.length;
              final totalPages = (totalItems / _itemsPerPage.value).ceil();
              final paginatedList = controller.filteredRegularShifts
                  .skip((_currentPage.value - 1) * _itemsPerPage.value)
                  .take(_itemsPerPage.value)
                  .toList();

              return Column(
                children: [
                  Expanded(
                    child: ReusableTableAndCard(
                      data: paginatedList
                          .map((shift) => {
                                'ID': shift.employeeID,
                                'Name': shift.employeeName,
                                'Start Date': shift.startDate,
                                'Type': shift.type == 1
                                    ? 'Fix'
                                    : shift.type == 2
                                        ? 'AutoShift'
                                        : shift.type == 3
                                            ? 'Rotation'
                                            : '',
                                'Shift': shift.shiftName,
                                'Pattern': shift.patternName,
                                'Shift Constant Days': shift.shiftConstantDays,
                              })
                          .toList(),
                      headers: const [
                        'ID',
                        'Name',
                        'Start Date',
                        'Type',
                        'Shift',
                        'Pattern',
                        'Shift Constant Days',
                        'Actions'
                      ],
                      visibleColumns: const [
                        // 'ID',
                        // 'Name',
                        'Start Date',
                        'Type',
                        'Shift',
                        'Pattern',
                        'Shift Constant Days',
                        'Actions'
                      ],
                      onEdit: (row) {
                        final shiftToEdit = paginatedList.firstWhere((s) =>
                            s.employeeID == row['ID'] &&
                            s.startDate == row['Start Date']);
                        _showRegularShiftDialog(context, shiftToEdit);
                      },
                      onDelete: (row) {
                        final shiftToDelete = paginatedList.firstWhere((s) =>
                            s.employeeID == row['ID'] &&
                            s.startDate == row['Start Date']);
                        _showDeleteConfirmationDialog(context, shiftToDelete);
                      },
                      onSort: (column, ascending) {
                        // Implement sorting in the controller
                        // controller.sortRegularShifts(column, ascending);
                      },
                    ),
                  ),
                  PaginationWidget(
                    currentPage: _currentPage.value,
                    totalPages: totalPages > 0 ? totalPages : 1,
                    onFirstPage: () => _currentPage.value = 1,
                    onPreviousPage: () {
                      if (_currentPage.value > 1) _currentPage.value--;
                    },
                    onNextPage: () {
                      if (_currentPage.value < totalPages) _currentPage.value++;
                    },
                    onLastPage: () => _currentPage.value = totalPages,
                    onItemsPerPageChange: (items) {
                      _itemsPerPage.value = items;
                      _currentPage.value = 1;
                    },
                    itemsPerPage: _itemsPerPage.value,
                    itemsPerPageOptions: const [10, 25, 50, 100],
                    totalItems: totalItems,
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeDetailsCard() {
    return Obx(() => selectedEmpName.value.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 2,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 20,
                      runSpacing: 16,
                      children: [
                        _buildInfoItem('Employee Name', selectedEmpName.value, Icons.person),
                        _buildInfoItem('Employee ID', selectedEmpId.value, Icons.badge),
                        _buildInfoItem('Designation', selectedDesignation.value, Icons.work),
                        _buildInfoItem('Department', selectedDepartment.value, Icons.business),
                        _buildInfoItem('Company', selectedCompany.value, Icons.apartment),
                        _buildInfoItem('Location', selectedLocation.value, Icons.location_on),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 20,
                      runSpacing: 16,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        SizedBox(
                          width: 150,
                          child: Obx(() => DropdownButtonFormField<int>(
                                decoration: const InputDecoration(
                                    labelText: 'Month',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8)),
                                value: selectedMonth.value,
                                items: months
                                    .map((m) => DropdownMenuItem<int>(
                                        value: m['value'],
                                        child: Text(m['name'])))
                                    .toList(),
                                onChanged: (value) =>
                                    selectedMonth.value = value!,
                              )),
                        ),
                        SizedBox(
                          width: 120,
                          child: Obx(() => DropdownButtonFormField<int>(
                                decoration: const InputDecoration(
                                    labelText: 'Year',
                                    border: OutlineInputBorder(),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8)),
                                value: selectedYear.value,
                                items: years
                                    .map((y) => DropdownMenuItem<int>(
                                        value: y, child: Text(y.toString())))
                                    .toList(),
                                onChanged: (value) =>
                                    selectedYear.value = value!,
                              )),
                        ),
                        ElevatedButton.icon(
                          onPressed: _fetchRegularShifts,
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
            ),
          )
        : const SizedBox.shrink());
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, RegularShiftModel shift) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text(
              'Are you sure you want to delete the shift for "${shift.employeeName}" on ${shift.startDate}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await controller.deleteRegularShift(
                  employeeID: shift.employeeID,
                  shiftDate: shift.startDate,
                );
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

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Container(
      constraints: const BoxConstraints(minWidth: 200),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text(value.isEmpty ? 'N/A' : value,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
