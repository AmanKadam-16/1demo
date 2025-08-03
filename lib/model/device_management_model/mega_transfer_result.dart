import 'package:time_attendance/model/device_management_model/device_employee_transfer_model.dart';

class MegaTransferResult {
  final bool success;
  final MegaTransferResponse? response;

  MegaTransferResult({
    required this.success,
    this.response,
  });
}
