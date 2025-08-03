import 'package:flutter/material.dart';

class ReusableTableAndCard extends StatefulWidget {
  final List<Map<String, String>> data;
  final List<String> headers;
  final List<String> visibleColumns;
  final Function(Map<String, String>)? onEdit;
  final Function(Map<String, String>)? onDelete;
  final Function(Map<String, String>)? onGeoFence;
  final Function(String columnName, bool isAscending)? onSort;
  final bool showCheckboxes;
  final Set<String>? selectedItems;
  final Function(bool?)? onSelectAll;
  final Function(String, bool)? onSelectItem;
  final String? idField; // Field to use as unique identifier for selection
  // New optional parameters
  final IconData? editIcon;
  final IconData? deleteIcon;
  final String? editTooltip;
  final String? deleteTooltip;
  final List<CustomAction>? customActions;
  final int maxVisibleButtons;

  const ReusableTableAndCard({
    super.key,
    required this.data,
    required this.headers,
    this.visibleColumns = const [],
    this.onEdit,
    this.onDelete,
    this.onGeoFence,
    this.onSort,
    this.showCheckboxes = false,
    this.selectedItems,
    this.onSelectAll,
    this.onSelectItem,
    this.idField,
    this.editIcon,
    this.deleteIcon,
    this.editTooltip,
    this.deleteTooltip,
    this.customActions,
    this.maxVisibleButtons = 2, // Default to showing 2 buttons before overflow
  });

  @override
  _ReusableTableAndCardState createState() => _ReusableTableAndCardState();
}

/// Custom action definition for additional action buttons
class CustomAction {
  final IconData icon;
  final String tooltip;
  final Function(Map<String, String>) onPressed;
  final Color? color;
  final bool isEnabled;

  const CustomAction({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    this.color,
    this.isEnabled = true,
  });
}

