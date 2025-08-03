import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:time_attendance/controller/device_management_controller/device_employee_controller.dart';
import 'package:time_attendance/controller/device_management_controller/device_employee_controller_HikeVision.dart';
import 'package:time_attendance/controller/device_management_controller/device_management_controller.dart';
import 'package:time_attendance/model/device_management_model/device_emloyee_edit_model.dart';
import 'package:time_attendance/model/device_management_model/device_employee_model.dart';
import 'package:time_attendance/model/device_management_model/device_employee_transfer_model.dart';
import 'package:time_attendance/model/device_management_model/device_management_model.dart';
import 'package:time_attendance/screen/housekeeping_tab_screen/deviceManagement_tab_screen/deviceEmployee_dialog_screen.dart';
import 'package:time_attendance/screen/housekeeping_tab_screen/deviceManagement_tab_screen/employee_transfer_dialog_screen.dart';
import 'package:time_attendance/widget/reusable/button/custom_action_button.dart';
import 'package:time_attendance/widget/reusable/dialog/dialogbox.dart';
import 'package:time_attendance/widget/reusable/list/reusable_list.dart';
import 'package:time_attendance/widget/reusable/pagination/pagination_widget.dart';
import 'package:time_attendance/widget/reusable/search/reusable_search_field.dart';
import 'package:time_attendance/widget/reusable/tooltip/help_tooltip_button.dart';

class DeviceEmployeeListScreen extends StatefulWidget {
  final String deviceName;
  final String deviceId;

  const DeviceEmployeeListScreen({
    Key? key,
    required this.deviceName,
    required this.deviceId,
  }) : super(key: key);

  @override
  State<DeviceEmployeeListScreen> createState() =>
      _DeviceEmployeeListScreenState();
}

final GlobalKey _actionButtonKey = GlobalKey();

class _DeviceEmployeeListScreenState extends State<DeviceEmployeeListScreen> {
  int _currentPage = 1;
  int _itemsPerPage = 10;
  int _totalPages = 1;
  List<int> itemsPerPageArray = [10, 25, 50, 100];
  final Set<String> _selectedItems =
      {}; // Add this line to track selected items
  final TextEditingController _searchController = TextEditingController();
  final DeviceEmployeeController _controller =
      Get.put(DeviceEmployeeController());
  final DeviceManagementController _deviceManagementController =
      Get.find<DeviceManagementController>();
  //  final processedDevices = <ProcessedDeviceInfo>[].obs;
  // device List can be accessed as  _deviceManagementController.processedDevices.
  final DeviceEmployeeControllerHK _controllerHK =
      Get.put(DeviceEmployeeControllerHK());

  // Add timer related variables
  Timer? _syncTimer;
  final _elapsedTime = '00:00'.obs;
  int _seconds = 0;

