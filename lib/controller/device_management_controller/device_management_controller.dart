import 'package:get/get.dart';
import 'package:time_attendance/Data/LoginInformation/AuthLogin.dart';
import 'package:time_attendance/Data/LoginInformation/AuthLoginInfoDetails.dart';
import 'package:time_attendance/General/MTAResult.dart';
import 'package:time_attendance/model/device_management_model/device_management_model.dart';
import 'package:time_attendance/model/device_management_model/device_management_details.dart';
import 'package:time_attendance/model/location_model/location_model.dart';
import 'package:time_attendance/model/location_model/location_details.dart';
import 'package:time_attendance/widgets/mtaToast.dart';
import 'package:time_attendance/model/TALogin/session_manager.dart'
    if (dart.library.html) 'package:time_attendance/model/TALogin/session_manager_web.dart'
    if (dart.library.io) 'package:time_attendance/model/TALogin/session_manager_mobile.dart';

class DeviceManagementController extends GetxController {
  final processedDevices = <ProcessedDeviceInfo>[].obs;
  final filteredDevices = <ProcessedDeviceInfo>[].obs;
  final locations = <Location>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;

  // Sorting variables
  final sortColumn = RxString('name');
  final isSortAscending = RxBool(true);

  // Authentication instance
  AuthLogin? _authLogin;
  final _deviceManagementDetails = DeviceManagementDetails();

  // Cache for device details
  final Map<String, DeviceDetails> _deviceDetailsCache = {};
  @override
  void onInit() {
    super.onInit();
    initializeAuth();
    fetchLocations(); // Fetch locations when controller initializes
  }

  Future<void> initializeAuth() async {
    try {
      final userInfo = await PlatformSessionManager.getUserInfo();
      if (userInfo != null) {
        String companyCode = userInfo['CompanyCode'];
        String loginID = userInfo['LoginID'];
        String password = userInfo['Password'];
        _authLogin = await AuthLoginDetails()
            .LoginInformationForFirstLogin(companyCode, loginID, password);
        fetchDevices();
      }
    } catch (e) {
      MTAToast().ShowToast(e.toString());
    }
  }

