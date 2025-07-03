import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:money_app/features/home/domain/usecases/send_money_usecase.dart';
import 'package:money_app/features/home/presentation/bloc/send_money_cubit.dart';


class MockSendMoney extends Mock implements SendMoney {}

void main() {
  late MockSendMoney mockSendMoney;
  late SendMoneyCubit cubit;

  setUp(() {
    mockSendMoney = MockSendMoney();
    cubit = SendMoneyCubit(sendMoney: mockSendMoney);
  });

  test('initial state is SendMoneyState.initial', () {
    expect(cubit.state, const SendMoneyState());
  });

  blocTest<SendMoneyCubit, SendMoneyState>(
    'emits [submitting, success] when sendMoney succeeds',
    setUp: () {
      when(() => mockSendMoney(any())).thenAnswer((_) async {});
    },
    build: () => cubit,
    act: (c) => c.submit(123.45),
    expect: () => [
      const SendMoneyState(status: SendMoneyStatus.submitting),
      const SendMoneyState(status: SendMoneyStatus.success),
    ],
    verify: (_) {
      verify(() => mockSendMoney(123.45)).called(1);
    },
  );

  blocTest<SendMoneyCubit, SendMoneyState>(
    'emits [submitting, failure] when sendMoney throws',
    setUp: () {
      when(() => mockSendMoney(any())).thenThrow(Exception('fail'));
    },
    build: () => cubit,
    act: (c) => c.submit(50.0),
    expect: () => [
      const SendMoneyState(status: SendMoneyStatus.submitting),
      const SendMoneyState(
        status: SendMoneyStatus.failure,
        errorMessage: 'Exception: fail',
      ),
    ],
  );

  blocTest<SendMoneyCubit, SendMoneyState>(
    'reset returns to initial state',
    build: () => cubit,
    seed: () => const SendMoneyState(status: SendMoneyStatus.success),
    act: (c) => c.reset(),
    expect: () => [const SendMoneyState()],
  );
}
