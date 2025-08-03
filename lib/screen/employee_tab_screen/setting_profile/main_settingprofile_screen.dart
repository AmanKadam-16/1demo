import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_attendance/controller/employee_tab_controller/settingprofile_controller.dart';
import 'package:time_attendance/model/employee_tab_model/settingprofile.dart';
import 'package:time_attendance/screen/employee_tab_screen/setting_profile/add_edit_setting_profile_screen.dart';
import 'package:time_attendance/widget/reusable/button/custom_action_button.dart';

import 'package:time_attendance/widget/reusable/list/reusable_list.dart';
import 'package:time_attendance/widget/reusable/pagination/pagination_widget.dart';
import 'package:time_attendance/widget/reusable/tooltip/help_tooltip_button.dart';
import 'package:time_attendance/widget/reusable/search/reusable_search_field.dart';

class MainSettingProfileScreen extends StatefulWidget {
  const MainSettingProfileScreen({super.key});

  @override
  State<MainSettingProfileScreen> createState() => _MainSettingProfileScreenState();
}

class _MainSettingProfileScreenState extends State<MainSettingProfileScreen> {
  final SettingProfileController controller = Get.put(SettingProfileController());
  final TextEditingController _searchController = TextEditingController();
  int _currentPage = 1;
  int _itemsPerPage = 10;
  late int _totalPages;

  @override
  void initState() {
    super.initState();
    controller.initializeAuthProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting Profiles'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          if (MediaQuery.of(context).size.width > 600)
            ReusableSearchField(
              searchController: _searchController,
              onSearchChanged: controller.updateSearchQuery,
            ),
          const SizedBox(width: 20),
          CustomActionButton(
            label: 'Add Setting Profile',
            onPressed: () => _showSettingProfileDialog(context),
          ),
          const SizedBox(width: 8),
          HelpTooltipButton(
            tooltipMessage: 'Manage setting profiles for employee configurations.',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          if (MediaQuery.of(context).size.width <= 600)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ReusableSearchField(
                searchController: _searchController,
                onSearchChanged: controller.updateSearchQuery,
                responsiveWidth: false,
              ),
            ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final profiles = controller.filteredSettingProfiles;
              _totalPages = (profiles.length / _itemsPerPage).ceil();

              final startIndex = (_currentPage - 1) * _itemsPerPage;
              final endIndex = startIndex + _itemsPerPage;
              final paginatedProfiles = profiles.length > endIndex
                  ? profiles.sublist(startIndex, endIndex)
                  : profiles.sublist(startIndex);

              return Column(
                children: [
                  Expanded(
                    child: ReusableTableAndCard(
                      data: paginatedProfiles.map((profile) => {
                        'Profile Name': profile.profileName,
                        'Description': profile.description,
                        'Default': profile.isDefaultProfile ? 'Yes' : 'No'
                      }).toList(),
                      headers: const [
                        'Profile Name',
                        'Description',
                        'Default',
                        'Actions'
                      ],
                      visibleColumns: const [
                        'Profile Name',
                        'Description',
                        'Default',
                        'Actions'
                      ],
                      onEdit: (row) {
                        final profile = profiles.firstWhere(
                          (p) => p.profileName == row['Profile Name'],
                        );
                        _showSettingProfileDialog(context, profile);
                      },
                      onDelete: (row) {
                        final profile = profiles.firstWhere(
                          (p) => p.profileName == row['Profile Name'],
                        );
                        _showDeleteConfirmationDialog(context, profile);
                      },
                      onSort: (columnName, ascending) =>
                          controller.sortSettingProfiles(columnName, ascending),
                    ),
                  ),
                  PaginationWidget(
                    currentPage: _currentPage,
                    totalPages: _totalPages,
                    onFirstPage: () => _handlePageChange(1),
                    onPreviousPage: () => _handlePageChange(_currentPage - 1),
                    onNextPage: () => _handlePageChange(_currentPage + 1),
                    onLastPage: () => _handlePageChange(_totalPages),
                    onItemsPerPageChange: _handleItemsPerPageChange,
                    itemsPerPage: _itemsPerPage,
                    itemsPerPageOptions: const [10, 25, 50, 100],
                    totalItems: profiles.length,
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
  void _showSettingProfileDialog(BuildContext context,
      [SettingProfileModel? profile]) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditSettingProfileScreen(profile: profile),
      ),
    );
  }
  void _showDeleteConfirmationDialog(
      BuildContext context, SettingProfileModel profile) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text(
              'Are you sure you want to delete the setting profile "${profile.profileName}"?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await controller.deleteSettingProfile(profile.profileId);
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  void _handlePageChange(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _handleItemsPerPageChange(int value) {
    setState(() {
      _itemsPerPage = value;
      _currentPage = 1;
    });
  }
}
