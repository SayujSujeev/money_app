import 'package:flutter/material.dart';
import 'package:money_app/features/home/presentation/pages/balance_page.dart';
import 'package:money_app/features/home/presentation/pages/history_page.dart';
import 'package:money_app/features/home/presentation/pages/send_money_page.dart';

class DashboardPage extends StatefulWidget {
  static const routeName = '/dashboard';
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  int _selectedIndex = 0;


  @override
  Widget build(BuildContext context) {

    Widget body;
    switch (_selectedIndex) {
      case 1:
        body = const SendMoneyPage();
        break;
      case 2:
        body = const HistoryPage();
        break;
      case 0:
      default:
        body = const BalancePage();
    }
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F1E),
      body: SafeArea(
        child: body,
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
        child: Container(
          decoration: BoxDecoration(
              color: const Color.fromRGBO(41, 48, 64, 1),
              borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(Icons.home_filled, 0),

              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, SendMoneyPage.routeName);
                },
                child: Container(
                  width: 60,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4A80F0),
                    // you can keep center highlighted
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),

              _buildNavItem(Icons.history, 2),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final selected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        width: 60,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(icon, color: selected ? const Color(0xFF4A80F0) : Colors.white54),
      ),
    );
  }
}
