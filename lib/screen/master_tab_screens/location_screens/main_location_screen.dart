import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/master_tab_controller/location_controller.dart';
import 'package:time_attendance/model/master_tab_model/location_model.dart';
import 'package:time_attendance/screen/master_tab_screens/location_screens/geo_fence_form.dart';
import 'package:time_attendance/screen/master_tab_screens/location_screens/location_dialog_screen.dart';
import 'package:time_attendance/services/master_excel_report.dart';
import 'package:time_attendance/services/master_pdf_report.dart';
import 'package:time_attendance/widget/reusable/alert/export_alert.dart';
import 'package:time_attendance/widget/reusable/button/custom_action_button.dart';
import 'package:time_attendance/widget/reusable/list/reusable_list.dart';
import 'package:time_attendance/widget/reusable/pagination/pagination_widget.dart';
import 'package:time_attendance/widget/reusable/search/reusable_search_field.dart';
import 'package:time_attendance/widget/reusable/tooltip/help_tooltip_button.dart';

class MainLocationScreen extends StatelessWidget {
  MainLocationScreen({Key? key}) : super(key: key);

  final controller = Get.put(LocationController());
  final TextEditingController _searchController = TextEditingController();
  final RxInt _currentPage = 1.obs;
  final RxInt _itemsPerPage = 10.obs;
  final RxInt _totalPages = 1.obs;

  void _handlePageChange(int page) {
    _currentPage.value = page;
    print('Page changed to: $page');
  }

  void _handleItemsPerPageChange(int value) {
    _itemsPerPage.value = value;
    _currentPage.value = 1;
    _calculateTotalPages();
    print('Items per page changed to: $value');
  }

  void _calculateTotalPages() {
    _totalPages.value =
        (controller.filteredLocations.length / _itemsPerPage.value).ceil();
    print('Total pages calculated: ${_totalPages.value}');
  }

