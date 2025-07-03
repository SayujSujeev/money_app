import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'package:money_app/features/home/data/datasource/transcation_api.dart';
import 'package:money_app/features/home/data/repositories/transaction_repository_impl.dart';
import 'package:money_app/features/home/domain/repositories/transaction_repository.dart';
import 'package:money_app/features/home/domain/usecases/get_balance.dart';
import 'package:money_app/features/home/domain/usecases/send_money_usecase.dart';
import 'package:money_app/features/home/domain/usecases/get_transcations_usecase.dart';
import 'package:money_app/features/home/presentation/bloc/balance_cubit.dart';
import 'package:money_app/features/home/presentation/bloc/send_money_cubit.dart';
import 'package:money_app/features/home/presentation/bloc/transactions_cubit.dart';

final sl = GetIt.instance;

void setupLocator() {
  // Core
  sl.registerLazySingleton<http.Client>(() => http.Client());

  // Data source
  sl.registerLazySingleton<TransactionApi>(
        () => TransactionApi(client: sl()),
  );

  // Repository: register under the interface type!
  sl.registerLazySingleton<TransactionRepository>(
        () => TransactionRepositoryImpl(api: sl()),
  );

  // Use cases depend on the interface
  sl.registerLazySingleton(() => GetBalance(sl<TransactionRepository>()));
  sl.registerLazySingleton(() => SendMoney(sl<TransactionRepository>()));
  sl.registerLazySingleton(() => GetTransactions(sl<TransactionRepository>()));

  // Cubits
  sl.registerFactory(
        () => BalanceCubit(getBalance: sl())..loadBalance(),
  );
  sl.registerFactory(
        () => SendMoneyCubit(sendMoney: sl()),
  );
  sl.registerFactory(
        () => TransactionsCubit(getTransactions: sl()),
  );
}
