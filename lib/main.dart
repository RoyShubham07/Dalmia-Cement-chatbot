import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthsphere/pages/home_page.dart';

import 'package:healthsphere/pages/login_page.dart';
import 'package:healthsphere/pages/main/ai_bot_page.dart';

import 'package:healthsphere/pages/register_page.dart';
import 'package:healthsphere/pages/splash_page.dart';
import 'package:healthsphere/values/app_constants.dart';
import 'package:healthsphere/values/app_routes.dart';
import 'package:healthsphere/values/app_theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    authFlowType: AuthFlowType.pkce,
    url: 'https://njbutwisncgxlabvcpic.supabase.co',
    anonKey:'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5qYnV0d2lzbmNneGxhYnZjcGljIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDQ2NDcxMDMsImV4cCI6MjAyMDIyMzEwM30.vYH8SSWAT3tMao6A3YwsUZ6SODb0arsodjxgzw07kU0',
  );
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const SplashPage();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasc-AI',
      theme: AppTheme.themeData,
      initialRoute: AppRoutes.loading,
      navigatorKey: AppConstants.navigationKey,
      routes: {
        AppRoutes.loginScreen: (context) => const LoginPage(),
        AppRoutes.loading: (context) => const SplashPage(),
        AppRoutes.registerScreen: (context) => const RegisterPage(),
        AppRoutes.home: (context) => const homepage(),
        AppRoutes.bot: (context) => const AIBotScreen(),
        
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
