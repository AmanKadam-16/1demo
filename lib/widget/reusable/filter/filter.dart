import 'package:flutter/material.dart';
import 'text_feaild.dart'; // Import for InlineTextField

class ExpandableFilter extends StatefulWidget {
  final Map<String, List<String>> filterOptions;
  final Map<String, bool> textFieldOptions; // New field for text inputs
  final Function(Map<String, String>) onApplyFilters;
  final Function() onClearFilters;
  final bool isLoading;

  const ExpandableFilter({
    Key? key,
    required this.filterOptions,
    this.textFieldOptions = const {}, // Default empty map if not provided
    required this.onApplyFilters,
    required this.onClearFilters,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<ExpandableFilter> createState() => _ExpandableFilterState();
}

class _ExpandableFilterState extends State<ExpandableFilter> {
  bool isExpanded = false;
  Map<String, String> selectedValues = {};
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    _removeOverlay();
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _showFilterOverlay() {
    _removeOverlay();

    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size size = renderBox.size;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx + size.width, // Position to the right of the button
        top: offset.dy,
        child: CompositedTransformFollower(
          link: _layerLink,
          targetAnchor: Alignment.topLeft,
          followerAnchor: Alignment.topLeft,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 300, // Adjust width as needed
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.6,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: _buildFilterContent(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  List<Widget> _buildFilterContent() {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Filter By',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              setState(() {
                isExpanded = false;
                _removeOverlay();
              });
            },
          ),
        ],
      ),
      const SizedBox(height: 16),
      
      // Text Field for Employee Name
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: InlineTextField(
          label: 'Employee Name',
          value: selectedValues['Employee Name'],
          onChanged: (value) {
            setState(() {
              if (value.isNotEmpty) {
                selectedValues['Employee Name'] = value;
              } else {
                selectedValues.remove('Employee Name');
              }
            });
          },
          hintText: 'Enter employee name',
        ),
      ),
      
      // Text Field for Employee ID
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: InlineTextField(
          label: 'Employee ID',
          value: selectedValues['Employee ID'],
          onChanged: (value) {
            setState(() {
              if (value.isNotEmpty) {
                selectedValues['Employee ID'] = value;
              } else {
                selectedValues.remove('Employee ID');
              }
            });
          },
          hintText: 'Enter employee ID',
        ),
      ),
      
      // Text Field for Enroll ID
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: InlineTextField(
          label: 'Enroll ID',
          value: selectedValues['Enroll ID'],
          onChanged: (value) {
            setState(() {
              if (value.isNotEmpty) {
                selectedValues['Enroll ID'] = value;
              } else {
                selectedValues.remove('Enroll ID');
              }
            });
          },
          hintText: 'Enter enroll ID',
        ),
      ),
      
      // Dropdown Filter Options
      ...widget.filterOptions.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  String? selectedValue = selectedValues[entry.key];
                  return AlertDialog(
                    title: Text('Select ${entry.key}'),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: Text('Select ${entry.key}'),
                            selected: selectedValue == null,
                            onTap: () {
                              setState(() {
                                selectedValues.remove(entry.key);
                              });
                              Navigator.pop(context);
                            },
                          ),
                          ...entry.value.map(
                            (option) => ListTile(
                              title: Text(option),
                              selected: selectedValue == option,
                              onTap: () {
                                setState(() {
                                  selectedValues[entry.key] = option;
                                });
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.key,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        selectedValues[entry.key] ?? 'Select ${entry.key}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        );
      }).toList(),
      
      // Additional text fields from textFieldOptions
      ...widget.textFieldOptions.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InlineTextField(
            label: entry.key,
            value: selectedValues[entry.key],
            onChanged: (value) {
              setState(() {
                if (value.isNotEmpty) {
                  selectedValues[entry.key] = value;
                } else {
                  selectedValues.remove(entry.key);
                }
              });
            },
            hintText: 'Enter ${entry.key}',
            validator: entry.value ? (value) {
              if (value == null || value.isEmpty) {
                return '${entry.key} is required';
              }
              return null;
            } : null,
          ),
        );
      }).toList(),
      
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  selectedValues.clear();
                });
                widget.onClearFilters();
              },
              child: const Text('Clear'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: widget.isLoading
                  ? null
                  : () {
                      widget.onApplyFilters(selectedValues);
                      setState(() {
                        isExpanded = false;
                        _removeOverlay();
                      });
                    },
              child: widget.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Apply'),
            ),
          ),
        ],
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    Widget filterButton;
    if (screenWidth <= 600) {
      filterButton = Padding(
        padding: const EdgeInsets.all(10.0),
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              isExpanded = !isExpanded;
              if (isExpanded) {
                _showFilterOverlay();
              } else {
                _removeOverlay();
              }
            });
          },
          backgroundColor: isExpanded 
            ? Theme.of(context).colorScheme.secondaryContainer
            : Theme.of(context).colorScheme.secondaryContainer,
          child: Icon(
            isExpanded ? Icons.filter_list_off : Icons.filter_list,
            size: 15,
          ),
          mini: true,
        ),
      );
    } else {
      filterButton = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: ElevatedButton.icon(
          onPressed: () {
            setState(() {
              isExpanded = !isExpanded;
              if (isExpanded) {
                _showFilterOverlay();
              } else {
                _removeOverlay();
              }
            });
          },
          icon: Icon(
            isExpanded ? Icons.filter_list_off : Icons.filter_list,
          ),
          label: const Text('Filters'),
          style: ElevatedButton.styleFrom(
            backgroundColor: isExpanded 
              ? Theme.of(context).colorScheme.secondaryContainer
              : Theme.of(context).colorScheme.secondaryContainer,
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            minimumSize: const Size(200, 40),
          ),
        ),
      );
    }

    return CompositedTransformTarget(
      link: _layerLink,
      child: filterButton,
    );
  }
}