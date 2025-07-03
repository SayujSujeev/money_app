import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:money_app/features/home/domain/usecases/get_balance.dart';
import 'package:money_app/features/home/presentation/bloc/balance_cubit.dart';


class MockGetBalance extends Mock implements GetBalance {}

void main() {
  late MockGetBalance mockGetBalance;
  late BalanceCubit cubit;

  setUp(() {
    mockGetBalance = MockGetBalance();
    cubit = BalanceCubit(getBalance: mockGetBalance);
  });

  test('initial state is BalanceState.initial', () {
    expect(cubit.state, const BalanceState());
  });

  blocTest<BalanceCubit, BalanceState>(
    'emits [loading, success] when loadBalance succeeds',
    setUp: () {
      when(() => mockGetBalance()).thenAnswer((_) async => 250.0);
    },
    build: () => cubit,
    act: (c) => c.loadBalance(),
    expect: () => [
      const BalanceState(status: BalanceStatus.loading),
      const BalanceState(status: BalanceStatus.success, balance: 250.0),
    ],
    verify: (_) {
      verify(() => mockGetBalance()).called(1);
    },
  );

  blocTest<BalanceCubit, BalanceState>(
    'emits [loading, failure] when loadBalance throws',
    setUp: () {
      when(() => mockGetBalance()).thenThrow(Exception('oops'));
    },
    build: () => cubit,
    act: (c) => c.loadBalance(),
    expect: () => [
      const BalanceState(status: BalanceStatus.loading),
      const BalanceState(
        status: BalanceStatus.failure,
        errorMessage: 'Exception: oops',
      ),
    ],
  );

  blocTest<BalanceCubit, BalanceState>(
    'toggleVisibility flips isHidden flag',
    build: () => cubit,
    seed: () => const BalanceState(isHidden: false),
    act: (c) => c.toggleVisibility(),
    expect: () => [const BalanceState(isHidden: true)],
  );
}
