import 'package:get/get.dart';
import 'package:time_attendance/model/devoice_tab_model/devoice_model.dart';
// import 'package:time_attendance/model/device_tab_model/device_model.dart';
// import 'package:time_attendance/model/device_model.dart'; // Assuming you have a device model

class deviceController extends GetxController {
  // Dummy data for devices
  final RxList<Device> devices = <Device>[].obs;
  final RxList<Device> selecteddevices = <Device>[].obs;
   final RxString selectedProtocol = ''.obs;

  void setProtocol(String protocol) {
    selectedProtocol.value = protocol;
  }

  void clearProtocol() {
    selectedProtocol.value = '';
  }

  @override
  void onInit() {
    super.onInit();
    // Initialize with dummy data
    devices.addAll([
      Device(
        devIndex: '1',
        devName: 'Device 1',
        devType: 'Type A',
        devStatus: 'Active',
        devVersion: '1.0',
        protocolType: 'HTTP',
        videoChannelNum: 1,
      ),
      Device(
        devIndex: '2',
        devName: 'Device 2',
        devType: 'Type B',
        devStatus: 'Inactive',
        devVersion: '2.0',
        protocolType: 'HTTPS',
        videoChannelNum: 2,
      ),
      Device(
        devIndex: '3',
        devName: 'Device 3',
        devType: 'Type A',
        devStatus: 'Active',
        devVersion: '1.5',
        protocolType: 'HTTP',
        videoChannelNum: 3,
      ),
      Device(
        devIndex: '4',
        devName: 'Device 4',
        devType: 'Type C',
        devStatus: 'Active',
        devVersion: '2.1',
        protocolType: 'HTTPS',
        videoChannelNum: 1,
      ),
      Device(
        devIndex: '5',
        devName: 'Device 5',
        devType: 'Type B',
        devStatus: 'Inactive',
        devVersion: '1.8',
        protocolType: 'HTTP',
        videoChannelNum: 2,
      ),
      Device(
        devIndex: '6',
        devName: 'Device 6',
        devType: 'Type A',
        devStatus: 'Active',
        devVersion: '2.3',
        protocolType: 'HTTPS',
        videoChannelNum: 4,
      ),
      Device(
        devIndex: '7',
        devName: 'Device 7',
        devType: 'Type C',
        devStatus: 'Inactive',
        devVersion: '1.7',
        protocolType: 'HTTP',
        videoChannelNum: 2,
      ),
      Device(
        devIndex: '8',
        devName: 'Device 8',
        devType: 'Type B',
        devStatus: 'Active',
        devVersion: '2.4',
        protocolType: 'HTTPS',
        videoChannelNum: 3,
      ),
      Device(
        devIndex: '9',
        devName: 'Device 9',
        devType: 'Type A',
        devStatus: 'Active',
        devVersion: '1.9',
        protocolType: 'HTTP',
        videoChannelNum: 1,
      ),
      Device(
        devIndex: '10',
        devName: 'Device 10',
        devType: 'Type C',
        devStatus: 'Inactive',
        devVersion: '2.2',
        protocolType: 'HTTPS',
        videoChannelNum: 2,
      ),
      Device(
        devIndex: '11',
        devName: 'Device 11',
        devType: 'Type B',
        devStatus: 'Active',
        devVersion: '1.6',
        protocolType: 'HTTP',
        videoChannelNum: 3,
      ),
      Device(
        devIndex: '12',
        devName: 'Device 12',
        devType: 'Type A',
        devStatus: 'Inactive',
        devVersion: '2.5',
        protocolType: 'HTTPS',
        videoChannelNum: 4,
      ),      // Add more dummy data as needed
    ]);
  }

  // Toggle selection of a device
  void toggledeviceSelection(Device device) {
    if (selecteddevices.contains(device)) {
      selecteddevices.remove(device);
    } else {
      selecteddevices.add(device);
    }
  }

  // Delete selected devices
  void deleteSelecteddevices() {
    devices.removeWhere((device) => selecteddevices.contains(device));
    selecteddevices.clear();
  }

  // Clear all selections
  void clearSelections() {
    selecteddevices.clear();
  }
}