class deviceModel {
  List<MatchList>? matchList;
  int? numOfMatches;
  int? totalMatches;

  deviceModel({this.matchList, this.numOfMatches, this.totalMatches});

  deviceModel.fromJson(Map<String, dynamic> json) {
    if (json['MatchList'] != null) {
      matchList = <MatchList>[];
      json['MatchList'].forEach((v) {
        matchList!.add(new MatchList.fromJson(v));
      });
    }
    numOfMatches = json['numOfMatches'];
    totalMatches = json['totalMatches'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.matchList != null) {
      data['MatchList'] = this.matchList!.map((v) => v.toJson()).toList();
    }
    data['numOfMatches'] = this.numOfMatches;
    data['totalMatches'] = this.totalMatches;
    return data;
  }
}

class MatchList {
  Device? device;

  MatchList({this.device});

  MatchList.fromJson(Map<String, dynamic> json) {
    device =
        json['Device'] != null ? new Device.fromJson(json['Device']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.device != null) {
      data['Device'] = this.device!.toJson();
    }
    return data;
  }
}

class Device {
  ISAPIParams? iSAPIParams;
  bool? activeStatus;
  String? devIndex;
  String? devMode;
  String? devName;
  String? devStatus;
  String? devType;
  String? devVersion;
  String? protocolType;
  int? videoChannelNum;

  Device(
      {this.iSAPIParams,
      this.activeStatus,
      this.devIndex,
      this.devMode,
      this.devName,
      this.devStatus,
      this.devType,
      this.devVersion,
      this.protocolType,
      this.videoChannelNum});

  Device.fromJson(Map<String, dynamic> json) {
    iSAPIParams = json['ISAPIParams'] != null
        ? new ISAPIParams.fromJson(json['ISAPIParams'])
        : null;
    activeStatus = json['activeStatus'];
    devIndex = json['devIndex'];
    devMode = json['devMode'];
    devName = json['devName'];
    devStatus = json['devStatus'];
    devType = json['devType'];
    devVersion = json['devVersion'];
    protocolType = json['protocolType'];
    videoChannelNum = json['videoChannelNum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.iSAPIParams != null) {
      data['ISAPIParams'] = this.iSAPIParams!.toJson();
    }
    data['activeStatus'] = this.activeStatus;
    data['devIndex'] = this.devIndex;
    data['devMode'] = this.devMode;
    data['devName'] = this.devName;
    data['devStatus'] = this.devStatus;
    data['devType'] = this.devType;
    data['devVersion'] = this.devVersion;
    data['protocolType'] = this.protocolType;
    data['videoChannelNum'] = this.videoChannelNum;
    return data;
  }
}

class ISAPIParams {
  String? address;
  String? addressingFormatType;
  int? portNo;

  ISAPIParams({this.address, this.addressingFormatType, this.portNo});

  ISAPIParams.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    addressingFormatType = json['addressingFormatType'];
    portNo = json['portNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['addressingFormatType'] = this.addressingFormatType;
    data['portNo'] = this.portNo;
    return data;
  }
}
