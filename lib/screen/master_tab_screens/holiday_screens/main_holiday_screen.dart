import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/master_tab_controller/company_controller.dart';
import 'package:time_attendance/controller/master_tab_controller/holiday_controller.dart';
import 'package:time_attendance/model/master_tab_model/holiday_model.dart';
import 'package:time_attendance/screen/master_tab_screens/holiday_screens/holiday_dailog_screen.dart';
import 'package:time_attendance/services/master_excel_report.dart';
import 'package:time_attendance/services/master_pdf_report.dart';
import 'package:time_attendance/widget/reusable/alert/export_alert.dart';
import 'package:time_attendance/widget/reusable/button/custom_action_button.dart';
import 'package:time_attendance/widget/reusable/list/reusable_list.dart';
import 'package:time_attendance/widget/reusable/pagination/pagination_widget.dart';
import 'package:time_attendance/widget/reusable/tooltip/help_tooltip_button.dart';
import 'package:time_attendance/widget/reusable/search/reusable_search_field.dart';

class MainHolidayScreen extends StatefulWidget {
  MainHolidayScreen({Key? key}) : super(key: key);

  @override
  State<MainHolidayScreen> createState() => _MainHolidayScreenState();
}

class _MainHolidayScreenState extends State<MainHolidayScreen> {
  final HolidaysController controller = Get.put(HolidaysController());
  final BranchController branchController = Get.put(BranchController());
  final TextEditingController _searchController = TextEditingController();
  final RxInt _currentPage = 1.obs;
  final RxInt _itemsPerPage = 10.obs;
  final RxInt _totalPages = 1.obs;
  final RxString _selectedCompanyId = RxString('');
  final RxString _selectedYear = RxString('All Years');

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  Future<void> _initializeControllers() async {
    await branchController.initializeAuthBranch();
    await controller.initializeAuthHoliday();
  }

  String _formatCompanyNames(List<ListOfCompany>? companies) {
    if (companies == null || companies.isEmpty) return 'N/A';
    return companies
        .map((company) => company.companyName ?? '')
        .where((name) => name.isNotEmpty)
        .join('\n');
  }

  List<String> _getAvailableYears() {
    Set<String> years = {'All Years'};
    final currentYear = DateTime.now().year;

    for (var holiday in controller.holiday) {
      if (holiday.holidayYear != null && holiday.holidayYear!.isNotEmpty) {
        years.add(holiday.holidayYear!);
      }
    }

    for (int year = currentYear - 2; year <= currentYear + 2; year++) {
      years.add(year.toString());
    }

    return years.toList()..sort();
  }

  Future<void> _handleSearch() async {
    final String companyId = _selectedCompanyId.value;
    final String year = _selectedYear.value;

    if (companyId.isNotEmpty && year != 'All Years') {
      // Both company and year are selected
      await controller.fetchHolidaysByBranchIDAndYear(companyId, year);
    } else if (companyId.isNotEmpty) {
      // Only company is selected
      await branchController.initializeAuthBranch();
    } else if (year != 'All Years') {
      // Only year is selected
      await controller.fetchHolidaysByYear(year);
    } else {
      // No filters selected
      await controller.fetchHolidays();
    }

    _applyFilters();
  }

  void _clearFilters() {
    _selectedCompanyId.value = '';
    _selectedYear.value = 'All Years';
    _searchController.clear();
    controller.updateSearchQuery('');
    controller.fetchHolidays();
  }

