part of 'balance_cubit.dart';

enum BalanceStatus { initial, loading, success, failure }

class BalanceState extends Equatable {
  final BalanceStatus status;
  final double balance;
  final bool isHidden;
  final String? errorMessage;

  const BalanceState({
    this.status = BalanceStatus.initial,
    this.balance = 0.0,
    this.isHidden = true,
    this.errorMessage,
  });

  BalanceState copyWith({
    BalanceStatus? status,
    double? balance,
    bool? isHidden,
    String? errorMessage,
  }) {
    return BalanceState(
      status: status ?? this.status,
      balance: balance ?? this.balance,
      isHidden: isHidden ?? this.isHidden,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, balance, isHidden, errorMessage];
}
