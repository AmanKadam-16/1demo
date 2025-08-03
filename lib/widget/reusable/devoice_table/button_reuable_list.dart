import 'package:flutter/material.dart';
import '../table_action_buttons.dart';

class ReusableTableAndCardButton extends StatefulWidget {
  final List<Map<String, String>> data;
  final List<String> headers;
  final List<String> visibleColumns;
  final Function(String columnName, bool isAscending)? onSort;
  final Function(List<Map<String, String>>)? onDownloadSelected;
  final Function(List<Map<String, String>>)? onCancelSelected;

  const ReusableTableAndCardButton({
    super.key,
    required this.data,
    required this.headers,
    this.visibleColumns = const [],
    this.onSort,
    this.onDownloadSelected,
    this.onCancelSelected,
  });

  @override
  _ReusableTableAndCardState createState() => _ReusableTableAndCardState();
}

class _ReusableTableAndCardState extends State<ReusableTableAndCardButton> {
  String? _currentSortColumn;
  bool _isAscending = true;
  Map<int, bool> _checkboxStates = {}; // Track checkbox states
  
  // Track if any checkbox is selected
  bool get _isAnyCheckboxSelected => _checkboxStates.values.any((isChecked) => isChecked);

  @override
  void initState() {
    super.initState();
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

  void _toggleAllCheckboxes(bool? value) {
    setState(() {
      for (var i = 0; i < widget.data.length; i++) {
        _checkboxStates[i] = value ?? false;
      }
    });
  }

  // Get all selected rows
  List<Map<String, String>> _getSelectedRows() {
    List<Map<String, String>> selectedRows = [];
    _checkboxStates.forEach((index, isSelected) {
      if (isSelected && index < widget.data.length) {
        selectedRows.add(widget.data[index]);
      }
    });
    return selectedRows;
  }

  // Handle bulk download
  void _handleDownload() {
    final selectedRows = _getSelectedRows();
    if (selectedRows.isNotEmpty && widget.onDownloadSelected != null) {
      widget.onDownloadSelected!(selectedRows);
    }
  }

  // Handle bulk cancel
  void _handleCancel() {
    final selectedRows = _getSelectedRows();
    if (selectedRows.isNotEmpty && widget.onCancelSelected != null) {
      widget.onCancelSelected!(selectedRows);
      // Reset checkbox states after cancellation
      setState(() {
        _checkboxStates = {};
        for (var i = 0; i < widget.data.length; i++) {
          _checkboxStates[i] = false;
        }
      });
    }
  }

  Widget _buildSortableHeader(String header) {
    return Expanded(
      child: InkWell(
        onTap: header != "Actions" ? () => _onSort(header) : null,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  header.length > 10 ? '${header.substring(0, 10)}...' : header,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
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

  // Build app bar with the new buttons
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text('Data Table'),
      actions: [
        TableActionButtons(
          isAnySelected: _isAnyCheckboxSelected,
          onDownload: _handleDownload,
          onCancel: _handleCancel,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: LayoutBuilder(        builder: (context, constraints) {
          if (constraints.maxWidth <= 600) {
            return _buildCardView(context, 1);
          } else if (constraints.maxWidth <= 920) {
            return _buildCardView(context, 2);
          } else {
            return _buildTableView(context);
          }
        },
      ),
    );
  }

  Widget _buildTableView(BuildContext context) {
    final headers = widget.headers
        .where((header) =>
            widget.visibleColumns.isEmpty || widget.visibleColumns.contains(header))
        .toList();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Container(
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Checkbox(
                    value: _checkboxStates.values.every((isChecked) => isChecked) && widget.data.isNotEmpty,
                    onChanged: _toggleAllCheckboxes,
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Row(
                    children: headers
                        .map((header) => _buildSortableHeader(header))
                        .toList(),
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
                        Expanded(
                          flex: 1,
                          child: Checkbox(
                            value: _checkboxStates[index] ?? false,
                            onChanged: (value) {
                              setState(() {
                                _checkboxStates[index] = value ?? false;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          flex: 8,
                          child: Row(
                            children: headers.map((header) {
                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                                  child: Tooltip(
                                    message: (row[header]?.length ?? 0) > 12 ? row[header]! : '',
                                    child: Text(
                                      row[header] ?? '',
                                      style: const TextStyle(
                                        color: Color(0xFF495057),
                                        fontSize: 13,
                                      ),
                                      overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
                                      maxLines: 1, // Ensure text is limited to one line
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
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
                              Checkbox(
                                value: _checkboxStates[index] ?? false,
                                onChanged: (value) {
                                  setState(() {
                                    _checkboxStates[index] = value ?? false;
                                  });
                                },
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: widget.headers
                                      .where((header) =>
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
                                            row[header] ?? '',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                            ),
                                            overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
                                            maxLines: 1, // Ensure text is limited to one line
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
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
                if (entry.key != 'Actions' && entry.value.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      '${entry.key}: ${entry.value}',
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
                      maxLines: 1, // Ensure text is limited to one line
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