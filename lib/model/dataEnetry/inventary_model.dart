// inventory_model.dart
class InventoryModel {
  String? inventoryId;
  String? name;
  String? laptop;
  String? laptopCharger;
  String? mobile;
  String? mobileCharger;
  String? idCard;
  String? accessCard;
  String? emailId;
  String? recordUpdateOn;
  String? bySenior;
  String? byUserLogin;

  InventoryModel({
    this.inventoryId,
    this.name,
    this.laptop,
    this.laptopCharger,
    this.mobile,
    this.mobileCharger,
    this.idCard,
    this.accessCard,
    this.emailId,
    this.recordUpdateOn,
    this.bySenior,
    this.byUserLogin,
  });

  InventoryModel copyWith({
    String? inventoryId,
    String? name,
    String? laptop,
    String? laptopCharger,
    String? mobile,
    String? mobileCharger,
    String? idCard,
    String? accessCard,
    String? emailId,
    String? recordUpdateOn,
    String? bySenior,
    String? byUserLogin,
  }) {
    return InventoryModel(
      inventoryId: inventoryId ?? this.inventoryId,
      name: name ?? this.name,
      laptop: laptop ?? this.laptop,
      laptopCharger: laptopCharger ?? this.laptopCharger,
      mobile: mobile ?? this.mobile,
      mobileCharger: mobileCharger ?? this.mobileCharger,
      idCard: idCard ?? this.idCard,
      accessCard: accessCard ?? this.accessCard,
      emailId: emailId ?? this.emailId,
      recordUpdateOn: recordUpdateOn ?? this.recordUpdateOn,
      bySenior: bySenior ?? this.bySenior,
      byUserLogin: byUserLogin ?? this.byUserLogin,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'inventoryId': inventoryId,
      'name': name,
      'laptop': laptop,
      'laptopCharger': laptopCharger,
      'mobile': mobile,
      'mobileCharger': mobileCharger,
      'idCard': idCard,
      'accessCard': accessCard,
      'emailId': emailId,
      'recordUpdateOn': recordUpdateOn,
      'bySenior': bySenior,
      'byUserLogin': byUserLogin,
    };
  }

  factory InventoryModel.fromJson(Map<String, dynamic> json) {
    return InventoryModel(
      inventoryId: json['inventoryId'],
      name: json['name'],
      laptop: json['laptop'],
      laptopCharger: json['laptopCharger'],
      mobile: json['mobile'],
      mobileCharger: json['mobileCharger'],
      idCard: json['idCard'],
      accessCard: json['accessCard'],
      emailId: json['emailId'],
      recordUpdateOn: json['recordUpdateOn'],
      bySenior: json['bySenior'],
      byUserLogin: json['byUserLogin'],
    );
  }
}