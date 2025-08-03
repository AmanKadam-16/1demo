// download_devoice_model.dart
class DeviceLogModel {
  String? deviceName;
  String? ipAddress;
  String? port;
  String? serialNumber;
  String? ioStatus;
  String? deviceType;
  String? fetchData;
  bool isSelected = false;
  bool? isConnected;
  bool? isLicensed;
  int? updatedLogsInDB;

  DeviceLogModel({
    this.deviceName = '',
    this.ipAddress = '',
    this.port = '',
    this.serialNumber = '',
    this.ioStatus = '',
    this.deviceType = '',
    this.fetchData = '',
    this.isConnected = false,
    this.isLicensed = false,
    this.updatedLogsInDB = 0,
    this.isSelected = false,
  });
  
  // Add equality method to prevent duplicates in lists
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceLogModel &&
          runtimeType == other.runtimeType &&
          serialNumber == other.serialNumber;

  @override
  int get hashCode => serialNumber.hashCode;
}