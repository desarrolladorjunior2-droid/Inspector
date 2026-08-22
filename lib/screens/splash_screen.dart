import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/app_routes.dart';
import '../widgets/app_buttons.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fade,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const Spacer(flex: 3),
                Image.asset(
                  'assets/icon/app_icon.png',
                  width: 160,
                  height: 160,
                ),
                const SizedBox(height: 20),
                const Text(
                  'INSPECTOR',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 6,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Reporta. Documenta. Inspecciona.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    letterSpacing: 1.2,
                  ),
                ),
                const Spacer(flex: 4),
                PrimaryButton(
                  label: 'INICIAR SESIÓN',
                  onPressed: () {
                    Navigator.of(context)
                        .push(AppRoutes.slide(const LoginScreen()));
                  },
                ),
                const SizedBox(height: 14),
                OutlineActionButton(
                  label: 'REGISTRARSE',
                  onPressed: () {
                    Navigator.of(context)
                        .push(AppRoutes.slide(const RegisterScreen()));
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
