import 'package:flutter/material.dart';

class ReusableSearchField extends StatelessWidget {
  final TextEditingController searchController;
  final Function(String) onSearchChanged;
  final String hintText;
  final double? width;
  final bool responsiveWidth;

  const ReusableSearchField({
    super.key,
    required this.searchController,
    required this.onSearchChanged,
    this.hintText = 'Search...',
    this.width,
    this.responsiveWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: responsiveWidth 
            ? (constraints.maxWidth > 600 ? 200 : double.infinity) 
            : (width ?? double.infinity),
          height: 40,
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: const Icon(Icons.search, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            onChanged: onSearchChanged,
          ),
        );
      },
    );
  }
}

/// A mixin to provide generic search functionality for controllers
mixin SearchMixin<T> {
  List<T> originalList = [];
  String _searchQuery = '';

  /// Update the search query and filter the list
  void updateSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    filterList();
  }

  /// Override this method in the specific controller to implement filtering logic
  void filterList() {
    // Default implementation, should be overridden
  }

  /// Generic search method that can be customized for different types
  List<T> performSearch(List<T> list, bool Function(T item, String query) searchCondition) {
    if (_searchQuery.isEmpty) return list;
    
    return list.where((item) => searchCondition(item, _searchQuery)).toList();
  }
}