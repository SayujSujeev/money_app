
import 'package:money_app/features/home/domain/repositories/transaction_repository.dart';

class SendMoney {
  final TransactionRepository repository;

  SendMoney(this.repository);

  Future<void> call(double amount) {
    return repository.sendMoney(amount);
  }
}
