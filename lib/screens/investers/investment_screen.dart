// ignore_for_file: library_private_types_in_public_api

import 'package:fintech/providers/user_providers.dart';
import 'package:fintech/utils/investment_utils.dart';
import 'package:fintech/models/investment_models.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InvestmentsScreen extends ConsumerStatefulWidget {
  @override
  _InvestmentsScreenState createState() => _InvestmentsScreenState();
}

class _InvestmentsScreenState extends ConsumerState<InvestmentsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Investments'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('investments')
            .where('investor',
                isEqualTo: ref.read(userProvider.notifier).state.email)
            .snapshots(),
        builder: (context, snapshot) {
          print(snapshot.data?.docs.first.data());
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          print(snapshot.data?.docs.length);
          if (snapshot.data?.docs.length == 0) {
            return const Center(
                child: Text('No investments found',
                    style: TextStyle(fontSize: 20)));
          }

          var investments = snapshot.data!.docs
              .map((doc) => InvestmentModel.fromFirestore(doc))
              .toList();
          print(investments);

          return ListView.builder(
            itemCount: investments.length,
            itemBuilder: (context, index) {
              var investment = investments[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text('Investment in ${investment.title}'),
                  subtitle:
                      Text('Amount: \$${investment.amount.toStringAsFixed(2)}'),
                  trailing: Text(
                    investment.status.toUpperCase(),
                    style: TextStyle(
                      color: getStatusColor(investment.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showInvestmentDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showInvestmentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Create New Investment'),
          content: TextField(
            decoration: const InputDecoration(
              hintText: 'Enter Investment Amount',
              prefixText: '\$',
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              // Handle investment amount
            },
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              child: const Text('Invest'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
