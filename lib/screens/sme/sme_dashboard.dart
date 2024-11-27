import 'package:fintech/models/sme_models.dart';
import 'package:fintech/screens/sme/2_sme_application.dart';
import 'package:fintech/screens/sme/sme_application_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SmeDashboard extends StatefulWidget {
  @override
  _SmeDashboardState createState() => _SmeDashboardState();
}

class _SmeDashboardState extends State<SmeDashboard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    print('initState hehe');
  }

  Stream<List<SmeModels>> _getSmeOpportunities() {
    User? currentUser = _auth.currentUser;
    print('currentUser hehe');
    // if (currentUser == null) return Stream.value([]);
    // final x = currentUser.uid;
    // print(x);
    final y = _firestore
        .collection('smes')
        // .where('smeId', isEqualTo: currentUser.uid)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => SmeModels.fromFirestore(doc)).toList());
    print(y);
    return y;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SME Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SmeApplicationScreen()));
              // Replace with your navigation method
            },
          )
        ],
      ),
      body: StreamBuilder<List<SmeModels>>(
        stream: _getSmeOpportunities(),
        builder: (context, snapshot) {
          // print();
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('No opportunities created yet'),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SmeApplicationPage()));
                    },
                    child: Text('Create New Opportunity'),
                  )
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              SmeModels opportunity = snapshot.data![index];
              print(opportunity.title);
              print(opportunity.description);
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(opportunity.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(opportunity.industry),
                      Text(
                        'Funding: \$${opportunity.currentFunding} / \$${opportunity.fundingGoal}',
                      ),
                    ],
                  ),
                  // trailing: Text(
                  //   opportunity..status ?? 'N/A',
                  //   style: TextStyle(
                  //     color: _getStatusColor(opportunity.status),
                  //   ),
                  // ),
                ),
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
}
