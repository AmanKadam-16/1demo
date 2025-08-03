// download_device_log_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:time_attendance/controller/housekepping_controller/download_devoice_controller.dart';
import 'package:time_attendance/widget/reusable/devoice_table/button_reuable_list.dart';
import 'package:time_attendance/widget/reusable/list/filter_table.dart';
import 'package:time_attendance/widget/reusable/search/reusable_search_field.dart';
import 'package:time_attendance/widget/reusable/tooltip/help_tooltip_button.dart';
// import 'package:time_attendance/widget/reusable/devoice_table/devoice_table.dart';

class DownloadDeviceLogScreen extends StatelessWidget {
  DownloadDeviceLogScreen({Key? key}) : super(key: key) {
    controller = Get.put(DownloadDeviceController());
  }

  late final DownloadDeviceController controller;
  final TextEditingController _searchController = TextEditingController();
  final DateFormat _dateFormat = DateFormat('dd-MMM-yyyy');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Download Logs(Device)'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          PopupMenuButton<String>(
            offset: const Offset(0, 50),
            icon: const Icon(Icons.calendar_today),
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                child: Container(
                  width: 300,
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildPopupDateField(
                        label: 'From Date:',
                        date: controller.fromDate.value,
                        onDateSelected: controller.updateFromDate,
                      ),
                      const SizedBox(height: 16),
                      _buildPopupDateField(
                        label: 'To Date:',
                        date: controller.toDate.value,
                        onDateSelected: controller.updateToDate,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Apply'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          ReusableSearchField(
            searchController: _searchController,
            onSearchChanged: controller.updateSearchQuery,
          ),
          const SizedBox(width: 8),
          HelpTooltipButton(
            tooltipMessage: 'Select the date range for downloading logs from devices.',
          ),
          const SizedBox(width: 16),
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
          Obx(() {
            if (controller.isDownloaded.value) {
              return Expanded(
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: _buildDeviceTable(),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      flex: 1,
                      child: _buildDownloadCompletedView(),
                    ),
                  ],
                ),
              );
            } else {
              return Expanded(
                child: Column(
                  children: [
                    Expanded(child: _buildDeviceTable()),
                  ],
                ),
              );
            }
          }),
        ],
      ),
    );
  }

  Widget _buildDateField({
    required BuildContext context,
    required DateTime date,
    required Function(DateTime) onDateSelected,
  }) {
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (picked != null) {
          onDateSelected(picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(_dateFormat.format(date)),
      ),
    );
  }

  Widget _buildPopupDateField({
    required String label,
    required DateTime date,
    required Function(DateTime) onDateSelected,
  }) {
    return Builder(
      builder: (context) => Row(
        children: [
          Text(label),
          const SizedBox(width: 8),
          Expanded(
            child: InkWell(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: date,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                );
                if (picked != null) {
                  onDateSelected(picked);
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(_dateFormat.format(date)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeviceTable() {
    return Obx(() {
      if (controller.filteredDevices.isEmpty) {
        return const Center(child: Text('No devices found'));
      }

      final List<Map<String, String>> tableData = controller.filteredDevices.map((device) {
        return {
          //  deviceName: 'Insignia_Test',
          // ipAddress: '192.168.1.181',
          // port: '4370',
          // serialNumber: 'BRM9203460950',
          // ioStatus: 'InOut',
          // deviceType: 'ZKColor',
          // fetchData: 'LAN',
          // isConnected: false,
          // isLicensed: false,
          // updatedLogsInDB: 0,
          // '': '',  // For checkbox column
          'Device Name': device.deviceName ?? '',
          'IPAddress': device.ipAddress ?? '',
          'Port': device.port ?? '',
          'SerialNumber': device.serialNumber ?? '',
          'IOStatus': device.ioStatus ?? '',
          'DeviceType': device.deviceType ?? '',
          'FetchData': device.fetchData ?? '',
          'fetchData': device.fetchData ?? '',
          'IsConnected': (device.isConnected ?? false) ? 'True' : 'False',
          'IsLicensed': (device.isLicensed ?? false) ? 'True' : 'False',
          'UpdatedLogsInDB': '${device.updatedLogsInDB ?? 0}',
          // 'DeviceType': device.deviceType ?? '',
          
        };
      }).toList();

      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: ReusableTableAndCardButton(
          data: tableData,
          headers: ['Device Name', 'IPAddress', 'SerialNumber', 'DeviceType', 'FetchData', 'IsConnected', 'IsLicensed', 'UpdatedLogsInDB'],
          // onSort: (columnName, isAscending) {
          //   controller.sortDevices(columnName, isAscending);
          // },
          // onDownloadSelected: (selectedDevices) {
          //   controller.selectedDevices.clear();
          //   controller.selectedDevices.addAll(selectedDevices);
          // },
        ),
      );
    });
  }
  Widget _buildDownloadCompletedView() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Download Successfully Completed...',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Obx(() {
            if (controller.downloadedDevices.isEmpty) {
              return const Center(child: Text('No devices selected'));
            }
            final List<Map<String, String>> statusTableData = controller.downloadedDevices.map((device) {
              return {
                'DeviceName': device.deviceName ?? '',
                'SerialNumber': device.serialNumber ?? '', 
                'IsConnected': (device.isConnected ?? false) ? 'True' : 'False',
                'IsLicensed': (device.isLicensed ?? false) ? 'True' : 'False',
                'UpdatedLogsInDB': '${device.updatedLogsInDB ?? 0}',
              };
            }).toList();
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ReusableTableAndCard(
                data: statusTableData,
                headers: ['DeviceName', 'SerialNumber', 'IsConnected', 'IsLicensed', 'UpdatedLogsInDB'],
              ),
            );
          }),
        ),
      ],
    );
  }
}