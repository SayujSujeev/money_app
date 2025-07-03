import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_app/features/home/domain/entities/transction.dart';
import 'package:intl/intl.dart';
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
    // trigger load
    context.read<TransactionsCubit>().fetchHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<TransactionsCubit, TransactionsState>(
          builder: (context, state) {
            if (state.status == TransactionsStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state.status == TransactionsStatus.failure) {
              return Center(child: Text('Error: ${state.errorMessage}'));
            }
            final List<Transaction> list = state.transactions;
            if (list.isEmpty) {
              return const Center(child: Text('No transactions yet.'));
            }
            return ListView.separated(
              itemCount: list.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, i) {
                final tx = list[i];
                return ListTile(
                  leading: const Icon(Icons.send),
                  title: Text('₱ ${tx.amount.toStringAsFixed(2)}'),
                  subtitle: Text(
                    DateFormat.yMMMd().add_jm().format(tx.date),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
