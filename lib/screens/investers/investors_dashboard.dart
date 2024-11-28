// ignore_for_file: library_private_types_in_public_api

import 'package:fintech/models/sme_models.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class InvestorOpportunitiesDashboard extends StatefulWidget {
  const InvestorOpportunitiesDashboard({super.key});

  @override
  _InvestorOpportunitiesDashboardState createState() =>
      _InvestorOpportunitiesDashboardState();
}

class _InvestorOpportunitiesDashboardState
    extends State<InvestorOpportunitiesDashboard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<SmeModels>> _getOpenOpportunities() {
    return _firestore
        .collection('smes')
        .where('status', isEqualTo: 'open')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => SmeModels.fromFirestore(doc)).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Investment Opportunities'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Implement filtering options
            },
          )
        ],
      ),
      body: StreamBuilder<List<SmeModels>>(
        stream: _getOpenOpportunities(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No open opportunities available'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              SmeModels opportunity = snapshot.data![index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(opportunity.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(opportunity.description),
                      const SizedBox(height: 8),
                      Text(
                        'Industry: ${opportunity.industry}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Funding Goal: \$${opportunity.fundingGoal}',
                        style: const TextStyle(color: Colors.green),
                      ),
                      Text(
                        'Current Funding: \$${opportunity.currentFunding}',
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // Navigate to opportunity details or investment page
                      // Replace with your navigation method
                    },
                    child:const Text('Invest'),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
