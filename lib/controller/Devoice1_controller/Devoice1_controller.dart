// controller/master_tab_controller/device_controller.dart
import 'package:get/get.dart';
import 'package:time_attendance/model/Devoice1_model/Devoice1_model.dart';
// import 'package:time_attendance/model/master_tab_model/device_model.dart';
import 'package:uuid/uuid.dart';

class DeviceController extends GetxController {
  final RxList<DeviceModel> devices = <DeviceModel>[].obs;
  final RxList<DeviceModel> filteredDevices = <DeviceModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Remove hardcoded location initialization
    initializeAuthDevice();
  }

  void initializeAuthDevice() {
    // This will now only handle device-specific initialization
    fetchDevices();
  }

  void fetchDevices() {
    isLoading.value = true;
    
    // Simulate API call with demo data, but without hardcoded location
    Future.delayed(const Duration(milliseconds: 500), () {
      devices.value = [
        DeviceModel(
          deviceId: '1',
          deviceName: 'Insignia_Test',
          ipAddress: '192.168.1.181',
          port: '4370',
          serialNumber: 'BRM9203460950',
          ioStatus: 'InOut',
          deviceType: 'ZKColor',
          fetchDataVia: 'LAN',
          location: '', // Will be set from LocationController
          locationCode: '', // Will be set from LocationController
        ),
        // Add more sample devices as needed
      ];
      
      updateFilteredDevices();
      isLoading.value = false;
    });
  }

  void saveDevice(DeviceModel device) {
    isLoading.value = true;
    
    if (device.deviceId.isEmpty) {
      // Create new device
      final newDevice = device.copyWith(deviceId: const Uuid().v4());
      devices.add(newDevice);
    } else {
      // Update existing device
      final index = devices.indexWhere((d) => d.deviceId == device.deviceId);
      if (index != -1) {
        devices[index] = device;
      }
    }
    
    updateFilteredDevices();
    isLoading.value = false;
  }

  void deleteDevice(String deviceId) {
    isLoading.value = true;
    
    devices.removeWhere((device) => device.deviceId == deviceId);
    updateFilteredDevices();
    
    isLoading.value = false;
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    updateFilteredDevices();
  }

  void updateFilteredDevices() {
    if (searchQuery.value.isEmpty) {
      filteredDevices.value = List.from(devices);
    } else {
      final query = searchQuery.value.toLowerCase();
      filteredDevices.value = devices.where((device) {
        return device.deviceName.toLowerCase().contains(query) ||
               device.ipAddress.toLowerCase().contains(query) ||
               device.serialNumber.toLowerCase().contains(query) ||
               device.location.toLowerCase().contains(query);
      }).toList();
    }
  }

  void sortDevices(String columnName, bool ascending) {
    isLoading.value = true;
    
    filteredDevices.sort((a, b) {
      String valueA = '';
      String valueB = '';
      
      switch (columnName) {
        case 'Device Name':
          valueA = a.deviceName;
          valueB = b.deviceName;
          break;
        case 'IP Address':
          valueA = a.ipAddress;
          valueB = b.ipAddress;
          break;
        case 'Port':
          valueA = a.port;
          valueB = b.port;
          break;
        case 'Serial Number':
          valueA = a.serialNumber;
          valueB = b.serialNumber;
          break;
        case 'IO Status':
          valueA = a.ioStatus;
          valueB = b.ioStatus;
          break;
        case 'Device Type':
          valueA = a.deviceType;
          valueB = b.deviceType;
          break;
        case 'Fetch Data Via':
          valueA = a.fetchDataVia;
          valueB = b.fetchDataVia;
          break;
        case 'Location':
          valueA = a.location;
          valueB = b.location;
          break;
      }
      
      return ascending 
          ? valueA.compareTo(valueB) 
          : valueB.compareTo(valueA);
    });
    
    isLoading.value = false;
  }
}