  void _applyFilters() {
    List<HolidayModel> filtered = controller.holiday.toList();

    if (_selectedCompanyId.value.isNotEmpty) {
      filtered = filtered
          .where((holiday) =>
              holiday.listOfCompany?.any(
                  (company) => company.companyID == _selectedCompanyId.value) ??
              false)
          .toList();
    }

    if (_selectedYear.value != 'All Years') {
      filtered = filtered
          .where((holiday) => holiday.holidayYear == _selectedYear.value)
          .toList();
    }

    if (controller.searchQuery.value.isNotEmpty) {
      final query = controller.searchQuery.value.toLowerCase();
      filtered = filtered
          .where((holiday) =>
              (holiday.holidayName?.toLowerCase().contains(query) ?? false) ||
              (holiday.holidayDate?.toLowerCase().contains(query) ?? false) ||
              (holiday.holidayYear?.toLowerCase().contains(query) ?? false))
          .toList();
    }

    controller.filterHolidays.value = filtered;
    _currentPage.value = 1;
    _calculateTotalPages();
  }

  void _calculateTotalPages() {
    _totalPages.value =
        (controller.filterHolidays.length / _itemsPerPage.value).ceil();
  }

  List<HolidayModel> _getPaginatedData() {
    final startIndex = (_currentPage.value - 1) * _itemsPerPage.value;
    final endIndex = startIndex + _itemsPerPage.value;
    if (startIndex >= controller.filterHolidays.length) return [];
    return controller.filterHolidays.sublist(
      startIndex,
      endIndex > controller.filterHolidays.length
          ? controller.filterHolidays.length
          : endIndex,
    );
  }

