import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/theme/app_theme.dart';

import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/splash/splash_screen.dart';

import 'services/auth_service.dart';
import 'services/profile_service.dart';
import 'services/quiz_service.dart';
import 'services/partner_service.dart';
import 'services/chat_service.dart';

import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/quiz_viewmodel.dart';
import 'viewmodels/partner_viewmodel.dart';
import 'viewmodels/chat_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://gljvdxvdpehdpranyfpy.supabase.co',
    publishableKey: 'sb_publishable_-UlLAtI9GUjiXOM5Zpqiig_usHgofb9',
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );

  runApp(const DuoryApp());
}

class DuoryApp extends StatelessWidget {
  const DuoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(AuthService(), ProfileService()),
        ),

        ChangeNotifierProvider(create: (_) => QuizViewModel(QuizService())),

        // PARTNER PROVIDER
        ChangeNotifierProvider(
          create: (_) => PartnerViewModel(PartnerService()),
        ),

        ChangeNotifierProvider(create: (_) => ChatViewModel(ChatService())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Duory',

        theme: AppTheme.lightTheme,

        // AuthGate menjadi root aplikasi
        home: const AuthGate(),
      ),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    _startSplash();
  }

  Future<void> _startSplash() async {
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    setState(() {
      _showSplash = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Tampilkan splash selama 3 detik
    if (_showSplash) {
      return const SplashScreen();
    }

    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,

      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final session =
            snapshot.data?.session ??
            Supabase.instance.client.auth.currentSession;

        if (session != null) {
          return const HomeScreen();
        }

        return const LoginScreen();
      },
    );
  }
}
