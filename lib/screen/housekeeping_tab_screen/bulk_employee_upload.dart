import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/Data_entry_tab_controller/Inventry_controller.dart';
import 'package:time_attendance/controller/housekeeping_controller/bulk_employee_upload_controller.dart';
import 'package:time_attendance/screen/housekeeping_tab_screen/bulk_employee_upload_dailog.dart';
import 'package:time_attendance/widget/reusable/button/custom_action_button.dart';
import 'package:time_attendance/widget/reusable/search/reusable_search_field.dart';
import 'package:time_attendance/widget/reusable/tooltip/help_tooltip_button.dart';  // Add this import

class bulkemployeeuploadscreen extends StatefulWidget {
  const bulkemployeeuploadscreen({super.key});

  @override
  State<bulkemployeeuploadscreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<bulkemployeeuploadscreen> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final BulkEmployeeUploadController controller = Get.find<BulkEmployeeUploadController>();

  void updateSearchQuery(String query) {
    // Implement search logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employess Bulk Upload'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          const SizedBox(width: 24), // Add more space from the left
          Container(
            width: 250, // adjusted from 200 to 250
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ReusableSearchField(
              searchController: _searchController,
              onSearchChanged: controller.updateSearchQuery,
            ),
          ),
          const SizedBox(width: 16),
          CustomActionButton(
            label: 'Add',
            onPressed: () {
              showUploadShiftDialog(context);
            },
          ),
          const SizedBox(width: 16),
          HelpTooltipButton(
            tooltipMessage: 'Upload and manage bulk employee data in this section.',
          ),
          const SizedBox(width: 16),
        ],
      ),
      
      body: Scaffold()
    );
  }
}