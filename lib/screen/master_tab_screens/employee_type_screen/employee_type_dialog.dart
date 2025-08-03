import 'package:flutter/material.dart';
import 'package:time_attendance/controller/master_tab_controller/emplyee_type_controller.dart';
import 'package:time_attendance/model/master_tab_model/employee_type_model.dart';
import 'package:time_attendance/widget/reusable/button/form_button.dart';

class EmployeeTypeDialog extends StatefulWidget {
  final EmplyeeTypeController controller;
  final EmployeeTypeModel employeeTypeModel;

  const EmployeeTypeDialog({
    super.key, 
    required this.controller,
    required this.employeeTypeModel,
  });

  @override
  State<EmployeeTypeDialog> createState() => _EmplyeeTypeController();
}

class _EmplyeeTypeController extends State<EmployeeTypeDialog> {
  late TextEditingController _nameController;
  String? _selectedMasterEmployeeTypeId;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.employeeTypeModel.employeeTypeName);
    _selectedMasterEmployeeTypeId = widget.employeeTypeModel.employeeTypeId.isNotEmpty 
        ? widget.employeeTypeModel.employeeTypeId 
        : null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      String employeeTypeId = '';
      if (_selectedMasterEmployeeTypeId != null) {
        final selectedType = widget.controller.empTypeDetails.firstWhere(
          (d) => d.employeeTypeId == _selectedMasterEmployeeTypeId,
          orElse: () => EmployeeTypeModel(
            employeeTypeId: '',
            employeeTypeName: '',
          ),
        );
        employeeTypeId = selectedType.employeeTypeId;
      }

      final updatedEmployeeType = EmployeeTypeModel(
        employeeTypeId: widget.employeeTypeModel.employeeTypeId,
        employeeTypeName: _nameController.text.trim(),
      );
      
      widget.controller.saveEmployeeType(updatedEmployeeType);
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
                  widget.employeeTypeModel.employeeTypeId.isEmpty 
                      ? 'Add Employee Type'
                      : 'Edit Employee Type',
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
                    labelText: 'Employee Type *',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    hintText: 'Enter Employee Type',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter Employee Type ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
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
