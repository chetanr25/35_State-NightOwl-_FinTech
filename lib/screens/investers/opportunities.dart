// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, unused_element, invalid_use_of_visible_for_testing_member

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintech/models/sme_models.dart';
import 'package:fintech/providers/user_providers.dart';
import 'package:fintech/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OpportunitiesScreen extends ConsumerStatefulWidget {
  const OpportunitiesScreen({super.key});

  @override
  _OpportunitiesScreenState createState() => _OpportunitiesScreenState();
}

class _OpportunitiesScreenState extends ConsumerState<OpportunitiesScreen> {
  final List<String> _selectedIndustries = [];
  List<SmeModels> _opportunities = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchOpportunities();
  }

  Future<void> _fetchOpportunities() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('smes').get();

      List<SmeModels> smeList = [];

      for (var smeDoc in snapshot.docs) {
        smeList.add(SmeModels.fromFirestore(smeDoc));
      }
      // }

      setState(() {
        _opportunities = smeList;
        _isLoading = false;
      });
    } catch (e) {
      showSnackBar(context, 'Error fetching opportunities: $e');

      setState(() {
        _isLoading = false;
      });
    }
  }

  List<SmeModels> get _recommendedOpportunities {
    if (_selectedIndustries.isEmpty) return [];
    return _opportunities.where((opp) {
      return _selectedIndustries.contains(opp.industry);
    }).toList();
  }

  List<SmeModels> get _otherOpportunities {
    if (_selectedIndustries.isEmpty) return _opportunities;
    return _opportunities.where((opp) {
      return !_selectedIndustries.contains(opp.industry);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Investment Opportunities'),
      ),
      body: ListView.builder(
        itemCount: _opportunities.length,
        itemBuilder: (context, index) {
          return _buildOpportunityCard(
            _opportunities[index],
            context: context,
            ref: ref,
          );
        },
      ),
    );
  }
}

Widget _buildOpportunityCard(SmeModels opportunity,
    {bool isRecommended = false,
    required BuildContext context,
    required WidgetRef ref}) {
  return Card(
    color: Colors.grey[800],
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isRecommended)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Recommended',
                style: TextStyle(color: Colors.white),
              ),
            ),
          const SizedBox(height: 8),
          Text(
            opportunity.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            opportunity.description,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Industry: ${opportunity.industry}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Funding Goal: \$${opportunity.fundingGoal.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Current: \$${opportunity.currentFunding.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${((opportunity.currentFunding / opportunity.fundingGoal) * 100).toStringAsFixed(1)}% Funded',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (opportunity.tags.isNotEmpty) ...[
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: opportunity.tags.map((tag) {
                return Chip(
                  label: Text(tag),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  double investmentAmount = 0;
                  return AlertDialog(
                    title: const Text('Make Investment'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Investment Amount (\$)',
                          ),
                          onChanged: (value) {
                            investmentAmount = double.tryParse(value) ?? 0;
                          },
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          if (investmentAmount <= 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please enter a valid amount'),
                              ),
                            );
                            return;
                          }

                          try {
                          
                            if (opportunity.currentFunding + investmentAmount <=
                                opportunity.fundingGoal) {
                              await FirebaseFirestore.instance
                                  .collection('smes')
                                  .doc(opportunity.smeId)
                                  .update({
                                'currentFunding':
                                    FieldValue.increment(investmentAmount),
                                'investments': FieldValue.arrayUnion([
                                  {
                                    'investor':
                                        // ignore: invalid_use_of_protected_member
                                        ref
                                            .read(userProvider.notifier)
                                            .state
                                            .email,
                                    'industryExpertise': ref
                                        .read(userProvider.notifier)
                                        .state
                                        .additionalData['industries'],
                                    'amount': investmentAmount,
                                    'timestamp':
                                        DateTime.now().toIso8601String(),
                                    'status': 'pending',
                                  },
                                ]),
                              });

                              await FirebaseFirestore.instance
                                  .collection('investments')
                                  .add({
                                'smeId': opportunity.smeId,
                                'amount': investmentAmount,
                                'timestamp': FieldValue.serverTimestamp(),
                                'status': 'pending',
                                'businessPlan': opportunity.businessPlan,
                                'title': opportunity.title,
                                'description': opportunity.description,
                                'industry': opportunity.industry,
                                'tags': opportunity.tags,
                                'investor':
                                    // ignore: invalid_use_of_protected_member
                                    ref.read(userProvider.notifier).state.email,
                              });
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Investment submitted successfully!'),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Investment amount exceeds funding goal'),
                                ),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error: ${e.toString()}'),
                              ),
                            );
                          }
                        },
                        child: const Text('Invest'),
                      ),
                    ],
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
            child: const Text('Invest Now'),
          ),
        ],
      ),
    ),
  );
}
