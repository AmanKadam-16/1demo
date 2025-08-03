class EmployeeBiometricSyncRequest {
  final String devIndex;

  EmployeeBiometricSyncRequest({required this.devIndex});

  Map<String, dynamic> toJson() => {
    'DevIndex': devIndex,
  };
}

class ProcessedEmployee {
  final String employeeNo;
  final String name;
  final int cardCount;
  final int fingerprintCount;
  final List<String> cardNumbers;
  final String status;
  final String? error;

  ProcessedEmployee({
    required this.employeeNo,
    required this.name,
    required this.cardCount,
    required this.fingerprintCount,
    required this.cardNumbers,
    required this.status,
    this.error,
  });

  factory ProcessedEmployee.fromJson(Map<String, dynamic> json) {
    return ProcessedEmployee(
      employeeNo: json['EmployeeNo'] as String,
      name: json['Name'] as String,
      cardCount: json['CardCount'] as int,
      fingerprintCount: json['FingerprintCount'] as int,
      cardNumbers: List<String>.from(json['CardNumbers'] ?? []),
      status: json['Status'] as String,
      error: json['Error'] as String?,
    );
  }
}

class EmployeeBiometricSyncResponse {
  final String devIndex;
  final List<ProcessedEmployee> processedEmployees;
  final int totalProcessed;
  final int successfullyAdded;
  final List<String> errors;

  EmployeeBiometricSyncResponse({
    required this.devIndex,
    required this.processedEmployees,
    required this.totalProcessed,
    required this.successfullyAdded,
    required this.errors,
  });

  factory EmployeeBiometricSyncResponse.fromJson(Map<String, dynamic> json) {
    return EmployeeBiometricSyncResponse(
      devIndex: json['DevIndex'] as String,
      processedEmployees: (json['ProcessedEmployees'] as List)
          .map((e) => ProcessedEmployee.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalProcessed: json['TotalProcessed'] as int,
      successfullyAdded: json['SuccessfullyAdded'] as int,
      errors: List<String>.from(json['Errors'] ?? []),
    );
  }
}