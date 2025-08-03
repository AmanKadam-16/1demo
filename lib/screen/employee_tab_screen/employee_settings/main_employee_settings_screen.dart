// main_department_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/employee_tab_controller/emplyoee_controller.dart';
import 'package:time_attendance/controller/employee_tab_controller/employee_search_controller.dart';
import 'package:time_attendance/controller/employee_tab_controller/settingprofile_controller.dart';
import 'package:time_attendance/model/employee_tab_model/settingprofile.dart';
import 'package:time_attendance/screen/employee_tab_screen/employee_screen/employee_filter.dart';
import 'package:time_attendance/screen/employee_tab_screen/setting_profile/add_edit_setting_profile_screen.dart';
import 'package:time_attendance/widget/reusable/button/custom_action_button.dart';
import 'package:time_attendance/widget/reusable/list/reusable_list.dart';
import 'package:time_attendance/widget/reusable/pagination/pagination_widget.dart';
import 'package:time_attendance/widget/reusable/tooltip/help_tooltip_button.dart';
import 'package:time_attendance/widget/reusable/search/reusable_search_field.dart';

class MainEmployeeSettingScreen extends StatefulWidget {
  const MainEmployeeSettingScreen({super.key});

  @override
  State<MainEmployeeSettingScreen> createState() =>
      _MainEmployeeSettingScreenState();
}

class _MainEmployeeSettingScreenState extends State<MainEmployeeSettingScreen> {
  final SettingProfileController settingProfileController =
      Get.put(SettingProfileController());
  final TextEditingController _searchController = TextEditingController();
  final EmployeeSearchController employeeController =
      Get.put(EmployeeSearchController());
  // Instantiate EmployeeController to access its methods
  final EmployeeController employeeOpsController = Get.put(EmployeeController());
  Set<String> selectedEmployees = {};

  @override
  void initState() {
    super.initState();
    // Initialize controllers
    settingProfileController.initializeAuthProfile();
    employeeOpsController.initializeAuthEmployee();
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => EmployeeFilterDialog(
        searchMode: EmployeeSearchMode.employee,
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

  void _showApplySettingsDialog(BuildContext context) {
    SettingProfileModel? selectedProfile;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Setting Profiles'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<SettingProfileModel>(
                    value: selectedProfile,
                    hint: const Text('Select Setting Profile'),
                    isExpanded: true,
                    items: settingProfileController.settingProfiles
                        .map((profile) {
                      return DropdownMenuItem<SettingProfileModel>(
                        value: profile,
                        child: Text(profile.profileName),
                      );
                    }).toList(),
                    onChanged: (SettingProfileModel? value) {
                      setState(() {
                        selectedProfile = value;
                      });
                    },
                  ),
                  if (selectedProfile != null) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'Description:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(selectedProfile!.description),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: selectedProfile == null
                      ? null
                      : () async {
                          final String profileId = selectedProfile!.profileId;
                          final List<String> employeeIds =
                              selectedEmployees.toList();

                          // Call the controller method to apply settings
                          await employeeOpsController
                              .applySettingProfileToEmployees(
                                  employeeIds, profileId);

                          // After completion, clear selection and close dialog
                          if (mounted) {
                            setState(() {
                              selectedEmployees.clear();
                            });
                            Navigator.of(context).pop();
                          }
                        },
                  child: const Text('Apply Settings'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employees Settings'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          SizedBox(
            width: 200,
            child: ReusableSearchField(
              searchController: _searchController,
              onSearchChanged: (value) =>
                  employeeController.updateSearchFilter(employeeName: value),
            ),
          ),
          const SizedBox(width: 8),
          CustomActionButton(
              label: 'Add Filter',
              onPressed: () => _showFilterDialog(context),
              icon: Icons.filter_list),
          CustomActionButton(
            label: 'Apply Profile',
            onPressed: () {
              if (selectedEmployees.isEmpty) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('No Selection'),
                      content: const Text(
                          'Please select at least one employee to apply settings'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
                return;
              }
              _showApplySettingsDialog(context);
            },
          ),
          const SizedBox(width: 8),
          HelpTooltipButton(
            tooltipMessage:
                'Assign Setting Profiles to employees for managing their configurations.',
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
                onSearchChanged: (value) =>
                    employeeController.updateSearchFilter(employeeName: value),
                responsiveWidth: false,
              ),
            ),
          Expanded(
            child: Obx(() {
              if (employeeController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!employeeController.hasSearched.value) {
                return const Center(
                    child: Text(
                        'Use the search or filter options to find employees'));
              }

              if (employeeController.filteredEmployees.isEmpty) {
                return const Center(child: Text('No employees found'));
              }

              return Column(
                children: [
                  Expanded(
                    child: ReusableTableAndCard(
                      data: List.generate(
                        employeeController.filteredEmployees.length,
                        (index) {
                          final employee =
                              employeeController.filteredEmployees[index];
                          return {
                            'Employee ID': employee.employeeID ?? '',
                            'Employee Name': employee.employeeName ?? '',
                            'Setting Profile': (employee.settingProfileName ?? '').isEmpty ? 'N/A' : employee.settingProfileName ?? 'N/A',
                          };
                        },
                      ),
                      headers: const [
                        'Employee ID',
                        'Employee Name',
                        'Setting Profile',
                        'Actions'
                      ],
                      visibleColumns: const [
                        'Employee ID',
                        'Employee Name',
                        'Setting Profile',
                        'Actions'
                      ],
                      showCheckboxes: true,
                      selectedItems: selectedEmployees,
                      idField: 'Employee ID',
                      onSelectAll: (bool? value) {
                        setState(() {
                          if (value ?? false) {
                            selectedEmployees = employeeController
                                .filteredEmployees
                                .map((emp) => emp.employeeID ?? '')
                                .where((id) => id.isNotEmpty)
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
                      onEdit: (row) {
                        final employeeId = row['Employee ID'];
                        final settingProfile = settingProfileController
                            .settingProfiles
                            .firstWhere(
                          (profile) => profile.profileId == employeeId,
                          orElse: () => SettingProfileModel(
                            profileId: '',
                            profileName: '',
                            description: '',
                            isDefaultProfile: false,
                            isEmpWeeklyOffAdjustable: false,
                            isShiftStartFromJoiningDate: false,
                            changesDoneOn: '',
                            changesDoneOnDateTime: DateTime.now(),
                            changesDoneBy: '',
                          ),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddEditSettingProfileScreen(
                                profile: settingProfile),
                          ),
                        );
                      },
                      onDelete: null,
                    ),
                  ),
                  PaginationWidget(
                    currentPage: employeeController.currentPage.value + 1,
                    totalPages: (employeeController.totalRecords.value /
                            employeeController.recordsPerPage.value)
                        .ceil(),
                    onFirstPage: () => employeeController.goToPage(0),
                    onPreviousPage: () => employeeController.previousPage(),
                    onNextPage: () => employeeController.nextPage(),
                    onLastPage: () => employeeController.goToPage(
                        (employeeController.totalRecords.value /
                                    employeeController.recordsPerPage.value)
                                .ceil() -
                            1),
                    onItemsPerPageChange: (value) =>
                        employeeController.updateRecordsPerPage(value),
                    itemsPerPage: employeeController.recordsPerPage.value,
                    itemsPerPageOptions: const [10, 25, 50, 100],
                    totalItems: employeeController.totalRecords.value,
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}