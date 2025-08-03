import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/setting/setting_controller.dart';
import 'package:time_attendance/screen/home_tab_screens/dashboard_screen.dart';
import 'package:time_attendance/widget/reusable/button/form_button.dart';  // Add this import

class EmployeeSettingsView extends GetView<EmployeeSettingsController> {
  const EmployeeSettingsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.offAll(() => const DashboardScreen()),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: constraints.maxWidth > 600 ? 32 : 16,
              vertical: 24,
            ),
            child: Obx(() => Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSection(
                          'Punch Settings',
                          _buildPunchTypeSection(constraints),
                        ),
                        _buildDivider(),
                        _buildSection(
                          'Work Calculation',
                          _buildWorkCalculationSection(constraints),
                        ),
                        _buildDivider(),
                        _buildSection(
                          'Over Time Calculations',
                          _buildOver(constraints),
                        ),
                        _buildDivider(),
                        _buildSection(
                          'Overtime Settings',
                          _buildOvertimeSection(constraints),
                        ),
                        _buildDivider(),
                        _buildSection(
                          'Break Settings',
                          _buildBreaksSection(),
                        ),
                        _buildDivider(),
                        _buildSection(
                          'Treat Weekly Off attendance as:',
                          _buildWeeklyOffSection(),
                        ),
                        _buildDivider(),
                        _buildResponsiveRow(
                          constraints,
                          [
                            Expanded(
                              child: _buildSection(
                                'Holiday Settings',
                                _buildHolidaySection(),
                              ),
                            ),
                            SizedBox(width: constraints.maxWidth > 600 ? 24 : 0),
                            Expanded(
                              child: _buildSection(
                                'Absent Settings',
                                _buildAbsentSection(),
                              ),
                            ),
                          ],
                        ),
                        _buildDivider(),
                        _buildSection(
                          'Number of absent days that are either to be prefixed or postfixed to mark WeeklyOff as "Absent":',
                          _buildPrefix(constraints),
                        ),
                        _buildDivider(),
                        _buildCheak(),
                        _buildDivider(),
                        _buildSection(
                          'Force Punch Out, if "No-Out" occurs(No out log found):',
                          _builPunchNotOut(),
                        ),
                        _buildDivider(),
                        _buildLateComingSection(),
                        _buildDivider(),
                        _buildLast(),
                        _buildDivider(),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: CustomButtons(
                            onSavePressed: () {
                              controller.saveSettings();
                            },
                            onCancelPressed: () {
                              controller.resetSettings();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )),
          );
        },
      ),
    );
  }

  Widget _buildSection(String title, Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotEmpty) ...[
            Text(
              title,
              style: Get.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
          ],
          child,
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Divider(),
    );
  }

  Widget _buildResponsiveRow(BoxConstraints constraints, List<Widget> children) {
    return constraints.maxWidth > 600
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children.map((child) => Expanded(child: child)).toList(),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children.map((child) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: child,
            )).toList(),
          );
  }

  Widget _buildCustomFormField({
    required String label,
    required String initialValue,
    required Function(String) onChanged,
    TextInputType? keyboardType,
    bool readOnly = false,
  }) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 48),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        ),
        keyboardType: keyboardType,
        initialValue: initialValue,
        onChanged: onChanged,
        readOnly: readOnly,
      ),
    );
  }

  Widget _buildCustomCheckbox({
    required String label,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 48),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => onChanged(!value),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                    value: value,
                    onChanged: (newValue) => onChanged(newValue!),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: Get.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPunchTypeSection(BoxConstraints constraints) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            _buildRadioTile('Double (First IN Last OUT)', 'double'),
            _buildRadioTile('Multiple (Even IN Odd OUT)', 'multiple'),
            _buildRadioTile('Single', 'single'),
          ],
        ),
        if (controller.settings.value.punchType == 'single') ...[
          const SizedBox(height: 16),
          SizedBox(
            width: constraints.maxWidth > 600 ? 300 : double.infinity,
            child: _buildCustomFormField(
              label: 'OUT Time* [In 24 Hour Format]',
              initialValue: '12:00 AM',
              onChanged: controller.updateOutTime,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: constraints.maxWidth > 600 ? 300 : double.infinity,
            child: _buildCustomFormField(
              label: 'Late Coming Minutes*',
              initialValue: '120',
              onChanged: controller.updateLateComingMinutes,
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: constraints.maxWidth > 600 ? 300 : double.infinity,
            child: _buildCustomFormField(
              label: 'Early Going Minutes*',
              initialValue: controller.settings.value.earlyGoingMinutes,
              onChanged: controller.updateEarlyGoingMinutes,
              keyboardType: TextInputType.number,
            ),
          ),
        ],
        if (controller.settings.value.punchType == 'double' || controller.settings.value.punchType == 'multiple') ...[
          const SizedBox(height: 16),
          SizedBox(
            width: constraints.maxWidth > 600 ? 300 : double.infinity,
            child: _buildCustomFormField(
              label: 'Late Coming Minutes*',
              initialValue: '120',
              onChanged: controller.updateLateComingMinutes,
              keyboardType: TextInputType.number,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: constraints.maxWidth > 600 ? 300 : double.infinity,
            child: _buildCustomFormField(
              label: 'Early Going Minutes*',
              initialValue: controller.settings.value.earlyGoingMinutes,
              onChanged: controller.updateEarlyGoingMinutes,
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ],
    );
  }
  Widget _buildOver(BoxConstraints constraints) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            _buildRadioTile('After Every Hour including Grace Minutes', 'double'),
            _buildRadioTile('After Every Half An Hour including Grace Minutes', 'multiple'),
            _buildRadioTile('None', 'single'),
          ],
        ),
       
      ],
    );
  }
  Widget _buildPrefix(BoxConstraints constraints) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            _buildRadioTile('Prefix', 'double'),
            _buildRadioTile('Postfix', 'multiple'),
            _buildRadioTile('A-WOFF-A', 'single'),
          ],
        ),
       
      ],
    );
  }
    Widget _buildRadioTile(String label, String value) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 48),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
            color: controller.settings.value.punchType == value
                ? Get.theme.primaryColor
                : Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => controller.updatePunchType(value),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Radio<String>(
                    value: value,
                    groupValue: controller.settings.value.punchType,
                    onChanged: (value) => controller.updatePunchType(value!),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: Get.textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSection(BoxConstraints constraints) {
    return _buildResponsiveRow(
      constraints,
      [
        Expanded(
          child: _buildCustomFormField(
            label: 'Late Coming Minutes',
            initialValue: controller.settings.value.lateComingMinutes,
            onChanged: controller.updateLateComingMinutes,
            keyboardType: TextInputType.number,
          ),
        ),
        SizedBox(width: constraints.maxWidth > 600 ? 16 : 0, height: constraints.maxWidth <= 600 ? 16 : 0),
        Expanded(
          child: _buildCustomFormField(
            label: 'Early Going Minutes',
            initialValue: controller.settings.value.earlyGoingMinutes,
            onChanged: controller.updateEarlyGoingMinutes,
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }

  Widget _buildWorkCalculationSection(BoxConstraints constraints) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            _buildRadioTile('Shift', 'shift'),
            _buildRadioTile('Employee', 'employee'),
          ],
        ),
        const SizedBox(height: 16),
        _buildResponsiveRow(
          constraints,
          [
            Expanded(
              child: _buildCustomFormField(
                label: 'Full Day Minutes',
                initialValue: controller.settings.value.fullDayMins,
                onChanged: controller.updateFullDayMins,
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(width: constraints.maxWidth > 600 ? 16 : 0, height: constraints.maxWidth <= 600 ? 16 : 0),
            Expanded(
              child: _buildCustomFormField(
                label: 'Half Day Minutes',
                initialValue: controller.settings.value.halfDayMins,
                onChanged: controller.updateHalfDayMins,
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOvertimeSection(BoxConstraints constraints) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCustomCheckbox(
          label: 'Is Employee Allowed to do Overtime',
          value: controller.settings.value.isOvertimeAllowed,
          onChanged: controller.toggleOvertimeAllowed,
        ),
        if (controller.settings.value.isOvertimeAllowed) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: constraints.maxWidth > 600 ? 300 : double.infinity,
            child: _buildCustomFormField(
              label: 'OT Grace Minutes',
              initialValue: controller.settings.value.otGraceMins,
              onChanged: controller.updateOtGraceMins,
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBreaksSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCustomCheckbox(
          label: 'Allow Breaks to Employee',
          value: controller.settings.value.allowBreaks,
          onChanged: controller.toggleAllowBreaks,
        ),
        if (controller.settings.value.allowBreaks) ...[
          const SizedBox(height: 16),
          _buildCustomCheckbox(
            label: 'Deduct Break from Full Day',
            value: controller.settings.value.deductBreakFullDay,
            onChanged: controller.toggleDeductBreakFullDay,
          ),
          const SizedBox(height: 8),
          _buildCustomCheckbox(
            label: 'Deduct Break from Half Day',
            value: controller.settings.value.deductBreakHalfDay,
            onChanged: controller.toggleDeductBreakHalfDay,
          ),
        ],
      ],
    );
  }
  Widget _buildCheak() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
      
          const SizedBox(height: 16),
          _buildCustomCheckbox(
            label: 'Calculate Late Coming Minutes and Early Going Minutes, if Employee present on Weekly Off',
            value: controller.settings.value.deductBreakFullDay,
            onChanged: controller.toggleDeductBreakFullDay,
          ),
          const SizedBox(height: 8),
          _buildCustomCheckbox(
            label: 'Is Weekly Off Rotational',
            value: controller.settings.value.deductBreakHalfDay,
            onChanged: controller.toggleDeductBreakHalfDay,
          ),
        ],
      
    );
  }
  Widget _buildLast() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
      
          const SizedBox(height: 16),
          _buildCustomCheckbox(
            label: 'Is Repeat Late Coming Deduction Allowed (After action taken and condition occurs again.)',
            value: controller.settings.value.deductBreakFullDay,
            onChanged: controller.toggleDeductBreakFullDay,
          ),
          
        ],
      
    );
  }
  Widget _buildLateComingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        _buildCustomCheckbox(
          label: 'Consider Late Coming Deduction',
          value: controller.settings.value.deductBreakFullDay,
          onChanged: controller.toggleDeductBreakFullDay,
        ),
        if (controller.settings.value.deductBreakFullDay) ...[
          const SizedBox(height: 16),
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Enter Late Coming Minutes',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          _buildRadioTile(
            'Monthly',
            'monthly',
          ),
          const SizedBox(height: 8),
          _buildRadioTile(
            'Weekly',
            'weekly',
          ),
          const SizedBox(height: 8),
          _buildRadioTile(
            'Daily',
            'daily',
          ),
          const SizedBox(height: 8),
          _buildRadioTile(
            'Yearly',
            'yearly',
          ),        ],
      ],
    );
  }
  Widget _buildWeeklyOffSection() {
     return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            _buildRadioTile('Over Time','ot'),
            _buildRadioTile('Compensatory Off', 'multiple'),
            _buildRadioTile('Present', 'single'),
          ],
        ),
       
      ],
    );
  }
  Widget _builPunchNotOut() {
     return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            _buildRadioTile('Default(Specific Time)','ot'),
            _buildRadioTile('By Shift OutTime', 'multiple'),
            _buildRadioTile('By Adding Half Day minutes in InTime', 'multiple'),
            _buildRadioTile('none', 'single'),
          ],
        ),
       
      ],
    );
  }

  Widget _buildHolidaySection() {
     return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            _buildRadioTile('Leave', 'double'),
            _buildRadioTile('WeeklyOff', 'multiple'),
           
          ],
        ),
       
      ],
    );
  }

  Widget _buildAbsentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            _buildRadioTile('Leave', 'multiple'),
            _buildRadioTile('Holiday', 'single'),
          ],
        ),
       
      ],
    );
  }

 

  Widget _buildSaveButton(BoxConstraints constraints) {
    return Center(
      child: SizedBox(
        width: constraints.maxWidth > 600 ? 300 : double.infinity,
        child: ElevatedButton(
          onPressed: () => controller.saveSettings(),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            backgroundColor: Get.theme.primaryColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.save, size: 20),
              const SizedBox(width: 8),
              Text(
                'Save Settings',
                style: Get.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method for dividers between sections
  Widget _buildSectionDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Divider(
        color: Colors.grey[300],
        thickness: 1,
      ),
    );
  }

  // Helper method for building text labels
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: Get.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  // Helper method for custom dropdown
  Widget _buildCustomDropdown({
    required String label,
    required String value,
    required List<DropdownMenuItem<String>> items,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      value: value,
      items: items,
      onChanged: onChanged,
      icon: const Icon(Icons.arrow_drop_down),
      isExpanded: true,
      style: Get.textTheme.bodyMedium,
    );
  }

  // Helper method for error handling and validation
  void _showErrorDialog(String message) {
    Get.dialog(
      AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Helper method for success message
  void _showSuccessMessage() {
    Get.snackbar(
      'Success',
      'Settings saved successfully',
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      icon: const Icon(Icons.check_circle, color: Colors.white),
    );
  }
}

// Extension for form validation
extension FormValidation on String {
  bool isValidNumber() {
    return int.tryParse(this) != null;
  }

  bool isValidTime() {
    final pattern = RegExp(r'^([01]?[0-9]|2[0-3]):[0-5][0-9]$');
    return pattern.hasMatch(this);
  }
}

// Extension for responsive sizing
extension ResponsiveSize on BuildContext {
  bool get isTablet => MediaQuery.of(this).size.width >= 600;
  bool get isDesktop => MediaQuery.of(this).size.width >= 1200;
  
  double get responsivePadding => isDesktop ? 32 : (isTablet ? 24 : 16);
  double get responsiveSpacing => isDesktop ? 24 : (isTablet ? 16 : 12);
}

// Custom theme extension for consistent styling
extension CustomTheme on ThemeData {
  InputDecorationTheme get customInputDecoration => InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey[50],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey[300]!),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.grey[300]!),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: primaryColor),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.red),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  );
}