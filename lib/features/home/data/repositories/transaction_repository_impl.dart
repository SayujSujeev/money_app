import 'package:money_app/features/home/data/datasource/transcation_api.dart';
import 'package:money_app/features/home/domain/entities/transction.dart';
import '../../domain/repositories/transaction_repository.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionApi api;
  static const _initialBalance = 500.0;

  TransactionRepositoryImpl({required this.api});

  @override
  Future<double> getBalance() async {
    final history = await api.fetchTransactions();
    final sentTotal = history.fold<double>(
      0.0,
          (sum, tx) => sum + tx.amount,
    );
    return _initialBalance - sentTotal;
  }

  @override
  Future<List<Transaction>> getTransactions() {
    return api.fetchTransactions();
  }

  @override
  Future<void> sendMoney(double amount) {
    return api.sendMoney(amount);
  }
}
