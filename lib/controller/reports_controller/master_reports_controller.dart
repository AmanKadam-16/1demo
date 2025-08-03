import 'package:get/get.dart';

class MasterReportController extends GetxController {
  final RxString exportFormat = 'PDF'.obs;
  final RxString filterBy = 'Company'.obs;
  var selectedFilterValue = ''.obs;
  
  void setExportFormat(String format) {
    exportFormat.value = format;
  }
  
  void setFilterBy(String filter) {
    filterBy.value = filter;
  }
  
  void generateReport() {
    print('Generating report with:');
    print('Export Format: ${exportFormat.value}');
    print('Filter By: ${filterBy.value}');
    print('Selected Filter Value: ${selectedFilterValue.value}');
  }
  
  void cancelOperation() {
    Get.back();
  }
}