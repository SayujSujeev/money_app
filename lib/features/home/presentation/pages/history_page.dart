import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:money_app/features/home/domain/entities/transction.dart';
import 'package:money_app/features/home/presentation/bloc/transactions_cubit.dart';

class HistoryPage extends StatefulWidget {
  static const routeName = '/history';

  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<TransactionsCubit>().fetchHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F1E),
      body: SafeArea(
        child: Column(
          children: [
            // ← custom header instead of AppBar
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Row(
                children: [
                  Text(
                    'Transactions',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // ← list content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: BlocBuilder<TransactionsCubit, TransactionsState>(
                  builder: (context, state) {
                    if (state.status == TransactionsStatus.loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state.status == TransactionsStatus.failure) {
                      return Center(
                        child: Text(
                          'Error: ${state.errorMessage}',
                          style: const TextStyle(color: Colors.white60),
                        ),
                      );
                    }

                    final List<Transaction> list = state.transactions;
                    if (list.isEmpty) {
                      return const Center(
                        child: Text(
                          'No transactions yet.',
                          style: TextStyle(color: Colors.white60),
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: list.length,
                      separatorBuilder: (_, __) => const Divider(
                        color: Color(0xFF293040),
                        thickness: 1,
                      ),
                      itemBuilder: (context, i) {
                        final tx = list[i];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              const Icon(Icons.send, color: Color(0xFF4A80F0)),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  '\$ ${tx.amount.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Text(
                                DateFormat.yMMMd().add_jm().format(tx.date),
                                style: const TextStyle(
                                  color: Colors.white60,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