    void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ExportAlertDialog(
          onExport: (fileType) async {
            try {
              if (fileType == 'PDF') {
                // Call the PDF service
                await GenericPdfGeneratorService.generateSimplePdf<HolidayModel>(
                  data: controller.holiday,
                  headers: ['Name', 'Date', 'Year'],
                  rowBuilder: (holiday) => [
                    holiday.holidayName ?? '',
                    holiday.holidayDate ?? '',
                    holiday.holidayYear ?? '',
                  ],
                  reportTitle: 'Holiday',
                );
              } else if (fileType == 'Excel') {
                await GenericExcelGeneratorService.generateExcel<HolidayModel>(
                  data: controller.holiday,
                  reportTitle: 'Holiday Report',
                  headers: ['Name', 'Date', 'Year'],
                  rowBuilder: (holiday) => [
                    holiday.holidayName ?? '',
                    holiday.holidayDate ?? '',
                    holiday.holidayYear ?? '',
                  ],
                );
              }
            } catch (e) {
              // Show an error message if something goes wrong
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to generate report: $e')),
              );
            }
          },
        );
      },
    );
  }


  Widget _buildCompanyDropdown() {
    return Obx(() => DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: 'Select Company',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          ),
          value: _selectedCompanyId.value.isEmpty ? null : _selectedCompanyId.value,
          items: [
            DropdownMenuItem<String>(
              value: '',
              child: Text('All Companies'),
            ),
            ...branchController.branches.map((branch) {
              return DropdownMenuItem<String>(
                value: branch.branchId,
                child: Text(branch.branchName ?? 'N/A'),
              );
            }).toList(),
          ],
          onChanged: (value) {
            _selectedCompanyId.value = value ?? '';
          },
        ));
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 800) {
            return Row(
              children: [
                Expanded(
                  child: _buildCompanyDropdown(),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Year',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      prefixIcon: const Icon(Icons.calendar_today),
                    ),
                    value: _selectedYear.value,
                    items: _getAvailableYears()
                        .map((year) => DropdownMenuItem(
                              value: year,
                              child: Text(year),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        _selectedYear.value = value;
                      }
                    },
                  ),
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  onPressed: _clearFilters,
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    side: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _handleSearch,
                  icon: const Icon(Icons.search),
                  label: const Text('Search'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildCompanyDropdown(),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Year',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    prefixIcon: const Icon(Icons.calendar_today),
                  ),
                  value: _selectedYear.value,
                  items: _getAvailableYears()
                      .map((year) => DropdownMenuItem(
                            value: year,
                            child: Text(year),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      _selectedYear.value = value;
                    }
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _clearFilters,
                        icon: const Icon(Icons.clear),
                        label: const Text('Clear'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          side: BorderSide(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _handleSearch,
                        icon: const Icon(Icons.search),
                        label: const Text('Search'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.width > 600 ? 70 : 140),
        child: AppBar(
          title: const Text('Holiday'),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black87),
          flexibleSpace: Column(
            children: [
              const SizedBox(height: 60),
              if (MediaQuery.of(context).size.width <= 600)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ReusableSearchField(
                    searchController: _searchController,
                    onSearchChanged: controller.updateSearchQuery,
                  ),
                ),
            ],
          ),
          actions: [
            if (MediaQuery.of(context).size.width > 600)
              ReusableSearchField(
                searchController: _searchController,
                onSearchChanged: controller.updateSearchQuery,
              ),
            const SizedBox(width: 20),
            CustomActionButton(
              label: 'Add Holiday',
              onPressed: () => showHolidayDialog(context, HolidayModel()),
            ),
                    CustomActionButton(
              label: 'Export',
              onPressed: () => _showExportDialog(context),
              icon: Icons.download,
            ),
            const SizedBox(width: 8),
            HelpTooltipButton(
              tooltipMessage: 'Manage holidays in this section.',
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value ||
                  branchController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              _calculateTotalPages();
              final paginatedData = _getPaginatedData();

              return Column(
                children: [
                  _buildFilterBar(),
                  Expanded(
                    child: ReusableTableAndCard(
                      data: List.generate(paginatedData.length, (index) {
                        final holiday = paginatedData[index];
                        return {
                          'Holiday': holiday.holidayName ?? 'N/A',
                          'Holiday Date': holiday.holidayDate ?? 'N/A',
                          'Holiday Year': holiday.holidayYear ?? 'N/A',
                          'Company Name':
                              _formatCompanyNames(holiday.listOfCompany),
                          'Actions': 'Edit/Delete',
                        };
                      }),
                      headers: const [
                        'Holiday',
                        'Holiday Date',
                        'Holiday Year',
                        'Company Name',
                        'Actions'
                      ],
                      visibleColumns: const [
                        'Holiday',
                        'Holiday Date',
                        'Holiday Year',
                        'Company Name',
                        'Actions'
                      ],
                      onEdit: (row) {
                        final holiday = paginatedData.firstWhere(
                          (b) => b.holidayName == row['Holiday'],
                        );
                        showHolidayDialog(context, holiday);
                      },
                      onDelete: (row) {
                        final holiday = paginatedData.firstWhere(
                          (b) => b.holidayName == row['Holiday'],
                          orElse: () => HolidayModel(),
                        );
                        if (holiday.holidayID != null) {
                          _showDeleteConfirmationDialog(context, holiday);
                        }
                      },
                      onSort: (columnName, ascending) {
                        controller.sortHolidays(columnName, ascending);
                      },
                    ),
                  ),
                  PaginationWidget(
                    currentPage: _currentPage.value,
                    totalPages: _totalPages.value,
                    onFirstPage: () => _currentPage.value = 1,
                    onPreviousPage: () => _currentPage.value--,
                    onNextPage: () => _currentPage.value++,
                    onLastPage: () => _currentPage.value = _totalPages.value,
                    onItemsPerPageChange: (value) {
                      _itemsPerPage.value = value;
                      _currentPage.value = 1;
                      _calculateTotalPages();
                    },
                    itemsPerPage: _itemsPerPage.value,
                    itemsPerPageOptions: const [10, 25, 50, 100],
                    totalItems: controller.filterHolidays.length,
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

void _showDeleteConfirmationDialog(BuildContext context, HolidayModel holiday) {
  final HolidaysController controller = Get.find<HolidaysController>();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirm Deletion'),
        content:
            Text('Are you sure you want to delete ${holiday.holidayName}?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await controller.deleteHoliday(holiday.holidayID ?? '');
              if (context.mounted) Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );
}

void showHolidayDialog(BuildContext context, HolidayModel holiday) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: HolidayDialog(
          holidayController: Get.find<HolidaysController>(),
          holiday: holiday,
        ),
      );
    },
  );
}
