// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/master_tab_controller/company_controller.dart';
import 'package:time_attendance/controller/master_tab_controller/holiday_controller.dart';
import 'package:time_attendance/model/master_tab_model/holiday_model.dart';
import 'package:time_attendance/widget/reusable/button/form_button.dart';

class HolidayDialog extends StatefulWidget {
  final HolidaysController holidayController;
  final HolidayModel holiday;

  const HolidayDialog({
    super.key,
    required this.holidayController,
    required this.holiday,
  });

  @override
  State<HolidayDialog> createState() => _HolidayDialogState();
}

class _HolidayDialogState extends State<HolidayDialog> {
  late TextEditingController _nameController;
  late TextEditingController _dateController;
  late TextEditingController _yearController;
  late TextEditingController _searchController;
  final _formKey = GlobalKey<FormState>();
  final BranchController branchController = Get.find<BranchController>();
  List<ListOfCompany> selectedCompanies = [];
  String searchQuery = '';
  bool _dropdownOpen = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.holiday.holidayName);
    _dateController = TextEditingController(text: widget.holiday.holidayDate);
    _yearController = TextEditingController(text: widget.holiday.holidayYear);
    _searchController = TextEditingController();
    selectedCompanies = widget.holiday.listOfCompany ?? [];

    _initializeBranchController();
  }

  Future<void> _initializeBranchController() async {
    await branchController.initializeAuthBranch();
    await branchController.fetchBranches();
    setState(() {});
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _yearController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedHoliday = HolidayModel(
        holidayID: widget.holiday.holidayID,
        holidayName: _nameController.text,
        holidayDate: _dateController.text, // Uncomment this
        holidayYear: _yearController.text, // Uncomment this
        listOfCompany: selectedCompanies,
      );

      widget.holidayController.saveHoliday(updatedHoliday);
      Navigator.of(context).pop();
    }
  }

  List<ListOfCompany> _getFilteredCompanies() {
    final branches = branchController.branches;
    final companies = branches
        .map((branch) => ListOfCompany(
              companyID: branch.branchId,
              companyName: branch.branchName,
              address: branch.address,
              contactNo: branch.contact,
              website: branch.website,
              mastCompanyID: branch.masterBranchId,
              mastCompanyName: branch.masterBranch,
            ))
        .toList();

    if (searchQuery.isEmpty) {
      return companies;
    }

    return companies
        .where((company) =>
            company.companyName
                ?.toLowerCase()
                .contains(searchQuery.toLowerCase()) ??
            false ||
                (company.mastCompanyName != null &&
                    company.mastCompanyName!
                        .toLowerCase()
                        .contains(searchQuery.toLowerCase())))
        .toList();
  }

  Widget _buildCompanyDropdown() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              _dropdownOpen = !_dropdownOpen;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedCompanies.isEmpty
                        ? 'Select Companies'
                        : selectedCompanies
                            .map((company) => company.companyName)
                            .join(', '),
                    style: TextStyle(
                      color: selectedCompanies.isEmpty
                          ? Colors.grey.shade600
                          : Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  _dropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompanySelectionPanel() {
    final filteredCompanies = _getFilteredCompanies();

    return Container(
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.4,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search companies...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Checkbox(
                  value: selectedCompanies.length == filteredCompanies.length,
                  onChanged: (bool? value) {
                    setState(() {
                      if (value ?? false) {
                        selectedCompanies = List.from(filteredCompanies);
                      } else {
                        selectedCompanies.clear();
                      }
                    });
                  },
                ),
                const Text('Select All'),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: Obx(
              () => branchController.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : filteredCompanies.isEmpty
                      ? const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              'No companies found',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredCompanies.length,
                          itemBuilder: (context, index) {
                            final company = filteredCompanies[index];
                            final isSelected = selectedCompanies
                                .any((c) => c.companyID == company.companyID);

                            return Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    if (isSelected) {
                                      selectedCompanies.removeWhere(
                                        (c) => c.companyID == company.companyID,
                                      );
                                    } else {
                                      selectedCompanies.add(company);
                                    }
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        value: isSelected,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            if (value ?? false) {
                                              if (!isSelected) {
                                                selectedCompanies.add(company);
                                              }
                                            } else {
                                              selectedCompanies.removeWhere(
                                                (c) =>
                                                    c.companyID ==
                                                    company.companyID,
                                              );
                                            }
                                          });
                                        },
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              company.companyName ??
                                                  'Unnamed Company',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            if (company.mastCompanyName != null)
                                              Text(
                                                company.mastCompanyName!,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double dialogHeight = MediaQuery.of(context).size.width < 767
        ? MediaQuery.of(context).size.height * 0.45
        : MediaQuery.of(context).size.height * 0.67;
    return Container(
      width: 500,
      height: dialogHeight,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
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
                    widget.holiday.holidayID == null ||
                            widget.holiday.holidayID!.isEmpty
                        ? 'Add Holiday'
                        : 'Edit Holiday',
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
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Holiday *',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                      ),
                      validator: (value) => value?.isEmpty ?? true
                          ? 'Please enter Holiday'
                          : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      enabled: widget.holiday.holidayID == null ||
                          widget.holiday.holidayID!.isEmpty,
                      controller: _dateController,
                      decoration: InputDecoration(
                        labelText: 'Holiday Date *',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (date != null) {
                              // Format as YYYY-MM-DD for consistency with DateTime.parse()
                              _dateController.text =
                                  "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

                              // Also update the year field if you're using it separately
                              _yearController.text = date.year.toString();
                            }
                          },
                        ),
                      ),
                      validator: (value) => value?.isEmpty ?? true
                          ? 'Please enter Holiday date'
                          : null,
                      readOnly: true,
                    ),
                    const SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Companies *',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildCompanyDropdown(),
                        if (_dropdownOpen) _buildCompanySelectionPanel(),
                      ],
                    ),
                    const SizedBox(height: 40),
                    CustomButtons(
                      onSavePressed: _handleSave,
                      onCancelPressed: () => Navigator.of(context).pop(),
                    ),
                    // Theme(
                    //   data: Theme.of(context).copyWith(
                    //     buttonTheme: ButtonThemeData(
                    //       colorScheme: Theme.of(context).colorScheme,
                    //     ),
                    //   ),
                    //   child: CustomButtons(
                    //     onSavePressed: _handleSave,
                    //     onCancelPressed: () => Navigator.of(context).pop(),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
