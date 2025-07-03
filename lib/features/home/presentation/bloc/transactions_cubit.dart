import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:money_app/features/home/domain/entities/transction.dart';
import 'package:money_app/features/home/domain/usecases/get_transcations_usecase.dart';


part 'transactions_state.dart';

class TransactionsCubit extends Cubit<TransactionsState> {
  final GetTransactions getTransactions;

  TransactionsCubit({required this.getTransactions})
      : super(const TransactionsState());

  Future<void> fetchHistory() async {
    emit(state.copyWith(status: TransactionsStatus.loading));
    try {
      final list = await getTransactions();
      emit(state.copyWith(
        status: TransactionsStatus.success,
        transactions: list,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: TransactionsStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }
}
