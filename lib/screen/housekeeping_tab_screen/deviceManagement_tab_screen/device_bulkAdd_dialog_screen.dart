import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb; // Added for kIsWeb
// Conditional import for dart:html if needed, or rely on tree-shaking
// For simplicity here, a direct import is used, Flutter's build usually handles it.
import 'dart:html' as html; // Added for web download
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:csv/csv.dart';
import 'package:time_attendance/controller/device_management_controller/device_management_controller.dart';
import 'package:time_attendance/model/device_management_model/device_management_model.dart';
import 'dart:typed_data';
import 'package:time_attendance/widgets/mtaToast.dart'; // Added for Uint8List

class BulkAddDeviceDialog extends StatefulWidget {
  const BulkAddDeviceDialog({Key? key, required this.controller}) : super(key: key);
  final DeviceManagementController controller;

  @override
  State<BulkAddDeviceDialog> createState() => _BulkAddDeviceDialogState();
}

class _BulkAddDeviceDialogState extends State<BulkAddDeviceDialog> {
  List<Map<String, String>> devices = []; // Restored devices variable
  int? selectedLocation; // Changed to int? to match locationCode
  String password = '';
  String username = 'admin';
  bool isLoading = false; // Used for CSV parsing
  String? errorMsg;

  final ScrollController _scrollController = ScrollController();
  bool showPassword = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _pickAndParseCSV() async {
    setState(() {
      isLoading = true;
      errorMsg = null;
    });
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );
      if (result != null) {
        String csvString;
        if (result.files.single.bytes != null) {
          // For web and all platforms that provide bytes
          csvString = utf8.decode(result.files.single.bytes!);
        } else if (result.files.single.path != null) {
          // For mobile/desktop if path is provided
          final file = File(result.files.single.path!);
          csvString = await file.readAsString();
        } else {
          throw Exception('No file data found');
        }
        List<List<dynamic>> csvTable = const CsvToListConverter().convert(csvString, eol: '\n');
        if (csvTable.isNotEmpty) {
          // Remove empty rows
          csvTable = csvTable.where((row) => row.any((cell) => cell.toString().trim().isNotEmpty)).toList();
          // Remove the second row if it is all zeros (template row)
          if (csvTable.length > 1 && csvTable[1].every((cell) => cell.toString().trim() == '0')) {
            csvTable.removeAt(1);
          }
          final headers = csvTable.first.map((e) => e.toString().trim()).toList();
          // Check for required columns
          const requiredColumns = ['Name', 'IP Address', 'Port No.'];
          final missingColumns = requiredColumns.where((col) => !headers.contains(col)).toList();
          print('missingColumns: $missingColumns');
          print('headers: $headers');
          print('requiredColumns: $requiredColumns');
          if (missingColumns.isNotEmpty) {
            setState(() {
              errorMsg = 'Missing required columns: ' + missingColumns.join(', ');
              devices = [];
            });
            // Ensure isLoading is reset before returning
            setState(() => isLoading = false);
            return;
          }
          final List<Map<String, String>> parsedDevices = [];
          for (int i = 1; i < csvTable.length; i++) {
            final row = csvTable[i];
            if (row.length != headers.length) continue;
            // Skip rows that are all empty
            if (row.every((cell) => cell.toString().trim().isEmpty)) continue;
            final device = <String, String>{};
            for (int j = 0; j < headers.length; j++) {
              device[headers[j]] = row[j].toString();
            }
            parsedDevices.add(device);
          }
          setState(() {
            devices = parsedDevices;
          });
        }
      }
    } catch (e) {
      setState(() {
        errorMsg = 'Failed to parse CSV: ${e.toString()}';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _downloadTemplate() async {
    const String csvHeaders = 'Name,IP Address,Port No.';
    const String exampleRow = '0,0,0'; // Template row that gets removed by parser
    final String csvContent = '$csvHeaders\n$exampleRow\n';
    final Uint8List bytes = utf8.encode(csvContent);
    const String fileName = 'device_template.csv';

    try {
      if (kIsWeb) {
        // Web implementation
        final blob = html.Blob([bytes], 'text/csv;charset=utf-8;');
        final url = html.Url.createObjectUrlFromBlob(blob);
        html.AnchorElement(href: url)
          ..setAttribute("download", fileName)
          ..click();
        html.Url.revokeObjectUrl(url);
        if (mounted) {
          MTAToast().ShowToast('Template downloaded: device_template.csv');
        }
      } else {
        // Mobile/Desktop implementation
        String? outputPath = await FilePicker.platform.saveFile(
          dialogTitle: 'Save CSV Template',
          fileName: fileName,
          type: FileType.custom,
          allowedExtensions: ['csv'],
        );

        if (outputPath != null) {
          // If user picked a path (didn't cancel)
          final file = File(outputPath);
          await file.writeAsBytes(bytes);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Template saved to: $outputPath')),
            );
          }
        } else {
          // User canceled the picker
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Save template cancelled.')),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error downloading template: ${e.toString()}')),
        );
      }
    }
  }

  void _handleAdd() async {
    if (devices.isEmpty || selectedLocation == null || password.isEmpty) return;
    setState(() => isLoading = true);
    try {
      // Build a single AddDeviceRequest with a list of DeviceIn (devInlist)
      final List<DeviceIn> devInlist = devices.map((device) {
        return DeviceIn(
          device: DeviceInfo(
            protocolType: 'ISAPI',
            devName: device['Name']?.trim() ?? '',
            devType: 'AccessControl',
            isapiParams: ISAPIParamsRequest(
              addressingFormatType: 'IPV4Address',
              address: device['IP Address']?.trim() ?? '',
              portNo: int.tryParse(device['Port No.']?.trim() ?? '0') ?? 0,
              userName: username.trim(),
              password: password.trim(),
            ),
          ),
        );
      }).toList();
      final AddDeviceRequest requests = 
        AddDeviceRequest(deviceInList: devInlist);
      final isSuccess = await widget.controller.addDevice(requests, selectedLocation ?? 0);
      if (mounted) {
        Navigator.of(context).pop();
        MTAToast().ShowToast(
          isSuccess ? 'Devices added successfully!' : 'Failed to add devices.',
        );
      }
    } catch (e) {
      if (mounted) {
        MTAToast().ShowToast('Error: ${e.toString()}');
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Bulk Add Devices'),
      content: SizedBox(
        width: 400, // Consider making this responsive or larger if needed
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 600, // Set a max height for the dialog content
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: isLoading ? null : _pickAndParseCSV,
                        icon: const Icon(Icons.upload_file),
                        label: const Text('Upload CSV'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: isLoading ? null : _downloadTemplate, // Also disable if CSV is loading
                        icon: const Icon(Icons.download),
                        label: const Text('Template'), // Shorter label for smaller button
                      ),
                    ),
                  ],
                ),
                if (isLoading) ...[
                  const SizedBox(height: 8),
                  const LinearProgressIndicator(),
                ],
                if (errorMsg != null) ...[
                  const SizedBox(height: 8),
                  Text(errorMsg!, style: const TextStyle(color: Colors.red)),
                ],
                const SizedBox(height: 16),
                const Text('Preview Devices:'),
                const SizedBox(height: 4),
                Text(
                  'Uploaded: ${devices.length} device${devices.length == 1 ? '' : 's'}',
                  style: const TextStyle(fontSize: 13, color: Colors.blueGrey),
                ),
                const SizedBox(height: 8),
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: devices.isEmpty
                      ? const Center(child: Text('No devices uploaded.'))
                      : Scrollbar(
                          controller: _scrollController,
                          thumbVisibility: true,
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: devices.length,
                            itemBuilder: (context, index) {
                              final device = devices[index];
                              return ListTile(
                                dense: true,
                                leading: const Icon(Icons.devices),
                                title: Text(
                                  '${device['Name'] ?? '-'} · ${device['IP Address'] ?? '-'}',
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                                subtitle: Text('Type: ${device['Device Type'] ?? '-'}, Port: ${device['Port No.'] ?? '-'}'),
                              );
                            },
                          ),
                        ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  value: selectedLocation,
                  items: widget.controller.locations.map((location) {
                    return DropdownMenuItem<int>(
                      value: location.locationCode,
                      child: Text(location.locationName),
                    );
                  }).toList(),
                  onChanged: (val) => setState(() => selectedLocation = val),
                  decoration: const InputDecoration(
                    labelText: 'Select Location',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: username,
                  onChanged: (val) => setState(() => username = val),
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  obscureText: !showPassword,
                  onChanged: (val) => setState(() => password = val),
                  initialValue: password, // Keep initialValue if you want it to be pre-filled
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        showPassword ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          showPassword = !showPassword;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: (devices.isNotEmpty && selectedLocation != null && password.isNotEmpty && !isLoading)
              ? _handleAdd
              : null,
          child: const Text('Add'),
        ),
      ],
    );
  }
}