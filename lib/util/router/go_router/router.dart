import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:time_attendance/screen/HouseKeeping/Devoice1_tab_screen/devoice_main_screen.dart';
import 'package:time_attendance/screen/HouseKeeping/download_devoice_tab_screen/main_devoice_download_screen.dart';
import 'package:time_attendance/screen/auth/LoginPage.dart';
import 'package:time_attendance/screen/data_enetry/dataProcess_tab_screen/multi_select_dashboard.dart';
import 'package:time_attendance/screen/data_entry_tab_screen/inventory_screen/main_inventory_screen.dart';
import 'package:time_attendance/screen/data_entry_tab_screen/manual_attendance_screen/main_manualAttendance_screen.dart';
// import 'package:time_attendance/screen/devoice_tab_screen/main_devoice_screen.dart';
import 'package:time_attendance/screen/employee_tab_screen/Employee_practices/emp_file.dart';
import 'package:time_attendance/screen/employee_tab_screen/RegularShift_screen/main_regularShift_screen.dart';
import 'package:time_attendance/screen/employee_tab_screen/employee_settings/main_employee_settings_screen.dart';
import 'package:time_attendance/screen/employee_tab_screen/setting_profile/main_settingprofile_screen.dart';
import 'package:time_attendance/screen/employee_tab_screen/temprorary_shift/main_temporary_shift.dart';
import 'package:time_attendance/screen/employee_tab_screen/temprorary_weeklyOff/main_tempWeeklyOff_screen.dart';
import 'package:time_attendance/screen/home_tab_screens/dashboard_screen.dart';
import 'package:time_attendance/screen/housekeeping_tab_screen/deviceManagement_tab_screen/main_deviceManagement_screen.dart';
import 'package:time_attendance/screen/housekeeping_tab_screen/device_tab_screen/main_device_screen.dart';
import 'package:time_attendance/screen/master_tab_screens/company_screens/main_company_screen.dart';
import 'package:time_attendance/screen/master_tab_screens/department_screens/main_department_screen.dart';
import 'package:time_attendance/screen/master_tab_screens/designation_screens/main_designation_screen.dart';
import 'package:time_attendance/screen/master_tab_screens/employee_type_screen/main_employee_type_screen.dart';
import 'package:time_attendance/screen/master_tab_screens/holiday_screens/main_holiday_screen.dart';
import 'package:time_attendance/screen/master_tab_screens/location_screens/main_location_screen.dart';
import 'package:time_attendance/screen/employee_tab_screen/employee_screen/employee_main_screen.dart';
import 'package:time_attendance/screen/reports/master_report_tab_screen/master_report_main_screen.dart';
import 'package:time_attendance/screen/setting/setting_main_screen.dart';
import 'package:time_attendance/screen/shift_tab_screen/shift_details_screen/main_shift_details_screen.dart';
import 'package:time_attendance/screen/shift_tab_screen/shift_pattern_screen/main_shift_pattern_screen.dart';
import 'package:time_attendance/widget/responsive_scaffold.dart';
import 'package:time_attendance/model/TALogin/session_manager.dart'
    if (dart.library.html) 'package:time_attendance/model/TALogin/session_manager_web.dart'
    if (dart.library.io) 'package:time_attendance/model/TALogin/session_manager_mobile.dart';

