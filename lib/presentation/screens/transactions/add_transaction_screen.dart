import 'package:flutter/material.dart';

class AddTransactionScreen extends StatelessWidget {
  const AddTransactionScreen({super.key, this.transactionId});

  final String? transactionId;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Ajout transaction — bientôt')),
    );
  }
}