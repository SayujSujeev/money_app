import 'package:money_app/features/home/domain/repositories/transaction_repository.dart';

class GetBalance {
  final TransactionRepository repository;

  GetBalance(this.repository);

  Future<double> call() {
    return repository.getBalance();
  }
}
