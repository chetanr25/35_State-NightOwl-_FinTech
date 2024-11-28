import 'package:fintech/models/sme_models.dart';
import 'package:fintech/providers/user_providers.dart';
import 'package:fintech/screens/sme/sme_application.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SmeDashboard extends ConsumerStatefulWidget {
  const SmeDashboard({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SmeDashboardState createState() => _SmeDashboardState();
}

class _SmeDashboardState extends ConsumerState<SmeDashboard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
  }

  Stream<List<SmeModels>> _getSmeOpportunities() {
    final y = _firestore
        .collection('smes')
        .where('email', isEqualTo: ref.read(userProvider).email)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => SmeModels.fromFirestore(doc)).toList());

    return y;
  }

  Future<void> _approveInvestment(String investmentId) async {
    try {
      await _firestore
          .collection('investments')
          .doc(investmentId)
          .update({'status': 'approved'});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Investment approved successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error approving investment: $e')),
      );
    }
  }

  Widget _buildOpportunityCard(SmeModels opportunity) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              opportunity.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Funding Progress Bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Funding Progress: \$${opportunity.currentFunding.toStringAsFixed(2)} / \$${opportunity.fundingGoal.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: opportunity.currentFunding / opportunity.fundingGoal,
                  minHeight: 10,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Text(
              'Investors',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Investors List
            StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('investments')
                  .where('smeId', isEqualTo: opportunity.smeId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final investments = snapshot.data!.docs;

                if (investments.isEmpty) {
                  return const Text('No investors yet');
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: investments.length,
                  itemBuilder: (context, index) {
                    final investment =
                        investments[index].data() as Map<String, dynamic>;

                    return Card(
                      color: Colors.grey[800],
                      child: ListTile(
                        title: Text('Investor: ${investment['investor']}'),
                        subtitle: Text(
                            'Amount: \$${investment['amount'].toStringAsFixed(2)}'),
                        trailing: investment['status'] == 'pending'
                            ? ElevatedButton(
                                onPressed: () =>
                                    _approveInvestment(investments[index].id),
                                child: const Text('Approve'),
                              )
                            : Text(
                                investment['status'].toUpperCase(),
                                style: TextStyle(
                                  color: investment['status'] == 'approved'
                                      ? Colors.green
                                      : Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SME Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SmeApplicationScreen()));
              // Replace with your navigation method
            },
          )
        ],
      ),
      // body: _buildOpportunityCard(opportunity),
      body: StreamBuilder<List<SmeModels>>(
        stream: _getSmeOpportunities(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No opportunities created yet'),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SmeApplicationScreen()));
                    },
                    child: const Text('Create New Opportunity'),
                  )
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              SmeModels opportunity = snapshot.data![index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: _buildOpportunityCard(opportunity),
                // child: ListTile(
                //   title: Text(opportunity.title),
                //   subtitle: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text(opportunity.industry),
                //       Text(
                //         'Funding: \$${opportunity.currentFunding} / \$${opportunity.fundingGoal}',
                //       ),
                //     ],
                //   ),
                //   trailing: Text(
                //     opportunity.currentFunding.toString(),
                //     style: TextStyle(
                //       color: _getStatusColor(
                //           opportunity.currentFunding.toString()),
                //     ),
                //   ),
                // ),
              );
            },
          );
        },
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'draft':
        return Colors.grey;
      case 'submitted':
        return Colors.orange;
      case 'under_review':
        return Colors.blue;
      case 'approved':
        return Colors.green;
      default:
        return Colors.black;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
