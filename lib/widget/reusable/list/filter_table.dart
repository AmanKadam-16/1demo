import 'package:flutter/material.dart';

class ReusableTableAndCard extends StatefulWidget {
  final List<Map<String, String>> data;
  final List<String> headers;
  final List<String> visibleColumns;
  final Function(Map<String, String>)? onEdit;
  final Function(Map<String, String>)? onDelete;
  final Function(Map<String, String>)? onGeoFence;
  final Function(String columnName, bool isAscending)? onSort;
  final Function(List<Map<String, String>>)? onSelectedRows; // Add this line

  const ReusableTableAndCard({
    super.key,
    required this.data,
    required this.headers,
    this.visibleColumns = const [],
    this.onEdit,
    this.onDelete,
    this.onGeoFence,
    this.onSort,
    this.onSelectedRows, // Add this line
  });

  @override
  _ReusableTableAndCardState createState() => _ReusableTableAndCardState();
}

class _ReusableTableAndCardState extends State<ReusableTableAndCard> {
  String? _currentSortColumn;
  bool _isAscending = true;
  List<String> _selectedColumns = [];
  Map<int, bool> _checkboxStates = {};
  bool _isAnyCheckboxSelected = false;

  @override
  void initState() {
    super.initState();
    _selectedColumns = widget.visibleColumns.isNotEmpty ? List.from(widget.visibleColumns) : List.from(widget.headers);
    // Ensure "Actions" column is always visible
    if (!_selectedColumns.contains("Actions")) {
      _selectedColumns.add("Actions");
    }
    // Initialize checkbox states
    for (var i = 0; i < widget.data.length; i++) {
      _checkboxStates[i] = false;
    }
  }

  void _onSort(String column) {
    setState(() {
      if (_currentSortColumn == column) {
        _isAscending = !_isAscending;
      } else {
        _currentSortColumn = column;
        _isAscending = true;
      }
      widget.onSort?.call(column, _isAscending);
    });
  }

