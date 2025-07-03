import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_app/features/home/presentation/pages/history_page.dart';
import 'package:money_app/features/home/presentation/pages/send_money_page.dart';

import '../bloc/balance_cubit.dart';

class BalancePage extends StatelessWidget {
  static const routeName = '/';

  const BalancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wallet')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BlocBuilder<BalanceCubit, BalanceState>(
              builder: (context, state) {
                if (state.status == BalanceStatus.loading) {
                  return const CircularProgressIndicator();
                }
                if (state.status == BalanceStatus.failure) {
                  return Text('Error: ${state.errorMessage}');
                }
                // Success case
                final display = state.isHidden
                    ? '******'
                    : '${state.balance.toStringAsFixed(2)} PHP';
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      display,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        state.isHidden
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () =>
                          context.read<BalanceCubit>().toggleVisibility(),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, SendMoneyPage.routeName),
              child: const Text('Send Money'),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () =>
                  Navigator.pushNamed(context, HistoryPage.routeName),
              child: const Text('View Transactions'),
            ),
          ],
        ),
      ),
    );
  }
}
