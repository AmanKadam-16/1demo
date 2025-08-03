// main_device_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:time_attendance/Devoice_tab_screen/devoice_dialog_main_screen.dart';
import 'package:time_attendance/controller/Devoice1_controller/Devoice1_controller.dart';
import 'package:time_attendance/controller/master_tab_controller/location_controller.dart';
import 'package:time_attendance/model/Devoice1_model/Devoice1_model.dart';
import 'package:time_attendance/screen/HouseKeeping/Devoice1_tab_screen/devoice_dialog_main_screen.dart';
// import 'package:time_attendance/controller/master_tab_controller/device_controller.dart';
// import 'package:time_attendance/model/master_tab_model/device_model.dart';
// import 'package:time_attendance/screen/master_tab_screens/device_screens/device_dialog_screen.dart';
import 'package:time_attendance/widget/reusable/button/custom_action_button.dart';
import 'package:time_attendance/widget/reusable/dialog/dialogbox.dart';
import 'package:time_attendance/widget/reusable/list/reusable_list.dart';
import 'package:time_attendance/widget/reusable/pagination/pagination_widget.dart';
import 'package:time_attendance/widget/reusable/tooltip/help_tooltip_button.dart';
import 'package:time_attendance/widget/reusable/search/reusable_search_field.dart';

class MainDeviceScreen extends StatelessWidget {
  MainDeviceScreen({super.key});

  final DeviceController controller = Get.find<DeviceController>();
  final LocationController controller1 = Get.find<LocationController>();
  final TextEditingController _searchController = TextEditingController();
  int _currentPage = 1;
  int _itemsPerPage = 10;
  int _totalPages = 1;

  @override
  Widget build(BuildContext context) {
    controller.initializeAuthDevice();
    controller1.initializeAuthLocation();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Devices'),
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
            label: 'Add Device',
            onPressed: () => _showDeviceDialog(context),
          ),
          const SizedBox(width: 8),
          HelpTooltipButton(
            tooltipMessage: 'Manage devices, their configurations, and connections in this section.',
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
                        controller.filteredDevices.length,
                        (index) => {
                          'Device Name': controller.filteredDevices[index].deviceName,
                          'IP Address': controller.filteredDevices[index].ipAddress,
                          'Port': controller.filteredDevices[index].port,
                          'Serial Number': controller.filteredDevices[index].serialNumber,
                          'IO Status': controller.filteredDevices[index].ioStatus,
                          'Device Type': controller.filteredDevices[index].deviceType,
                          'Fetch Data': controller.filteredDevices[index].fetchDataVia,
                          'Location': controller.filteredDevices[index].location,
                          'Location Code': controller.filteredDevices[index].locationCode,
                        },
                      ),
                      headers: [
                        'Device Name', 'IP Address', 'Port', 'Serial Number', 'IO Status',
                        'Device Type', 'Fetch Data', 'Location', 'Location Code', 'Actions'
                      ],
                      visibleColumns: [
                        'Device Name', 'IP Address', 'Port', 'Serial Number', 'IO Status',
                        'Device Type', 'Fetch Data', 'Location', 'Location Code', 'Actions'
                      ],
                      onEdit: (row) {
                        final device = controller.filteredDevices.firstWhere(
                          (d) => d.deviceName == row['Device Name'] && d.ipAddress == row['IP Address'],
                        );
                        _showDeviceDialog(context, device);
                      },
                      onDelete: (row) {
                        final device = controller.filteredDevices.firstWhere(
                          (d) => d.deviceName == row['Device Name'] && d.ipAddress == row['IP Address'],
                        );
                        _showDeleteConfirmationDialog(context, device);
                      },
                      onSort: (columnName, ascending) => 
                        controller.sortDevices(columnName, ascending),
                    ),
                  ),
                  PaginationWidget(
                    currentPage: _currentPage,
                    totalPages: _totalPages,
                    onFirstPage: () => _handlePageChange(1),
                    onPreviousPage: () => _handlePageChange(_currentPage - 1),
                    onNextPage: () => _handlePageChange(_currentPage + 1),
                    onLastPage: () => _handlePageChange(_totalPages),
                    onItemsPerPageChange: _handleItemsPerPageChange,
                    itemsPerPage: _itemsPerPage,
                    itemsPerPageOptions: [10, 25, 50, 100],
                    totalItems: controller.filteredDevices.length,
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showDeviceDialog(BuildContext context, [DeviceModel? device]) {
    showCustomDialog(
      context: context,
      dialogContent: [
        DeviceDialog(
          controller: controller,
          device: device ?? DeviceModel(),
        ),
      ],
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, DeviceModel device) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete the device "${device.deviceName}"?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                controller.deleteDevice(device.deviceId);
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

  void _handlePageChange(int page) {
    _currentPage = page;
    controller.update();
  }

  void _handleItemsPerPageChange(int itemsPerPage) {
    _itemsPerPage = itemsPerPage;
    _currentPage = 1;
    controller.update();
  }
}