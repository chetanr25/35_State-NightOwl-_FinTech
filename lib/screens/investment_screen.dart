// ignore_for_file: library_private_types_in_public_api

import 'package:fintech/utils/investment_utils.dart';
import 'package:fintech/models/investment_models.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InvestmentsScreen extends StatefulWidget {
  @override
  _InvestmentsScreenState createState() => _InvestmentsScreenState();
}

class _InvestmentsScreenState extends State<InvestmentsScreen> {
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
            .where('investorId', isEqualTo: 'gPG5X0NmAI7RXm4eX6sR')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No investments found'));
          }

          var investments = snapshot.data!.docs
              .map((doc) => InvestmentModel.fromFirestore(doc))
              .toList();

          return ListView.builder(
            itemCount: investments.length,
            itemBuilder: (context, index) {
              var investment = investments[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text('Investment in ${investment.smeId}'),
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
