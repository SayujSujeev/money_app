import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_app/features/home/domain/usecases/send_money_usecase.dart';


part 'send_money_state.dart';

class SendMoneyCubit extends Cubit<SendMoneyState> {
  final SendMoney sendMoney;

  SendMoneyCubit({required this.sendMoney}) : super(const SendMoneyState());

  Future<void> submit(double amount) async {
    emit(state.copyWith(status: SendMoneyStatus.submitting));
    try {
      await sendMoney(amount);
      emit(state.copyWith(status: SendMoneyStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: SendMoneyStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  void reset() {
    emit(const SendMoneyState());
  }
}
