import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_app/features/home/presentation/bloc/send_money_cubit.dart';


class SendMoneyPage extends StatefulWidget {
  static const routeName = '/send';

  const SendMoneyPage({super.key});

  @override
  State<SendMoneyPage> createState() => _SendMoneyPageState();
}

class _SendMoneyPageState extends State<SendMoneyPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showResultSheet(String message, bool success) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              success ? Icons.check_circle : Icons.error,
              color: success ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message, style: const TextStyle(fontSize: 16))),
          ],
        ),
      ),
    ).whenComplete(() {
      context.read<SendMoneyCubit>().reset();
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Send Money')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocListener<SendMoneyCubit, SendMoneyState>(
          listener: (context, state) {
            if (state.status == SendMoneyStatus.success) {
              _showResultSheet('Money sent successfully!', true);
            } else if (state.status == SendMoneyStatus.failure) {
              _showResultSheet(
                'Send failed: ${state.errorMessage}',
                false,
              );
            }
          },
          child: Column(
            children: [
              TextField(
                controller: _controller,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                  prefixText: '₱ ',
                ),
              ),
              const SizedBox(height: 24),
              BlocBuilder<SendMoneyCubit, SendMoneyState>(
                builder: (context, state) {
                  return state.status == SendMoneyStatus.submitting
                      ? const CircularProgressIndicator()
                      : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final text = _controller.text;
                        if (text.isEmpty) return;
                        final amount = double.parse(text);
                        context.read<SendMoneyCubit>().submit(amount);
                      },
                      child: const Text('Submit'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
