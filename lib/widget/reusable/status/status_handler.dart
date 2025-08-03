// status_handler.dart
import 'package:flutter/material.dart';

class StatusHandler {
  // Convert boolean to display text
  static String getStatusText(bool value) {
    return value ? 'Active' : 'Inactive';
  }

  // Convert display text to boolean
  static bool getStatusValue(String text) {
    return text.toLowerCase() == 'active';
  }
}

// Reusable widget to display status with color
class StatusDisplay extends StatelessWidget {
  final bool value;
  final double? fontSize;
  final bool showDot;

  const StatusDisplay({
    Key? key, 
    required this.value,
    this.fontSize,
    this.showDot = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showDot) ...[
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: value ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(width: 8),
        ],
        Text(
          StatusHandler.getStatusText(value),
          style: TextStyle(
            color: value ? Colors.green : Colors.red,
            fontSize: fontSize ?? 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// Example usage with your data structure
class StatusMapper {
  static List<Map<String, dynamic>> convertApiResponse(List<dynamic> apiData) {
    return apiData.map((item) {
      return {
        'name': item['name'],
        'value': item['value'],
        'displayText': StatusHandler.getStatusText(item['value']),
      };
    }).toList();
  }
}