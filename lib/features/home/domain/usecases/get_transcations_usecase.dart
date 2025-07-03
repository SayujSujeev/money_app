
import 'package:money_app/features/home/domain/entities/transction.dart';
import 'package:money_app/features/home/domain/repositories/transaction_repository.dart';

class GetTransactions {
  final TransactionRepository repository;

  GetTransactions(this.repository);

  Future<List<Transaction>> call() {
    return repository.getTransactions();
  }
}
