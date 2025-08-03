// designation_model.dart
class DesignationModel {
  String designationId;
  String designationName;
  String masterDesignationId;
  String masterDesignationName;
  bool isDataRetrieved;

  DesignationModel({
    this.designationId = '',
    this.designationName = '',
    this.masterDesignationId = '',
    this.masterDesignationName = '',
    this.isDataRetrieved = false,
  });

  factory DesignationModel.fromJson(Map<String, dynamic> json) {
    return DesignationModel(
      designationId: json['DesignationID'] ?? '',
      designationName: json['DesignationName'] ?? '',
      masterDesignationId: json['MastDesignationID'] ?? '',
      masterDesignationName: json['MastDesignationName'] ?? '',
      isDataRetrieved: true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'DesignationID': designationId,
      'DesignationName': designationName,
      'MastDesignationID': masterDesignationId,
      'MastDesignationName': masterDesignationName,
    };
  }
}