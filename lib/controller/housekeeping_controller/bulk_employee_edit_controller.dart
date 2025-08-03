import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'dart:io';

import 'package:time_attendance/model/master_tab_model/department_model.dart';

class BulkEmployeeeditController extends GetxController {
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final RxString selectedFileName = RxString('');
  final RxBool isLoading = false.obs;
  final RxList<String> uploadedEmployees = <String>[].obs;
  final searchQuery = ''.obs;
  final departments = <DepartmentModel>[].obs;
  final filteredDepartments = <DepartmentModel>[].obs;
  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      selectedFileName.value = result.files.single.name;
      // Store the file path for later use
      String filePath = result.files.single.path!;
      // You can process the CSV file here if needed
    }
  }

  void setDate(DateTime date) {
    selectedDate.value = date;
  }

  Future<void> generateBlankCSV() async {
    // Implementation for generating blank CSV template
    try {
      // Generate CSV logic here
      String csvContent = "Employee ID,Name,Department,Position,Email\n";
      // Add logic to save the file
    } catch (e) {
      Get.snackbar('Error', 'Failed to generate CSV template: ${e.toString()}');
    }
  }

  Future<void> uploadEmployees() async {
    if (selectedFileName.isEmpty) {
      Get.snackbar('Error', 'Please select a file first');
      return;
    }

    try {
      isLoading.value = true;
      // Add your API call or database operation here
      await Future.delayed(Duration(seconds: 2)); // Simulated API call
      
      Get.snackbar('Success', 'Employees uploaded successfully');
      // Clear the selection after successful upload
      selectedFileName.value = '';
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload employees: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void refresh() {
    selectedFileName.value = '';
    selectedDate.value = DateTime.now();
    uploadedEmployees.clear();
  }

   void updateSearchQuery(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredDepartments.assignAll(departments);
    } else {
      filteredDepartments.assignAll(
        departments.where((d) => 
          d.departmentName.toLowerCase().contains(query.toLowerCase()) ||
          d.masterDepartmentName.toLowerCase().contains(query.toLowerCase())
        )
      );
    }
  }
}
