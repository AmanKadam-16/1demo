import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:time_attendance/controller/employee_tab_controller/employee_search_controller.dart';
import 'package:time_attendance/controller/employee_tab_controller/emplyoee_controller.dart';
import 'package:time_attendance/controller/employee_tab_controller/settingprofile_controller.dart';
import 'package:time_attendance/model/employee_tab_model/employee_complete_model.dart';
import 'package:time_attendance/widget/reusable/button/form_button.dart';
import 'package:time_attendance/widget/reusable/dialog/employee_selection_dialog.dart';

extension FirstWhereOrNullExtension<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

class EmployeeForm extends StatelessWidget {
  final EmployeeController controller = Get.put(EmployeeController());
  final SettingProfileController settingProfileController =
      Get.put(SettingProfileController());
  final employeeSearchController = Get.put(EmployeeSearchController());

  // Add this RxString to persist the selected profile across rebuilds
  final RxString selectedProfileId = ''.obs;

  void clearAllFields() {
    // Clear all text fields
    controller.employeeIdController.clear();
    controller.enrollIdController.clear();
    controller.employeeNameController.clear();
    controller.designationFormController.clear();
    controller.employeeTypeFormController.clear();
    // Set current date as default joining date
    controller.dateOfJoiningController.text =
        DateFormat('yyyy-MM-dd').format(DateTime.now());
    controller.dateOfLeavingController.clear();
    controller.seniorReportingController.clear();
    controller.seniorReportingNameController.clear();
    controller.officeEmailController.clear();
    controller.genderController.clear();
    controller.bloodGroupController.clear();
    controller.nationalityController.clear();
    controller.personalEmailController.clear();
    controller.mobileNoController.clear();
    controller.dateOfBirthController.clear();
    controller.localAddressController.clear();
    controller.permanentAddressController.clear();
    controller.contactNoController.clear();

    // Reset dropdowns
    controller.selectedCompany.value = '';
    controller.selectedDepartment.value = '';
    controller.selectedLocation.value = '';
    controller.selectedEmployeeStatus.value = 'Active';
    controller.selectedEmployeeType.value = '';
    controller.selectedSettingProfile.value = null;
    selectedProfileId.value = '';
  }

