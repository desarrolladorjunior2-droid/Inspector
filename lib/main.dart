import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'screens/location_permission_screen.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.asegurarCuentaAdmin();
  runApp(const InspectorApp());
}

class InspectorApp extends StatelessWidget {
  const InspectorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inspector',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      home: const LocationPermissionScreen(),
    );
  }
}
