import 'package:flutter/material.dart';
import 'package:time_attendance/widget/reusable/button/form_button.dart';

class InventoryDialog extends StatefulWidget {
  final String title;
  const InventoryDialog({Key? key, this.title = 'Add Inventory'}) : super(key: key);

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
  bool _isPurchase = false;
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
    double dialogWidth = MediaQuery.of(context).size.width < 767
        ? MediaQuery.of(context).size.width * 0.9
        : MediaQuery.of(context).size.width * 0.5;
    double dialogHeight = MediaQuery.of(context).size.width < 767
        ? MediaQuery.of(context).size.height * 0.45
        : MediaQuery.of(context).size.height * 0.67;
    
    bool isSmallScreen = MediaQuery.of(context).size.width < 720;

    return Container(
      width: dialogWidth,
      height: dialogHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
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
                  widget.title,
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
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Asset Name and Checkboxes Row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Asset Name
                          Expanded(
                            flex: isSmallScreen ? 100 : 50,
                            child: TextFormField(
                              controller: _assetNameController,
                              decoration: InputDecoration(
                                labelText: 'Asset Name*',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              validator: (value) => 
                                value?.isEmpty ?? true ? 'Please enter Asset Name' : null,
                            ),
                          ),
                          if (!isSmallScreen) const SizedBox(width: 20),
                          // Checkboxes
                          if (!isSmallScreen)
                            Expanded(
                              flex: 50,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Checkbox(
                                      value: _isRental,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          _isRental = value ?? false;
                                          if (_isRental) _isPurchase = false;
                                        });
                                      },
                                    ),
                                    const Text('Rental'),
                                    const SizedBox(width: 20),
                                    Checkbox(
                                      value: _isPurchase,
                                      onChanged: (bool? value) {
                                        setState(() {
                                          _isPurchase = value ?? false;
                                          if (_isPurchase) _isRental = false;
                                        });
                                      },
                                    ),
                                    const Text('Purchase'),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                      if (isSmallScreen) const SizedBox(height: 20),
                      if (isSmallScreen)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Checkbox(
                              value: _isRental,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isRental = value ?? false;
                                  if (_isRental) _isPurchase = false;
                                });
                              },
                            ),
                            const Text('Rental'),
                            const SizedBox(width: 20),
                            Checkbox(
                              value: _isPurchase,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isPurchase = value ?? false;
                                  if (_isPurchase) _isRental = false;
                                });
                              },
                            ),
                            const Text('Purchase'),
                          ],
                        ),
                      const SizedBox(height: 20),

                      // Manufacture
                      if (!isSmallScreen)
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _manufactureController,
                                decoration: InputDecoration(
                                  labelText: 'Manufacture*',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                validator: (value) => 
                                  value?.isEmpty ?? true ? 'Please enter Manufacture' : null,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: TextFormField(
                                controller: _serialNumberController,
                                decoration: InputDecoration(
                                  labelText: 'Serial Number*',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                validator: (value) => 
                                  value?.isEmpty ?? true ? 'Please enter Serial Number' : null,
                              ),
                            ),
                          ],
                        ),
                      if (isSmallScreen)
                        Column(
                          children: [
                            TextFormField(
                              controller: _manufactureController,
                              decoration: InputDecoration(
                                labelText: 'Manufacture*',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              validator: (value) => 
                                value?.isEmpty ?? true ? 'Please enter Manufacture' : null,
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _serialNumberController,
                              decoration: InputDecoration(
                                labelText: 'Serial Number*',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              validator: (value) => 
                                value?.isEmpty ?? true ? 'Please enter Serial Number' : null,
                            ),
                          ],
                        ),
                      const SizedBox(height: 20),
                      if (!isSmallScreen)
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _modelNumberController,
                                decoration: InputDecoration(
                                  labelText: 'Model Number*',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                validator: (value) => 
                                  value?.isEmpty ?? true ? 'Please enter Model Number' : null,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: TextFormField(
                                controller: _purchaseDateController,
                                decoration: InputDecoration(
                                  labelText: 'Purchase Date*',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
                                readOnly: true,
                              ),
                            ),
                          ],
                        ),
                      if (isSmallScreen)
                        Column(
                          children: [
                            TextFormField(
                              controller: _modelNumberController,
                              decoration: InputDecoration(
                                labelText: 'Model Number*',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              validator: (value) => 
                                value?.isEmpty ?? true ? 'Please enter Model Number' : null,
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: _purchaseDateController,
                              decoration: InputDecoration(
                                labelText: 'Purchase Date*',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
                              readOnly: true,
                            ),
                          ],
                        ),
                      const SizedBox(height: 20),
                      if (!isSmallScreen)
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: TextFormField(
                                controller: _issueDateController,
                                decoration: InputDecoration(
                                  labelText: 'Issue Date*',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
                                readOnly: true,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  Checkbox(
                                    value: _isInStock,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _isInStock = value ?? false;
                                      });
                                    },
                                  ),
                                  const Text('Instock'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      if (isSmallScreen)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextFormField(
                              controller: _issueDateController,
                              decoration: InputDecoration(
                                labelText: 'Issue Date*',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
                              readOnly: true,
                            ),
                            const SizedBox(height: 20),
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
                                const Text('Instock'),
                              ],
                            ),
                          ],
                        ),
                      const SizedBox(height: 20),
                      if (!isSmallScreen)
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: 'Department',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                ),
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
                            const SizedBox(width: 20),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: 'Allocated to',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                ),
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
                      if (isSmallScreen)
                        Column(
                          children: [
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'Department',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              ),
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
                            const SizedBox(height: 20),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'Allocated to',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              ),
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
                          ],
                        ),
                      const SizedBox(height: 40),                      
                      // Buttons
                      CustomButtons(
                        onSavePressed: _handleSave,
                        onCancelPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}