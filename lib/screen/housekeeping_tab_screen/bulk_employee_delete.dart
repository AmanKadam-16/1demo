import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/Data_entry_tab_controller/Inventry_controller.dart';
import 'package:time_attendance/controller/housekeeping_controller/bulk_employee_delete_controller.dart';
import 'package:time_attendance/widget/reusable/button/custom_action_button.dart';
import 'package:time_attendance/widget/reusable/search/reusable_search_field.dart';
import 'package:time_attendance/widget/reusable/tooltip/help_tooltip_button.dart';
import 'package:file_picker/file_picker.dart';

class bulkemployeedeletescreen extends StatefulWidget {
  const  bulkemployeedeletescreen({super.key});

  @override
  State< bulkemployeedeletescreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State< bulkemployeedeletescreen> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final BulkEmployeedeleteController controller = Get.find<BulkEmployeedeleteController>();
  String? selectedFileName;

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      setState(() {
        selectedFileName = result.files.single.name;
      });
    }
  }

  void updateSearchQuery(String query) {
    // Implement search logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employess Bulk Delete'),
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
          HelpTooltipButton(
            tooltipMessage: 'Upload and manage bulk employee data in this section.',
          ),
          const SizedBox(width: 16),
        ],
      ),
      
      body:  Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "please select CSV file",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: "Select File *",
                            border: OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          ),
                          readOnly: true,
                          controller: TextEditingController(text: selectedFileName),
                        ),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: pickFile,
                        child: Text("Browse"),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 300, // Fixed width for consistent button sizes
                          height: 36,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                             
                            ),
                            onPressed: () {},
                            child: Text("Delete Employees",  
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        SizedBox(
                          width: 350, // Increased from 200 to 240
                          height: 36,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {},
                            child: Text("Mark Employees as In-active", 
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 36,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {},
                                child: Text("Refresh"),
                              ),
                            ),
                            SizedBox(width: 12),
                            SizedBox(
                              height: 36,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {},
                                child: Text("Cancel"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: Container(
                color: Colors.white,
                // Add your table or list view here
              ),
            ),
          ],
        ),
      ),
    );
  }
}