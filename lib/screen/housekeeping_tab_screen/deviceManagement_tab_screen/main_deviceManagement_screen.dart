// main_department_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/device_management_controller/device_management_controller.dart';
import 'package:time_attendance/model/device_management_model/device_management_model.dart';
import 'package:time_attendance/screen/housekeeping_tab_screen/deviceManagement_tab_screen/device_bulkAdd_dialog_screen.dart';
import 'device_dialog_screen.dart';
import 'device_employee_list_screen.dart';
import 'package:time_attendance/widget/reusable/button/custom_action_button.dart';
import 'package:time_attendance/widget/reusable/list/reusable_list.dart';
import 'package:time_attendance/widget/reusable/pagination/pagination_widget.dart';
import 'package:time_attendance/widget/reusable/tooltip/help_tooltip_button.dart';
import 'package:time_attendance/widget/reusable/search/reusable_search_field.dart';

import '../../../widget/reusable/dialog/dialogbox.dart';

class MainDeviceManagementScreen extends StatefulWidget {
  const MainDeviceManagementScreen({super.key});
  @override
  State<MainDeviceManagementScreen> createState() =>
      _MainDeviceManagementScreenState();
}

class _MainDeviceManagementScreenState
    extends State<MainDeviceManagementScreen> {
  // DeviceManagementController
  final DeviceManagementController deviceController =
      Get.put(DeviceManagementController());
  final TextEditingController _searchController = TextEditingController();
  int _currentPage = 1;
  int _itemsPerPage = 10;
  List<int> itemsPerPageArray = [10, 25, 50, 100];
  Set<String> selectedDevices = {};
  void _updateItemsPerPageArray() {
    if (deviceController.processedDevices.isNotEmpty) {
      final int processedDevicesLength =
          deviceController.processedDevices.length;
      if (processedDevicesLength > itemsPerPageArray.last) {
        itemsPerPageArray = [...itemsPerPageArray, processedDevicesLength];
      }
    }
  }

  // Listen to changes in processed devices
  // ever(deviceController.processedDevices, (_) => _updateItemsPerPageArray());

  @override
  void initState() {
    super.initState();
    // Listen to changes in deviceController's processedDevices
    ever(deviceController.processedDevices, (_) => _updateItemsPerPageArray());
  }

  // Get current page items
  List<ProcessedDeviceInfo> _getCurrentPageItems() {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    return deviceController.filteredDevices.sublist(
      startIndex,
      endIndex > deviceController.filteredDevices.length
          ? deviceController.filteredDevices.length
          : endIndex,
    );
  }

  // Check if all current page items are selected
  bool _areAllCurrentPageItemsSelected() {
    final currentPageItems = _getCurrentPageItems();
    if (currentPageItems.isEmpty) return false;
    return currentPageItems
        .every((item) => selectedDevices.contains(item.devIndex));
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, Set<String> deviceIds) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content:
              const Text('Are you sure you want to delete selected device(s)?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                deviceController.deleteDevices(deviceIds.toList());
                Navigator.of(context).pop();
                // also clear the selectedDevices set
                setState(() {
                  selectedDevices.clear();
                });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Management'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          if (MediaQuery.of(context).size.width > 600)
            ReusableSearchField(
              searchController: _searchController,
              hintText: 'Search by name, IP Address, or Status',
              onSearchChanged: deviceController.updateSearchQuery,
            ),
          const SizedBox(width: 20),
          CustomActionButton(
            label: 'Add Device',
            onPressed: () => {_showDeviceDialog(context)},
          ),
          CustomActionButton(
            label: 'Bulk Add',
            onPressed: () => {
              showDialog(
                context: context,
                builder: (context) =>
                    BulkAddDeviceDialog(controller: deviceController),
              )
            },
            icon: Icons.add_circle_outline,
          ),
          CustomActionButton(
            label: 'Delete (${selectedDevices.length})',
            icon: Icons.delete,
            onPressed: () => {
              if (selectedDevices.isNotEmpty)
                {_showDeleteConfirmationDialog(context, selectedDevices)}
              else
                {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('No Devices Selected'),
                        content: const Text(
                            'Please select at least one device to delete.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Close'),
                          ),
                        ],
                      );
                    },
                  )
                }
            },
          ),
          // refresh icon with on pressed to do deviceController.fetchDevices() and tooltip
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Devices',
            onPressed: () {
              deviceController.fetchDevices();
            },
          ),
          HelpTooltipButton(
            tooltipMessage:
                'Manage devices and their configurations in this section.',
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
                onSearchChanged: deviceController.updateSearchQuery,
                responsiveWidth: false,
              ),
            ),
          Expanded(
            child: Obx(() {
              if (deviceController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (deviceController.filteredDevices.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'No devices found',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => deviceController.fetchDevices(),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Refresh'),
                      ),
                    ],
                  ),
                );
              }

              return Column(
                children: [
                  Expanded(
                    child: ReusableTableAndCard(
                      data: _getCurrentPageItems()
                          .map((device) => {
                                'Dev Index': device.devIndex,
                                'Name': device.name,
                                'Status': device.status,
                                'Type': device.type,
                                'IP Address': device.ipAddress,
                                'Port': device.port.toString(),
                                'Location': device.location,
                                'Employees': device.employees.toString(),
                                'Version': device.version,
                              })
                          .toList(),
                      headers: [
                        'Dev Index',
                        'Name',
                        'Status',
                        'Type',
                        'IP Address',
                        'Port',
                        'Location',
                        'Employees',
                        'Version',
                        'Actions'
                      ],
                      visibleColumns: [
                        'Name',
                        'Status',
                        'Type',
                        'IP Address',
                        'Port',
                        'Location',
                        'Employees',
                        'Version',
                        'Actions'
                      ],
                      showCheckboxes: true,
                      maxVisibleButtons: 1,
                      selectedItems: selectedDevices,
                      onSelectAll: (bool? value) {
                        setState(() {
                          final currentPageItems = _getCurrentPageItems();
                          if (value ?? false) {
                            for (var device in currentPageItems) {
                              selectedDevices.add(device.devIndex);
                            }
                          } else {
                            for (var device in currentPageItems) {
                              selectedDevices.remove(device.devIndex);
                            }
                          }
                        });
                      },
                      onSelectItem: (String id, bool selected) {
                        setState(() {
                          if (selected) {
                            selectedDevices.add(id);
                          } else {
                            selectedDevices.remove(id);
                          }
                        });
                      },
                      idField: 'Dev Index',
                      onEdit: (row) {
                        final device =
                            deviceController.filteredDevices.firstWhere(
                          (d) => d.devIndex == row['Dev Index'],
                        );
                        _showDeviceDialog(context, device);
                      },
                      onDelete: (row) {
                        final device =
                            deviceController.filteredDevices.firstWhere(
                          (d) => d.devIndex == row['Dev Index'],
                        );
                        _showDeleteConfirmationDialog(
                            context, {device.devIndex});
                      },
                      customActions: [
                        CustomAction(
                          icon: Icons.person,
                          tooltip: 'Manage Employees',
                          onPressed: (row) => {
                            if (row['Status'].toString().toLowerCase() ==
                                'online')
                              {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DeviceEmployeeListScreen(
                                      deviceName: row['Name'].toString(),
                                      deviceId: row['Dev Index'].toString(),
                                    ),
                                  ),
                                )
                              }
                            else
                              {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Device Offline'),
                                      content: const Text(
                                          'This device is currently offline. Please check the device or try refreshing the page.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('Close'),
                                        ),
                                      ],
                                    );
                                  },
                                )
                              }
                          },
                          color: const Color(0xFF009688),
                          isEnabled: true,
                        )
                      ],
                      onSort: (columnName, ascending) =>
                          deviceController.sortDevices(columnName, ascending),
                    ),
                  ),
                  PaginationWidget(
                    currentPage: _currentPage,
                    totalPages: (deviceController.filteredDevices.length /
                            _itemsPerPage)
                        .ceil(),
                    onFirstPage: () => setState(() => _currentPage = 1),
                    onPreviousPage: () => setState(() {
                      if (_currentPage > 1) _currentPage--;
                    }),
                    onNextPage: () => setState(() {
                      if (_currentPage <
                          (deviceController.filteredDevices.length /
                                  _itemsPerPage)
                              .ceil()) {
                        _currentPage++;
                      }
                    }),
                    onLastPage: () => setState(() {
                      _currentPage = (deviceController.filteredDevices.length /
                              _itemsPerPage)
                          .ceil();
                    }),
                    onItemsPerPageChange: _handleItemsPerPageChange,
                    itemsPerPage: _itemsPerPage,
                    itemsPerPageOptions: itemsPerPageArray,
                    totalItems: deviceController.filteredDevices.length,
                    itemName: 'devices',
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showDeviceDialog(BuildContext context, [ProcessedDeviceInfo? device]) {
    showCustomDialog(
      context: context,
      dialogContent: [
        DeviceDialog(
          controller: deviceController,
          deviceIndex: device?.devIndex ?? '',
          device: device ??
              ProcessedDeviceInfo(
                devIndex: '',
                name: '',
                status: 'Offline',
                type: '',
                ipAddress: '',
                port: 80,
                location: '',
                locationCode: 0,
                employees: 0,
                version: '',
                username: '',
                password: '',
              ),
        ),
      ],
    );
  }

  void _handlePageChange(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _handleItemsPerPageChange(int value) {
    setState(() {
      _itemsPerPage = value;
      _currentPage = 1;
    });
  }
}
