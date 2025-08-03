  // Inventory Dialog
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/widget/reusable/button/form_button.dart';

class InventoryDialog extends StatefulWidget {
  const InventoryDialog({super.key});

  @override
  State<InventoryDialog> createState() => _InventoryDialogState();
}

class _InventoryDialogState extends State<InventoryDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _assetNameController = TextEditingController();
  final TextEditingController _manufactureController = TextEditingController();
  final TextEditingController _modelNumberController = TextEditingController();
  final TextEditingController _serialNumberController = TextEditingController();

  DateTime? _issueDate;
  DateTime? _purchaseDate;
  bool _isRental = true;
  bool _isInstock = false;
  String? _selectedDepartment;
  String? _selectedEmployee;

  @override
  void dispose() {
    _assetNameController.dispose();
    _manufactureController.dispose();
    _modelNumberController.dispose();
    _serialNumberController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Implement save functionality
      Navigator.of(context).pop();
    }
  }

  Future<void> _selectDate(BuildContext context, bool isIssueDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isIssueDate) {
          _issueDate = picked;
        } else {
          _purchaseDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    Widget buildResponsiveRow(List<Widget> children) {
      if (isMobile) {
        return Column(
          children: children.map((child) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: SizedBox(width: double.infinity, child: child),
          )).toList(),
        );
      } else {
        return Row(
          children: List.generate(children.length * 2 - 1, (index) {
            if (index.isEven) {
              return Expanded(child: children[index ~/ 2]);
            } else {
              return const SizedBox(width: 16);
            }
          }),
        );
      }
    }

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
                const Text(
                  'Add Asset',
                  style: TextStyle(
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
              children: [
                TextFormField(
                  controller: _assetNameController,
                  decoration: const InputDecoration(
                    labelText: 'Asset Name*',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value?.isEmpty ?? true 
                      ? 'Asset name is required' 
                      : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: CheckboxListTile(
                              title: const Text('Rental'),
                              value: _isRental,
                              onChanged: (value) {
                                setState(() {
                                  _isRental = value ?? true;
                                });
                              },
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                          Expanded(
                            child: CheckboxListTile(
                              title: const Text('Purchase'),
                              value: !_isRental,
                              onChanged: (value) {
                                setState(() {
                                  _isRental = !(value ?? false);
                                });
                              },
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                buildResponsiveRow([
                  TextFormField(
                    controller: _manufactureController,
                    decoration: const InputDecoration(
                      labelText: 'Manufacture*',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value?.isEmpty ?? true 
                        ? 'Manufacture is required' 
                        : null,
                  ),
                  TextFormField(
                    controller: _serialNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Serial Number*',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value?.isEmpty ?? true 
                        ? 'Serial number is required' 
                        : null,
                  ),
                ]),
                const SizedBox(height: 16),
                buildResponsiveRow([
                  TextFormField(
                    controller: _modelNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Model Number*',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value?.isEmpty ?? true 
                        ? 'Model number is required' 
                        : null,
                  ),
                  TextFormField(
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Purchase Date*',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    controller: TextEditingController(
                      text: _purchaseDate?.toString().split(' ')[0] ?? '',
                    ),
                    onTap: () => _selectDate(context, false),
                    validator: (value) => _purchaseDate == null 
                        ? 'Purchase date is required' 
                        : null,
                  ),
                ]),
                const SizedBox(height: 16),
                buildResponsiveRow([
                  TextFormField(
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Issue Date*',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    controller: TextEditingController(
                      text: _issueDate?.toString().split(' ')[0] ?? '',
                    ),
                    onTap: () => _selectDate(context, true),
                    validator: (value) => _issueDate == null 
                        ? 'Issue date is required' 
                        : null,
                  ),                  CheckboxListTile(
                    title: const Text('Instock'),
                    value: _isInstock,
                    onChanged: (value) {
                      setState(() {
                        _isInstock = value ?? false;
                      });
                    },
                    contentPadding: EdgeInsets.zero,
                  ),
                ]),
                const SizedBox(height: 16),
                buildResponsiveRow([
                  DropdownButtonFormField<String>(
                    value: _selectedDepartment,
                    decoration: const InputDecoration(
                      labelText: 'Department',
                      border: OutlineInputBorder(),
                    ),
                    items: <String>['IT', 'HR', 'Finance', 'Operations']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedDepartment = newValue;
                      });
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: _selectedEmployee,
                    decoration: const InputDecoration(
                      labelText: 'Allocated to',
                      border: OutlineInputBorder(),
                    ),
                    items: <String>['John Doe', 'Jane Smith', 'Bob Johnson']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedEmployee = newValue;
                      });
                    },
                  ),
                ]),
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
