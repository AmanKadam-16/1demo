import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/device_management_controller/device_employee_controller_HikeVision.dart';
import 'package:time_attendance/controller/device_management_controller/device_management_controller.dart';
import 'package:time_attendance/model/device_management_model/device_employee_transfer_model.dart';
import 'package:time_attendance/model/device_management_model/mega_transfer_result.dart';
import 'package:time_attendance/screen/housekeeping_tab_screen/deviceManagement_tab_screen/device_selection_dialog_screen.dart';
import 'package:time_attendance/screen/housekeeping_tab_screen/deviceManagement_tab_screen/employee_transfer_summary_dialog_screen.dart';
import 'package:time_attendance/widgets/mtaToast.dart';

class EmployeeTransferDialog extends StatefulWidget {
  final List<String> employeeNos;
  final String sourceDevId;
  final List<EmployeeTransferDetail> empDetailsList;
  final DeviceEmployeeControllerHK controllerHK;

  const EmployeeTransferDialog({
    Key? key,
    required this.employeeNos,
    required this.sourceDevId,
    required this.empDetailsList,
    required this.controllerHK,
  }) : super(key: key);

  @override
  State<EmployeeTransferDialog> createState() => _EmployeeTransferDialogState();
}

class _EmployeeTransferDialogState extends State<EmployeeTransferDialog> {
  final deviceHKController = Get.put(DeviceEmployeeControllerHK());
  final controller = Get.find<DeviceManagementController>();
  final RxSet<String> selectedDeviceIds = <String>{}.obs;
  final searchController = TextEditingController();
  final _elapsedTime = '00:00'.obs;
  Timer? _syncTimer;
  int _seconds = 0;

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

  @override
  void dispose() {
    _stopSyncTimer();
    super.dispose();
  }

  void _handleTransfer(BuildContext context) async {
    if (selectedDeviceIds.isNotEmpty) {
      // Show loading dialog with timer
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          _startSyncTimer();
          return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              title: const Text('Transfer in Progress'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Transferring employee biometric data to selected devices.\nThis operation may take a few minutes to complete.'),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Transfer in progress...'),
                          Obx(() => Text('Time elapsed: ${_elapsedTime.value}')),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );

      final selectedDevices = controller.processedDevices
          .where((device) => selectedDeviceIds.contains(device.devIndex))
          .map((device) => device.devIndex)
          .toList();

      final MegaTransferResult result =
          await deviceHKController.megaEmployeeBiometricDataTransferSync(
        employeeDetails: widget.empDetailsList,
        targetDevices: selectedDevices,
        hostDeviceIndex: widget.sourceDevId,
      );

      _stopSyncTimer();
      Navigator.of(context).pop(); // Close the loading dialog

      if (result.success && result.response != null) {
        Navigator.of(context).pop(); // Close the transfer dialog
        // Show Transfer summary dialog
        showDialog(
          context: context,
          builder: (context) => EmployeeTransferSummaryDialog(
            response: result.response!,
          ),
        );
      } else {
        MTAToast().ShowToast(
          'Failed to transfer employee data',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Transfer Biometric Data',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        'Transfer ${widget.employeeNos.length} selected employee(s) to another device or location.',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black87),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),          DeviceSelectionDialog(
            sourceDeviceId: widget.sourceDevId,
            searchController: searchController,
            onSelectionChanged: (selectedDevices) {
              selectedDeviceIds.clear();
              selectedDeviceIds.addAll(selectedDevices);
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                Obx(() => ElevatedButton(
                      onPressed: selectedDeviceIds.isEmpty
                          ? null
                          : () => _handleTransfer(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      child: const Text(
                        'Transfer',
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
