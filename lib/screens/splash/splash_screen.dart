import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../auth/login_screen.dart';
import '../home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkSession();
    });
  }

  Future<void> _checkSession() async {
    await Future.delayed(
      const Duration(seconds: 1),
    );

    if (!mounted) return;

    final authViewModel = context.read<AuthViewModel>();

    final session =
        Supabase.instance.client.auth.currentSession;

    if (session != null) {
      final profileLoaded =
          await authViewModel.loadProfile();

      if (!mounted) return;

      if (profileLoaded) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const HomeScreen(),
          ),
        );

        return;
      }
    }

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/duory_logo.svg',
              width: 120,
              height: 120,
            ),

            const SizedBox(height: 16),

            Text(
              'Duory',
              style: AppTextStyles.bold20.copyWith(
                color: AppColors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}