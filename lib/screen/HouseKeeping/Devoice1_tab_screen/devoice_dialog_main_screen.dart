import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/Devoice1_controller/Devoice1_controller.dart';
import 'package:time_attendance/controller/master_tab_controller/location_controller.dart';
import 'package:time_attendance/model/Devoice1_model/Devoice1_model.dart';
import 'package:time_attendance/widget/reusable/button/form_button.dart';

class DeviceDialog extends StatefulWidget {
  final DeviceController controller;
  final DeviceModel device;

  const DeviceDialog({
    super.key, 
    required this.controller,
    required this.device,
  });

  @override
  State<DeviceDialog> createState() => _DeviceDialogState();
}

class _DeviceDialogState extends State<DeviceDialog> {
  late TextEditingController _nameController;
  late TextEditingController _ipAddressController;
  late TextEditingController _portController;
  late TextEditingController _serialNumberController;
  late TextEditingController _locationCodeController;
  
  String? _selectedIOStatus;
  String? _selectedDeviceType;
  String? _selectedFetchDataVia;
  String? _selectedLocation;
  
  final _formKey = GlobalKey<FormState>();
  final LocationController locationController = Get.find<LocationController>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.device.deviceName);
    _ipAddressController = TextEditingController(text: widget.device.ipAddress);
    _portController = TextEditingController(text: widget.device.port);
    _serialNumberController = TextEditingController(text: widget.device.serialNumber);
    _locationCodeController = TextEditingController(text: widget.device.locationCode);
    
    _selectedIOStatus = widget.device.ioStatus.isNotEmpty 
        ? widget.device.ioStatus 
        : 'InOut';
    _selectedDeviceType = widget.device.deviceType.isNotEmpty 
        ? widget.device.deviceType 
        : 'ZKColor';
    _selectedFetchDataVia = widget.device.fetchDataVia.isNotEmpty 
        ? widget.device.fetchDataVia 
        : 'LAN';
    _selectedLocation = widget.device.location.isNotEmpty 
        ? widget.device.location 
        : 'Pune';

    _initializeLocationController();
  }

  Future<void> _initializeLocationController() async {
    await locationController.initializeAuthLocation();
    await locationController.fetchLocation();
    setState(() {});
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ipAddressController.dispose();
    _portController.dispose();
    _serialNumberController.dispose();
    _locationCodeController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedDevice = DeviceModel(
        deviceId: widget.device.deviceId,
        deviceName: _nameController.text.trim(),
        ipAddress: _ipAddressController.text.trim(),
        port: _portController.text.trim(),
        serialNumber: _serialNumberController.text.trim(),
        ioStatus: _selectedIOStatus ?? 'InOut',
        deviceType: _selectedDeviceType ?? 'ZKColor',
        fetchDataVia: _selectedFetchDataVia ?? 'LAN',
        location: _selectedLocation ?? 'Pune',
        locationCode: _locationCodeController.text.trim(),
      );
      
      widget.controller.saveDevice(updatedDevice);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Text(
                  widget.device.deviceId.isEmpty 
                      ? 'Add Device'
                      : 'Edit Device',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black87),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // First row
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: 'Device Name *',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            hintText: 'Enter device name',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter device name';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: TextFormField(
                          controller: _ipAddressController,
                          decoration: InputDecoration(
                            labelText: 'IP Address *',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            hintText: 'Enter IP address',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter IP address';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Second row
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _serialNumberController,
                          decoration: InputDecoration(
                            labelText: 'Serial Number',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            hintText: 'Enter serial number',
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: TextFormField(
                          controller: _portController,
                          decoration: InputDecoration(
                            labelText: 'Port No. *',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            hintText: 'Enter port number',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter port number';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Third row
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedIOStatus,
                          decoration: InputDecoration(
                            labelText: 'IO Status *',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          items: ['InOut', 'In', 'Out'].map((status) {
                            return DropdownMenuItem<String>(
                              value: status,
                              child: Text(status),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedIOStatus = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select IO status';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedFetchDataVia,
                          decoration: InputDecoration(
                            labelText: 'Fetch Data Via *',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          items: ['LAN', 'USB', 'Serial'].map((method) {
                            return DropdownMenuItem<String>(
                              value: method,
                              child: Text(method),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedFetchDataVia = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select fetch data method';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Fourth row
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedDeviceType,
                          decoration: InputDecoration(
                            labelText: 'Device Type *',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          items: ['ZKColor', 'ZKFace', 'Suprema'].map((type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedDeviceType = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select device type';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Obx(() => locationController.isLoading.value
                            ? const Center(child: CircularProgressIndicator())
                            : DropdownButtonFormField<String>(
                                value: _selectedLocation,
                                decoration: InputDecoration(
                                  labelText: 'Location',
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                items: locationController.locations
                                    .map((location) => DropdownMenuItem<String>(
                                          value: location.locationName,
                                          child: Text(location.locationName ?? 'Unnamed Location'),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedLocation = value;
                                    // Update location code based on selected location
                                    final selectedLoc = locationController.locations
                                        .firstWhere((loc) => loc.locationName == value);
                                    _locationCodeController.text = selectedLoc.locationCode ?? '';
                                  });
                                },
                              )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  // Fifth row
                  TextFormField(
                    controller: _locationCodeController,
                    decoration: InputDecoration(
                      labelText: 'Location Code',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      hintText: 'Enter location code',
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  CustomButtons(
                    onSavePressed: _handleSave,
                    onCancelPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}