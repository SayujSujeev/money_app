import 'package:flutter/material.dart';
import 'package:money_app/features/home/presentation/pages/dashboard_page.dart';

class SplashPage extends StatefulWidget {
  static const routeName = '/';

  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // After 2 seconds, go to Dashboard
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, DashboardPage.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0B0F1E), // your dark background
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Replace with your logo if you have one
            Icon(
              Icons.account_balance_wallet,
              size: 80,
              color: Color(0xFF4A80F0),
            ),
            SizedBox(height: 24),
            Text(
              'Send Money',
              style: TextStyle(
                color: Color(0xFF4A80F0),
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
