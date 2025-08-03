import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/device_management_controller/device_management_controller.dart';
import 'package:time_attendance/model/device_management_model/device_management_model.dart';
import 'package:time_attendance/widget/reusable/button/form_button.dart';

class DeviceDialog extends StatefulWidget {
  final DeviceManagementController controller;
  final ProcessedDeviceInfo device;
  final String? deviceIndex;

  const DeviceDialog({
    super.key,
    required this.controller,
    required this.device,
    required this.deviceIndex,
  });

  @override
  State<DeviceDialog> createState() => _DeviceDialogState();
}

class _DeviceDialogState extends State<DeviceDialog> {
  late TextEditingController _nameController;
  late TextEditingController _ipAddressController;
  late TextEditingController _portController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _locationController;
  int? _selectedLocation;
  bool _isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.device.name);
    _ipAddressController = TextEditingController(text: widget.device.ipAddress);
    _portController =
        TextEditingController(text: widget.device.port.toString());
    _usernameController = TextEditingController(text: widget.device.username);
    _passwordController = TextEditingController(text: widget.device.password);
    _locationController = TextEditingController();
    _selectedLocation =
        widget.device.location.isNotEmpty ? widget.device.locationCode : null;

    // If in edit mode and location is not present, set to 0 (force reselect)
    if (widget.device.devIndex.isNotEmpty && _selectedLocation != null) {
      final exists = widget.controller.locations
          .any((loc) => loc.locationCode == _selectedLocation);
      if (!exists) {
        _selectedLocation = 0;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ipAddressController.dispose();
    _portController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _handleSave() async {
    if (_formKey.currentState?.validate() ?? false) {
      bool isSuccess = false;
      if (widget.device.devIndex.isEmpty) {
        // Add new device
        final newDevice = AddDeviceRequest(
          deviceInList: [
            DeviceIn(
              device: DeviceInfo(
                protocolType: 'ISAPI',
                devName: _nameController.text.trim(),
                devType: 'AccessControl',
                isapiParams: ISAPIParamsRequest(
                    addressingFormatType: 'IPV4Address',
                    address: _ipAddressController.text.trim(),
                    portNo: int.parse(_portController.text.trim()),
                    userName: _usernameController.text.trim(),
                    password: _passwordController.text.trim()),
              ),
            ),
          ],
        );
        isSuccess = await widget.controller
            .addDevice(newDevice, _selectedLocation ?? 0);
      } else {
        final updatedDevice = ModifyDeviceRequest(
          deviceInfo: DeviceModifyInfo(
            devIndex: widget.device.devIndex,
            protocolType: 'ISAPI',
            devName: _nameController.text.trim(),
            isapiParams: ISAPIModifyParams(
              addressingFormatType: 'IPV4Address',
              address: _ipAddressController.text.trim(),
              portNo: int.parse(_portController.text.trim()),
              userName: _usernameController.text.trim(),
              password: _passwordController.text.trim(),
            ),
          ),
        );
        isSuccess = await widget.controller
            .modifyDevice(updatedDevice, _selectedLocation ?? 0);
      }
      if (isSuccess) {
        Navigator.of(context).pop();
      }
      // Navigator.of(context).pop();
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
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
                  widget.device.devIndex.isEmpty
                      ? 'Add New Device'
                      : 'Edit Device',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Device Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    hintText: 'Enter device name',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter device name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _ipAddressController,
                  decoration: InputDecoration(
                    labelText: 'IP Address',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    hintText: 'Example: 192.168.1.100',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter IP address';
                    }

                    // Check IP address format
                    final ipParts = value.split('.');
                    if (ipParts.length != 4) {
                      return 'Invalid IP address format';
                    }

                    // Check each octet
                    for (final part in ipParts) {
                      final int? octet = int.tryParse(part);
                      if (octet == null || octet < 0 || octet > 255) {
                        return 'Each IP segment must be between 0 and 255';
                      }
                    }

                    // Check for valid characters using RegExp
                    if (!RegExp(r'^(\d{1,3}\.){3}\d{1,3}$').hasMatch(value)) {
                      return 'IP address contains invalid characters';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _portController,
                  decoration: InputDecoration(
                    labelText: 'Port',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    hintText: 'Enter port number (1-65535)',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter port number';
                    }

                    final port = int.tryParse(value);
                    if (port == null) {
                      return 'Please enter a valid port number';
                    }

                    if (port < 1 || port > 65535) {
                      return 'Port must be between 1 and 65535';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    hintText: 'Enter username',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                    hintText: 'Enter password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: _togglePasswordVisibility,
                    ),
                  ),
                  obscureText: !_isPasswordVisible,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Obx(() {
                        final items = [
                          const DropdownMenuItem<int>(
                            value: 0,
                            child: Text('Select location'),
                          ),
                          ...widget.controller.locations.map((location) {
                            return DropdownMenuItem<int>(
                              value: location.locationCode,
                              child: Text(location.locationName),
                            );
                          }).toList(),
                        ];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DropdownButtonFormField<int>(
                              value: _selectedLocation,
                              decoration: InputDecoration(
                                labelText: 'Location',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                hintText: 'Select a location',
                              ),
                              items: items,
                              onChanged: (value) {
                                setState(() {
                                  _selectedLocation = value;
                                });
                              },
                              validator: (value) {
                                if (value == null || value == 0) {
                                  return 'Please select a location';
                                }
                                return null;
                              },
                            ),
                          ],
                        );
                      }),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      child: IconButton(
                        icon: const Icon(Icons.add_circle),
                        onPressed: () {
                          _locationController.clear(); // Clear previous input
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Add Location'),
                              content: TextFormField(
                                controller: _locationController,
                                decoration: InputDecoration(
                                  labelText: 'Location Name',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  hintText: 'Enter location name',
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter location name';
                                  }
                                  return null;
                                },
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    if (_locationController.text
                                        .trim()
                                        .isNotEmpty) {
                                      final success = await widget.controller
                                          .addLocation(
                                              _locationController.text.trim());
                                      if (success && context.mounted) {
                                        Navigator.of(context).pop();
                                      }
                                    }
                                  },
                                  child: const Text('Add'),
                                ),
                              ],
                            ),
                          );
                        },
                        tooltip: 'Add New Location',
                        style: IconButton.styleFrom(
                          foregroundColor: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                CustomButtons(
                  onSavePressed: _handleSave,
                  onCancelPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}