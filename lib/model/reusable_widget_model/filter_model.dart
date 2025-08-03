import 'package:flutter/material.dart';

class FilterOption {
  final String label;
  final String value;
  final IconData? icon;

  FilterOption({
    required this.label,
    required this.value,
    this.icon,
  });
}