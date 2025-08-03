import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_attendance/theme/font.dart';
import 'package:time_attendance/theme/theme.dart';
import 'package:time_attendance/util/router/go_router/router.dart';

/// Entry point of the application
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

/// The root widget of the Time Attendance application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Set preferred orientations
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Create text theme with custom fonts
    final TextTheme textTheme = createTextTheme(
      context, 
      const String.fromEnvironment('PRIMARY_FONT', defaultValue: 'Inter'),
      const String.fromEnvironment('SECONDARY_FONT', defaultValue: 'Roboto'),
    );
    final MaterialTheme theme = MaterialTheme(textTheme);

    return MaterialApp.router(
      title: 'Time Attendance',
      theme: theme.light(),
      // darkTheme: theme.dark(), // Uncomment to enable dark theme
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}