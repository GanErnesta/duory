import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../home/home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  StreamSubscription<AuthState>? _authSubscription;

  bool _obscurePassword = true;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();

    _authSubscription =
        Supabase.instance.client.auth.onAuthStateChange.listen(
      (data) async {
        if (!mounted) return;

        if (data.event == AuthChangeEvent.signedIn) {
          await _handleGoogleSignedIn();
        }
      },
    );
  }

  Future<void> _handleGoogleSignedIn() async {
    if (_isNavigating) return;

    _isNavigating = true;

    try {
      final authViewModel = context.read<AuthViewModel>();

      await authViewModel.loadProfile();

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
        (route) => false,
      );
    } catch (e) {
      _isNavigating = false;

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Gagal memuat profil. Silakan coba lagi.',
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Email dan password wajib diisi.',
          ),
        ),
      );
      return;
    }

    final authViewModel = context.read<AuthViewModel>();

    final success = await authViewModel.login(
      email: email,
      password: password,
    );

    if (!mounted) return;

    if (success) {
      await authViewModel.loadProfile();

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            authViewModel.errorMessage ??
                'Login gagal.',
          ),
        ),
      );
    }
  }

  Future<void> _loginWithGoogle() async {
    final authViewModel = context.read<AuthViewModel>();

    final success =
        await authViewModel.loginWithGoogle();

    if (!mounted) return;

    if (!success &&
        authViewModel.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            authViewModel.errorMessage!,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Spacer(),

              RichText(
                text: TextSpan(
                  style: AppTextStyles.bold30.copyWith(
                    fontSize: 30,
                    height: 1.2,
                  ),
                  children: const [
                    TextSpan(
                      text: 'Selamat ',
                      style: TextStyle(
                        color: AppColors.red,
                      ),
                    ),
                    TextSpan(
                      text: 'Datang',
                      style: TextStyle(
                        color: AppColors.blue,
                      ),
                    ),
                    TextSpan(text: '\n'),
                    TextSpan(
                      text: 'di ',
                      style: TextStyle(
                        color: AppColors.red,
                      ),
                    ),
                    TextSpan(
                      text: 'Duory',
                      style: TextStyle(
                        color: Color(0xFF3B332E),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),

              Text(
                'Email',
                style: AppTextStyles.regular16.copyWith(
                  color: const Color(0xFF3B332E),
                ),
              ),

              const SizedBox(height: 5),

              TextField(
                controller: _emailController,
                keyboardType:
                    TextInputType.emailAddress,
                style: AppTextStyles.regular14.copyWith(
                  color: const Color(0xFF3B332E),
                ),
                decoration: InputDecoration(
                  hintText: 'Masukkan email',
                  hintStyle:
                      AppTextStyles.regular16.copyWith(
                    color: const Color(0xFFB8B8B8),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.red,
                    ),
                  ),
                  enabledBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.red,
                    ),
                  ),
                  focusedBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.red,
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'Password',
                style: AppTextStyles.regular16.copyWith(
                  color: const Color(0xFF3B332E),
                ),
              ),

              const SizedBox(height: 5),

              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: AppTextStyles.regular14.copyWith(
                  color: const Color(0xFF3B332E),
                ),
                decoration: InputDecoration(
                  hintText: 'Masukkan password',
                  hintStyle:
                      AppTextStyles.regular16.copyWith(
                    color: const Color(0xFFB8B8B8),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 16,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons
                              .visibility_off_outlined
                          : Icons
                              .visibility_outlined,
                      color: AppColors.blueDark,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword =
                            !_obscurePassword;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.red,
                    ),
                  ),
                  enabledBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.red,
                    ),
                  ),
                  focusedBorder:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.red,
                      width: 1.5,
                    ),
                  ),
                ),
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding:
                        const EdgeInsets.only(top: 4),
                    minimumSize: Size.zero,
                    tapTargetSize:
                        MaterialTapTargetSize
                            .shrinkWrap,
                  ),
                  child: Text(
                    'Lupa password?',
                    style:
                        AppTextStyles.regular12.copyWith(
                      color: AppColors.blue,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              Consumer<AuthViewModel>(
                builder:
                    (context, viewModel, _) {
                  return SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed:
                          viewModel.isLoading
                              ? null
                              : _loginWithGoogle,
                      icon: SvgPicture.asset(
                        'assets/icon/google.svg',
                        width: 20,
                        height: 20,
                      ),
                      label: Text(
                        'Google',
                        style: AppTextStyles
                            .regular16
                            .copyWith(
                          color: AppColors.red,
                        ),
                      ),
                      style:
                          OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: AppColors.red,
                        ),
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            12,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 98),

              Consumer<AuthViewModel>(
                builder:
                    (context, viewModel, _) {
                  return SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed:
                          viewModel.isLoading
                              ? null
                              : _login,
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            AppColors.red,
                        foregroundColor:
                            AppColors.white,
                        elevation: 0,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            12,
                          ),
                        ),
                      ),
                      child: viewModel.isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child:
                                  CircularProgressIndicator(
                                strokeWidth: 2,
                                color:
                                    AppColors.white,
                              ),
                            )
                          : Text(
                              'Masuk',
                              style: AppTextStyles
                                  .regular18
                                  .copyWith(
                                color:
                                    AppColors.white,
                              ),
                            ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Belum punya akun? ',
                      style:
                          AppTextStyles.regular14
                              .copyWith(
                        color:
                            const Color(0xFF3B332E),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const RegisterScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Daftar',
                        style: AppTextStyles
                            .regular14
                            .copyWith(
                          color: AppColors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}