// designation_dialog.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/master_tab_controller/designation_controller.dart';
import 'package:time_attendance/model/master_tab_model/designation_model.dart';
import 'package:time_attendance/widget/reusable/button/form_button.dart';

class DesignationDialog extends StatefulWidget {
  final DesignationController controller;
  final DesignationModel designation;

  const DesignationDialog({
    super.key, 
    required this.controller,
    required this.designation,
  });

  @override
  State<DesignationDialog> createState() => _DesignationDialogState();
}

class _DesignationDialogState extends State<DesignationDialog> {
  late TextEditingController _nameController;
  String? _selectedMasterDesignationId;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.designation.designationName);
    _selectedMasterDesignationId = widget.designation.masterDesignationId.isNotEmpty 
        ? widget.designation.masterDesignationId 
        : null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      // Find the selected designation to get its name
      String masterDesignationName = '';
      if (_selectedMasterDesignationId != null) {
        final masterDesignation = widget.controller.designations.firstWhere(
          (d) => d.designationId == _selectedMasterDesignationId,
          orElse: () => DesignationModel(),
        );
        masterDesignationName = masterDesignation.designationName;
      }

      final updatedDesignation = DesignationModel(
        designationId: widget.designation.designationId,
        designationName: _nameController.text,
        masterDesignationId: _selectedMasterDesignationId ?? '',
        masterDesignationName: masterDesignationName,
      );
      
      widget.controller.saveDesignation(updatedDesignation);
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
          // Dialog Header
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
                  widget.designation.designationId.isEmpty 
                      ? 'Add Designation'
                      : 'Edit Designation',
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

          // Dialog Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Designation *',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Designation';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Obx(() => DropdownButtonFormField<String>(
                  value: _selectedMasterDesignationId,
                  decoration: InputDecoration(
                    labelText: 'Master Designation',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('None'),
                    ),
                    ...widget.controller.designations
                        .where((d) => d.designationId != widget.designation.designationId) // Exclude current designation
                        .map((designation) {
                      return DropdownMenuItem<String>(
                        value: designation.designationId,
                        child: Text(designation.designationName),
                      );
                    }),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedMasterDesignationId = value;
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