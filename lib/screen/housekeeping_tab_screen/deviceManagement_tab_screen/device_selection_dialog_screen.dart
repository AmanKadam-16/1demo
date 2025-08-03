import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/device_management_controller/device_management_controller.dart';

class DeviceSelectionDialog extends StatelessWidget {
  final String sourceDeviceId;
  final ValueChanged<Set<String>> onSelectionChanged;  // Callback for selection changes
  final TextEditingController searchController;
  final bool showSelectAll;
  final bool onlyOnlineDevices;

  const DeviceSelectionDialog({
    Key? key,
    required this.sourceDeviceId,
    required this.onSelectionChanged,  // Required callback
    required this.searchController,
    this.showSelectAll = true,
    this.onlyOnlineDevices = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DeviceManagementController>();
    final selectedDeviceIds = <String>{}.obs;  // Local state for selections

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: 'Search by device name or location...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: controller.updateSearchQuery,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          height: 300,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Obx(() {
            final devices = controller.filteredDevices
                .where((device) => 
                    device.devIndex != sourceDeviceId && 
                    (!onlyOnlineDevices || device.status.toLowerCase() == 'online'))
                .toList();

            return ListView(
              children: [
                if (showSelectAll)
                  CheckboxListTile(
                    title: const Text(
                      'Select All Devices',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    value: devices.isNotEmpty &&
                        selectedDeviceIds.length == devices.length,
                    onChanged: (bool? value) {
                      if (value == true) {
                        selectedDeviceIds.addAll(devices.map((device) => device.devIndex));
                      } else {
                        selectedDeviceIds.clear();
                      }
                      onSelectionChanged(selectedDeviceIds); // Notify parent of changes
                    },
                  ),
                ...devices.map((device) => CheckboxListTile(
                      title: Text(device.name),
                      subtitle: Text('${device.location} • ${device.ipAddress}'),
                      value: selectedDeviceIds.contains(device.devIndex),
                      onChanged: (bool? value) {
                        if (value == true) {
                          selectedDeviceIds.add(device.devIndex);
                        } else {
                          selectedDeviceIds.remove(device.devIndex);
                        }
                        onSelectionChanged(selectedDeviceIds); // Notify parent of changes
                      },
                    )),
              ],
            );
          }),
        ),
      ],
    );
  }
}