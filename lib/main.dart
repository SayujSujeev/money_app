import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:money_app/features/home/data/datasource/transcation_api.dart';
import 'package:money_app/features/home/data/repositories/transaction_repository_impl.dart';
import 'package:money_app/features/home/domain/usecases/get_balance.dart';
import 'package:money_app/features/home/domain/usecases/get_transcations_usecase.dart';
import 'package:money_app/features/home/domain/usecases/send_money_usecase.dart';
import 'package:money_app/features/home/presentation/bloc/balance_cubit.dart';
import 'package:money_app/features/home/presentation/bloc/send_money_cubit.dart';
import 'package:money_app/features/home/presentation/bloc/transactions_cubit.dart';
import 'package:money_app/features/home/presentation/pages/balance_page.dart';
import 'package:money_app/features/home/presentation/pages/history_page.dart';
import 'package:money_app/features/home/presentation/pages/send_money_page.dart';


void main() {
  final client = http.Client();
  final api = TransactionApi(client: client);
  final repository = TransactionRepositoryImpl(api: api);

  final getBalance = GetBalance(repository);
  final sendMoney = SendMoney(repository);
  final getTransactions = GetTransactions(repository);

  runApp(SendMoneyApp(
    getBalance: getBalance,
    sendMoney: sendMoney,
    getTransactions: getTransactions,
  ));
}

class SendMoneyApp extends StatelessWidget {
  final GetBalance getBalance;
  final SendMoney sendMoney;
  final GetTransactions getTransactions;

  const SendMoneyApp({
    super.key,
    required this.getBalance,
    required this.sendMoney,
    required this.getTransactions,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => BalanceCubit(getBalance: getBalance)..loadBalance(),
        ),
        BlocProvider(
          create: (_) => SendMoneyCubit(sendMoney: sendMoney),
        ),
        BlocProvider(
          create: (_) => TransactionsCubit(getTransactions: getTransactions),
        ),
      ],
      child: MaterialApp(
        title: 'Send Money App',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: BalancePage.routeName,
        routes: {
          BalancePage.routeName: (_) => const BalancePage(),
          SendMoneyPage.routeName: (_) => const SendMoneyPage(),
          HistoryPage.routeName: (_) => const HistoryPage(),
        },
      ),
    );
  }
}
