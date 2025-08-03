import 'dart:convert';

// Device Management Models File

class DeviceSearchRequest {
  SearchDescription searchDescription;

  DeviceSearchRequest({required this.searchDescription});

  Map<String, dynamic> toJson() => {
        'SearchDescription': searchDescription.toJson(),
      };
}

class SearchDescription {
  int position;
  int maxResult;
  Filter filter;

  SearchDescription({
    required this.position,
    required this.maxResult,
    required this.filter,
  });

  Map<String, dynamic> toJson() => {
        'position': position,
        'maxResult': maxResult,
        'Filter': filter.toJson(),
      };
}

class Filter {
  String key;
  String devType;
  List<String> protocolType;
  List<String> devStatus;

  Filter({
    this.key = '',
    this.devType = '',
    required this.protocolType,
    required this.devStatus,
  });

  Map<String, dynamic> toJson() => {
        'key': key,
        'devType': devType,
        'protocolType': protocolType,
        'devStatus': devStatus,
      };
}

class DeviceSearchResponse {
  SearchResult searchResult;

  DeviceSearchResponse({required this.searchResult});

  factory DeviceSearchResponse.fromJson(Map<String, dynamic> json) =>
      DeviceSearchResponse(
        searchResult: SearchResult.fromJson(json['SearchResult']),
      );
}

class SearchResult {
  List<MatchItem> matchList;
  int numOfMatches;
  int totalMatches;

  SearchResult({
    required this.matchList,
    required this.numOfMatches,
    required this.totalMatches,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) => SearchResult(
        matchList: (json['MatchList'] as List?)
            ?.map((item) => MatchItem.fromJson(item))
            .toList() ?? [],
        numOfMatches: json['numOfMatches'] ?? 0,
        totalMatches: json['totalMatches'] ?? 0,
      );
}

class MatchItem {
  Device device;

  MatchItem({required this.device});

  factory MatchItem.fromJson(Map<String, dynamic> json) =>
      MatchItem(device: Device.fromJson(json['Device']));
}

class Device {
  ISAPIParams isapiParams;
  bool activeStatus;
  String devIndex;
  String devMode;
  String devName;
  String devStatus;
  String devType;
  String devVersion;
  String protocolType;
  int videoChannelNum;

  Device({
    required this.isapiParams,
    required this.activeStatus,
    required this.devIndex,
    required this.devMode,
    required this.devName,
    required this.devStatus,
    required this.devType,
    required this.devVersion,
    required this.protocolType,
    required this.videoChannelNum,
  });

  factory Device.fromJson(Map<String, dynamic> json) => Device(
        isapiParams: ISAPIParams.fromJson(json['ISAPIParams']),
        activeStatus: json['activeStatus'] ?? false,
        devIndex: json['devIndex'] ?? '',
        devMode: json['devMode'] ?? '',
        devName: json['devName'] ?? '',
        devStatus: json['devStatus'] ?? '',
        devType: json['devType'] ?? '',
        devVersion: json['devVersion'] ?? '',
        protocolType: json['protocolType'] ?? '',
        videoChannelNum: json['videoChannelNum'] ?? 0,
      );
}

class ISAPIParams {
  String address;
  String addressingFormatType;
  int portNo;

  ISAPIParams({
    required this.address,
    required this.addressingFormatType,
    required this.portNo,
  });

  factory ISAPIParams.fromJson(Map<String, dynamic> json) => ISAPIParams(
        address: json['address'],
        addressingFormatType: json['addressingFormatType'],
        portNo: json['portNo'],
      );
}

class DeviceDetails {
  String devIndex;
  String devName;
  int devLocation;
  String devLocationName;
  DateTime createDate;
  DateTime updateDate;
  bool isDeleted; 

  DeviceDetails({
    required this.devIndex,
    required this.devName,
    required this.devLocation,
    required this.devLocationName,
    required this.createDate,
    required this.updateDate,
    required this.isDeleted,
  });

  factory DeviceDetails.fromJson(Map<String, dynamic> json) => DeviceDetails(
        devIndex: json['DevIndex'],
        devName: json['DevName'],
        devLocation: json['DevLocation'],
        devLocationName: json['DevLocationName'],
        createDate: DateTime.parse(json['CreateDate']),
        updateDate: DateTime.parse(json['UpdateDate']),
        isDeleted: json['IsDeleted'],
      );
}

class UserCountResponse {
  UserInfoCount userInfoCount;

  UserCountResponse({required this.userInfoCount});

  factory UserCountResponse.fromJson(Map<String, dynamic> json) =>
      UserCountResponse(
        userInfoCount: UserInfoCount.fromJson(json['UserInfoCount']),
      );
}

class UserInfoCount {
  int userNumber;

  UserInfoCount({required this.userNumber});

  factory UserInfoCount.fromJson(Map<String, dynamic> json) =>
      UserInfoCount(userNumber: json['userNumber']);
}

class ProcessedDeviceInfo {
  String devIndex;
  String name;
  String status;
  String type;
  String ipAddress;
  int port;
  String location;
  int locationCode;
  int employees;
  String version;
  String username;
  String password;

  ProcessedDeviceInfo({
    required this.devIndex,
    required this.name,
    required this.status,
    required this.type,
    required this.ipAddress,
    required this.port,
    required this.location,
    required this.locationCode,
    required this.employees,
    required this.version,
    this.username = '',
    this.password = '',
  });
}

class AddDeviceRequest {
  List<DeviceIn> deviceInList;

  AddDeviceRequest({required this.deviceInList});

