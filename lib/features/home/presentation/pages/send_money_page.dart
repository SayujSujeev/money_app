import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_app/features/home/presentation/bloc/balance_cubit.dart';
import 'package:money_app/features/home/presentation/bloc/send_money_cubit.dart';
import 'package:sliding_action_button/sliding_action_button.dart';

class SendMoneyPage extends StatefulWidget {
  static const routeName = '/send';

  const SendMoneyPage({super.key});

  @override
  State<SendMoneyPage> createState() => _SendMoneyPageState();
}

class _SendMoneyPageState extends State<SendMoneyPage> {
  String _amount = '';

  void _addDigit(String d) {
    setState(() {
      if (d == '.' && _amount.contains('.')) return;
      _amount = (_amount + d).replaceFirst(RegExp(r'^0+'), '');
    });
  }

  void _backspace() {
    if (_amount.isEmpty) return;
    setState(() {
      _amount = _amount.substring(0, _amount.length - 1);
    });
  }

  void _submit() {
    final parsed = double.tryParse(_amount);
    if (parsed != null && parsed > 0) {
      context.read<SendMoneyCubit>().submit(parsed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final balanceState = context.watch<BalanceCubit>().state;
    final available = balanceState.balance.toStringAsFixed(2);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF4A80F0), Color(0xFF6D9CFF)],
              ),
            ),
          ),

          // 2) Content
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                      const Text(
                        'Send Money',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(flex: 2),
                    ],
                  ),
                ),

                // — Available Balance
                const SizedBox(height: 16),
                const Text(
                  'Available Balance',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$ $available',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // — Send to
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 24,
                        backgroundImage:
                            NetworkImage('https://i.pravatar.cc/150?img=32'),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ilham Stephenson',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                          SizedBox(height: 4),
                          Text('@ilhamstephen',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                      const Spacer(),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white24,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                        ),
                        onPressed: () async {
                          },
                        icon: const Icon(Icons.note_add, color: Colors.white),
                        label: const Text('Add Notes',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        )),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _amount.isEmpty ? '\$ 0.00' : "\$ $_amount",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 24),

                        // — Keypad
                        _buildKeypadRow(['1', '2', '3']),
                        _buildKeypadRow(['4', '5', '6']),
                        _buildKeypadRow(['7', '8', '9']),
                        _buildKeypadRow(['.', '0', '⌫']),
                      ],
                    ),
                  ),
                ),

                BlocBuilder<SendMoneyCubit, SendMoneyState>(
                  builder: (context, state) {
                    final isSubmitting = state.status == SendMoneyStatus.submitting;
                    final parsed = double.tryParse(_amount) ?? 0;

                    return Container(
                      color: Colors.white10,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                        child: CircleSlideToActionButton(
                          width: MediaQuery.of(context).size.width - 64,
                          parentBoxRadiusValue: 28,
                          circleSlidingButtonSize: 56,
                          leftEdgeSpacing: 4,
                          rightEdgeSpacing: 4,

                          slideActionButtonType: SlideActionButtonType.slideActionWithLoaderButton,

                          initialSlidingActionLabel:
                          isSubmitting ? 'Sending…' : 'Swipe to send money',
                          finalSlidingActionLabel: 'Sent!',

                          // when loading, this color is used for the spinner
                          loaderColor: Colors.blue,

                          circleSlidingButtonIcon: const Icon(
                            Icons.double_arrow,
                            color: Colors.blue,
                          ),

                          parentBoxBackgroundColor: Colors.white,
                          parentBoxDisableBackgroundColor: Colors.grey.shade300,
                          circleSlidingButtonBackgroundColor: Colors.white,

                          isEnable: !isSubmitting,

                          onSlideActionCompleted: () {

                            context.read<SendMoneyCubit>().submit(parsed);
                          },

                          onSlideActionCanceled: () {
                            // if the user lets go early
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          BlocListener<SendMoneyCubit, SendMoneyState>(
            listener: (context, state) {
              final amt = _amount;
              const user = 'johnsm123';
              if (state.status == SendMoneyStatus.success) {
                _showResultDialog(context, true, amt, user);
              } else if (state.status == SendMoneyStatus.failure) {
                _showResultDialog(context, false, amt, user, error: state.errorMessage);
              }
            },
            child: const SizedBox.shrink(),
          ),

        ],
      ),
    );
  }

  void _showResultDialog(
      BuildContext ctx,
      bool success,
      String amount,
      String username, {
        String? error,
      }) {
    showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (_) {
        // Wrap the Dialog in a Theme to force dark styling
        return Theme(
          data: Theme.of(ctx).copyWith(
            brightness: Brightness.dark,
            dialogBackgroundColor: const Color(0xFF1E1E2E),
            colorScheme: ColorScheme.dark(
              primary: success ? Colors.green : Colors.red,
              onSurface: Colors.white, // for Text
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: success ? Colors.green : Colors.red,
              ),
            ),
          ),
          child: Dialog(
            backgroundColor: const Color(0xFF1E1E2E),
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            insetPadding: const EdgeInsets.symmetric(horizontal: 32),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    success ? Icons.check_circle : Icons.error,
                    size: 64,
                    color: success ? Colors.green : Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    success ? 'Transfer Complete!' : 'Transfer Failed',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    success
                        ? 'You successfully transferred \$$amount to @$username.'
                        : error ?? 'Something went wrong.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        const Color(0xFF4A80F0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(ctx).pop(); // dismiss dialog
                        if (success) Navigator.of(ctx).pop(); // back to screen
                      },
                      child: const Text('Continue'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }



  Widget _buildKeypadRow(List<String> keys) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: keys.map((k) {
            return GestureDetector(
              onTap: () {
                if (k == '⌫') {
                  _backspace();
                } else {
                  _addDigit(k);
                }
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: Colors.white10,
                  shape: BoxShape.circle
                ),
                child: Center(
                  child: Text(
                    k,
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              ),
            );
          }).toList()),
    );
  }
}

