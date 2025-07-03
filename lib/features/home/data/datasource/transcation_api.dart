import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:money_app/features/home/data/models/transaction_model.dart';

class TransactionApi {
  final http.Client client;
  static const _baseUrl =
      'https://my-json-server.typicode.com/sayujsujeev/money_app';

  TransactionApi({required this.client});

  Future<List<TransactionModel>> fetchTransactions() async {
    final response = await client.get(Uri.parse('$_baseUrl/transactions'));
    if (response.statusCode == 200) {
      final List<dynamic> list = jsonDecode(response.body);
      return list
          .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    throw Exception('Failed to load transactions');
  }

  Future<void> sendMoney(double amount) async {
    final response = await client.post(
      Uri.parse('$_baseUrl/transactions'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(
          TransactionModel(id: 0, amount: amount, date: DateTime.now())
              .toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Send money failed');
    }
  }
}
