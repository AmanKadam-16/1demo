class Employee {
  final EmployeeProfessional employeeProfessional;
  final EmployeePersonal employeePersonal;

  Employee({
    required this.employeeProfessional,
    required this.employeePersonal,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      employeeProfessional: EmployeeProfessional.fromJson(json['EmployeeProfessional']),
      employeePersonal: EmployeePersonal.fromJson(json['EmployeePersonal']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'EmployeeProfessional': employeeProfessional.toJson(),
      'EmployeePersonal': employeePersonal.toJson(),
    };
  }
}

class EmployeeProfessional {
  final String enrollID;
  final String employeeID;
  final String employeeName;
  final String companyID;
  final String departmentID;
  final String designationID;
  final String locationID;
  final String employeeTypeID;
  final String employeeType;
  final int empStatus;
  final String dateOfEmployment;
  final String? dateOfLeaving;
  final String seniorEmployeeID;
  final String emailID;

  EmployeeProfessional({
    required this.enrollID,
    required this.employeeID,
    required this.employeeName,
    required this.companyID,
    required this.departmentID,
    required this.designationID,
    required this.locationID,
    required this.employeeTypeID,
    required this.employeeType,
    required this.empStatus,
    required this.dateOfEmployment,
    this.dateOfLeaving,
    required this.seniorEmployeeID,
    required this.emailID,
  });

  factory EmployeeProfessional.fromJson(Map<String, dynamic> json) {
    return EmployeeProfessional(
      enrollID: json['EnrollID'],
      employeeID: json['EmployeeID'],
      employeeName: json['EmployeeName'],
      companyID: json['CompanyID'],
      departmentID: json['DepartmentID'],
      designationID: json['DesignationID'],
      locationID: json['LocationID'],
      employeeTypeID: json['EmployeeTypeID'],
      employeeType: json['EmployeeType'],
      empStatus: json['EmpStatus'],
      dateOfEmployment: json['DateOfEmployment'],
      dateOfLeaving: json['DateOfLeaving'],
      seniorEmployeeID: json['SeniorEmployeeID'],
      emailID: json['EmailID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'EnrollID': enrollID,
      'EmployeeID': employeeID,
      'EmployeeName': employeeName,
      'CompanyID': companyID,
      'DepartmentID': departmentID,
      'DesignationID': designationID,
      'LocationID': locationID,
      'EmployeeTypeID': employeeTypeID,
      'EmployeeType': employeeType,
      'EmpStatus': empStatus,
      'DateOfEmployment': dateOfEmployment,
      'DateOfLeaving': dateOfLeaving,
      'SeniorEmployeeID': seniorEmployeeID,
      'EmailID': emailID,
    };
  }
}

class EmployeePersonal {
  final String employeeID;
  final String employeeName;
  final String localAddress;
  final String permanentAddress;
  final String gender;
  final String dateOfBirth;
  final String contactNo;
  final String mobileNumber;
  final String nationality;
  final String emailID;
  final String bloodGroup;

  EmployeePersonal({
    required this.employeeID,
    required this.employeeName,
    required this.localAddress,
    required this.permanentAddress,
    required this.gender,
    required this.dateOfBirth,
    required this.contactNo,
    required this.mobileNumber,
    required this.nationality,
    required this.emailID,
    required this.bloodGroup,
  });

  factory EmployeePersonal.fromJson(Map<String, dynamic> json) {
    return EmployeePersonal(
      employeeID: json['EmployeeID'],
      employeeName: json['EmployeeName'],
      localAddress: json['LocalAddress'],
      permanentAddress: json['PermanentAddress'],
      gender: json['Gender'],
      dateOfBirth: json['DateOfBirth'],
      contactNo: json['ContactNo'],
      mobileNumber: json['MobileNumber'],
      nationality: json['Nationality'],
      emailID: json['EmailID'],
      bloodGroup: json['BloodGroup'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'EmployeeID': employeeID,
      'EmployeeName': employeeName,
      'LocalAddress': localAddress,
      'PermanentAddress': permanentAddress,
      'Gender': gender,
      'DateOfBirth': dateOfBirth,
      'ContactNo': contactNo,
      'MobileNumber': mobileNumber,
      'Nationality': nationality,
      'EmailID': emailID,
      'BloodGroup': bloodGroup,
    };
  }
}
