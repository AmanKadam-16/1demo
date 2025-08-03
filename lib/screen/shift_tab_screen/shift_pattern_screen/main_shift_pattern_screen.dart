import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/shift_tab_controller/shift_pattern_controller.dart';
import 'package:time_attendance/model/Masters/shiftPattern.dart';
// import 'package:time_attendance/model/sfift_tab_model/shift_pattern_model.dart';
import 'package:time_attendance/screen/shift_tab_screen/shift_pattern_screen/shift_pattern_dialog_screen.dart';
import 'package:time_attendance/widget/reusable/button/custom_action_button.dart';
import 'package:time_attendance/widget/reusable/dialog/dialogbox.dart';
import 'package:time_attendance/widget/reusable/list/reusable_list.dart';
import 'package:time_attendance/widget/reusable/search/reusable_search_field.dart';
import 'package:time_attendance/widget/reusable/tooltip/help_tooltip_button.dart';
import 'package:time_attendance/widget/reusable/pagination/pagination_widget.dart';

class MainShiftPatternScreen extends StatelessWidget {
  MainShiftPatternScreen({super.key});

  final ShiftPatternController controller = Get.put(ShiftPatternController());
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shift Patterns'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          if (MediaQuery.of(context).size.width > 600)
            ReusableSearchField(
              searchController: _searchController,
              onSearchChanged: controller.updateSearchQuery,
            ),
          const SizedBox(width: 20),
          CustomActionButton(
            label: 'Add Shift Pattern',
            onPressed: () => _showShiftPatternDialog(context),
          ),
          const SizedBox(width: 8),
          HelpTooltipButton(
            tooltipMessage: 'Manage shift patterns in this section.',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          if (MediaQuery.of(context).size.width <= 600)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ReusableSearchField(
                searchController: _searchController,
                onSearchChanged: controller.updateSearchQuery,
                responsiveWidth: false,
              ),
            ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              
              return Column(
                children: [
                  Expanded(
                    child: ReusableTableAndCard(
                      data: List.generate(
                        controller.filteredShiftPatterns.length,
                        (index) => {
                          'Pattern Name': controller.filteredShiftPatterns[index].patternName,
                          'Shifts': controller.filteredShiftPatterns[index].listOfShifts
                            .map((shift) => shift.shiftName)
                            .join(', '),
                        },
                      ),
                      headers: ['Pattern Name', 'Shifts', 'Actions'],
                      visibleColumns: ['Pattern Name', 'Shifts', 'Actions'],
                      onEdit: (row) {
                        final pattern = controller.filteredShiftPatterns.firstWhere(
                          (p) => p.patternName == row['Pattern Name'],
                        );
                        _showShiftPatternDialog(context, pattern);
                      },
                      onDelete: (row) {
                        final pattern = controller.filteredShiftPatterns.firstWhere(
                          (p) => p.patternName == row['Pattern Name'],
                        );
                        _showDeleteConfirmationDialog(context, pattern);
                      },
                      onSort: (columnName, ascending) => 
                        controller.sortShiftPatterns(columnName, ascending),
                    ),
                  ),
                  PaginationWidget(
                    currentPage: controller.currentPage.value,
                    totalPages: (controller.totalItems.value / controller.itemsPerPage.value).ceil(),
                    onFirstPage: () => _handlePageChange(1),
                    onPreviousPage: () => _handlePageChange(controller.currentPage.value - 1),
                    onNextPage: () => _handlePageChange(controller.currentPage.value + 1),
                    onLastPage: () => _handlePageChange(
                      (controller.totalItems.value / controller.itemsPerPage.value).ceil()
                    ),
                    onItemsPerPageChange: _handleItemsPerPageChange,
                    itemsPerPage: controller.itemsPerPage.value,
                    itemsPerPageOptions: [10, 25, 50, 100],
                    totalItems: controller.totalItems.value,
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  void _handlePageChange(int page) {
    controller.currentPage.value = page;
    controller.update();
  }

  void _handleItemsPerPageChange(int itemsPerPage) {
    controller.itemsPerPage.value = itemsPerPage;
    controller.currentPage.value = 1;
    controller.update();
  }

  void _showShiftPatternDialog(BuildContext context, [ShiftPatternModel? pattern]) {
    showCustomDialog(
      context: context,
      dialogContent: [
        ShiftPatternDialog(
          controller: controller,
          shiftPattern: pattern ?? ShiftPatternModel(
            patternId: 0,
            patternName: '',
            pattern: '',
            shiftsInPattern: [],
            listOfShifts: [],
          ),
        ),
      ],
    );
  }

   void _showDeleteConfirmationDialog(BuildContext context, ShiftPatternModel pattern) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this shift pattern?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                controller.deleteShiftPattern(pattern.patternId.toString());
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }
}