  void _updateItemsPerPageArray() {
    if (_controller.employees.isNotEmpty) {
      final int employeesLength = _controller.employees.length;
      if (employeesLength > itemsPerPageArray.last) {
        itemsPerPageArray = [...itemsPerPageArray, employeesLength];
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.getEmployeesByDevId(widget.deviceId);
    // Listen to changes in employees
    ever(_controller.employees, (_) => _updateItemsPerPageArray());
  }

  String getEmployeeStatus(DeviceEmployeeInfo employee) {
    if (!employee.valid.enable) return 'Disabled';

    DateTime? endTime;
    try {
      endTime = DateTime.parse(employee.valid.endTime);
    } catch (e) {
      return 'Invalid Date';
    }

    // Check if the end time is in UTC
    if (employee.valid.timeType.toUpperCase() == 'UTC') {
      endTime = endTime.toLocal(); // Convert UTC to local time
    }

    return DateTime.now().isAfter(endTime) ? 'Disabled' : 'Enabled';
  }

  Map<String, dynamic> _employeeToRow(DeviceEmployeeInfo employee) {
    return {
      'Employee No.': employee.employeeNo,
      'Name': employee.name,
      'User Type': employee.userType,
      'Door Right': employee.doorRight,
      'Status': getEmployeeStatus(employee),
      'Card No.': employee.cardNo == '' ? 'N/A' : employee.cardNo,
      'FingerPrint': employee.fingerPrintCount.toString() == '0'
          ? 'N/A'
          : employee.fingerPrintCount.toString(),
      'id': employee
          .employeeNo, // Change this to use employeeNo as the identifier
    };
  }

  void _handleItemsPerPageChange(int value) {
    setState(() {
      _itemsPerPage = value;
      _currentPage = 1;
    });
  }

  // Add this method to get current page items
  List<DeviceEmployeeInfo> _getCurrentPageItems() {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    return _controller.filteredEmployees.sublist(
      startIndex,
      endIndex > _controller.filteredEmployees.length
          ? _controller.filteredEmployees.length
          : endIndex,
    );
  }

  // Add this method to check if all current page items are selected
  bool _areAllCurrentPageItemsSelected() {
    final currentPageItems = _getCurrentPageItems();
    if (currentPageItems.isEmpty) return false;
    return currentPageItems
        .every((item) => _selectedItems.contains(item.employeeNo));
  }

  void _handleDisableOrEnableEmployees(bool isEnable) async {
    List<DeviceEmployeeAddRequest> empDetailsList = _controller.employees
        .where((employee) => _selectedItems.contains(employee.employeeNo))
        .map((employee) => DeviceEmployeeAddRequest(
              devIndex: widget.deviceId,
              employeeNo: employee.employeeNo,
              name: employee.name,
              beginTime: employee.valid.beginTime,
              endTime: employee.valid.endTime,
              timeType: employee.valid.timeType,
              userType: employee.userType,
              closeDelayEnabled: employee.closeDelayEnabled,
              validEnable: true,
              password: employee.password,
              doorRight: employee.doorRight,
              maxOpenDoorTime: employee.maxOpenDoorTime,
              openDoorTime: employee.openDoorTime,
              localUIRight: employee.localUIRight,
              userVerifyMode: employee.userVerifyMode,
              fingerPrintCount: employee.fingerPrintCount,
              cardCount: employee.cardCount,
              cardNo: employee.cardNo,
            ))
        .toList();
    bool success = await _controllerHK.modifyUserApi(
        employeeDetails: empDetailsList,
        enable: isEnable,
        disableEmployee: isEnable ? false : true,
        enableEmployee: isEnable ? true : false);
    if (success) {
      await _controller.getEmployeesByDevId(widget.deviceId);
      // reset selected employees after enabling/disabling
      setState(() {
        _selectedItems.clear();
      });
    }
  }

  void _handleTransferEmployees() {
    _showEmployeeDialog(context);
  }

  void _handleDeleteEmployees(List<String> selectedEmployeeNumbers,
      List<String> selectedDevices) async {
    // Using employeeNo for deletion
    print('Delete ${selectedEmployeeNumbers.length} employees');
    bool success = await _controllerHK.deleteDeviceUsers(
        selectedDevices, selectedEmployeeNumbers);
    if (success) {
      _controller.getEmployeesByDevId(widget.deviceId);
      // also clear selected items after deletion
      setState(() {
        _selectedItems.clear();
      });
    }
  }

  Future<List<String>> _showDeviceSelectionDialog(BuildContext context) async {
    final TextEditingController searchController = TextEditingController();
    final Set<String> selectedDevices = {widget.deviceId};
    // Filter only online devices from the start
    List<ProcessedDeviceInfo> deviceList = _deviceManagementController
        .processedDevices
        .where((device) => device.status.toLowerCase() == 'online')
        .toList();
    List<ProcessedDeviceInfo> filteredDevices = deviceList;
    bool result = true;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            bool isAllSelected = filteredDevices.isNotEmpty &&
                filteredDevices.every(
                    (device) => selectedDevices.contains(device.devIndex));

            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Select Target Devices'),
                  Text('${selectedDevices.length} selected',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                ],
              ),
              content: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        labelText: 'Search by devices, location or IP',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        setState(() {
                          filteredDevices = deviceList
                              .where((device) =>
                                  device.name
                                      .toLowerCase()
                                      .contains(value.toLowerCase()) ||
                                  device.location
                                      .toLowerCase()
                                      .contains(value.toLowerCase()) ||
                                  device.ipAddress
                                      .toLowerCase()
                                      .contains(value.toLowerCase()))
                              .toList();
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      leading: Checkbox(
                        value: isAllSelected,
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              selectedDevices.clear();
                              selectedDevices.add(widget.deviceId);
                              selectedDevices.addAll(
                                  filteredDevices.map((d) => d.devIndex));
                            } else {
                              selectedDevices.clear();
                              selectedDevices.add(widget.deviceId);
                            }
                          });
                        },
                      ),
                      title: const Text('Select All'),
                    ),
                    Flexible(
                      child: deviceList.isEmpty
                          ? const Center(
                              child: Text('No online devices available'),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: filteredDevices.length,
                              itemBuilder: (context, index) {
                                final device = filteredDevices[index];
                                return ListTile(
                                  leading: Checkbox(
                                    value: selectedDevices
                                        .contains(device.devIndex),
                                    onChanged: (value) {
                                      setState(() {
                                        if (value == true) {
                                          selectedDevices.add(device.devIndex);
                                        } else {
                                          selectedDevices
                                              .remove(device.devIndex);
                                        }
                                      });
                                    },
                                  ),
                                  title: Text(device.name),
                                  subtitle: Text(
                                      'IP: ${device.ipAddress} • ${device.location}'),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    result = false;
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(selectedDevices.toList());
                  },
                  child: const Text('Confirm'),
                ),
              ],
            );
          },
        );
      },
    );

    return result ? selectedDevices.toList() : [];
  }

