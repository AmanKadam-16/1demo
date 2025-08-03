import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/data_enetry/multi_selection_dropdown.dart';
import 'package:time_attendance/controller/master_tab_controller/company_controller.dart';
import 'package:time_attendance/controller/master_tab_controller/department_controller.dart';
import 'package:time_attendance/controller/master_tab_controller/designation_controller.dart';
import 'package:time_attendance/controller/master_tab_controller/location_controller.dart';
import 'package:time_attendance/widget/reusable/multi_selection/multi_selection_dropdown.dart';
// import 'package:time_attendance/widgets/multi_select_component.dart';

class MultiSelectDashboard extends StatelessWidget {
  final TransferListController controller = Get.put(TransferListController());
  final BranchController controller1 = Get.find<BranchController>();
  final DepartmentController controller2 = Get.find<DepartmentController>();
  final LocationController controller3 = Get.find<LocationController>();
  final DesignationController controller4 = Get.find<DesignationController>();
  
  @override
  Widget build(BuildContext context) {
    controller1.initializeAuthBranch();
    controller2.initializeAuthDept();
    controller3.initializeAuthLocation();
    controller4.initializeAuthDesignation();

    return Scaffold(
      appBar: AppBar(
        title: Text('Data Process'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => controller.refreshData(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (controller.availableCompanies.isEmpty && 
              controller.availableDepartments.isEmpty && 
              controller.availableDesignations.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No data available'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => controller.refreshData(),
                    child: Text('Refresh'),
                  ),
                ],
              ),
            );
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              bool isWideScreen = constraints.maxWidth > 720;
              return Center(
                child: SingleChildScrollView(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 20,
                    runSpacing: 20,
                    children: [
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: isWideScreen
                              ? constraints.maxWidth * 0.48
                              : constraints.maxWidth,
                        ),
                        child: MultiSelectComponent(
                          title: 'Company',
                          availableItems: controller.availableCompanies,
                          selectedItems: controller.selectedCompanies,
                          highlightedAvailable: controller.highlightedAvailableCompanies,
                          highlightedSelected: controller.highlightedSelectedCompanies,
                          onMoveRight: controller.moveCompanyRight,
                          onMoveLeft: controller.moveCompanyLeft,
                          onMoveAllRight: controller.moveAllCompanyRight,
                          onMoveAllLeft: controller.moveAllCompanyLeft,
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: isWideScreen
                              ? constraints.maxWidth * 0.48
                              : constraints.maxWidth,
                        ),
                        child: MultiSelectComponent(
                          title: 'Department',
                          availableItems: controller.availableDepartments,
                          selectedItems: controller.selectedDepartments,
                          highlightedAvailable: controller.highlightedAvailableDepartments,
                          highlightedSelected: controller.highlightedSelectedDepartments,
                          onMoveRight: controller.moveDepartmentRight,
                          onMoveLeft: controller.moveDepartmentLeft,
                          onMoveAllRight: controller.moveAllDepartmentRight,
                          onMoveAllLeft: controller.moveAllDepartmentLeft,
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: isWideScreen
                              ? constraints.maxWidth * 0.48
                              : constraints.maxWidth,
                        ),
                        child: MultiSelectComponent(
                          title: 'Designation',
                          availableItems: controller.availableDesignations,
                          selectedItems: controller.selectedDesignations,
                          highlightedAvailable: controller.highlightedAvailableDesignations,
                          highlightedSelected: controller.highlightedSelectedDesignations,
                          onMoveRight: controller.moveDesignationRight,
                          onMoveLeft: controller.moveDesignationLeft,
                          onMoveAllRight: controller.moveAllDesignationRight,
                          onMoveAllLeft: controller.moveAllDesignationLeft,
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: isWideScreen
                              ? constraints.maxWidth * 0.48
                              : constraints.maxWidth,
                        ),
                        child: MultiSelectComponent(
                          title: 'Location',
                          availableItems: controller.availableLocations,
                          selectedItems: controller.selectedLocations,
                          highlightedAvailable: controller.highlightedAvailableLocations,
                          highlightedSelected: controller.highlightedSelectedLocations,
                          onMoveRight: controller.moveLocationRight,
                          onMoveLeft: controller.moveLocationLeft,
                          onMoveAllRight: controller.moveAllLocationRight,
                          onMoveAllLeft: controller.moveAllLocationLeft,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}