  final Employee? employee;
  EmployeeForm({Key? key, this.employee}) : super(key: key) {
    if (employee == null) {
      clearAllFields();
    }
    if (employee != null) {
      // Populate professional details
      final prof = employee!.employeeProfessional;
      if (prof != null) {
        controller.employeeIdController.text = prof.employeeID;
        controller.enrollIdController.text = prof.enrollID;
        controller.employeeNameController.text = prof.employeeName;
        controller.selectedCompany.value = prof.companyID;
        controller.selectedDepartment.value = prof.departmentID;
        controller.designationFormController.text = prof.designationID;
        controller.selectedLocation.value = prof.locationID;
        controller.selectedEmployeeType.value = prof.employeeTypeID;
        controller.employeeTypeFormController.text = prof.employeeType;
        controller.selectedEmployeeStatus.value =
            prof.empStatus == 1 ? 'Active' : 'Inactive';
        controller.dateOfJoiningController.text = prof.dateOfEmployment;
        controller.dateOfLeavingController.text = prof.dateOfLeaving ?? '';
        controller.seniorReportingController.text = prof.seniorEmployeeID;
        // controller.seniorReportingController.text
        // controller.seniorReportingNameController.text
        controller.officeEmailController.text = prof.emailID;
      }

      // Populate personal details
      final personal = employee!.employeePersonal;
      if (personal != null) {
        controller.genderController.text = personal.gender;
        controller.bloodGroupController.text = personal.bloodGroup;
        controller.nationalityController.text = personal.nationality;
        controller.personalEmailController.text = personal.emailID;
        controller.mobileNoController.text = personal.mobileNumber;
        controller.dateOfBirthController.text = personal.dateOfBirth;
        controller.localAddressController.text = personal.localAddress;
        controller.permanentAddressController.text = personal.permanentAddress;
        controller.contactNoController.text = personal.contactNo;
      }

      // Set work settings
      controller.selectedSettingProfile.value = null; // Reset first
      if (employee!.employeeWOFF != null &&
          employee!.employeeSetting != null &&
          employee!.employeeGeneralSetting != null &&
          employee!.employeeLogin != null) {
        // We have all required settings, create a SettingProfileModel and set it
        // This needs to be implemented based on how settings are handled
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Employee Form')),
      body: DefaultTabController(
        length: 3, // Changed from 2 to 3
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Professional'),
                Tab(text: 'Personal'),
                Tab(text: 'Work Setting'), // Added third tab
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildProfessionalTab(context),
                  _buildPersonalTab(context),
                  _buildWorkSettingTab(context), // Added third tab content
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showEmployeeSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => EmployeeSelectionDialog(
        onEmployeeSelected: (selectedEmployee) {
          // Set the selected employee's ID as the senior person ID
          controller.seniorReportingController.text =
              selectedEmployee.employeeID ?? '';
          // Set the selected employee's name as the display in the field
          controller.seniorReportingNameController.text =
              selectedEmployee.employeeName ?? '';
          // Navigator.of(context).pop();
        },
      ),
    );
  }

  Widget _buildProfessionalTab(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormRow(
            children: [
              _buildTextField(
                controller: controller.employeeIdController,
                label: 'Employee ID *',
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              _buildTextField(
                controller: controller.enrollIdController,
                label: 'Device Enroll ID *',
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              _buildTextField(
                controller: controller.employeeNameController,
                label: 'Employee Name *',
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Professional Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Obx(() => _buildFormRow(
                children: [
                  // Company Dropdown
                  DropdownButtonFormField<String>(
                    value: controller.selectedCompany.value.isEmpty
                        ? null
                        : controller.selectedCompany.value,
                    decoration: InputDecoration(
                      labelText: 'Company *',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    items: [
                      const DropdownMenuItem(
                          value: '', child: Text('Select Company')),
                      ...controller.companies
                          .map((company) => DropdownMenuItem(
                                value: company.branchId ?? '',
                                child: Text(company.branchName ?? ''),
                              ))
                          .toList(),
                    ],
                    onChanged: (value) =>
                        controller.selectedCompany.value = value ?? '',
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
                  ),
                  // Department Dropdown
                  DropdownButtonFormField<String>(
                    value: controller.selectedDepartment.value.isEmpty
                        ? null
                        : controller.selectedDepartment.value,
                    decoration: InputDecoration(
                      labelText: 'Department *',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    items: [
                      const DropdownMenuItem(
                          value: '', child: Text('Select Department')),
                      ...controller.departments
                          .map((dept) => DropdownMenuItem(
                                value: dept.departmentId,
                                child: Text(dept.departmentName),
                              ))
                          .toList(),
                    ],
                    onChanged: (value) =>
                        controller.selectedDepartment.value = value ?? '',
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
                  ),
                  // Employee Type Dropdown
                  DropdownButtonFormField<String>(
                    value: controller.selectedEmployeeType.value.isEmpty
                        ? null
                        : controller.selectedEmployeeType.value,
                    decoration: InputDecoration(
                      labelText: 'Employee Type *',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    items: [
                      const DropdownMenuItem(
                          value: '', child: Text('Select Employee Type')),
                      ...controller.employeeTypes
                          .map((type) => DropdownMenuItem(
                                value: type.employeeTypeId,
                                child: Text(type.employeeTypeName),
                              ))
                          .toList(),
                    ],
                    onChanged: (value) {
                      controller.selectedEmployeeType.value = value ?? '';
                      if (value != null) {
                        final selectedType = controller.employeeTypes
                            .firstWhere((type) => type.employeeTypeId == value);
                        controller.employeeTypeFormController.text =
                            selectedType.employeeTypeName;
                      }
                    },
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
                  ),
                ],
              )),
          const SizedBox(height: 16),
          Obx(() => _buildFormRow(
                children: [
                  // Designation Dropdown
                  DropdownButtonFormField<String>(
                    value: controller.designationFormController.text.isEmpty
                        ? null
                        : controller.designationFormController.text,
                    decoration: InputDecoration(
                      labelText: 'Designation *',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    items: [
                      const DropdownMenuItem(
                          value: '', child: Text('Select Designation')),
                      ...controller.designations
                          .map((designation) => DropdownMenuItem(
                                value: designation.designationId,
                                child: Text(designation.designationName),
                              ))
                          .toList(),
                    ],
                    onChanged: (value) =>
                        controller.designationFormController.text = value ?? '',
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
                  ),
                  // Location Dropdown
                  DropdownButtonFormField<String>(
                    value: controller.selectedLocation.value.isEmpty
                        ? null
                        : controller.selectedLocation.value,
                    decoration: InputDecoration(
                      labelText: 'Location *',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    items: [
                      const DropdownMenuItem(
                          value: '', child: Text('Select Location')),
                      ...controller.locations
                          .map((location) => DropdownMenuItem(
                                value: location.locationID,
                                child: Text(location.locationName ?? ''),
                              ))
                          .toList(),
                    ],
                    onChanged: (value) =>
                        controller.selectedLocation.value = value ?? '',
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
                  ),
                  // Employee Status Dropdown
                  DropdownButtonFormField<String>(
                    value: controller.selectedEmployeeStatus.value,
                    decoration: InputDecoration(
                      labelText: 'Employee Status *',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    items: controller.employeeStatuses
                        .map((status) => DropdownMenuItem(
                              value: status,
                              child: Text(status),
                            ))
                        .toList(),
                    onChanged: (value) => controller
                        .selectedEmployeeStatus.value = value ?? 'Active',
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
                  ),
                ],
              )),
          const SizedBox(height: 16),
          _buildFormRow(
            children: [
              _buildDateField(
                context: context, // Pass context here
                controller: controller.dateOfJoiningController,
                label: 'Date Of Joining *',
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              _buildDateField(
                context: context, // Pass context here
                controller: controller.dateOfLeavingController,
                label: 'Date Of Leaving',
              ),
              // Senior Reporting Person field with magnifying icon
              TextFormField(
                controller: controller.seniorReportingNameController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Senior Reporting Person',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => showEmployeeSelectionDialog(context),
                  ),
                ),
                onTap: () => showEmployeeSelectionDialog(context),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildFormRow(
            children: [
              _buildTextField(
                controller: controller.officeEmailController,
                label: 'Office Email ID',
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSaveCancelButtons(context),
        ],
      ),
    );
  }

  Widget _buildPersonalTab(BuildContext context) {
    // Set default value for nationality if empty
    if (controller.nationalityController.text.isEmpty) {
      controller.nationalityController.text = 'Indian';
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Personal Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildFormRow(
            children: [
              _buildDropdown(
                options: ['-', 'Male', 'Female'].obs,
                label: 'Gender *',
                onChanged: (value) => controller.genderController.text = value!,
                value: controller.genderController.text.isEmpty
                    ? '-'
                    : controller.genderController.text,
                validator: (value) =>
                    value == null || value == '-' || value.isEmpty
                        ? 'Required'
                        : null,
              ),
              _buildDropdown(
                options:
                    ['-', 'A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'].obs,
                label: 'Blood Group',
                onChanged: (value) =>
                    controller.bloodGroupController.text = value!,
                value: controller.bloodGroupController.text.isEmpty
                    ? '-'
                    : controller.bloodGroupController.text,
              ),
              _buildTextField(
                controller: controller.nationalityController,
                label: 'Nationality',
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildFormRow(
            children: [
              _buildTextField(
                controller: controller.personalEmailController,
                label: 'Personal Email ID',
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value != null && value.isNotEmpty && !value.contains('@')
                        ? 'Invalid email'
                        : null,
              ),
              _buildTextField(
                controller: controller.mobileNoController,
                label: 'Mobile No. *',
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              _buildDateField(
                context: context, // Pass context here
                controller: controller.dateOfBirthController,
                label: 'Date of Birth *',
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildFormRow(
            children: [
              _buildTextField(
                controller: controller.localAddressController,
                label: 'Local Address',
                maxLines: 3,
              ),
              _buildTextField(
                controller: controller.permanentAddressController,
                label: 'Permanent Address',
                maxLines: 3,
              ),
              _buildTextField(
                controller: controller.contactNoController,
                label: 'Contact No *',
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSaveCancelButtons(context),
        ],
      ),
    );
  }

  Widget _buildWorkSettingTab(BuildContext context) {
    return Obx(() {
      final profiles = settingProfileController.settingProfiles;
      if (profiles.isNotEmpty && selectedProfileId.value.isEmpty) {
        final defaultProfile =
            profiles.firstWhereOrNull((p) => p.isDefaultProfile);
        selectedProfileId.value =
            defaultProfile?.profileId ?? profiles.first.profileId;

        // Set the initial selected profile in the controller
        final selectedProfile = profiles
            .firstWhereOrNull((p) => p.profileId == selectedProfileId.value);
        if (selectedProfile != null) {
          controller.selectedSettingProfile.value = selectedProfile;
        }
      }
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Work Setting Profile',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            // Reduce dropdown width
            Row(
              children: [
                SizedBox(
                  width: 320, // Set a reasonable width for the dropdown
                  child: DropdownButtonFormField<String>(
                    value: selectedProfileId.value.isEmpty
                        ? null
                        : selectedProfileId.value,
                    decoration: InputDecoration(
                      labelText: 'Setting Profile *',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                    items: profiles
                        .map((profile) => DropdownMenuItem(
                              value: profile.profileId,
                              child: Text(profile.profileName),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        selectedProfileId.value = value;
                        // Update the controller's selected profile
                        final selectedProfile = profiles
                            .firstWhereOrNull((p) => p.profileId == value);
                        if (selectedProfile != null) {
                          controller.selectedSettingProfile.value =
                              selectedProfile;
                        }
                      }
                    },
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() {
              final profile = profiles.firstWhereOrNull(
                  (p) => p.profileId == selectedProfileId.value);
              if (profile != null && profile.description.isNotEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Description:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(profile.description),
                  ],
                );
              } else {
                return const SizedBox();
              }
            }),
            const SizedBox(height: 24),
            _buildSaveCancelButtons(context),
          ],
        ),
      );
    });
  }

  Widget _buildFormRow({required List<Widget> children}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Mobile: width < 600 (1 item per row)
        // Laptop: width >= 600 && < 1200 (2 items per row)
        // PC: width >= 1200 (3 items per row)
        int itemsPerRow;
        if (constraints.maxWidth < 600) {
          itemsPerRow = 1;
        } else if (constraints.maxWidth < 1200) {
          itemsPerRow = 2;
        } else {
          itemsPerRow = 3;
        }

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: children.asMap().entries.map((entry) {
            return SizedBox(
              width:
                  (constraints.maxWidth - (itemsPerRow - 1) * 16) / itemsPerRow,
              child: entry.value,
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    bool readOnly = false,
    VoidCallback? onTap,
    FormFieldValidator<String>? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onTap: onTap,
      validator: validator,
    );
  }

  Widget _buildDateField({
    required BuildContext context, // Add context parameter
    required TextEditingController controller,
    required String label,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      onTap: () => _selectDate(context, controller), // Use the passed context
      validator: validator,
    );
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Widget _buildDropdown({
    required RxList<String> options,
    required String label,
    required ValueChanged<String?> onChanged,
    FormFieldValidator<String>? validator,
    String? value,
  }) {
    return Obx(() => DropdownButtonFormField<String>(
          value: value,
          items: options
              .map((option) => DropdownMenuItem(
                    value: option,
                    child: Text(option),
                  ))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          validator: validator,
        ));
  }

  Widget _buildSaveCancelButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CustomButtons(
          onSavePressed: () async {
            // Pass isEdit=true if employee is not null (editing mode)
            final success =
                await controller.saveEmployee(isEdit: employee != null);
            if (success) {
              // Clear all form fields
              controller.employeeIdController.clear();
              controller.enrollIdController.clear();
              controller.employeeNameController.clear();
              controller.designationFormController.clear();
              controller.employeeTypeFormController.clear();
              controller.dateOfJoiningController.clear();
              controller.dateOfLeavingController.clear();
              controller.seniorReportingController.clear();
              controller.seniorReportingNameController.clear();
              controller.officeEmailController.clear();
              controller.genderController.clear();
              controller.bloodGroupController.clear();
              controller.nationalityController.clear();
              controller.personalEmailController.clear();
              controller.mobileNoController.clear();
              controller.dateOfBirthController.clear();
              controller.localAddressController.clear();
              controller.permanentAddressController.clear();
              controller.contactNoController.clear();

              // Reset dropdowns
              controller.selectedCompany.value = '';
              controller.selectedDepartment.value = '';
              controller.selectedLocation.value = '';
              controller.selectedEmployeeStatus.value = 'Active';
              controller.selectedEmployeeType.value = '';
              controller.selectedSettingProfile.value = null;

              Navigator.pop(context);
              await employeeSearchController.fetchEmployees(resetPage: true);
            }
          },
          onCancelPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
