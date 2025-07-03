import 'package:money_app/features/home/domain/entities/transction.dart';


class TransactionModel extends Transaction {
  TransactionModel({
    required super.id,
    required super.amount,
    required super.date,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    final rawBody = json['body']?.toString() ?? '0';
    final parsedAmount = double.tryParse(rawBody) ?? 0.0;
    return TransactionModel(
      id: json['id'] as int,
      amount: parsedAmount,
      date: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': 'send_money',
      'body': amount.toString(),
      'userId': 1,
    };
  }
}
