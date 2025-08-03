import 'package:flutter/material.dart';
import 'package:time_attendance/controller/master_tab_controller/location_controller.dart';
import 'package:time_attendance/model/master_tab_model/location_model.dart';
import 'package:time_attendance/widget/reusable/button/form_button.dart';

class LocationDialog extends StatefulWidget {
  final LocationController controller;
  final Location location;

  const LocationDialog({
    Key? key,
    required this.controller,
    required this.location,
  }) : super(key: key);

  @override
  State<LocationDialog> createState() => _LocationDialogState();
}

class _LocationDialogState extends State<LocationDialog> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _countryController;
  late TextEditingController _postalCodeController;
  late TextEditingController _longitudeController;
  late TextEditingController _latitudeController;
  late TextEditingController _distanceController;
  bool _isUseForGeoFencing = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.location.locationName);
    _addressController =
        TextEditingController(text: widget.location.locationAddress);
    _cityController = TextEditingController(text: widget.location.locationCity);
    _stateController =
        TextEditingController(text: widget.location.locationState);
    _countryController =
        TextEditingController(text: widget.location.locationCountry);
    _postalCodeController =
        TextEditingController(text: widget.location.postalCode);
    _longitudeController = TextEditingController(
        text: widget.location.longitude?.toString() ?? '');
    _latitudeController =
        TextEditingController(text: widget.location.latitude?.toString() ?? '');
    _distanceController =
        TextEditingController(text: widget.location.distance?.toString() ?? '');
    _isUseForGeoFencing = widget.location.isUseForGeoFencing ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _postalCodeController.dispose();
    _longitudeController.dispose();
    _latitudeController.dispose();
    _distanceController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedLocation = Location(
        locationID: widget.location.locationID ?? '',
        locationName: _nameController.text.trim(),
        locationCode: widget.location.locationCode ?? '',
        locationAddress: _addressController.text.trim(),
        locationCity: _cityController.text.trim(),
        locationState: _stateController.text.trim(),
        locationCountry: _countryController.text.trim(),
        postalCode: _postalCodeController.text.trim(),
        isUseForGeoFencing: _isUseForGeoFencing,
        longitude: double.tryParse(_longitudeController.text.trim()) ?? 0.0,
        latitude: double.tryParse(_latitudeController.text.trim()) ?? 0.0,
        distance: double.tryParse(_distanceController.text.trim()) ?? 0.0,
      );

      widget.controller.saveLocation(updatedLocation).then((_) {
        Navigator.of(context).pop();
      }).catchError((error) {
        // Handle error if needed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double dialogWidth = MediaQuery.of(context).size.width < 767
        ? MediaQuery.of(context).size.width * 0.9
        : MediaQuery.of(context).size.width * 0.5;
    double dialogHeight = MediaQuery.of(context).size.width < 767
        ? MediaQuery.of(context).size.height * 0.45
        : MediaQuery.of(context).size.height * 0.67;

    return Container(
      width: dialogWidth,
      height: dialogHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
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
                  widget.location.locationID == null ||
                          widget.location.locationID!.isEmpty
                      ? 'Add Location'
                      : 'Edit Location',
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
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Location Name *',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        validator: (value) => value?.isEmpty ?? true
                            ? 'Please enter Location name'
                            : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          labelText: 'Address *',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        maxLines: 3,
                        validator: (value) => value?.isEmpty ?? true
                            ? 'Please enter Address'
                            : null,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _cityController,
                              decoration: InputDecoration(
                                labelText: 'City',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: TextFormField(
                              controller: _stateController,
                              decoration: InputDecoration(
                                labelText: 'State',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _countryController,
                              decoration: InputDecoration(
                                labelText: 'Country',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: TextFormField(
                              controller: _postalCodeController,
                              decoration: InputDecoration(
                                labelText: 'Postal Code',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Use for Geo Fencing'),
                          Switch(
                            value: _isUseForGeoFencing,
                            onChanged: (bool value) {
                              setState(() {
                                _isUseForGeoFencing = value;
                              });

                              if (value) {
                                widget.controller.handleGeoFencingToggle(
                                  value,
                                  (lat, lng) {
                                    setState(() {
                                      _latitudeController.text = lat.toString();
                                      _longitudeController.text =
                                          lng.toString();
                                    });
                                  },
                                );
                              }
                            },
                          ),
                        ],
                      ),
                      if (_isUseForGeoFencing) ...[
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _longitudeController,
                                decoration: InputDecoration(
                                  labelText: 'Longitude',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) => _isUseForGeoFencing &&
                                        (value?.isEmpty ?? true)
                                    ? 'Please enter Longitude'
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: TextFormField(
                                controller: _latitudeController,
                                decoration: InputDecoration(
                                  labelText: 'Latitude',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) => _isUseForGeoFencing &&
                                        (value?.isEmpty ?? true)
                                    ? 'Please enter Latitude'
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _distanceController,
                          decoration: InputDecoration(
                            labelText: 'Distance (in meters)',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              _isUseForGeoFencing && (value?.isEmpty ?? true)
                                  ? 'Please enter Distance'
                                  : null,
                        ),
                      ],
                      const SizedBox(height: 40),
                      CustomButtons(
                        onSavePressed: _handleSave,
                        onCancelPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
