import 'package:flutter/material.dart';

class PaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onFirstPage;
  final VoidCallback onPreviousPage;
  final VoidCallback onNextPage;
  final VoidCallback onLastPage;
  final int itemsPerPage;
  final List<int> itemsPerPageOptions;
  final void Function(int) onItemsPerPageChange;
  final int totalItems;
  final String itemName;

  const PaginationWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onFirstPage,
    required this.onPreviousPage,
    required this.onNextPage,
    required this.onLastPage,
    required this.itemsPerPage,
    required this.itemsPerPageOptions,
    required this.onItemsPerPageChange,
    required this.totalItems,
    this.itemName = 'items',
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 920) {
          // Existing large screen layout
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: constraints.maxWidth < 800
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 8),
                      _buildNavigationRow(isCompact: true),
                      _buildDropdown(),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDropdown(),
                      _buildNavigationRow(isCompact: false),
                    ],
                  ),
          );
        } else {
          // Mobile screen layout
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildDropdown(),
                _buildNavigationRow(isCompact: true),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildDropdown() {
    return DropdownButton<int>(
      value: itemsPerPage,
      items: itemsPerPageOptions.map((option) {
        return DropdownMenuItem<int>(
          value: option,
          key: Key('items_per_page_$option'),
          child: Text('$option items per page'),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          onItemsPerPageChange(value);
        }
      },
    );
  }

  Widget _buildNavigationRow({required bool isCompact}) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      crossAxisAlignment: WrapCrossAlignment.center,
      alignment: WrapAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$totalItems $itemName',
              style: TextStyle(fontSize: isCompact ? 12 : 14),
            ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: currentPage > 1 ? onFirstPage : null,
              icon: const Icon(Icons.first_page),
            ),
            IconButton(
              onPressed: currentPage > 1 ? onPreviousPage : null,
              icon: const Icon(Icons.chevron_left),
            ),
            Text(
              'Page $currentPage of $totalPages',
              style: TextStyle(fontSize: isCompact ? 12 : 14),
            ),
            IconButton(
              onPressed: currentPage < totalPages ? onNextPage : null,
              icon: const Icon(Icons.chevron_right),
            ),
            IconButton(
              onPressed: currentPage < totalPages ? onLastPage : null,
              icon: const Icon(Icons.last_page),
            ),
          ],
        ),
      ],
    );
  }
}