import 'package:money_app/features/home/domain/entities/transction.dart';

abstract class TransactionRepository {
  Future<List<Transaction>> getTransactions();

  Future<void> sendMoney(double amount);

  Future<double> getBalance();
}
