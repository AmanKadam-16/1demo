import 'package:flutter/material.dart';
import 'package:time_attendance/model/device_management_model/device_employee_transfer_model.dart';
import 'package:intl/intl.dart';

class EmployeeTransferSummaryDialog extends StatefulWidget {
  final MegaTransferResponse response;

  const EmployeeTransferSummaryDialog({
    Key? key,
    required this.response,
  }) : super(key: key);

  @override
  State<EmployeeTransferSummaryDialog> createState() => _EmployeeTransferSummaryDialogState();
}

class _EmployeeTransferSummaryDialogState extends State<EmployeeTransferSummaryDialog> {
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _formatDateTime(String dateTimeStr) {
    final dateTime = DateTime.parse(dateTimeStr);
    return DateFormat('MMM dd, yyyy HH:mm:ss').format(dateTime);
  }

  List<ProcessedEmployeeResult> get _filteredEmployees {
    if (_searchQuery.isEmpty) return widget.response.processedEmployees;
    
    return widget.response.processedEmployees.where((employee) {
      return employee.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             employee.employeeNo.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search by employee name or ID',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transfer Summary',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 16),
        _buildInfoRow('Start Time:', _formatDateTime(widget.response.startTime)),
        _buildInfoRow('End Time:', _formatDateTime(widget.response.endTime)),
        _buildInfoRow('Total Processing Time:', widget.response.totalProcessingTime),
        Divider(height: 24),
        _buildInfoRow('Total Employees:', widget.response.totalEmployees.toString()),
        _buildInfoRow('Successful Transfers:', widget.response.successfulEmployees.toString()),
        _buildInfoRow('Target Devices:', widget.response.totalTargetDevices.toString()),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 8),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildEmployeesList() {
    final filteredList = _filteredEmployees;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Processed Employees',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8),
            if (_searchQuery.isNotEmpty)
              Text(
                '(${filteredList.length} found)',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
          ],
        ),
        SizedBox(height: 8),
        _buildSearchBar(),
        SizedBox(height: 8),
        if (filteredList.isEmpty && _searchQuery.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'No employees found matching "${_searchQuery}"',
                style: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          )
        else
          Container(
            constraints: BoxConstraints(maxHeight: 300),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final employee = filteredList[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 4),
                  child: ExpansionTile(
                    title: Row(
                      children: [
                        Icon(
                          employee.overallSuccess ? Icons.check_circle : Icons.error,
                          color: employee.overallSuccess ? Colors.green : Colors.red,
                        ),
                        SizedBox(width: 8),
                        Text('${employee.name} (${employee.employeeNo})'),
                      ],
                    ),
                    children: employee.targetDeviceResults.map((device) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Device: ${device.deviceId}'),
                            ...device.steps.map((step) => Padding(
                              padding: const EdgeInsets.only(left: 16, top: 4),
                              child: Row(
                                children: [
                                  Icon(
                                    step.success ? Icons.check_circle_outline : 
                                    (step.alreadyExists ? Icons.info : Icons.error_outline),
                                    size: 16,
                                    color: step.success ? Colors.green : 
                                    (step.alreadyExists ? Colors.blue : Colors.red),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      '${step.stepName}: ${step.alreadyExists ? "Already Exists" : 
                                      (step.success ? "Success" : step.errorMessage ?? "Failed")}',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            )).toList(),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildErrorSection() {
    if (widget.response.errors.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Errors',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        SizedBox(height: 8),
        ...widget.response.errors.map((error) => Text(
          '• $error',
          style: TextStyle(color: Colors.red),
        )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: EdgeInsets.all(24),
            constraints: BoxConstraints(maxWidth: 600),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderSection(),
                SizedBox(height: 24),
                _buildEmployeesList(),
                SizedBox(height: 16),
                _buildErrorSection(),
              ],
            ),
          ),
          Positioned(
            right: 8,
            top: 8,
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
