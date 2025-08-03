import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:time_attendance/model/TALogin/session_manager.dart'
    if (dart.library.html) 'package:time_attendance/model/TALogin/session_manager_web.dart'
    if (dart.library.io) 'package:time_attendance/model/TALogin/session_manager_mobile.dart';

@immutable
class DrawerItem {
  final String path;
  final String label;
  final IconData icon;

  const DrawerItem(this.path, this.label, this.icon);
}

@immutable
class DrawerItemGroup {
  final String label;
  final IconData icon;
  final List<DrawerItem> children;

  const DrawerItemGroup(this.label, this.icon, this.children);
}

class ResponsiveScaffold extends StatelessWidget {
  static const double _kDrawerPadding = 16.0;
  static const double _kMobileBreakpoint = 600.0;
  static const double _kIconSpacing = 8.0;
  static const double _kMenuOffset = 50.0;
  static const double _kHeaderFontSize = 24.0;

  final Widget child;

  const ResponsiveScaffold({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      drawer: _buildDrawer(context),
      body: child,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final bool isMobile =
        MediaQuery.of(context).size.width <= _kMobileBreakpoint;

    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      title: MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go('/home'),
        child: const Text('Time Attendance'),
      ),
      ),
      actions: [
      _buildSettingsButton(context),
      if (!isMobile) _buildNotificationButton(),
      _buildProfileAvatar(),
      const SizedBox(width: _kIconSpacing),
      _buildProfileMenu(context, isMobile),
      ],
    );
  }

  Widget _buildSettingsButton(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.settings),
      tooltip: 'Settings',
      onPressed: () => context.go('/settingprofile'),
    );
  }

  Widget _buildNotificationButton() {
    return IconButton(
      icon: const Icon(Icons.notifications),
      tooltip: 'Notifications',
      onPressed: () {},
    );
  }

  Widget _buildProfileAvatar() {
    return const CircleAvatar(
      backgroundImage: AssetImage('assets/images/user_avatar.png'),
    );
  }

  Widget _buildProfileMenu(BuildContext context, bool isMobile) {
    return PopupMenuButton<String>(
      offset: const Offset(0, _kMenuOffset),
      onSelected: (value) => _handleProfileMenuSelection(context, value),
      itemBuilder: (context) => _buildProfileMenuItems(context, isMobile),
      child: _buildProfileMenuTrigger(),
    );
  }

  void _handleProfileMenuSelection(BuildContext context, String value) {
    switch (value) {
      case 'logout':
        _showLogoutDialog(context);
        break;
      case 'view_profile':
        // Handle view profile
        break;
    }
  }

  List<PopupMenuEntry<String>> _buildProfileMenuItems(
      BuildContext context, bool isMobile) {
    return [
      if (isMobile) ...[
        _buildMenuItem('settings', 'Settings', Icons.settings),
        _buildMenuItem('notifications', 'Notifications', Icons.notifications),
      ],
      _buildMenuItem('view_profile', 'View Profile', Icons.person),
      _buildMenuItem('logout', 'Logout', Icons.logout),
    ];
  }

  PopupMenuItem<String> _buildMenuItem(
      String value, String text, IconData icon) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }

  Widget _buildProfileMenuTrigger() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        children: [
          FutureBuilder<Map<String, dynamic>?>(
            future: PlatformSessionManager.getLoginDetails(),
            builder: (context, snapshot) {
              return Text(snapshot.data?['UserName'] ?? 'User');
            },
          ),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await PlatformSessionManager.clearSession();
              context.go('/login');
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  // Drawer for mobile view
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _buildDrawerHeader(context),
          _buildDrawerItem(context, '/home', 'Home', Icons.home),
          _buildMasterSection(context),
          _buildShiftSection(context),
          _buildEmployeeSection(context),
          _buildDataEntrySection(context),
          _buildHousekeepingSection(context),
          _buildReportsSection(context),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Text(
        'Time Attendance',
        style: TextStyle(
          color: Colors.white,
          fontSize: _kHeaderFontSize,
        ),
      ),
    );
  }

  Widget _buildExpandableSection({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<dynamic> items,
  }) {
    return ExpansionTile(
      leading: Icon(icon),
      title: Text(title),
      shape: Border.all(color: Colors.transparent),
      children: items.map((item) {
        if (item is DrawerItem) {
          return _buildPaddedDrawerItem(context, item);
        } else if (item is DrawerItemGroup) {
          return Padding(
            padding: const EdgeInsets.only(left: _kDrawerPadding),
            child: ExpansionTile(
              leading: Icon(item.icon),
              title: Text(item.label),
              shape: Border.all(color: Colors.transparent),
              children: item.children
                  .map((child) => _buildPaddedDrawerItem(context, child))
                  .toList(),
            ),
          );
        }
        return const SizedBox.shrink();
      }).toList(),
    );
  }

  Widget _buildPaddedDrawerItem(BuildContext context, DrawerItem item) {
    return Padding(
      padding: const EdgeInsets.only(left: _kDrawerPadding),
      child: _buildDrawerItem(context, item.path, item.label, item.icon),
    );
  }

  Widget _buildMasterSection(BuildContext context) {
    return _buildExpandableSection(
      context: context,
      title: 'Master',
      icon: Icons.settings,
      items: [
        DrawerItem('/designation', 'Designation', Icons.badge),
        DrawerItem('/department', 'Department', Icons.business),
        DrawerItem('/company', 'Branch', Icons.business),
        DrawerItem('/location', 'Location', Icons.location_on),
        DrawerItem('/holiday', 'Holiday', Icons.calendar_today),
        DrawerItem('/employeeType', 'Employee Type', Icons.work_history),
      ],
    );
  }

  Widget _buildShiftSection(BuildContext context) {
    return _buildExpandableSection(
      context: context,
      title: 'Shift',
      icon: Icons.punch_clock_rounded,
      items: [
        DrawerItem('/shiftdetail', 'Shift Details', Icons.lock_clock),
        DrawerItem('/shiftpattern', 'Shift Pattern', Icons.lock_clock),
      ],
    );
  }

  Widget _buildEmployeeSection(BuildContext context) {
    return _buildExpandableSection(
      context: context,
      title: 'Employee',
      icon: Icons.people,
      items: [
        DrawerItem('/settingprofile', 'Setting Profiles', Icons.settings),
        DrawerItem('/employeesettings', 'Employee Settings', Icons.manage_accounts),
        DrawerItem('/employee', 'Employee Details', Icons.account_box),
        DrawerItem('/regularshift', 'Assign Shift', Icons.schedule),
        DrawerItem('/temporaryshift', 'Shift Roster', Icons.schedule),
        DrawerItem('/temporaryweeklyoff', 'Temporary Weekly Off', Icons.calendar_today),
        // DrawerItem('/employeefilter', 'Employee Filter', Icons.people),
      ],
    );
  }

  Widget _buildHousekeepingSection(BuildContext context) {
    return _buildExpandableSection(
      context: context,
      title: 'Housekeeping',
      icon: Icons.house,
      items: [
        DrawerItem('/device', 'Device', Icons.laptop),
        DrawerItem('/downoaddevice', 'Download Device', Icons.download),
        DrawerItem('/deviceManagement', 'Device Management', Icons.settings),
      ],
    );
  }

  Widget _buildDataEntrySection(BuildContext context) {
    return _buildExpandableSection(
      context: context,
      title: 'Data Entry',
      icon: Icons.data_usage,
      items: [
        DrawerItem('/inventory', 'Inventory', Icons.track_changes),
        DrawerItem('/dataprocess', 'Data Process', Icons.track_changes),
        DrawerItemGroup(
          'Regularization',
          Icons.edit_calendar,
          [
            DrawerItem('/manual-attendance/create', 'Create', Icons.add_circle),
            DrawerItem('/manual-attendance/approve', 'Approve/Reject', Icons.approval),
          ],
        ),
      ],
    );
  }

  Widget _buildReportsSection(BuildContext context) {
    return _buildExpandableSection(
      context: context,
      title: 'Reports',
      icon: Icons.assignment,
      items: [
        DrawerItem('/masterreport', 'Master Report', Icons.analytics),
      ],
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, String path, String label, IconData icon) {
    final currentPath =
        GoRouter.of(context).routeInformationProvider.value.uri.path;
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      selected: currentPath == path,
      onTap: () {
        Navigator.pop(context);
        context.go(path);
      },
    );
  }
}
