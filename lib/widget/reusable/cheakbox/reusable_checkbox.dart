// custom_checkbox.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomCheckbox extends StatelessWidget {
  final String label;
  final RxBool value;
  final double? width;
  final EdgeInsetsGeometry? padding;

  const CustomCheckbox({
    Key? key,
    required this.label,
    required this.value,
    this.width,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Obx(() => Checkbox(
            value: value.value,
            onChanged: (bool? newValue) {
              value.value = newValue ?? false;
            },
          )),
        ],
      ),
    );
  }
}