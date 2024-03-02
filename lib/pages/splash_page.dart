import 'package:flutter/material.dart';
import 'package:healthsphere/main.dart';
import 'package:healthsphere/utils/extensions.dart';
import 'package:healthsphere/values/app_routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _redirect();
  }

  Future<void> _redirect() async {
    await Future.delayed(Duration.zero);
    if (!mounted) {
      return;
    }

    final session = Supabase.instance.client.auth.currentSession;
    
    if (session != null) {
      AppRoutes.home.replaceNamed();
    } else {
      AppRoutes.loginScreen.replaceNamed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
