import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/master_tab_controller/location_controller.dart';
import 'package:time_attendance/model/master_tab_model/location_model.dart';
import 'package:time_attendance/widget/reusable/button/form_button.dart';

class GeoFenceForm extends StatefulWidget {
  final Location locationData;
  final Location location;

  const GeoFenceForm({
    Key? key,
    required this.locationData,
    required this.location,
  }) : super(key: key);

  @override
  State<GeoFenceForm> createState() => _GeoFenceFormState();
}

class _GeoFenceFormState extends State<GeoFenceForm> {
  final LocationController controller = Get.find<LocationController>();
  late TextEditingController longitudeController;
  late TextEditingController latitudeController;
  late TextEditingController distanceController;
  late bool isUseForGeoFencing;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    longitudeController = TextEditingController(
        text: widget.location.longitude?.toString() ?? '');
    latitudeController =
        TextEditingController(text: widget.location.latitude?.toString() ?? '');
    distanceController =
        TextEditingController(text: widget.location.distance?.toString() ?? '');
    isUseForGeoFencing = widget.location.isUseForGeoFencing ?? false;
  }

  @override
  void dispose() {
    longitudeController.dispose();
    latitudeController.dispose();
    distanceController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedLocation = widget.location.copyWith(
        isUseForGeoFencing: isUseForGeoFencing,
        longitude: double.tryParse(longitudeController.text),
        latitude: double.tryParse(latitudeController.text),
        distance: double.tryParse(distanceController.text),
      );
      controller.saveLocation(updatedLocation);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 767;

    return Container(
      width: screenSize.width * 0.31, // 30% of screen width
      height: screenSize.height * 0.45, // Reduced to 40% of screen height for a more compact form
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
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
                  Expanded(
                    child: Text(
                      'Geo Fence Details',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black87),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            // Form Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 16.0 : 24.0,
                    vertical: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Toggle switch
                      Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Use for Geo Fencing'),
                          Switch(
                            value: isUseForGeoFencing,
                            onChanged: (bool value) {
                              setState(() {
                                isUseForGeoFencing = value;
                                if (value) {
                                  controller.handleGeoFencingToggle(
                                    value,
                                    (lat, lng) {
                                      setState(() {
                                        latitudeController.text = lat.toString();
                                        longitudeController.text = lng.toString();
                                      });
                                    },
                                  );
                                } else {
                                  latitudeController.text = '0';
                                  longitudeController.text = '0';
                                }
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Coordinates Section with Wrap
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: isSmallScreen
                                ? (screenSize.width * 0.22)
                                : (screenSize.width * 0.22),
                            child: _buildTextField(
                              controller: longitudeController,
                              label: 'Longitude',
                              keyboardType: TextInputType.number,
                              validator: _validateLongitude,
                              enabled: isUseForGeoFencing,
                            ),
                          ),
                          const SizedBox(width: 4),
                          SizedBox(
                            width: isSmallScreen
                                ? (screenSize.width * 0.22)
                                : (screenSize.width * 0.22),
                            child: _buildTextField(
                              controller: latitudeController,
                              label: 'Latitude',
                              keyboardType: TextInputType.number,
                              validator: _validateLatitude,
                              enabled: isUseForGeoFencing,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Distance field
                      SizedBox(
                        width: isSmallScreen
                            ? (screenSize.width * 0.46)
                            : (screenSize.width * 0.46),
                        child: _buildTextField(
                          controller: distanceController,
                          label: 'Distance',
                          keyboardType: TextInputType.number,
                          suffix: Text(
                            '(in meters)',
                            style:
                                TextStyle(color: Colors.grey[600], fontSize: 14),
                          ),
                          enabled: isUseForGeoFencing,
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Actions (moved inside the form padding, like company dialog)
                      CustomButtons(
                        onSavePressed: _handleSave,
                        onCancelPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    Widget? suffix,
    bool enabled = true,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        suffix: suffix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  String? _validateLatitude(String? value) {
    if (value == null || value.isEmpty) {
      return 'Latitude is required';
    }
    final lat = double.tryParse(value);
    if (lat == null) {
      return 'Latitude must be a number';
    }
    if (lat < -90 || lat > 90) {
      return 'Latitude must be between -90 and 90';
    }
    return null;
  }

  String? _validateLongitude(String? value) {
    if (value == null || value.isEmpty) {
      return 'Longitude is required';
    }
    final lng = double.tryParse(value);
    if (lng == null) {
      return 'Longitude must be a number';
    }
    if (lng < -180 || lng > 180) {
      return 'Longitude must be between -180 and 180';
    }
    return null;
  }
}
