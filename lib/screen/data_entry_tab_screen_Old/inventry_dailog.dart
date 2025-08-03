import 'package:flutter/material.dart';
import 'package:time_attendance/model/Data_entry_tab_model/inventry_model.dart';
import 'package:time_attendance/widget/reusable/button/form_button.dart';

class InventoryDialog extends StatefulWidget {
  final String title;
  final InventoryModel? inventory;  // Add this line

  const InventoryDialog({
    Key? key, 
    this.title = 'Add Inventory',
    this.inventory,  // Add this line
  }) : super(key: key);

  @override
  _InventoryDialogState createState() => _InventoryDialogState();
}

class _InventoryDialogState extends State<InventoryDialog> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for text fields
  final _assetNameController = TextEditingController();
  final _manufactureController = TextEditingController();
  final _serialNumberController = TextEditingController();
  final _modelNumberController = TextEditingController();
  final _purchaseDateController = TextEditingController();
  final _issueDateController = TextEditingController();

  // State variables
  bool _isRental = false;
  bool _isInStock = false;
  String? _selectedDepartment;
  String? _selectedEmployee;

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _assetNameController.dispose();
    _manufactureController.dispose();
    _serialNumberController.dispose();
    _modelNumberController.dispose();
    _purchaseDateController.dispose();
    _issueDateController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      // Save logic here
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Add headline
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // First Row: Asset Name and Rental/Purchase
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _assetNameController,
                        decoration: InputDecoration(
                          labelText: 'Asset Name*',
                          border: OutlineInputBorder(),
                          hintText: 'Enter name',
                        ),
                        validator: (value) => 
                          value?.isEmpty ?? true ? 'Please enter Asset Name' : null,
                      ),
                    ),
                    SizedBox(width: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: _isRental,
                          onChanged: (bool? value) {
                            setState(() {
                              _isRental = value ?? false;
                            });
                          },
                        ),
                        Text('Rental'),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Second Row: Manufacture and Serial Number
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _manufactureController,
                        decoration: InputDecoration(
                          labelText: 'Manufacture*',
                          border: OutlineInputBorder(),
                          hintText: 'Enter manufacture',
                        ),
                        validator: (value) => 
                          value?.isEmpty ?? true ? 'Please enter Manufacture' : null,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _serialNumberController,
                        decoration: InputDecoration(
                          labelText: 'Serial Number*',
                          border: OutlineInputBorder(),
                          hintText: 'Enter Serial Number',
                        ),
                        validator: (value) => 
                          value?.isEmpty ?? true ? 'Please enter Serial Number' : null,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Third Row: Model Number and Purchase Date
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _modelNumberController,
                        decoration: InputDecoration(
                          labelText: 'Model Number*',
                          border: OutlineInputBorder(),
                          hintText: 'Enter Model Number',
                        ),
                        validator: (value) => 
                          value?.isEmpty ?? true ? 'Please enter Model Number' : null,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _purchaseDateController,
                        decoration: InputDecoration(
                          labelText: 'Purchase Date*',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _purchaseDateController.text = 
                                "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                            });
                          }
                        },
                        validator: (value) => 
                          value?.isEmpty ?? true ? 'Please enter Purchase Date' : null,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Fourth Row: Issue Date and Instock
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _issueDateController,
                        decoration: InputDecoration(
                          labelText: 'Issue Date*',
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _issueDateController.text = 
                                "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                            });
                          }
                        },
                        validator: (value) => 
                          value?.isEmpty ?? true ? 'Please enter Issue Date' : null,
                      ),
                    ),
                    SizedBox(width: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: _isInStock,
                          onChanged: (bool? value) {
                            setState(() {
                              _isInStock = value ?? false;
                            });
                          },
                        ),
                        Text('Instock'),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // Fifth Row: Department and Allocated to
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Department',
                          border: OutlineInputBorder(),
                        ),
                        hint: Text('Department'),
                        value: _selectedDepartment,
                        items: ['IT', 'HR', 'Finance', 'Marketing']
                            .map((department) => DropdownMenuItem(
                                  value: department,
                                  child: Text(department),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedDepartment = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Allocated to',
                          border: OutlineInputBorder(),
                        ),
                        hint: Text('Employee name'),
                        value: _selectedEmployee,
                        items: ['John Doe', 'Jane Smith', 'Mike Johnson']
                            .map((employee) => DropdownMenuItem(
                                  value: employee,
                                  child: Text(employee),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedEmployee = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),

                // Save and Cancel Buttons
                CustomButtons(
                  onSavePressed: _handleSave,
                  onCancelPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}