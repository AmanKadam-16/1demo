import 'package:flutter/material.dart';

class CustomDeleteButton extends StatelessWidget {
  final String label; // Button label (e.g., "Delete")
  final VoidCallback onPressed; // Callback for button click

  const CustomDeleteButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen width using MediaQuery
    double screenWidth = MediaQuery.of(context).size.width;

    // Define padding based on screen size
    final EdgeInsetsGeometry padding = screenWidth > 600
        ? const EdgeInsets.symmetric(horizontal: 16.0) // Larger padding for tablets
        : const EdgeInsets.all(0); // No padding for mobile

    if (screenWidth <= 600) {
      // Mobile view: Display a floating action button
      return Padding(
        padding: const EdgeInsets.all(10.0), // 10px padding around the button
        child: FloatingActionButton(
          onPressed: onPressed,
          backgroundColor: Theme.of(context).colorScheme.errorContainer, // Use error color for delete
          child: Icon(
            Icons.delete,
            size: 15, // Compact icon size
            color: Theme.of(context).colorScheme.onErrorContainer, // Icon color
          ),
          mini: true, // Ensures the button is smaller
        ),
      );
    } else {
      // Tablet/Desktop view: Display a regular button with a label
      return Padding(
        padding: padding,
        child: ElevatedButton.icon(
          icon: Icon(
            Icons.delete,
            color: Theme.of(context).colorScheme.onErrorContainer, // Icon color
          ),
          label: Text(
            label,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onErrorContainer, // Text color
            ),
          ),
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.errorContainer, // Background color
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            minimumSize: const Size(200, 40), // Adjust button size for larger screens
          ),
        ),
      );
    }
  }
}