import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_app/core/di/injection.dart';
import 'package:money_app/features/home/data/datasource/transcation_api.dart';
import 'package:money_app/features/home/data/repositories/transaction_repository_impl.dart';
import 'package:money_app/features/home/domain/usecases/get_balance.dart';
import 'package:money_app/features/home/domain/usecases/get_transcations_usecase.dart';
import 'package:money_app/features/home/domain/usecases/send_money_usecase.dart';
import 'package:money_app/features/home/presentation/bloc/balance_cubit.dart';
import 'package:money_app/features/home/presentation/bloc/send_money_cubit.dart';
import 'package:money_app/features/home/presentation/bloc/transactions_cubit.dart';
import 'package:money_app/features/home/presentation/pages/balance_page.dart';
import 'package:money_app/features/home/presentation/pages/dashboard_page.dart';
import 'package:money_app/features/home/presentation/pages/history_page.dart';
import 'package:money_app/features/home/presentation/pages/send_money_page.dart';
import 'package:money_app/features/home/presentation/pages/splash_page.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(const SendMoneyApp());
}

class SendMoneyApp extends StatelessWidget {
  const SendMoneyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // pull each Cubit from get_it
        BlocProvider(create: (_) => sl<BalanceCubit>()),
        BlocProvider(create: (_) => sl<SendMoneyCubit>()),
        BlocProvider(create: (_) => sl<TransactionsCubit>()),
      ],
      child: MaterialApp(
        title: 'Send Money App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: SplashPage.routeName,
        routes: {
          SplashPage.routeName:   (_) => const SplashPage(),
          DashboardPage.routeName: (_) => const DashboardPage(),
          BalancePage.routeName:   (_) => const BalancePage(),
          SendMoneyPage.routeName: (_) => const SendMoneyPage(),
          HistoryPage.routeName:   (_) => const HistoryPage(),
        },
      ),
    );
  }
}