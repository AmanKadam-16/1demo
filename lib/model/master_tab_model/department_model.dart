// department_model.dart
class DepartmentModel {
  String departmentId;
  String departmentName;
  String masterDepartmentId;
  String masterDepartmentName;
  bool isDataRetrieved;

  DepartmentModel({
    this.departmentId = '',
    this.departmentName = '',
    this.masterDepartmentId = '',
    this.masterDepartmentName = '',
    this.isDataRetrieved = false,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    return DepartmentModel(
      departmentId: json['DepartmentID'] ?? '',
      departmentName: json['DepartmentName'] ?? '',
      masterDepartmentId: json['MastDepartmentID'] ?? '',
      masterDepartmentName: json['MastDepartmentName'] ?? '',
      isDataRetrieved: true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'DepartmentID': departmentId,
      'DepartmentName': departmentName,
      'MastDepartmentID': masterDepartmentId,
      'MastDepartmentName': masterDepartmentName,
    };
  }
}