// download_devoice_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:time_attendance/model/housekeeping_model/download_devoice_model.dart';

class DownloadDeviceController extends GetxController {
  final isLoading = false.obs;
  final devices = <DeviceLogModel>[].obs;
  final filteredDevices = <DeviceLogModel>[].obs;
  final searchQuery = ''.obs;
  final fromDate = DateTime.now().obs;
  final toDate = DateTime.now().obs;
  final isDownloaded = false.obs;
  final selectedDevices = <DeviceLogModel>[].obs;
  final downloadedDevices = <DeviceLogModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDevices();
  }

  Future<void> fetchDevices() async {
    try {
      isLoading.value = true;
      
      // Initialize with empty list first to avoid null issues
      devices.clear();
      
      // Simulating API call or data fetching
      final fetchedDevices = [
        DeviceLogModel(
          deviceName: 'Insignia_Test',
          ipAddress: '192.168.1.181',
          port: '4370',
          serialNumber: 'BRM9203460950',
          ioStatus: 'InOut',
          deviceType: 'ZKColor',
          fetchData: 'LAN',
          isConnected: false,
          isLicensed: false,
          updatedLogsInDB: 0,
        ),
        // DeviceLogModel(
        //   deviceName: 'Entrance_Device',
        //   ipAddress: '192.168.1.182',
        //   port: '4370',
        //   serialNumber: 'BRM9203460951',
        //   ioStatus: 'InOut',
        //   deviceType: 'ZKTeco',
        //   fetchData: 'LAN',
        //   isConnected: true,
        //   isLicensed: true,
        //   updatedLogsInDB: 145,
        // ),
        // DeviceLogModel(
        //   deviceName: 'Exit_Device',
        //   ipAddress: '192.168.1.183',
        //   port: '4370',
        //   serialNumber: 'BRM9203460952',
        //   ioStatus: 'InOut',
        //   deviceType: 'ZKColor',
        //   fetchData: 'LAN',
        //   isConnected: true,
        //   isLicensed: true,
        //   updatedLogsInDB: 78,
        // ),
      ];
      
      // Add to the devices list
      devices.addAll(fetchedDevices);
      
      // Update filtered devices
      filteredDevices.clear();
      filteredDevices.addAll(devices);
      
    } catch (e) {
      print('Error fetching devices: ${e.toString()}');
      // Initialize with empty lists on error
      devices.clear();
      filteredDevices.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    
    // Clear first to avoid null issues
    filteredDevices.clear();
    
    if (query.isEmpty) {
      filteredDevices.addAll(devices);
    } else {
      filteredDevices.addAll(
        devices.where((device) =>
            (device.deviceName?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
            (device.serialNumber?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
            (device.ipAddress?.toLowerCase().contains(query.toLowerCase()) ?? false)
        ),
      );
    }
  }

  void selectDevice(DeviceLogModel device, bool isSelected) {
    // Null check for device or serial number
    if (device.serialNumber == null) return;
    
    final index = devices.indexWhere((d) => d.serialNumber == device.serialNumber);
    if (index != -1) {
      devices[index].isSelected = isSelected;
      
      if (isSelected) {
        // Check if already in selectedDevices to avoid duplicates
        if (!selectedDevices.any((d) => d.serialNumber == device.serialNumber)) {
          selectedDevices.add(devices[index]);
        }
      } else {
        selectedDevices.removeWhere((d) => d.serialNumber == device.serialNumber);
      }
      
      // Refresh both collections
      filteredDevices.refresh();
      selectedDevices.refresh();
    }
  }

  void updateFromDate(DateTime date) {
    fromDate.value = date;
  }

  void updateToDate(DateTime date) {
    toDate.value = date;
  }

  Future<bool> downloadDeviceLogs() async {
    if (selectedDevices.isEmpty) {
      Get.snackbar(
        'Warning',
        'No devices selected',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
    
    isLoading.value = true;
    try {
      // Simulate download process
      await Future.delayed(const Duration(seconds: 2));
      downloadedDevices.assignAll(selectedDevices); // Store downloaded devices
      isDownloaded.value = true;
      return true;
    } finally {
      isLoading.value = false;
    }
  }

  void resetDownloadStatus() {
    isDownloaded.value = false;
    selectedDevices.clear();
    downloadedDevices.clear(); // Clear downloaded devices
    // Reset isSelected for all devices
    for (var device in devices) {
      device.isSelected = false;
    }
    filteredDevices.refresh();
  }
}