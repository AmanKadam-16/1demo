import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/model/Masters/shiftPattern.dart';
import 'package:time_attendance/model/Masters/list_of_shift_model.dart';
import 'package:time_attendance/controller/shift_tab_controller/shift_pattern_controller.dart';
import 'package:time_attendance/widget/reusable/button/form_button.dart';

class ShiftPatternDialog extends StatefulWidget {
  final ShiftPatternController controller;
  final ShiftPatternModel shiftPattern;

  const ShiftPatternDialog({
    Key? key,
    required this.controller,
    required this.shiftPattern,
  }) : super(key: key);

  @override
  State<ShiftPatternDialog> createState() => _ShiftPatternDialogState();
}

class _ShiftPatternDialogState extends State<ShiftPatternDialog> {
  late TextEditingController _nameController;
  final _formKey = GlobalKey<FormState>();
  
  // Regular expression for validating pattern name
  final RegExp _patternNameRegex = RegExp(r'^[a-zA-Z][a-zA-Z0-9]*$');
  
  // List to hold all available shifts
  List<ListOfShift> availableShifts = [];
  
  // List to hold selected shifts in sequence
  List<ListOfShift> selectedShifts = [];
  
  // Track currently selected shifts in each list
  ListOfShift? selectedAvailableShift;
  ListOfShift? selectedPatternShift;
  
  int? selectedPatternIndex;

  // Error messages
  String? patternNameError;
  String? shiftSelectionError;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.shiftPattern.patternName);
    
    // Initialize selected shifts from the pattern
    selectedShifts = List.from(widget.shiftPattern.listOfShifts);
    
    // Observe controller's shifts for changes
    ever(widget.controller.shifts, (shifts) {
      if (mounted) {
        setState(() {
          availableShifts = List.from(shifts);
        });
      }
    });
    
    // Initialize available shifts
    availableShifts = List.from(widget.controller.shifts);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String? _validatePatternName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Pattern name is required';
    }
    if (!_patternNameRegex.hasMatch(value)) {
      return 'Pattern name must start with a letter and contain only letters and numbers (no spaces)';
    }
    return null;
  }  bool _isValidPatternName(String name) {
    // Pattern to match: starts with letter, followed by letters and numbers only
    final RegExp patternNameRegex = RegExp(r'^[a-zA-Z][a-zA-Z0-9]*$');
    return patternNameRegex.hasMatch(name);
  }  void _handleSave() async {
    // Reset error messages
    setState(() {
      patternNameError = null;
      shiftSelectionError = null;
    });

    // Validate pattern name
    if (!_isValidPatternName(_nameController.text)) {
      setState(() {
        patternNameError = 'Pattern name must start with a letter and contain only letters and numbers (no spaces)';
      });
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      if (selectedShifts.isEmpty) {
        setState(() {
          shiftSelectionError = 'Please select at least one shift for the pattern';
        });
        return;
      }

      try {
        // Convert selected shifts to a list of shift IDs
        final List<String> shiftIds = selectedShifts.map((s) => s.shiftId.toString()).toList();
        bool success;
        if (widget.shiftPattern.patternId == 0) {
          // Create new pattern
          success = await widget.controller.saveShiftPattern(
            _nameController.text,
            shiftIds,
          );
        } else {
          // Update existing pattern
          success = await widget.controller.updateShiftPattern(
            widget.shiftPattern.patternId,
            _nameController.text,
            shiftIds,
          );
        }

        // Close the dialog after successful save/update
        if (success) {
          widget.controller.fetchShiftPatterns(); // Refresh the list
          Navigator.of(context).pop();
        }
      } catch (e) {
        // Error handling is already done in the controller
        // The toast will show the error message
      }
    }
  }
  void _addShiftToPattern() {
    setState(() {
      patternNameError = null;
      shiftSelectionError = null;
    });

    // First check if pattern name is filled
    if (_nameController.text.trim().isEmpty) {
      setState(() {
        patternNameError = 'Please enter Pattern Name first';
      });
      return;
    }

    if (selectedAvailableShift != null) {
      setState(() {
        selectedShifts.add(selectedAvailableShift!);
        selectedAvailableShift = null;
      });
    }
  }

  void _removeShiftFromPattern() {
    if (selectedPatternIndex != null) {
      setState(() {
        selectedShifts.removeAt(selectedPatternIndex!);
        selectedPatternIndex = null;
        selectedPatternShift = null;
      });
    }
  }

  void _removeAllShiftsFromPattern() {
    setState(() {
      selectedShifts.clear();
      selectedPatternIndex = null;
      selectedPatternShift = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
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
                  widget.shiftPattern.patternId == 0
                      ? 'Add Shift Pattern'
                      : 'Edit Shift Pattern',
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
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Shift Pattern Name *',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      errorText: patternNameError,
                    ),
                    validator: _validatePatternName,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Shift Pattern *',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  if (shiftSelectionError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        shiftSelectionError!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Available Shifts List
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Available Shifts'),
                            const SizedBox(height: 8),
                            Container(
                              height: 200,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ListView.builder(
                                itemCount: availableShifts.length,
                                itemBuilder: (context, index) {
                                  final shift = availableShifts[index];
                                  final isSelected = selectedAvailableShift?.shiftId == shift.shiftId;
                                  
                                  return Material(
                                    color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedAvailableShift = shift;
                                          selectedPatternShift = null;
                                          selectedPatternIndex = null;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              shift.shiftName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            if (selectedAvailableShift != null) ...[
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey.shade50,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ShiftName: ${selectedAvailableShift!.shiftName}',
                                      style: const TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'InTime: ${selectedAvailableShift!.inTime}',
                                      style: const TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'OutTime: ${selectedAvailableShift!.outTime}',
                                      style: const TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      
                      // Control Buttons
                      Container(
                        width: 60,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 60),
                            ElevatedButton(
                              onPressed: selectedAvailableShift != null ? _addShiftToPattern : null,
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(44, 44),
                                padding: EdgeInsets.zero,
                              ),
                              child: const Icon(Icons.arrow_forward),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: selectedPatternIndex != null ? _removeShiftFromPattern : null,
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(44, 44),
                                padding: EdgeInsets.zero,
                              ),
                              child: const Icon(Icons.arrow_back),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: selectedShifts.isNotEmpty ? _removeAllShiftsFromPattern : null,
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(44, 44),
                                padding: EdgeInsets.zero,
                              ),
                              child: const Text('<<'),
                            ),
                          ],
                        ),
                      ),
                      
                      // Selected Shifts Pattern List
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Selected Pattern Sequence'),
                            const SizedBox(height: 8),
                            Container(
                              height: 200,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: selectedShifts.isEmpty
                                ? const Center(
                                    child: Text(
                                      'No shifts selected',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: selectedShifts.length,
                                    itemBuilder: (context, index) {
                                      final shift = selectedShifts[index];
                                      final isSelected = selectedPatternIndex == index;
                                      
                                      return Material(
                                        color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              selectedPatternIndex = index;
                                              selectedPatternShift = shift;
                                              selectedAvailableShift = null;
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: 24,
                                                  height: 24,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.blue.withOpacity(0.1),
                                                  ),
                                                  child: Text('${index + 1}'),
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        shift.shiftName,
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  CustomButtons(
                    onSavePressed: _handleSave,
                    onCancelPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}