final GoRouter router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginPage(),
      redirect: _loginRedirect, // Add redirect logic here
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
      redirect: _loginRedirect, // Add redirect logic here
    ),
    ShellRoute(
      builder: (context, state, child) => ResponsiveScaffold(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const DashboardScreen(),
          redirect: _authGuard, // Protect this route
        ),
        GoRoute(
          path: '/designation',
          builder: (context, state) => MainDesignationScreen(),
          redirect: _authGuard, // Protect this route
        ),
        GoRoute(
          path: '/department',
          builder: (context, state) => MainDepartmentScreen(),
          redirect: _authGuard, // Protect this route
        ),
        GoRoute(
          path: '/company',
          builder: (context, state) => MainCompanyScreen(),
          redirect: _authGuard, // Protect this route
        ),
        // deviceManagement
        GoRoute(
          path: '/deviceManagement',
          builder: (context, state) => MainDeviceManagementScreen(),
          redirect: _authGuard, // Protect this route
        ),
        // /manual-attendance/create
        GoRoute(
          path: '/manual-attendance/create',
          builder: (context, state) => ManualAttendanceCreateScreen(),
          redirect: _authGuard, // Protect this route
        ),
        // /manual-attendance/approve
        GoRoute(
          path: '/manual-attendance/approve',
          builder: (context, state) => ManualAttendanceCreateScreen(),
          redirect: _authGuard, // Protect this route
        ),
        GoRoute(
          path: '/location',
          builder: (context, state) => MainLocationScreen(),
          redirect: _authGuard, // Protect this route
        ),
        GoRoute(
          path: '/holiday',
          builder: (context, state) => MainHolidayScreen(),
          redirect: _authGuard, // Protect this route
        ),
        GoRoute(
          path: '/employeeType',
          builder: (context, state) => MainEmployeeTypeScreen(),
          redirect: _authGuard, // Protect this route
        ),
        GoRoute(
          path: '/shiftdetail',
          builder: (context, state) => MainShiftDetailsScreen(),
          redirect: _authGuard, // Protect this route
        ),
        GoRoute(
          path: '/shiftpattern',
          builder: (context, state) => MainShiftPatternScreen(),

          redirect: _authGuard, // Protect this route
        ),
        GoRoute(
          path: '/employee',
          builder: (context, state) => MainEmployeeScreen(),
          redirect: _authGuard, // Protect this route
        ),
        GoRoute(
          path: '/employeesettings',
          builder: (context, state) => MainEmployeeSettingScreen(),
          redirect: _authGuard, // Protect this route
        ),
        GoRoute(
          path: '/settingprofile',
          builder: (context, state) => MainSettingProfileScreen(),
          redirect: _authGuard, // Protect this route
        ),
        GoRoute(
          path: '/employeefilter',
          builder: (context, state) => EmployeeFilterScreen(),
          redirect: _authGuard, // Protect this route
        ),
        // Temporary Shift
        GoRoute(
          path: '/regularshift',
          builder: (context, state) => MainRegularShiftScreen(),
          redirect: _authGuard, // Protect this route
        ),
        GoRoute(
          path: '/temporaryshift',
          builder: (context, state) => TemporaryShiftScreen(),
          redirect: _authGuard, // Protect this route
        ),
        //temporaryweeklyoff
        GoRoute(
          path: '/temporaryweeklyoff',
          builder: (context, state) => TemporaryWeeklyOffScreen(),
          redirect: _authGuard, // Protect this route
        ),
        GoRoute(
          path: '/deviceMng',
          builder: (context, state) => MainDeviceScreenView(),
          redirect: _authGuard, // Protect this route
        ),
        GoRoute(
          path: '/employeesettingss',
          builder: (context, state) => EmployeeSettingsView(),
          redirect: _authGuard, // Protect this route
        ),
        GoRoute(
          path: '/inventory',
          builder: (context, state) => InventoryScreen(),
          redirect: _authGuard, // Protect this route
        ),
        GoRoute(
          path: '/dataprocess',
          builder: (context, state) => MultiSelectDashboard(),
          redirect: _authGuard, // Protect this route
        ),
        GoRoute(
          path: '/masterreport',
          builder: (context, state) => MasterReportMainScreen(),
          redirect: _authGuard, // Protect this route
        ),
        GoRoute(
          path: '/device',
          builder: (context, state) => MainDeviceScreenView(),
          redirect: _authGuard, // Protect this route
        ),
        GoRoute(
          path: '/downoaddevice',
          builder: (context, state) => DownloadDeviceLogScreen(),
          redirect: _authGuard, // Protect this route
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Navigation error: ${state.error}'),
    ),
  ),
);

// Auth Guard function
Future<String?> _authGuard(BuildContext context, GoRouterState state) async {
  final isLoggedIn = await PlatformSessionManager.isLoggedIn();
  if (!isLoggedIn) {
    return '/login'; // Redirect to login if user is not authenticated
  }
  return null; // Proceed if authenticated
}

// Login Redirect function
Future<String?> _loginRedirect(
    BuildContext context, GoRouterState state) async {
  final isLoggedIn = await PlatformSessionManager.isLoggedIn();
  if (isLoggedIn) {
    return '/home'; // Redirect to home if user is already logged in
  }
  return null; // Proceed to login page if not authenticated
}