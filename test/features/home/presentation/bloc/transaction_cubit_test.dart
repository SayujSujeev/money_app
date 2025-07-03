import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:money_app/features/home/domain/entities/transction.dart';
import 'package:money_app/features/home/domain/usecases/get_transcations_usecase.dart';
import 'package:money_app/features/home/presentation/bloc/transactions_cubit.dart';


class MockGetTransactions extends Mock implements GetTransactions {}

void main() {
  late MockGetTransactions mockGetTransactions;
  late TransactionsCubit cubit;

  final fakeList = [
    Transaction(id: 1, amount: 10.0, date: DateTime.now()),
    Transaction(id: 2, amount: 20.0, date: DateTime.now()),
  ];

  setUp(() {
    mockGetTransactions = MockGetTransactions();
    cubit = TransactionsCubit(getTransactions: mockGetTransactions);
  });

  test('initial state is TransactionsState.initial', () {
    expect(cubit.state, const TransactionsState());
  });

  blocTest<TransactionsCubit, TransactionsState>(
    'emits [loading, success] when fetchHistory succeeds',
    setUp: () {
      when(() => mockGetTransactions()).thenAnswer((_) async => fakeList);
    },
    build: () => cubit,
    act: (c) => c.fetchHistory(),
    expect: () => [
      const TransactionsState(status: TransactionsStatus.loading),
      TransactionsState(
        status: TransactionsStatus.success,
        transactions: fakeList,
      ),
    ],
    verify: (_) {
      verify(() => mockGetTransactions()).called(1);
    },
  );

  blocTest<TransactionsCubit, TransactionsState>(
    'emits [loading, failure] when fetchHistory throws',
    setUp: () {
      when(() => mockGetTransactions()).thenThrow(Exception('nope'));
    },
    build: () => cubit,
    act: (c) => c.fetchHistory(),
    expect: () => [
      const TransactionsState(status: TransactionsStatus.loading),
      const TransactionsState(
        status: TransactionsStatus.failure,
        errorMessage: 'Exception: nope',
      ),
    ],
  );
}
