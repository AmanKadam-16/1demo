class EmployeeModel {
  final String id;
  final String enrollId;
  final String name;
  final String company;
  final String department;
  final String designation;
  final String branch;
  final String employeeType;
  final String status;
  final String? shift;

  EmployeeModel({
    required this.id,
    required this.enrollId,
    required this.name,
    required this.company,
    required this.department,
    required this.designation,
    required this.branch,
    required this.employeeType,
    required this.status,
    required this.shift,
  });
}
