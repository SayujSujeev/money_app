import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_app/features/home/domain/usecases/get_balance.dart';

part 'balance_state.dart';

class BalanceCubit extends Cubit<BalanceState> {
  final GetBalance getBalance;

  BalanceCubit({required this.getBalance}) : super(const BalanceState());

  Future<void> loadBalance() async {
    emit(state.copyWith(status: BalanceStatus.loading));
    try {
      final bal = await getBalance();
      emit(state.copyWith(status: BalanceStatus.success, balance: bal));
    } catch (e) {
      emit(state.copyWith(
        status: BalanceStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void toggleVisibility() {
    emit(state.copyWith(isHidden: !state.isHidden));
  }
}
