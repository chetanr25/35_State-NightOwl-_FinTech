import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fintech/core/constants.dart';
import 'package:fintech/models/sme_models.dart';
import 'package:flutter/material.dart';

class OpportunitiesScreen extends StatefulWidget {
  @override
  _OpportunitiesScreenState createState() => _OpportunitiesScreenState();
}

class _OpportunitiesScreenState extends State<OpportunitiesScreen> {
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
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'sme')
          .get();

      List<SmeModels> smeList = [];
      for (var doc in snapshot.docs) {
        // Get SME opportunities from Firestore
        final smeSnapshot = await FirebaseFirestore.instance
            .collection('opportunities')
            .where('smeId', isEqualTo: doc.id)
            .get();

        // Convert each document to SmeModels
        for (var smeDoc in smeSnapshot.docs) {
          smeList.add(SmeModels.fromFirestore(smeDoc));
        }
      }

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

  Widget _buildOpportunityCard(SmeModels opportunity,
      {bool isRecommended = false}) {
    return Card(
      margin: EdgeInsets.all(8),
      color: isRecommended ? Colors.blue.shade50 : null,
      child: ListTile(
        title: Text(opportunity.title ?? 'Unknown'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(opportunity.industry ?? 'No industry specified'),
            if (isRecommended)
              Container(
                margin: const EdgeInsets.only(top: 4),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Recommended',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          // Handle opportunity selection
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Investment Opportunities'),
        bottom: PreferredSize(
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
      ),
      body: ListView(
        children: [],
      ),
    );
  }
}
