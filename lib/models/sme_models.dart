import 'package:cloud_firestore/cloud_firestore.dart';

class SmeModels {
  final String smeId;
  final String title;
  final String description;
  final double fundingGoal;
  final double currentFunding;
  final String industry;
  final List<String> tags;
  final DateTime createdAt;
  final String? businessPlan;
  final List<String> financialDocuments;
  final List<Map<String, dynamic>> investments;
  SmeModels({
    required this.smeId,
    required this.title,
    required this.description,
    required this.fundingGoal,
    this.currentFunding = 0.0,
    required this.industry,
    this.tags = const [],
    DateTime? createdAt,
    this.businessPlan,
    this.financialDocuments = const [],
    this.investments = const [],
  }) : createdAt = createdAt ?? DateTime.now();

  factory SmeModels.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return SmeModels(
      smeId: data['smeId'],
      title: data['title'],
      description: data['description'],
      fundingGoal: (data['fundingGoal'] as num).toDouble(),
      currentFunding: (data['currentFunding'] as num?)?.toDouble() ?? 0.0,
      industry: data['industry'],
      tags: List<String>.from(data['tags'] ?? []),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      businessPlan: data['businessPlan'],
      financialDocuments: List<String>.from(data['financialDocuments'] ?? []),
      investments: List<Map<String, dynamic>>.from(data['investments'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'smeId': smeId,
      'title': title,
      'description': description,
      'fundingGoal': fundingGoal,
      'currentFunding': currentFunding,
      'industry': industry,
      'tags': tags,
      'createdAt': createdAt,
      'businessPlan': businessPlan,
      'financialDocuments': financialDocuments,
    };
  }
}
