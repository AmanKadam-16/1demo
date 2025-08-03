import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/devoice_controller/devoice_controller.dart';
// import 'package:time_attendance/controller/device_controller/device_controller.dart';
import 'package:time_attendance/widget/reusable/button/form_button.dart';

class deviceDialog extends StatelessWidget {
  final deviceController controller = Get.find<deviceController>();

  deviceDialog({Key? key}) : super(key: key) {
    controller.setProtocol('ISUP5.0');
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Obx(() {
        return SizedBox(
          width: MediaQuery.of(context).size.width * 0.3,
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header section (not scrollable)
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
                    const Text(
                      'Add device',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.black87),
                      onPressed: () {
                        controller.clearProtocol();
                        Get.back();
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              // Scrollable content
              Expanded(
                child: Scrollbar(
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Radio buttons for protocol selection
                          Row(
                            children: [
                              Radio<String>(
                                value: 'ISUP5.0',
                                groupValue: controller.selectedProtocol.value,
                                onChanged: (value) {
                                  controller.setProtocol(value!);
                                },
                              ),
                              const Text('ISUP5.0'),
                              const SizedBox(width: 20),
                              Radio<String>(
                                value: 'ISAPI',
                                groupValue: controller.selectedProtocol.value,
                                onChanged: (value) {
                                  controller.setProtocol(value!);
                                },
                              ),
                              const Text('ISAPI'),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Display the form based on the selected protocol
                          _buildForm(controller.selectedProtocol.value),
                          const SizedBox(height: 40),
                          CustomButtons(
                            onSavePressed: () {
                              // Handle save logic here
                              Get.back();
                            },
                            onCancelPressed: () {
                              controller.clearProtocol();
                              Get.back();
                            },
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
      }),
    );
  }

  Widget _buildForm(String protocol) {
    switch (protocol) {
      case 'ISUP5.0':
        return _buildISUP5Form();
      case 'ISAPI':
        return _buildISAPIForm();
      default:
        return _buildISUP5Form(); // Default to ISUP5.0 form
    }
  }

  Widget _buildISUP5Form() {
    return Column(
      children: [
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Device Name *',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Device ID *',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Key *',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildISAPIForm() {
    return Column(
      children: [
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Device Name *',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'IP Address *',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Port *',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'User Name *',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Password *',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}