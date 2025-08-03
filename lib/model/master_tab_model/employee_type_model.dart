
class EmployeeTypeModel {
  String employeeTypeId;
  String employeeTypeName;
  bool isDataRetrieved;

  EmployeeTypeModel({
    required this.employeeTypeId,
    required this.employeeTypeName,
    this.isDataRetrieved = false,
   });

  factory EmployeeTypeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeTypeModel(
      employeeTypeId: json['EmployeeTypeID'] ?? '',
      employeeTypeName: json['EmployeeTypeName'] ?? '',
        isDataRetrieved: true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'EmployeeTypeID': employeeTypeId,
      'EmployeeTypeName': employeeTypeName,
    };
  }
}