import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_app/features/home/presentation/bloc/balance_cubit.dart';
import 'package:money_app/features/home/presentation/pages/history_page.dart';

class BalancePage extends StatefulWidget {
  static const routeName = '/balance';

  const BalancePage({super.key});

  @override
  State<BalancePage> createState() => _BalancePageState();
}

class _BalancePageState extends State<BalancePage> {
  final _favorites = const [
    {
      'name': 'Alexis',
      'avatarUrl': 'https://i.pravatar.cc/150?img=13',
    },
    {
      'name': 'Danielle',
      'avatarUrl': 'https://i.pravatar.cc/150?img=47',
    },
  ];

  final _recent = [
    {
      'name': 'Alexis Sanchez',
      'subtitle': 'Payment Received',
      'time': '12:21',
      'amount': 124.0,
      'isPositive': true,
      'avatarUrl': 'https://i.pravatar.cc/150?img=32',
    },
    {
      'name': 'Ilham Stephenson',
      'subtitle': 'Send Money Success',
      'time': '08:11',
      'amount': 80.0,
      'isPositive': false,
      'avatarUrl': 'https://i.pravatar.cc/150?img=56',
    },
  ];


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F1E),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage:
                        NetworkImage('https://i.pravatar.cc/150?img=12'),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Hi John,',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4A80F0), Color(0xFF6D9CFF)],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  // Move the BlocBuilder up so we can rebuild both text & icon together
                  child: BlocBuilder<BalanceCubit, BalanceState>(
                    builder: (context, state) {
                      final display = state.isHidden
                          ? '******'
                          : '\$ ${state.balance.toStringAsFixed(2)}';

                      return Row(
                        children: [
                          Text(
                            display,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const Spacer(),

                          // ⇨ SHOW / HIDE toggle
                          IconButton(
                            icon: Icon(
                              state.isHidden
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white,
                              size: 28,
                            ),
                            onPressed: () =>
                                context.read<BalanceCubit>().toggleVisibility(),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 32),

              const Text(
                'Favorites',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _favorites.length + 1,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      // Add button
                      return Container(
                        width: 80,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E2432),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Center(
                          child: Icon(Icons.add, color: Colors.white, size: 28),
                        ),
                      );
                    }
                    final fav = _favorites[index - 1];
                    return Container(
                      width: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E2432),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 16),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(fav['avatarUrl']!),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            fav['name']!,
                            style: const TextStyle(
                              color: Colors.white70,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 32),

              // Recent Activity
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Activity',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, HistoryPage.routeName),
                    child: const Text('See All'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Column(
                children: _recent.map((act) {
                  final isPos = act['isPositive'] as bool;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2432),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage:
                          NetworkImage(act['avatarUrl']!.toString()),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                act['name']!.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                act['subtitle']!.toString(),
                                style: const TextStyle(
                                  color: Colors.white60,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '${isPos ? '+' : '-'} \$${(act['amount'] as double).toStringAsFixed(2)}',
                              style: TextStyle(
                                color: isPos ? Colors.green : Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              act['time']!.toString(),
                              style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