class _ReusableTableAndCardState extends State<ReusableTableAndCard> {
  String? _currentSortColumn;
  bool _isAscending = true;

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
        onTap: header != "Actions" && header != "GeoFence"
            ? () => _onSort(header)
            : null,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: Row(
            mainAxisAlignment: header == "GeoFence"
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
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

  List<Widget> _buildActionButtons(Map<String, String> row, BuildContext context) {
    List<Widget> buttons = [];
    List<PopupMenuItem<String>> overflowItems = [];
    int visibleButtonCount = 0;
    
    // Helper function to create action button
    Widget createActionButton(IconData icon, Color color, String tooltip, VoidCallback onPressed) {
      return IconButton(
        icon: Icon(icon, color: color),
        tooltip: tooltip,
        onPressed: onPressed,
      );
    }

    // Add GeoFence button if available
    // if (widget.headers.contains('GeoFence')) {
    //   if (visibleButtonCount < widget.maxVisibleButtons) {
    //     buttons.add(InkWell(
    //       onTap: () => widget.onGeoFence?.call(row),
    //       child: Icon(
    //         row['GeoFence'] == 'Yes' ? Icons.location_on : Icons.location_off,
    //         color: row['GeoFence'] == 'Yes' ? Colors.green : Colors.red,
    //       ),
    //     ));
    //     visibleButtonCount++;
    //   } else {
    //     overflowItems.add(
    //       PopupMenuItem<String>(
    //         value: 'geofence',
    //         child: ListTile(
    //           leading: Icon(
    //             row['GeoFence'] == 'Yes' ? Icons.location_on : Icons.location_off,
    //             color: row['GeoFence'] == 'Yes' ? Colors.green : Colors.red,
    //           ),
    //           title: Text('GeoFence'),
    //         ),
    //       ),
    //     );
    //   }
    // }

    // Add Edit button if available
    if (widget.onEdit != null) {
      if (visibleButtonCount < widget.maxVisibleButtons) {
        buttons.add(createActionButton(
          widget.editIcon ?? Icons.edit,
          Theme.of(context).colorScheme.primary,
          widget.editTooltip ?? 'Edit',
          () => widget.onEdit!(row),
        ));
        visibleButtonCount++;
      } else {
        overflowItems.add(
          PopupMenuItem<String>(
            value: 'edit',
            child: ListTile(
              leading: Icon(widget.editIcon ?? Icons.edit),
              title: Text(widget.editTooltip ?? 'Edit'),
            ),
          ),
        );
      }
    }

    // Add Delete button if available
    if (widget.onDelete != null) {
      if (visibleButtonCount < widget.maxVisibleButtons) {
        buttons.add(createActionButton(
          widget.deleteIcon ?? Icons.delete,
          Theme.of(context).colorScheme.error,
          widget.deleteTooltip ?? 'Delete',
          () => widget.onDelete!(row),
        ));
        visibleButtonCount++;
      } else {
        overflowItems.add(
          PopupMenuItem<String>(
            value: 'delete',
            child: ListTile(
              leading: Icon(widget.deleteIcon ?? Icons.delete, color: Theme.of(context).colorScheme.error),
              title: Text(widget.deleteTooltip ?? 'Delete'),
            ),
          ),
        );
      }
    }

    // Add custom actions
    if (widget.customActions != null) {
      for (var action in widget.customActions!) {
        if (visibleButtonCount < widget.maxVisibleButtons) {
          buttons.add(createActionButton(
            action.icon,
            action.color ?? Theme.of(context).colorScheme.primary,
            action.tooltip,
            () => action.onPressed(row),
          ));
          visibleButtonCount++;
        } else {
          overflowItems.add(
            PopupMenuItem<String>(
              value: 'custom_${widget.customActions!.indexOf(action)}',
              child: ListTile(
                leading: Icon(action.icon, color: action.color),
                title: Text(action.tooltip),
              ),
            ),
          );
        }
      }
    }

    // Add overflow menu if there are overflow items
    if (overflowItems.isNotEmpty) {
      buttons.add(
        PopupMenuButton<String>(
          icon: Icon(Icons.more_vert, color: Theme.of(context).colorScheme.primary),
          tooltip: 'More actions',
          onSelected: (String value) {
            switch (value) {
              case 'edit':
                widget.onEdit?.call(row);
                break;
              case 'delete':
                widget.onDelete?.call(row);
                break;
              case 'geofence':
                widget.onGeoFence?.call(row);
                break;
              default:
                if (value.startsWith('custom_')) {
                  final index = int.parse(value.split('_')[1]);
                  widget.customActions![index].onPressed(row);
                }
            }
          },
          itemBuilder: (BuildContext context) => overflowItems,
        ),
      );
    }

    return buttons;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= 820) {
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
    final regularHeaders = widget.headers
        .where((header) =>
            header != widget.headers.last &&
            (widget.visibleColumns.isEmpty ||
                widget.visibleColumns.contains(header)))
        .toList();
    final lastHeader = widget.headers.last;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Container(
            color: Theme.of(context).colorScheme.secondaryContainer,
            child: Row(
              children: [
                if (widget.showCheckboxes) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Checkbox(
                      value: widget.selectedItems?.length == widget.data.length,
                      tristate: widget.selectedItems?.isNotEmpty == true &&
                          widget.selectedItems?.length != widget.data.length,
                      onChanged: widget.onSelectAll,
                    ),
                  ),
                ],
                Expanded(
                  flex: 9,
                  child: Row(
                    children: regularHeaders
                        .where((header) => header != 'Select')
                        .map((header) => _buildSortableHeader(header))
                        .toList(),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      lastHeader,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
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
                  final String itemId =
                      widget.idField != null ? row[widget.idField!] ?? '' : '';
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
                        if (widget.showCheckboxes) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Checkbox(
                              value: widget.selectedItems?.contains(itemId),
                              onChanged: (bool? value) {
                                if (value != null && widget.onSelectItem != null) {
                                  widget.onSelectItem!(itemId, value);
                                }
                              },
                            ),
                          ),
                        ],
                        Expanded(
                          flex: 9,
                          child: Row(
                            children: regularHeaders
                                .where((header) => header != 'Select')
                                .map((header) {
                              if (header == "GeoFence") {
                                return Expanded(
                                  child: Center(
                                    child: _buildGeoFenceIcon(row),
                                  ),
                                );
                              }
                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 6, horizontal: 8),
                                  child: Tooltip(
                                    message: (row[header]?.length ?? 0) > 12
                                        ? row[header]!
                                        : '',
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
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _buildActionButtons(row, context),
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
                                  children: widget.headers
                                      .where((header) =>
                                          header != "Actions" &&
                                          header != "City" &&
                                          header != "State")
                                      .take(2)
                                      .map((header) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 8.0),
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
                                    if (widget.headers.contains('GeoFence'))
                                      InkWell(
                                        onTap: () =>
                                            widget.onGeoFence?.call(row),
                                        child: row['GeoFence'] == 'Yes'
                                            ? const Icon(Icons.location_on,
                                                color: Colors.green)
                                            : const Icon(Icons.location_off,
                                                color: Colors.red),
                                      ),
                                    if (widget.onEdit != null)
                                      Tooltip(
                                        message: widget.editTooltip ?? 'Edit',
                                        child: IconButton(
                                          icon: Icon(
                                              widget.editIcon ?? Icons.edit,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                          onPressed: () => widget.onEdit!(row),
                                        ),
                                      ),
                                    if (widget.onDelete != null)
                                      Tooltip(
                                        message:
                                            widget.deleteTooltip ?? 'Delete',
                                        child: IconButton(
                                          icon: Icon(
                                              widget.deleteIcon ?? Icons.delete,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error),
                                          onPressed: () =>
                                              widget.onDelete!(row),
                                        ),
                                      ),
                                    if (widget.customActions != null)
                                      ...widget.customActions!.map(
                                        (action) => Tooltip(
                                          message: action.tooltip,
                                          child: IconButton(
                                            icon: Icon(action.icon,
                                                color: action.color ??
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .primary),
                                            onPressed: () =>
                                                action.onPressed(row),
                                          ),
                                        ),
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
                if (entry.key == 'longitude' ||
                    entry.key == 'latitude' ||
                    entry.key == 'distance' ||
                    (entry.key != 'Actions' && entry.value.isNotEmpty)) {
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