  Widget _buildSortableHeader(String header) {
    return Expanded(
      child: InkWell(
        onTap: header != "Actions" && header != "GeoFence" ? () => _onSort(header) : null,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: Row(
            mainAxisAlignment: header == "GeoFence" ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Text(
                header,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              if (_currentSortColumn == header)
                Icon(
                  _isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGeoFenceIcon(Map<String, String> row) {
    final isGeoFenceEnabled = row['GeoFence'] == 'Yes';
    return InkWell(
      onTap: () => widget.onGeoFence?.call(row),
      child: Icon(
        isGeoFenceEnabled ? Icons.location_on : Icons.location_off,
        color: isGeoFenceEnabled ? Colors.green : Colors.red,
      ),
    );
  }

  void _showColumnSelectionDialog(BuildContext context) {
  // Create a local set of selected columns that we'll modify in the dialog
  Set<String> localSelectedColumns = Set.from(_selectedColumns);

  showDialog(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder( // Use StatefulBuilder to manage dialog state
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text('Select Columns'),
            content: SingleChildScrollView(
              child: Column(
                children: widget.headers.map((header) {
                  if (header == "Actions") return SizedBox.shrink(); // Exclude "Actions" from selection
                  return CheckboxListTile(
                    title: Text(header),
                    value: localSelectedColumns.contains(header),
                    onChanged: (bool? value) {
                      // Update both the dialog state and local selection
                      setDialogState(() {
                        if (value == true) {
                          localSelectedColumns.add(header);
                        } else {
                          localSelectedColumns.remove(header);
                        }
                      });
                      
                      // Update the parent widget's state
                      setState(() {
                        _selectedColumns = localSelectedColumns.toList();
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            actions: [
              TextButton(
                child: Text('Close'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      );
    },
  );
}

  void _toggleAllCheckboxes(bool? value) {
    setState(() {
      for (var i = 0; i < widget.data.length; i++) {
        _checkboxStates[i] = value ?? false;
      }
      _updateSelectedStatus();
    });
  }

  void _updateSelectedStatus() {
    setState(() {
      _isAnyCheckboxSelected = _checkboxStates.values.any((isChecked) => isChecked);
    });
    if (widget.onSelectedRows != null) {
      final selectedRows = widget.data.where((row) => 
        _checkboxStates[widget.data.indexOf(row)] ?? false).toList();
      widget.onSelectedRows!(selectedRows);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= 600) {
          return _buildCardView(context, 1);
        } else if (constraints.maxWidth <= 920) {
          return _buildCardView(context, 2);
        } else {
          return _buildTableView(context);
        }
      },
    );
  }

Widget _buildTableView(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Container(
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: Row(
              children: [
                // Add checkbox column
                Expanded(
                  flex: 1,
                  child: Checkbox(
                    value: _checkboxStates.values.every((isChecked) => isChecked),
                    onChanged: _toggleAllCheckboxes,
                  ),
                ),
                // Existing header row
                Expanded(
                  flex: 8,
                  child: Row(
                    children: _selectedColumns
                        .where((header) => header != "Actions" && header != "GeoFence")
                        .map((header) => _buildSortableHeader(header))
                        .toList(),
                  ),
                ),
                if (_selectedColumns.contains("GeoFence"))
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        "GeoFence",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (_isAnyCheckboxSelected)
                        IconButton(
                          icon: const Icon(Icons.done_all),
                          onPressed: () {
                            // Handle bulk action here
                          },
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      IconButton(
                        icon: Icon(Icons.more_vert),
                        onPressed: () => _showColumnSelectionDialog(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: widget.data.map((row) {
                  final index = widget.data.indexOf(row);
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xFFDEE2E6),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Add checkbox for each row
                        Expanded(
                          flex: 1,
                          child: Checkbox(
                            value: _checkboxStates[index] ?? false,
                            onChanged: (value) {
                              setState(() {
                                _checkboxStates[index] = value ?? false;
                                _updateSelectedStatus();
                              });
                            },
                          ),
                        ),
                        Expanded(
                          flex: 9,
                          child: Row(
                            children: _selectedColumns
                                .where((header) => header != "Actions" && header != "GeoFence")
                                .map((header) {
                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                                  child: Tooltip(
                                    message: (row[header]?.length ?? 0) > 12 ? row[header]! : '',
                                    child: Text(
                                      (row[header]?.length ?? 0) > 20
                                          ? '${row[header]!.substring(0, 20)}...'
                                          : row[header] ?? '',
                                      style: const TextStyle(
                                        color: Color(0xFF495057),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        if (_selectedColumns.contains("GeoFence"))
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: _buildGeoFenceIcon(row),
                            ),
                          ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (widget.onEdit != null)
                                IconButton(
                                  icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.primary),
                                  onPressed: () => widget.onEdit!(row),
                                ),
                              if (widget.onDelete != null)
                                IconButton(
                                  icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.error),
                                  onPressed: () => widget.onDelete!(row),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardView(BuildContext context, int cardsPerRow) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: List.generate(
            (widget.data.length / cardsPerRow).ceil(),
            (rowIndex) {
              return Row(
                children: List.generate(cardsPerRow, (colIndex) {
                  final index = rowIndex * cardsPerRow + colIndex;
                  if (index >= widget.data.length) {
                    return Expanded(child: Container());
                  }
                  final row = widget.data[index];
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => _showFullInfoDialog(context, row),
                      child: Card(
                        margin: const EdgeInsets.all(4.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: _selectedColumns
                                      .where((header) =>
                                          header != "Actions" &&
                                          header != "City" &&
                                          header != "State")
                                      .take(2)
                                      .map((header) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: Tooltip(
                                        message: (row[header]?.length ?? 0) > 12
                                            ? row[header]!
                                            : '',
                                        child: GestureDetector(
                                          onTap: () => _showFullTextDialog(
                                              context, header, row[header]),
                                          child: Text(
                                            (row[header]?.length ?? 0) > 20
                                                ? '${row[header]!.substring(0, 20)}...'
                                                : row[header] ?? '',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (_selectedColumns.contains('GeoFence'))
                                      InkWell(
                                        onTap: () => widget.onGeoFence?.call(row),
                                        child: row['GeoFence'] == 'Yes'
                                          ? const Icon(Icons.location_on, color: Colors.green)
                                          : const Icon(Icons.location_off, color: Colors.red),
                                      ),
                                    if (widget.onEdit != null)
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        color: Theme.of(context).colorScheme.primary,
                                        onPressed: () => widget.onEdit!(row),
                                      ),
                                    if (widget.onDelete != null)
                                      IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Theme.of(context).colorScheme.error),
                                        onPressed: () => widget.onDelete!(row),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showFullTextDialog(BuildContext context, String? header, String? text) {
    if (text == null || text.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(header ?? 'Details'),
          content: Text(text),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  void _showFullInfoDialog(BuildContext context, Map<String, String> row) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Full Information'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: row.entries.map((entry) {
                if (entry.key == 'longitude' || entry.key == 'latitude' || entry.key == 'distance' || (entry.key != 'Actions' && entry.value.isNotEmpty)) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      '${entry.key}: ${entry.value}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}