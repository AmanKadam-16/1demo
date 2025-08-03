// model/master_tab_model/device_model.dart
import 'dart:convert';

class DeviceModel {
  final String deviceId;
  final String deviceName;
  final String ipAddress;
  final String port;
  final String serialNumber;
  final String ioStatus;
  final String deviceType;
  final String fetchDataVia;
  final String location;
  final String locationCode;

  DeviceModel({
    this.deviceId = '',
    this.deviceName = '',
    this.ipAddress = '',
    this.port = '',
    this.serialNumber = '',
    this.ioStatus = '',
    this.deviceType = '',
    this.fetchDataVia = '',
    this.location = '',
    this.locationCode = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'deviceId': deviceId,
      'deviceName': deviceName,
      'ipAddress': ipAddress,
      'port': port,
      'serialNumber': serialNumber,
      'ioStatus': ioStatus,
      'deviceType': deviceType,
      'fetchDataVia': fetchDataVia,
      'location': location,
      'locationCode': locationCode,
    };
  }

  factory DeviceModel.fromMap(Map<String, dynamic> map) {
    return DeviceModel(
      deviceId: map['deviceId'] ?? '',
      deviceName: map['deviceName'] ?? '',
      ipAddress: map['ipAddress'] ?? '',
      port: map['port'] ?? '',
      serialNumber: map['serialNumber'] ?? '',
      ioStatus: map['ioStatus'] ?? '',
      deviceType: map['deviceType'] ?? '',
      fetchDataVia: map['fetchDataVia'] ?? '',
      location: map['location'] ?? '',
      locationCode: map['locationCode'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory DeviceModel.fromJson(String source) => DeviceModel.fromMap(json.decode(source));

  DeviceModel copyWith({
    String? deviceId,
    String? deviceName,
    String? ipAddress,
    String? port,
    String? serialNumber,
    String? ioStatus,
    String? deviceType,
    String? fetchDataVia,
    String? location,
    String? locationCode,
  }) {
    return DeviceModel(
      deviceId: deviceId ?? this.deviceId,
      deviceName: deviceName ?? this.deviceName,
      ipAddress: ipAddress ?? this.ipAddress,
      port: port ?? this.port,
      serialNumber: serialNumber ?? this.serialNumber,
      ioStatus: ioStatus ?? this.ioStatus,
      deviceType: deviceType ?? this.deviceType,
      fetchDataVia: fetchDataVia ?? this.fetchDataVia,
      location: location ?? this.location,
      locationCode: locationCode ?? this.locationCode,
    );
  }
}