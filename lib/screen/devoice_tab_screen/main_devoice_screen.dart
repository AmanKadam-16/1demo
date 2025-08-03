import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/devoice_controller/devoice_controller.dart';
import 'package:time_attendance/model/devoice_tab_model/devoice_model.dart';
import 'package:time_attendance/screen/devoice_tab_screen/devoice_dialog_screen.dart';

// Import the new controller
import 'package:time_attendance/widget/reusable/button/custom_action_button.dart';
import 'package:time_attendance/widget/reusable/button/delete_button.dart';
import 'package:time_attendance/widget/reusable/devoice_table/devoice_table.dart';
// import 'package:time_attendance/widget/reusable/device_table/device_table.dart';
import 'package:time_attendance/widget/reusable/dialog/dialogbox.dart';
import 'package:time_attendance/widget/reusable/pagination/pagination_widget.dart';
import 'package:time_attendance/widget/reusable/tooltip/help_tooltip_button.dart';
import 'package:time_attendance/widget/reusable/search/reusable_search_field.dart';

class MaindeviceScreen extends StatelessWidget {
  MaindeviceScreen({Key? key}) : super(key: key);

  final deviceController controller = Get.put(deviceController());
  final TextEditingController _searchController = TextEditingController();
  final RxInt _currentPage = 1.obs;
  final RxInt _itemsPerPage = 10.obs;
  final RxInt _totalPages = 1.obs;

  void _handlePageChange(int page) {
    _currentPage.value = page;
  }

  void _handleItemsPerPageChange(int value) {
    _itemsPerPage.value = value;
    _currentPage.value = 1;
    _calculateTotalPages();
  }

  void _calculateTotalPages() {
    _totalPages.value = (controller.devices.length / _itemsPerPage.value).ceil();
  }

  List<Device> _getPaginatedData() {
    final startIndex = (_currentPage.value - 1) * _itemsPerPage.value;
    final endIndex = startIndex + _itemsPerPage.value;
    if (startIndex >= controller.devices.length) return [];
    return controller.devices.sublist(
      startIndex,
      endIndex > controller.devices.length ? controller.devices.length : endIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device '),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          if (MediaQuery.of(context).size.width > 600)
            CustomDeleteButton(
              onPressed: () {
                if (controller.selecteddevices.isNotEmpty) {
                  _showDeleteConfirmationDialog(context);
                }
              },
              label: 'Delete device',
            ),
          const SizedBox(width: 20),
          ReusableSearchField(
            searchController: _searchController,
            onSearchChanged: (query) {
              // Implement search functionality if needed
            },
          ),
          const SizedBox(width: 20),
          CustomActionButton(
            label: 'Add device',
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => deviceDialog(),
              );
            },
            // onPressed: () => _showdeviceDialog(context),
          ),
          const SizedBox(width: 8),
          HelpTooltipButton(
            tooltipMessage: 'Manage device in this section.',
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
                onSearchChanged: (query) {
                  // Implement search functionality if needed
                },
                responsiveWidth: false,
              ),
            ),
          Expanded(
            child: Obx(() {
              if (controller.devices.isEmpty) {
                return const Center(child: Text('No devices found.'));
              }

              _calculateTotalPages();
              final paginatedData = _getPaginatedData();

              return Column(
                children: [
                  Expanded(
                    child: ReusableTableAndCard(
                      data: List.generate(paginatedData.length, (index) {
                        final device = paginatedData[index];
                        return {
                          'device Name': device.devName ?? 'N/A',
                          'device Model': device.devType ?? 'N/A',
                          'Access Protocol': device.protocolType ?? 'N/A',
                          'device ID': device.devIndex ?? 'N/A',
                          'Ip Address': 'N/A', // Add IP address if available
                          'device Version': device.devVersion ?? 'N/A',
                          'device Status': device.devStatus ?? 'N/A',
                          'Channel Number': device.videoChannelNum?.toString() ?? 'N/A',
                          'Actions': 'Edit/Delete',
                        };
                      }),
                      headers: const [
                        'device Name',
                        'device Model',
                        'Access Protocol',
                        'device ID',
                        'Ip Address',
                        'device Version',
                        'device Status',
                        'Channel Number',
                        'Actions'
                      ],
                      visibleColumns: const [
                        'device Name',
                        'device Model',
                        'Access Protocol',
                        'device ID',
                        'Ip Address',
                        'device Version',
                        'device Status',
                        'Channel Number',
                        'Actions'
                      ],
                       onTransfer: (row) {
                        // Handle transfer
                        print('Transfer: $row');
                      },
                      onEdit: (row) {
                        final device = paginatedData.firstWhere(
                          (d) => d.devIndex == row['device ID'],
                        );
                        // _showdeviceDialog(context, device);
                      },
                      onDelete: (row) {
                        final device = paginatedData.firstWhere(
                          (d) => d.devIndex == row['device ID'],
                        );
                        _showDeleteConfirmationDialog(context, device);
                      },
                     
                      onSort: (columnName, ascending) {
                        // Implement sorting if needed
                      },
                      // onSelect: (row) {
                      //   final device = paginatedData.firstWhere(
                      //     (d) => d.devIndex == row['device ID'],
                      //   );
                      //   controller.toggledeviceSelection(device);
                      // },
                    ),
                  ),
                  Obx(() => PaginationWidget(
                        currentPage: _currentPage.value,
                        totalPages: _totalPages.value,
                        onFirstPage: () => _handlePageChange(1),
                        onPreviousPage: () => _handlePageChange(_currentPage.value - 1),
                        onNextPage: () => _handlePageChange(_currentPage.value + 1),
                        onLastPage: () => _handlePageChange(_totalPages.value),
                        onItemsPerPageChange: _handleItemsPerPageChange,
                        itemsPerPage: _itemsPerPage.value,
                        itemsPerPageOptions: const [10, 25, 50, 100],
                        totalItems: controller.devices.length,
                      )),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  // void _showdeviceDialog(BuildContext context, [deviceModel? device]) {
  //   showCustomDialog(
  //     context: context,
  //     dialogContent: [
  //       // Implement the dialog for adding/editing devices
  //     ],
  //   );
  // }

  void _showDeleteConfirmationDialog(BuildContext context, [Device? device]) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete the selected devices?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                controller.deleteSelecteddevices();
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}