  void _showGeoFenceDialog(BuildContext context, Location location) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: GeoFenceForm(
              locationData: location,
              location: location,
            ),
          ),
        );
      },
    );
  }

  List<Location> _getPaginatedData() {
    final startIndex = (_currentPage.value - 1) * _itemsPerPage.value;
    final endIndex = startIndex + _itemsPerPage.value;
    if (startIndex >= controller.filteredLocations.length) {
      return [];
    }
    return controller.filteredLocations.sublist(
      startIndex,
      endIndex > controller.filteredLocations.length
          ? controller.filteredLocations.length
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
                await GenericPdfGeneratorService.generateSimplePdf<Location>(
                  data: controller.filteredLocations,
                  headers: ['Name', 'Address', 'City', 'State', 'Country'],
                  rowBuilder: (location) => [
                    location.locationName ?? '',
                    location.locationAddress ?? '',
                    location.locationCity ?? '',
                    location.locationState ?? '',
                    location.locationCountry ?? '',
                  ],
                  reportTitle: 'Location',
                );
              } else if (fileType == 'Excel') {
                await GenericExcelGeneratorService.generateExcel<Location>(
                  data: controller.filteredLocations,
                  reportTitle: 'Location Report',
                  headers: ['Name', 'Address', 'City', 'State', 'Country'],
                     rowBuilder: (location) => [
                    location.locationName ?? '',
                    location.locationAddress ?? '',
                    location.locationCity ?? '',
                    location.locationState ?? '',
                    location.locationCountry ?? '',
                  ],
                );
              }
            } catch (e) {
              // Show an error message if something goes wrong
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to generate report: $e')),
              );
              print(e);
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    controller.initializeAuthLocation();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.width > 600 ? 70 : 140),
        child: AppBar(
          title: const Text('Location'),
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
                    onSearchChanged: (value) {
                      controller.updateSearchQuery(value);
                    },
                  ),
                ),
            ],
          ),
          actions: [
            if (MediaQuery.of(context).size.width > 600)
              ReusableSearchField(
                searchController: _searchController,
                onSearchChanged: (value) {
                  controller.updateSearchQuery(value);
                },
              ),
            const SizedBox(width: 20),
            CustomActionButton(
              label: 'Add Location',
              onPressed: () {
                print('Add Location button pressed');
                showLocationDialog(context, Location());
              },
            ),
            CustomActionButton(
              label: 'Export',
              onPressed: () => _showExportDialog(context),
              icon: Icons.download,
            ),
            const SizedBox(width: 8),
            HelpTooltipButton(
              tooltipMessage:
                  'Manage locations, addresses, and geofencing settings. Add, edit, or search locations using the controls above.',
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              _calculateTotalPages();
              final paginatedData = _getPaginatedData();

              final List<Map<String, String>> tableData =
                  paginatedData.map((location) {
                return {
                  'Location Name': location.locationName?.isEmpty == true
                      ? 'N/A'
                      : location.locationName ?? 'N/A',
                  'Address': location.locationAddress?.isEmpty == true
                      ? 'N/A'
                      : location.locationAddress ?? 'N/A',
                  'City': location.locationCity?.isEmpty == true
                      ? 'N/A'
                      : location.locationCity ?? 'N/A',
                  'State': location.locationState?.isEmpty == true
                      ? 'N/A'
                      : location.locationState ?? 'N/A',
                  'GeoFence':
                      location.isUseForGeoFencing == true ? 'Yes' : 'No',
                  'longitude ': '${location.longitude ?? "N/A"}',
                  'latitude ': '${location.latitude ?? "N/A"}',
                  'Distance': '${location.distance ?? "N/A"} m',
                  'Actions': '',
                };
              }).toList();

              return Column(
                children: [
                  Expanded(
                    child: ReusableTableAndCard(
                      data: tableData,
                      headers: const [
                        'Location Name',
                        'Address',
                        'City',
                        'State',
                        'GeoFence',
                        'Actions'
                      ],
                      onEdit: (row) {
                        final location = paginatedData.firstWhere(
                          (b) => b.locationName == row['Location Name'],
                        );
                        showLocationDialog(context, location);
                      },
                      onDelete: (row) {
                        final location = paginatedData.firstWhere(
                          (b) => b.locationName == row['Location Name'],
                          orElse: () => Location(),
                        );
                        if (location.locationID != null) {
                          _showDeleteConfirmationDialog(context, location);
                        }
                      },
                      onGeoFence: (row) {
                        final location = paginatedData.firstWhere(
                          (b) => b.locationName == row['Location Name'],
                          orElse: () => Location(),
                        );
                        if (location.locationID != null) {
                          _showGeoFenceDialog(context, location);
                        }
                      },
                      onSort: (columnName, ascending) {
                        controller.sortLocations(columnName, ascending);
                      },
                    ),
                  ),
                  Obx(() => PaginationWidget(
                        currentPage: _currentPage.value,
                        totalPages: _totalPages.value,
                        onFirstPage: () => _handlePageChange(1),
                        onPreviousPage: () =>
                            _handlePageChange(_currentPage.value - 1),
                        onNextPage: () =>
                            _handlePageChange(_currentPage.value + 1),
                        onLastPage: () => _handlePageChange(_totalPages.value),
                        onItemsPerPageChange: _handleItemsPerPageChange,
                        itemsPerPage: _itemsPerPage.value,
                        itemsPerPageOptions: const [10, 25, 50, 100],
                        totalItems: controller.filteredLocations.length,
                      )),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  void showLocationDialog(BuildContext context, Location location) {
    print('Opening location dialog for: ${location.locationName}');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: LocationDialog(
            location: location,
            controller: Get.find<LocationController>(),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, Location location) {
    final LocationController controller = Get.find<LocationController>();
    print('Showing delete confirmation for: ${location.locationName}');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content:
              Text('Are you sure you want to delete ${location.locationName}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                print('Delete cancelled for: ${location.locationName}');
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                print('Deleting location: ${location.locationName}');
                await controller.deleteLocation(location.locationID ?? '');
                if (context.mounted) Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