  Map<String, dynamic> toJson() => {
        'DeviceInList': deviceInList.map((device) => device.toJson()).toList(),
      };
}

class DeviceIn {
  DeviceInfo device;

  DeviceIn({required this.device});

  Map<String, dynamic> toJson() => {
        'Device': device.toJson(),
      };
}

class DeviceInfo {
  String protocolType;
  String devName;
  String devType;
  ISAPIParamsRequest isapiParams;

  DeviceInfo({
    required this.protocolType,
    required this.devName,
    required this.devType,
    required this.isapiParams,
  });

  Map<String, dynamic> toJson() => {
        'protocolType': protocolType,
        'devName': devName,
        'devType': devType,
        'ISAPIParams': isapiParams.toJson(),
      };
}

class ISAPIParamsRequest {
  String addressingFormatType;
  String address;
  int portNo;
  String userName;
  String password;

  ISAPIParamsRequest({
    required this.addressingFormatType,
    required this.address,
    required this.portNo,
    required this.userName,
    required this.password
  });

  Map<String, dynamic> toJson() => {
        'addressingFormatType': addressingFormatType,
        'address': address,
        'portNo': portNo,
        'userName': userName,
        'password': password,
      };
}

class AddDeviceResponse {
  List<DeviceOut> deviceOutList;

  AddDeviceResponse({required this.deviceOutList});

  factory AddDeviceResponse.fromJson(Map<String, dynamic> json) {
    return AddDeviceResponse(
      deviceOutList: (json['DeviceOutList'] as List)
          .map((device) => DeviceOut.fromJson(device))
          .toList(),
    );
  }
}

class DeviceOut {
  DeviceOutInfo device;

  DeviceOut({required this.device});

  factory DeviceOut.fromJson(Map<String, dynamic> json) {
    return DeviceOut(device: DeviceOutInfo.fromJson(json['Device']));
  }
}

class DeviceOutInfo {
  ISAPIParams isapiParams;
  String devIndex;
  String devName;
  String protocolType;
  String status;

  DeviceOutInfo({
    required this.isapiParams,
    required this.devIndex,
    required this.devName,
    required this.protocolType,
    required this.status,
  });

  factory DeviceOutInfo.fromJson(Map<String, dynamic> json) {
    return DeviceOutInfo(
      isapiParams: ISAPIParams.fromJson(json['ISAPIParams']),
      devIndex: json['devIndex'],
      devName: json['devName'],
      protocolType: json['protocolType'],
      status: json['status'],
    );
  }
}

class CreateUpdateDeviceRequest {
  String devIndex;
  String devName;
  int devLocation;

  CreateUpdateDeviceRequest({
    required this.devIndex,
    required this.devName,
    required this.devLocation,
  });

  Map<String, dynamic> toJson() => {
        'DevIndex': devIndex,
        'DevName': devName,
        'DevLocation': devLocation,
      };
}

class ModifyDeviceRequest {
  DeviceModifyInfo deviceInfo;

  ModifyDeviceRequest({required this.deviceInfo});

  Map<String, dynamic> toJson() => {
        'DeviceInfo': deviceInfo.toJson(),
      };
}

class DeviceModifyInfo {
  String devIndex;
  String protocolType;
  String devName;
  ISAPIModifyParams isapiParams;

  DeviceModifyInfo({
    required this.devIndex,
    required this.protocolType,
    required this.devName,
    required this.isapiParams,
  });

  Map<String, dynamic> toJson() => {
        'devIndex': devIndex,
        'protocolType': protocolType,
        'devName': devName,
        'ISAPIParams': isapiParams.toJson(),
      };
}

class ISAPIModifyParams {
  String addressingFormatType;
  String address;
  int portNo;
  String userName;
  String password;

  ISAPIModifyParams({
    required this.addressingFormatType,
    required this.address,
    required this.portNo,
    required this.userName,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        'addressingFormatType': addressingFormatType,
        'address': address,
        'portNo': portNo,
        'userName': userName,
        'password': password,
      };
}

class ModifyDeviceResponse {
  int statusCode;
  String statusString;
  String subStatusCode;

  ModifyDeviceResponse({
    required this.statusCode,
    required this.statusString,
    required this.subStatusCode,
  });

  factory ModifyDeviceResponse.fromJson(Map<String, dynamic> json) {
    return ModifyDeviceResponse(
      statusCode: json['statusCode'],
      statusString: json['statusString'],
      subStatusCode: json['subStatusCode'],
    );
  }
}

class DeleteDeviceRequest {
  List<String> devIndexList;

  DeleteDeviceRequest({required this.devIndexList});

  Map<String, dynamic> toJson() => {
        'DevIndexList': devIndexList,
      };
}

class DeleteDeviceResponse {
  List<DeleteDevResult> delDevList;

  DeleteDeviceResponse({required this.delDevList});

  factory DeleteDeviceResponse.fromJson(Map<String, dynamic> json) =>
      DeleteDeviceResponse(
        delDevList: (json['DelDevList'] as List)
            .map((item) => DeleteDevResult.fromJson(item))
            .toList(),
      );
}

class DeleteDevResult {
  DeleteDevInfo dev;

  DeleteDevResult({required this.dev});

  factory DeleteDevResult.fromJson(Map<String, dynamic> json) =>
      DeleteDevResult(dev: DeleteDevInfo.fromJson(json['Dev']));
}

class DeleteDevInfo {
  String devIndex;
  String status;

  DeleteDevInfo({
    required this.devIndex,
    required this.status,
  });

  factory DeleteDevInfo.fromJson(Map<String, dynamic> json) => DeleteDevInfo(
        devIndex: json['devIndex'],
        status: json['status'],
      );
}
