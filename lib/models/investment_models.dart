import 'package:cloud_firestore/cloud_firestore.dart';

class InvestmentModel {
  final String smeId;
  final double amount;
  final String status;
  final Timestamp timestamp;
  final String businessPlan;
  final String title;
  final String description;
  final String industry;
  final List<dynamic> tags;

  InvestmentModel({
    required this.smeId,
    required this.amount,
    required this.status,
    required this.timestamp,
    required this.businessPlan,
    required this.title,
    required this.description,
    required this.industry,
    required this.tags,
  });

  factory InvestmentModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return InvestmentModel(
      smeId: data['smeId'] ?? '',
      amount: (data['amount'] ?? 0.0).toDouble(),
      status: data['status'] ?? 'pending',
      timestamp: data['timestamp'] ?? Timestamp.now(),
      businessPlan: data['businessPlan'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      industry: data['industry'] ?? '',
      tags: data['tags'] ?? {},
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'smeId': smeId,
      'amount': amount,
      'status': status,
      'timestamp': timestamp,
      'businessPlan': businessPlan,
      'title': title,
      'description': description,
      'industry': industry,
      'tags': tags,
    };
  }
}
