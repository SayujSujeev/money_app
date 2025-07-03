part of 'send_money_cubit.dart';

enum SendMoneyStatus { initial, submitting, success, failure }

class SendMoneyState extends Equatable {
  final SendMoneyStatus status;
  final String? errorMessage;

  const SendMoneyState({
    this.status = SendMoneyStatus.initial,
    this.errorMessage,
  });

  SendMoneyState copyWith({
    SendMoneyStatus? status,
    String? errorMessage,
  }) {
    return SendMoneyState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
