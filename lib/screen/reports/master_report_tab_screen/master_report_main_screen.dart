import 'package:flutter/material.dart';import 'package:get/get.dart';
import 'package:time_attendance/controller/reports_controller/master_reports_controller.dart';
import 'package:time_attendance/widget/reusable/tooltip/help_tooltip_button.dart';
import 'package:time_attendance/widget/reusable/button/extra_button.dart';
import 'package:time_attendance/controller/reusable_widget_controller/extra_button_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MasterReportMainScreen extends StatelessWidget {
  const MasterReportMainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MasterReportController());
    final buttonController = Get.put(ButtonController());
    buttonController.initializeButtons(2); // Initialize for 2 buttons
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Master Reports'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          const SizedBox(width: 8),
          HelpTooltipButton(
            tooltipMessage:
                'Generate comprehensive reports filtered by various criteria and export them in your preferred format.',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filter by:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildFilterOptionResponsive(controller, 'Location', constraints),
                      _buildFilterOptionResponsive(controller, 'Company', constraints),
                      _buildFilterOptionResponsive(controller, 'Department', constraints),
                      _buildFilterOptionResponsive(controller, 'Designation', constraints),
                      _buildFilterOptionResponsive(controller, 'Shift', constraints),
                    ],
                  ),
                  const SizedBox(height: 40),
                  _buildButtons(controller, buttonController, context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterOptionResponsive(MasterReportController controller, String filter, BoxConstraints constraints) {
    double width = constraints.maxWidth < 600 
        ? constraints.maxWidth 
        : constraints.maxWidth < 1200 
            ? (constraints.maxWidth / 3) - 16
            : (constraints.maxWidth / 5) - 16;
    
    return SizedBox(
      width: width,
      child: InkWell(
        onTap: () => controller.setFilterBy(filter),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Obx(() => Radio<String>(
                value: filter,
                groupValue: controller.filterBy.value,
                onChanged: (value) => controller.setFilterBy(value!),
              )),
              Expanded(
                child: Text(
                  filter,
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterSelectionDialog(BuildContext context, MasterReportController controller) {
    String selectedValue = 'PDF';
    List<String> allOptions = [];

    // Add export format options
    allOptions.addAll(['PDF', 'Excel', 'MS Word', 'RichText', 'None']);

    // Add filter options based on selected filter
    switch (controller.filterBy.value) {
      case 'Location':
        break;
      case 'Company':
        break;
      case 'Department':
        break;
      case 'Designation':
        break;
      case 'Shift':
        break;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Exports Reports as...'),
          content: Container(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedValue,
                  items: allOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    selectedValue = value!;
                    // Check if selection is an export format
                    if(['PDF', 'Excel', 'MS Word', 'RichText', 'None'].contains(value)) {
                      controller.setExportFormat(value);
                    } else {
                      controller.selectedFilterValue.value = value;
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedValue != null) {
                  _generateFinalReport(context, controller);
                  Navigator.pop(context);
                }
              },
              child: Text('Generate Report'),
            ),
          ],
        );
      },
    );
  }
  void _generateFinalReport(BuildContext context, MasterReportController controller) {
    // Generate report logic here
    Fluttertoast.showToast(
      msg: "Report generated successfully!",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  Widget _buildButtons(MasterReportController controller, ButtonController buttonController, BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: [
        ExtraButton(
          text: 'Generate Report',
          onPressed: () {
            if (controller.filterBy.value != '') {
              _showFilterSelectionDialog(context, controller);
            } else {
              Fluttertoast.showToast(
                msg: "Please select a filter option first",
                backgroundColor: Colors.red,
                textColor: Colors.white,
              );
            }
          },
          index: 0,
          controller: buttonController,
          hoverColor: Colors.black,
          width: 180,
          defaultColor: Colors.black,
          textColor: Colors.white,
        ),
        ExtraButton(
          text: 'Cancel',
          onPressed: controller.cancelOperation,
          index: 1,
          controller: buttonController,
          hoverColor: Colors.grey,
          width: 180,
        ),
      ],
    );
  }
}