  Future<void> fetchDevices() async {
    try {
      if (_authLogin == null) {
        throw Exception('Authentication not initialized');
      }

      isLoading.value = true;
      MTAResult result = MTAResult();

      // Step 1: Get devices from search API
      final searchRequest = DeviceSearchRequest(
        searchDescription: SearchDescription(
          position: 0,
          maxResult: 3000,
          filter: Filter(
            protocolType: ['ISAPI'],
            devStatus: ['online', 'offline'],
          ),
        ),
      );

      final searchResponse = await _deviceManagementDetails.searchDevices(
        _authLogin!,
        searchRequest,
        result,
      );
      if (searchResponse.searchResult.totalMatches == 0) {
        processedDevices.clear();
        filteredDevices.clear();
        print('No devices found');
        return;
      }

      // Step 2: Get all device details
      final deviceDetails =
          await _deviceManagementDetails.getAllDeviceDetails(result);
      _deviceDetailsCache.clear();
      for (var detail in deviceDetails) {
        _deviceDetailsCache[detail.devIndex] = detail;
      }

      // Step 3: Get user count for online devices
      final List<ProcessedDeviceInfo> processed = [];

      for (var match in searchResponse.searchResult.matchList) {
        final device = match.device;
        final details = _deviceDetailsCache[device.devIndex];

        // Only fetch user count for online and active devices
        int employeeCount = 0;
        if (device.devStatus.toLowerCase() == 'online') {
          try {
            final userCountResponse =
                await _deviceManagementDetails.getUserCount(
              device.devIndex,
              result,
            );
            employeeCount = userCountResponse.userInfoCount.userNumber;
          } catch (e) {
            print('Error fetching user count for device ${device.devName}: $e');
          }
        }

        processed.add(ProcessedDeviceInfo(
          devIndex: device.devIndex,
          name: device.devName,
          status: device.devStatus.toLowerCase(),
          type: device.devType,
          ipAddress: device.isapiParams.address,
          port: device.isapiParams.portNo,
          location: details?.devLocationName ?? 'N/A',
          locationCode: details?.devLocation ?? 0,
          employees: employeeCount,
          version: device.devVersion == '' ? 'N/A' : device.devVersion,
        ));
      }

      processedDevices.assignAll(processed);
      updateSearchQuery('');
    } catch (e) {
      MTAToast().ShowToast(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addDevice(AddDeviceRequest request, int locationId) async {
    try {
      isLoading.value = true;
      MTAResult result = MTAResult();

      final response =
          await _deviceManagementDetails.addDevice(request, result);

      if (!result.IsResultPass) {
        MTAToast().ShowToast(result.ErrorMessage);
        return false;
      }

      if (response.deviceOutList.isEmpty) {
        MTAToast().ShowToast('No device response received');
        return false;
      }

      bool anySuccess = false;

      // Process each device in the response
      for (var deviceOut in response.deviceOutList) {
        if (deviceOut.device.status == 'success') {
          // Create device in the system after successful addition
          final createRequest = CreateUpdateDeviceRequest(
            devIndex: deviceOut.device.devIndex,
            devName: deviceOut.device.devName,
            devLocation: locationId,
          );

          final success = await createDevice(createRequest);
          if (success) {
            MTAToast().ShowToast(
                '${deviceOut.device.devName} device added successfully');
            anySuccess = true;
          }
        }
      }
     if (anySuccess) {
            await fetchDevices();
     }
      return anySuccess;
    } catch (e) {
      MTAToast().ShowToast('Error adding device: ${e.toString()}');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createDevice(CreateUpdateDeviceRequest request) async {
    try {
      isLoading.value = true;
      MTAResult result = MTAResult();

      await _deviceManagementDetails.createDevice(request, result);

      if (!result.IsResultPass) {
        MTAToast().ShowToast('Failed to create device: ${result.ErrorMessage}');
        return false;
      }
      return true;
    } catch (e) {
      MTAToast().ShowToast('Error creating device: ${e.toString()}');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
  Future<bool> modifyDevice(ModifyDeviceRequest request, int locationId) async {
    try {
      isLoading.value = true;
      MTAResult result = MTAResult();

      // First step: Call the modify device API
      final modifyResponse = await _deviceManagementDetails.modifyDevice(request, result);

      if (!result.IsResultPass) {
        MTAToast().ShowToast(result.ErrorMessage);
        return false;
      }

      // Check for specific success conditions from modify API
      if (modifyResponse.statusCode != 1 || 
          modifyResponse.statusString.toLowerCase() != "ok" ||
          modifyResponse.subStatusCode.toLowerCase() != "ok") {
        MTAToast().ShowToast('Device modification failed: ${modifyResponse.statusString}');
        return false;
      }

      // Second step: If modify was successful, update device details
      final updateRequest = CreateUpdateDeviceRequest(
        devIndex: request.deviceInfo.devIndex,
        devName: request.deviceInfo.devName,
        devLocation: locationId,
      );

      final updateSuccess = await updateDevice(updateRequest);
      if (updateSuccess) {
        MTAToast().ShowToast('Device modified and updated successfully');
        await fetchDevices(); // Refresh device list
        return true;
      } else {
        MTAToast().ShowToast('Device modification succeeded but update failed');
        return false;
      }
    } catch (e) {
      MTAToast().ShowToast('Error modifying device: ${e.toString()}');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateDevice(CreateUpdateDeviceRequest request) async {
    try {
      isLoading.value = true;
      MTAResult result = MTAResult();

      final response = await _deviceManagementDetails.updateDevice(request, result);
      if (!result.IsResultPass) {
        MTAToast().ShowToast('Failed to update device: ${result.ErrorMessage}');
        return false;
      }
      // Check if the response matches expected success message
      if (result.IsResultPass) {
        return true;
      } else {
        MTAToast().ShowToast('Unexpected response from update: $response');
        return false;
      }
    } catch (e) {
      MTAToast().ShowToast('Error updating device: ${e.toString()}');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteDevices(List<String> deviceIndexes) async {
    try {
      isLoading.value = true;
      MTAResult result = MTAResult();

      // Step 1: Call delete proxy API
      final deleteRequest = DeleteDeviceRequest(devIndexList: deviceIndexes);
      final deleteResponse = await _deviceManagementDetails.deleteDeviceProxy(deleteRequest, result);

      if (!result.IsResultPass) {
        MTAToast().ShowToast(result.ErrorMessage);
        return false;
      }

      bool anySuccess = false;

      // Step 2: Process each device deletion result
      for (var deleteResult in deleteResponse.delDevList) {
        if (deleteResult.dev.status.toLowerCase() == 'success') {
          // Call individual device delete API for successful proxy deletions
          final success = await deleteDevice(deleteResult.dev.devIndex);
          if (success) {
            MTAToast().ShowToast('Device ${deleteResult.dev.devIndex} deleted successfully');
            anySuccess = true;
          }
        }
      }

      if (anySuccess) {
        await fetchDevices(); // Refresh the device list
      }

      return anySuccess;
    } catch (e) {
      MTAToast().ShowToast('Error deleting devices: ${e.toString()}');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> deleteDevice(String devIndex) async {
    try {
      MTAResult result = MTAResult();
      
      await _deviceManagementDetails.deleteDevice(devIndex, result);

      if (!result.IsResultPass) {
        MTAToast().ShowToast('Failed to delete device: ${result.ErrorMessage}');
        return false;
      }

      return true;
    } catch (e) {
      MTAToast().ShowToast('Error deleting device: ${e.toString()}');
      return false;
    }
  }

  Future<void> fetchLocations() async {
    try {
      isLoading.value = true;
      MTAResult result = MTAResult();
      final locationDetails = LocationDetails();
      
      final locationList = await locationDetails.getAllLocations(result);
      
      if (result.IsResultPass) {
        locations.assignAll(locationList);
      } else {
        MTAToast().ShowToast('Failed to fetch locations: ${result.ErrorMessage}');
      }
    } catch (e) {
      MTAToast().ShowToast('Error fetching locations: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addLocation(String locationName) async {
    try {
      isLoading.value = true;
      MTAResult result = MTAResult();
      final locationDetails = LocationDetails();
      
      final request = CreateLocationRequest(locationName: locationName);
      await locationDetails.createLocation(request, result);
      
      if (result.IsResultPass) {
        MTAToast().ShowToast('Location added successfully');
        await fetchLocations(); // Refresh the locations list
        return true;
      } else {
        MTAToast().ShowToast(result.ErrorMessage);
        return false;
      }
    } catch (e) {
      MTAToast().ShowToast('Error adding location: ${e.toString()}');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredDevices.assignAll(processedDevices);
    } else {
      filteredDevices.assignAll(
        processedDevices.where((device) =>
            device.name.toLowerCase().contains(query.toLowerCase()) ||
            device.type.toLowerCase().contains(query.toLowerCase()) ||
            device.ipAddress.toLowerCase().contains(query.toLowerCase()) ||
            device.status.toLowerCase().contains(query.toLowerCase()) ||
            device.location.toLowerCase().contains(query.toLowerCase())),
      );
    }
  }

  void sortDevices(String columnName, bool? ascending) {
    if (ascending != null) {
      isSortAscending.value = ascending;
    } else if (sortColumn.value == columnName) {
      isSortAscending.value = !isSortAscending.value;
    } else {
      isSortAscending.value = true;
    }

    sortColumn.value = columnName;

    filteredDevices.sort((a, b) {
      int comparison;
      switch (columnName) {
        case 'Name':
          comparison = a.name.compareTo(b.name);
          break;
        case 'Type':
          comparison = a.type.compareTo(b.type);
          break;
        case 'Status':
          comparison = a.status.compareTo(b.status);
          break;
        case 'IP Address':
          comparison = a.ipAddress.compareTo(b.ipAddress);
          break;
        case 'Port':
          comparison = a.port.compareTo(b.port);
          break;
        case 'Location':
          comparison = a.location.compareTo(b.location);
          break;
        case 'Employees':
          comparison = a.employees.compareTo(b.employees);
          break;
        case 'Version':
          comparison = a.version.compareTo(b.version);
          break;
        default:
          comparison = 0;
      }
      return isSortAscending.value ? comparison : -comparison;
    });
  }
}
