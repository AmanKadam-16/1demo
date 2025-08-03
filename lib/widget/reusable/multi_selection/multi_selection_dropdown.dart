// File: lib/widgets/multi_select_component.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MultiSelectComponent extends StatelessWidget {
  final String title;
  final RxList<String> availableItems;
  final RxList<String> selectedItems;
  final RxList<String> highlightedAvailable;
  final RxList<String> highlightedSelected;
  final VoidCallback onMoveRight;
  final VoidCallback onMoveLeft;
  final VoidCallback onMoveAllRight;
  final VoidCallback onMoveAllLeft;

  const MultiSelectComponent({
    Key? key,
    required this.title,
    required this.availableItems,
    required this.selectedItems,
    required this.highlightedAvailable,
    required this.highlightedSelected,
    required this.onMoveRight,
    required this.onMoveLeft,
    required this.onMoveAllRight,
    required this.onMoveAllLeft,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Obx(() => Text(
                  'Available: ${availableItems.length} | Selected: ${selectedItems.length}',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                )),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            // Available Items List
            Expanded(
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Obx(() => ListView.builder(
                      itemCount: availableItems.length,
                      itemBuilder: (context, index) {
                        String item = availableItems[index];
                        bool isHighlighted = highlightedAvailable.contains(item);
                        return StatefulBuilder(
                          builder: (context, setState) {
                            bool isHovered = false;
                            return MouseRegion(
                              onEnter: (_) => setState(() => isHovered = true),
                              onExit: (_) => setState(() => isHovered = false),
                              cursor: SystemMouseCursors.click,
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                color: isHighlighted
                                    ? Colors.lightBlueAccent.withOpacity(0.3)
                                    : isHovered
                                        ? Colors.grey.withOpacity(0.1)
                                        : Colors.transparent,
                                child: ListTile(
                                  title: Text(
                                    item,
                                    style: TextStyle(
                                      color: isHovered ? Colors.blue : null,
                                    ),
                                  ),
                                  onTap: () {
                                    if (isHighlighted)
                                      highlightedAvailable.remove(item);
                                    else
                                      highlightedAvailable.add(item);
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                    )),
              ),
            ),
            // Transfer Buttons
            Column(
              children: [
                ElevatedButton(
                  onPressed: onMoveRight,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(44, 44),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Icon(Icons.chevron_right),
                ),
                ElevatedButton(
                  onPressed: onMoveLeft,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(44, 44),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Icon(Icons.chevron_left),
                ),
                ElevatedButton(
                  onPressed: onMoveAllRight,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(44, 44),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Icon(Icons.last_page),
                ),
                ElevatedButton(
                  onPressed: onMoveAllLeft,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(44, 44),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Icon(Icons.first_page),
                ),
              ],
            ),
            // Selected Items List
            Expanded(
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Obx(() => ListView.builder(
                      itemCount: selectedItems.length,
                      itemBuilder: (context, index) {
                        String item = selectedItems[index];
                        bool isHighlighted = highlightedSelected.contains(item);
                        return StatefulBuilder(
                          builder: (context, setState) {
                            bool isHovered = false;
                            return MouseRegion(
                              onEnter: (_) => setState(() => isHovered = true),
                              onExit: (_) => setState(() => isHovered = false),
                              cursor: SystemMouseCursors.click,
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                color: isHighlighted
                                    ? Colors.lightBlueAccent.withOpacity(0.3)
                                    : isHovered
                                        ? Colors.grey.withOpacity(0.1)
                                        : Colors.transparent,
                                child: ListTile(
                                  title: Text(
                                    item,
                                    style: TextStyle(
                                      color: isHovered ? Colors.blue : null,
                                    ),
                                  ),
                                  onTap: () {
                                    if (isHighlighted)
                                      highlightedSelected.remove(item);
                                    else
                                      highlightedSelected.add(item);
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                    )),
              ),
            ),
          ],
        ),
      ],
    );
  }
}