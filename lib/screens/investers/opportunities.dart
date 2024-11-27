import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintech/core/constants.dart';
import 'package:fintech/models/sme_models.dart';
import 'package:fintech/providers/user_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OpportunitiesScreen extends ConsumerStatefulWidget {
  const OpportunitiesScreen({super.key});

  @override
  _OpportunitiesScreenState createState() => _OpportunitiesScreenState();
}

class _OpportunitiesScreenState extends ConsumerState<OpportunitiesScreen> {
  // List<String> _industries = [
  //   'Technology',
  //   'Healthcare',
  //   'Finance',
  //   'Agriculture',
  //   'Education',
  //   'Retail'
  // ];

  List<String> _selectedIndustries = [];
  List<SmeModels> _opportunities = [];
  // List<Map<String, dynamic>> _opportunities = [];
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
      // print(snapshot.docs);

      List<SmeModels> smeList = [];

      // Convert each document to SmeModels
      for (var smeDoc in snapshot.docs) {
        smeList.add(SmeModels.fromFirestore(smeDoc));
      }
      // }
      print(smeList);
      setState(() {
        _opportunities = smeList;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching opportunities: $e');
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

  // Widget _buildOpportunityCard(SmeModels opportunity,
  //     {bool isRecommended = false}) {
  //   return Card(
  //     margin: EdgeInsets.all(8),
  //     color: isRecommended ? Colors.blue.shade50 : null,
  //     child: GestureDetector(
  //       onTap: () {},
  //       child: ListTile(
  //         title: Text(opportunity.title ?? 'Unknown'),
  //         subtitle: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Text(opportunity.industry ?? 'No industry specified'),
  //             if (isRecommended)
  //               Container(
  //                 margin: const EdgeInsets.only(top: 4),
  //                 padding:
  //                     const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
  //                 decoration: BoxDecoration(
  //                   color: Colors.blue,
  //                   borderRadius: BorderRadius.circular(12),
  //                 ),
  //                 child: Text(
  //                   'Recommended',
  //                   style: TextStyle(color: Colors.white, fontSize: 12),
  //                 ),
  //               ),
  //           ],
  //         ),
  //         trailing: Icon(Icons.arrow_forward_ios),
  //         onTap: () {
  //           // Handle opportunity selection
  //         },
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Investment Opportunities'),
        /*  bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: industries.map((industry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(industry),
                    selected: _selectedIndustries.contains(industry),
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          _selectedIndustries.add(industry);
                        } else {
                          _selectedIndustries.remove(industry);
                        }
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),
     */
      ),
      body: ListView(
        children: [
          if (_isLoading) const Center(child: CircularProgressIndicator()),
          ..._opportunities
              .map((opportunity) => _buildOpportunityCard(opportunity,
                  context: context, ref: ref))
              .toList(),
        ],
      ),
    );
  }

  // Widget _buildOpportunityCard(SmeModels opportunity,
  //     {bool isRecommended = false}) {
  //   return Card(child: Text(opportunity.title ?? 'Unknown'));
  // }
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
                              // await FirebaseFirestore.instance
                              //     .collection('smes')
                              //     .doc(opportunity.smeId)
                              //     .update({
                              //   'currentFunding':
                              //       FieldValue.increment(investmentAmount),
                              // });
                              FirebaseFirestore.instance
                                  .collection('smes')
                                  .doc(opportunity.smeId)
                                  .update({
                                'currentFunding':
                                    FieldValue.increment(investmentAmount),
                                'investments': FieldValue.arrayUnion([
                                  {
                                    'amount': investmentAmount,
                                    'timestamp': FieldValue.serverTimestamp(),
                                    'status': 'pending',
                                  },
                                ]),
                              });
                              // Create investment record
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
