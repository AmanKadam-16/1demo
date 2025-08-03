import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterController extends GetxController {
  final RxMap<String, String> selectedValues = <String, String>{}.obs;
  final RxBool isLoading = false.obs;
  final RxMap<String, List<String>> filterOptions = <String, List<String>>{}.obs;

  // Method to set filter options from API
  void setFilterOptions(Map<String, List<String>> options) {
    filterOptions.value = options;
    update();
  }

  // Method to set filter value
  void setFilterValue(String filterType, String value) {
    selectedValues[filterType] = value;
    update();
  }

  // Method to clear all filters
  void clearFilters() {
    selectedValues.clear();
    update();
  }

  // Method to check if any filter is applied
  bool hasActiveFilters() {
    return selectedValues.isNotEmpty;
  }
}

