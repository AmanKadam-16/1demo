import 'dart:convert';

class DeviceModel {
  final int deviceID;
  final String deviceName;
  final int portNo;
  final String ipAddress;
  final int ioStatus;
  final String serialNumber;
  final int fetchDataVia;
  final int type;
  final String locationID;
  final String locationName;
  final String locationCode;

  DeviceModel({
    required this.deviceID,
    required this.deviceName,
    required this.portNo,
    required this.ipAddress,
    required this.ioStatus,
    required this.serialNumber,
    required this.fetchDataVia,
    required this.type,
    required this.locationID,
    required this.locationName,
    required this.locationCode,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) => DeviceModel(
        deviceID: json["DeviceID"],
        deviceName: json["DeviceName"],
        portNo: json["PortNo"],
        ipAddress: json["IPAddress"],
        ioStatus: json["IOStatus"],
        serialNumber: json["SerialNumber"],
        fetchDataVia: json["FetchDataVia"],
        type: json["Type"],
        locationID: json["LocationID"].toString(),
        locationName: json["LocationName"],
        locationCode: json["LocationCode"],
      );

  Map<String, dynamic> toJson() => {
        "DeviceID": deviceID,
        "DeviceName": deviceName,
        "PortNo": portNo,
        "IPAddress": ipAddress,
        "IOStatus": ioStatus,
        "SerialNumber": serialNumber,
        "FetchDataVia": fetchDataVia,
        "Type": type,
        "LocationID": locationID,
        "LocationName": locationName,
        "LocationCode": locationCode,
      };
}

List<DeviceModel> deviceModelFromJson(String str) => List<DeviceModel>.from(json.decode(str).map((x) => DeviceModel.fromJson(x)));

String deviceModelToJson(List<DeviceModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