// if receive date as 1970-01-01T05:30:00 and if its UTC then append +05:30 to it and return
  String _formatDateTime(String timeType, String dateTimeStr) {
    if (timeType.toLowerCase() == 'utc') {
      return '$dateTimeStr+05:30';
    } else {
      // For local time format: "2017-08-01T17:30:08"
      return dateTimeStr;
    }
  }

  void _showEmployeeDialog(BuildContext context) {
    final employeeListWithDetails = _controller.employees
        .where((item) => _selectedItems.contains(item.employeeNo))
        .map((employee) => EmployeeTransferDetail(
              employeeNo: employee.employeeNo,
              id: employee.id,
              name: employee.name,
              userType: employee.userType,
              closeDelayEnabled: employee.closeDelayEnabled,
              valid: ValidInfo(
                enable: employee.valid.enable,
                timeType: employee.valid.timeType,
                beginTime: _formatDateTime(
                    employee.valid.timeType, employee.valid.beginTime),
                endTime: _formatDateTime(
                    employee.valid.timeType, employee.valid.endTime),
              ),
              password: employee.password,
              doorRight: employee.doorRight,
              rightPlan: employee.rightPlan
                  .map((plan) => RightPlan1(
                        doorNo: plan.doorNo,
                        planTemplateNo: plan.planTemplateNo,
                      ))
                  .toList(),
              maxOpenDoorTime: employee.maxOpenDoorTime,
              openDoorTime: employee.openDoorTime,
              localUIRight: employee.localUIRight,
              userVerifyMode: employee.userVerifyMode,
              fingerPrintCount: employee.fingerPrintCount,
              cardCount: employee.cardCount,
              cardNo: employee.cardNo,
            ))
        .toList();
    showCustomDialog(
      context: context,
      dialogContent: [
        EmployeeTransferDialog(
          employeeNos: _selectedItems.toList(),
          sourceDevId: widget.deviceId,
          empDetailsList: employeeListWithDetails,
          controllerHK: _controllerHK,
        )
      ],
    );

    // Reset selected items after showing the dialog
    setState(() {
      _selectedItems.clear();
    });
  }

  void _showDeviceEmployeeDialog(BuildContext context,
      [DeviceEmployeeInfo? employeeDetails]) async {
    List<String>? selectedDevices = await _showDeviceSelectionDialog(context);
    if (selectedDevices.isEmpty) {
      // If no devices were selected, return early
      return;
    } else {
      showCustomDialog(
        context: context,
        dialogContent: [
          DeviceEmployeeDialog(
            employee: employeeDetails,
            controller: _controllerHK,
            controllerLocal: _controller,
            deviceId: widget.deviceId,
            deviceIds: selectedDevices,
          ),
        ],
      );
    }
  }

  Future<void> _showDeleteConfirmation(
      List<String> selectedEmployeeNumbers) async {
    // First show device selection dialog and get result
    List<String>? selectedDevices = await _showDeviceSelectionDialog(context);

    // Only proceed with delete confirmation if devices were selected
    if (selectedDevices.isNotEmpty) {
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Delete Confirmation'),
            content: const Text(
                'Are you sure you want to delete selected employee(s)?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _showFinalDeleteConfirmation(
                      selectedEmployeeNumbers, selectedDevices);
                },
                style: TextButton.styleFrom(),
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

  Future<void> _showFinalDeleteConfirmation(
      List<String> selectedEmployeeNumbers,
      List<String> selectedDevices) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warning'),
          content: const Text(
              'Once deleted, this action cannot be reverted.\n Do you want to proceed?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _handleDeleteEmployees(
                    selectedEmployeeNumbers, selectedDevices);
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.redAccent,
              ),
              child: const Text('Yes, delete'),
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

  Future<void> _showEmployeeDisableOrEnableConfirmation(
      List<String> selectedEmployeeNumbers, bool isEnable) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isEnable
              ? 'Enable Employees Confirmation'
              : 'Disable Employees Confirmation'),
          content: Text(isEnable
              ? 'Are you sure you want to enable selected employee(s)?'
              : 'Are you sure you want to disable selected employee(s)?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _handleDisableOrEnableEmployees(isEnable);
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: !isEnable ? Colors.redAccent : null,
              ),
              child: Text(isEnable ? 'Yes, enable' : 'Yes, disable'),
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

  void _startSyncTimer() {
    _seconds = 0;
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds++;
      int minutes = _seconds ~/ 60;
      int remainingSeconds = _seconds % 60;
      _elapsedTime.value =
          '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    });
  }

  void _stopSyncTimer() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }

  Future<void> _showSyncConfirmation(String deviceName) async {
    bool isSyncing = false;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Sync Records'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    "This action will sync employee biometric and personal details between device '$deviceName' and local database.\nThis operation may take a few minutes to complete."),
                if (isSyncing) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Sync in progress...'),
                          Obx(() =>
                              Text('Time elapsed: ${_elapsedTime.value}')),
                        ],
                      ),
                    ],
                  ),
                ],
              ],
            ),
            actions: <Widget>[
              if (!isSyncing) ...[
                TextButton(
                  onPressed: () async {
                    setState(() => isSyncing = true);
                    _startSyncTimer();

                    await _controllerHK
                        .syncEmployeeBiometricDetails(widget.deviceId);
                    await _controller.getEmployeesByDevId(widget.deviceId);

                    _stopSyncTimer();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Yes'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('No'),
                ),
              ],
            ],
          );
        });
      },
    );
  }

  void showActionsPopover(BuildContext context, Offset offset) async {
    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(offset.dx, offset.dy, 0, 0),
      items: [
        PopupMenuItem<String>(
          value: 'sync',
          child: Row(
            children: const [
              Icon(Icons.sync),
              SizedBox(width: 8),
              Text('Sync Records'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'enable',
          enabled: _selectedItems.isNotEmpty,
          child: Row(
            children: [
              const Icon(Icons.check_circle_outline),
              const SizedBox(width: 8),
              Text('Enable (${_selectedItems.length})'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'disable',
          enabled: _selectedItems.isNotEmpty,
          child: Row(
            children: [
              const Icon(Icons.block),
              const SizedBox(width: 8),
              Text('Disable (${_selectedItems.length})'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'transfer',
          enabled: _selectedItems.isNotEmpty,
          child: Row(
            children: [
              const Icon(Icons.swap_horiz),
              const SizedBox(width: 8),
              Text('Transfer (${_selectedItems.length})'),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'delete',
          enabled: _selectedItems.isNotEmpty,
          child: Row(
            children: [
              const Icon(Icons.delete_outline),
              const SizedBox(width: 8),
              Text('Delete Selected (${_selectedItems.length})'),
            ],
          ),
        ),
      ],
    );

    if (selected != null) {
      switch (selected) {
        case 'sync':
          _showSyncConfirmation(widget.deviceName);
          break;
        case 'enable':
          _showEmployeeDisableOrEnableConfirmation(
              _selectedItems.toList(), true);
          break;
        case 'disable':
          _showEmployeeDisableOrEnableConfirmation(
              _selectedItems.toList(), false);
          break;
        case 'transfer':
          _handleTransferEmployees();
          break;
        case 'delete':
          // _handleDeleteEmployees(_selectedItems.toList());
          _showDeleteConfirmation(
              _selectedItems.toList()); // alert before deletion
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee List | ${widget.deviceName}'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          if (MediaQuery.of(context).size.width > 600)
            ReusableSearchField(
              searchController: _searchController,
              onSearchChanged: _controller.updateSearchQuery,
            ),
          const SizedBox(width: 20),
          CustomActionButton(
            key: _actionButtonKey,
            label: 'Actions (${_selectedItems.length})',
            icon: Icons.more_vert,
            onPressed: () {
              final RenderBox renderBox = _actionButtonKey.currentContext!
                  .findRenderObject() as RenderBox;
              final Offset offset = renderBox.localToGlobal(Offset.zero);
              showActionsPopover(context, offset);
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh List',
            onPressed: () {
              _controller.getEmployeesByDevId(widget.deviceId);
            },
          ),
          HelpTooltipButton(
            tooltipMessage:
                'Manage device employees and their configurations in this section.',
          ),
          const SizedBox(width: 8)
        ],
      ),
      body: Column(
        children: [
          if (MediaQuery.of(context).size.width <= 600)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ReusableSearchField(
                searchController: _searchController,
                onSearchChanged: _controller.updateSearchQuery,
                responsiveWidth: false,
              ),
            ),
          Expanded(
            child: Obx(() {
              if (_controller.isLoading.value ||
                  _controllerHK.isLoading.value) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      if (_controllerHK.isLoading.value)
                        const Padding(
                          padding: EdgeInsets.only(top: 16.0),
                          child: Text(
                            'Sync is in progress, please wait...',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }

              if (_controller.employees.isEmpty) {
                return const Center(
                  child: Text(
                    'No employees found. Try syncing records in actions menu.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                );
              }

              final List<DeviceEmployeeInfo> employeesToShow =
                  _getCurrentPageItems();

              return Column(
                children: [
                  Expanded(
                    child: ReusableTableAndCard(
                      data: employeesToShow
                          .map((employee) => Map<String, String>.from(
                              _employeeToRow(employee)))
                          .toList(),
                      headers: const [
                        'Employee No.',
                        'Name',
                        'User Type',
                        'Door Right',
                        'Status',
                        'Card No.',
                        'FingerPrint',
                        'Actions'
                      ],
                      visibleColumns: const [
                        'Employee No.',
                        'Name',
                        'User Type',
                        'Door Right',
                        'Status',
                        'Card No.',
                        'FingerPrint',
                        'Actions'
                      ],
                      onSort: (columnName, ascending) {
                        _controller.sortEmployees(columnName, ascending);
                        setState(() {}); // Refresh the UI after sorting
                      },
                      showCheckboxes: true,
                      maxVisibleButtons: 2,
                      selectedItems: _selectedItems,
                      onSelectAll: (bool? value) {
                        setState(() {
                          final currentPageItems = _getCurrentPageItems();
                          if (value == true) {
                            // Only select if not all items are already selected
                            if (!_areAllCurrentPageItemsSelected()) {
                              for (var employee in currentPageItems) {
                                _selectedItems.add(employee.employeeNo);
                              }
                            }
                          } else {
                            // Deselect all items on current page
                            for (var employee in currentPageItems) {
                              _selectedItems.remove(employee.employeeNo);
                            }
                          }
                        });
                      },
                      onSelectItem: (String id, bool selected) {
                        setState(() {
                          if (selected) {
                            _selectedItems.add(id);
                          } else {
                            _selectedItems.remove(id);
                          }
                        });
                      },
                      idField: 'id',
                      onEdit: (row) {
                        // Implement if needed
                        final employeeDetails = _controller.employees
                            .where((employee) =>
                                employee.employeeNo == row['Employee No.']!)
                            .toList();
                        _showDeviceEmployeeDialog(context, employeeDetails[0]);
                      },
                      onDelete: (row) {
                        // Implement if needed
                        // _handleDeleteEmployees([row['Employee No.']!]);
                        _showDeleteConfirmation(
                            [row['Employee No.']!]); // alert before deletion
                      },
                    ),
                  ),
                  PaginationWidget(
                    currentPage: _currentPage,
                    totalPages:
                        (_controller.filteredEmployees.length / _itemsPerPage)
                            .ceil(),
                    onFirstPage: () => setState(() => _currentPage = 1),
                    onPreviousPage: () => setState(() {
                      if (_currentPage > 1) _currentPage--;
                    }),
                    onNextPage: () => setState(() {
                      if (_currentPage <
                          (_controller.filteredEmployees.length / _itemsPerPage)
                              .ceil()) {
                        _currentPage++;
                      }
                    }),
                    onLastPage: () => setState(() {
                      _currentPage =
                          (_controller.filteredEmployees.length / _itemsPerPage)
                              .ceil();
                    }),
                    onItemsPerPageChange: _handleItemsPerPageChange,
                    itemsPerPage: _itemsPerPage,
                    itemsPerPageOptions: itemsPerPageArray,
                    totalItems: _controller.totalEmployeeCount,
                    itemName: 'employees',
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
