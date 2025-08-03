import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/master_tab_controller/department_controller.dart';
import 'package:time_attendance/model/master_tab_model/department_model.dart';
import 'package:time_attendance/widget/reusable/button/form_button.dart';

class DepartmentDialog extends StatefulWidget {
  final DepartmentController controller;
  final DepartmentModel department;

  const DepartmentDialog({
    super.key, 
    required this.controller,
    required this.department,
  });

  @override
  State<DepartmentDialog> createState() => _DepartmentDialogState();
}

class _DepartmentDialogState extends State<DepartmentDialog> {
  late TextEditingController _nameController;
  String? _selectedMasterDepartmentId;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.department.departmentName);
    _selectedMasterDepartmentId = widget.department.masterDepartmentId.isNotEmpty 
        ? widget.department.masterDepartmentId 
        : null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      String masterDepartmentName = '';
      if (_selectedMasterDepartmentId != null) {
        final masterDepartment = widget.controller.departments.firstWhere(
          (d) => d.departmentId == _selectedMasterDepartmentId,
          orElse: () => DepartmentModel(),
        );
        masterDepartmentName = masterDepartment.departmentName;
      }

      final updatedDepartment = DepartmentModel(
        departmentId: widget.department.departmentId,
        departmentName: _nameController.text.trim(),
        masterDepartmentId: _selectedMasterDepartmentId ?? '',
        masterDepartmentName: masterDepartmentName,
      );
      
      widget.controller.saveDepartment(updatedDepartment);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Text(
                  widget.department.departmentId.isEmpty 
                      ? 'Add Department'
                      : 'Edit Department',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black87),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Department *',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    hintText: 'Enter Department',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter Department';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Obx(() => DropdownButtonFormField<String>(
                  value: _selectedMasterDepartmentId,
                  decoration: InputDecoration(
                    labelText: 'Master Department',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    hintText: 'Select master department',
                  ),
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('None'),
                    ),
                    ...widget.controller.departments
                        .where((d) => d.departmentId != widget.department.departmentId)
                        .map((department) {
                      return DropdownMenuItem<String>(
                        value: department.departmentId,
                        child: Text(department.departmentName),
                      );
                    }),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedMasterDepartmentId = value;
                    });
                  },
                )),
                const SizedBox(height: 40),
                CustomButtons(
                  onSavePressed: _handleSave,
                  onCancelPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
