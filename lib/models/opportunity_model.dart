import 'package:cloud_firestore/cloud_firestore.dart';

class OpportunityModel {
  final String id;
  final String smeId;
  final String companyName;
  final String industry;
  final double fundingNeeded;
  final double fundingCurrent;
  final double minInvestment;
  final String pitchDescription;
  final String risksAndChallenges;
  final String status;

  OpportunityModel({
    required this.id,
    required this.smeId,
    required this.companyName,
    required this.industry,
    required this.fundingNeeded,
    required this.fundingCurrent,
    required this.minInvestment,
    required this.pitchDescription,
    required this.risksAndChallenges,
    required this.status,
  });

  factory OpportunityModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return OpportunityModel(
      id: doc.id,
      smeId: data['smeId'] ?? '',
      companyName: data['companyName'] ?? '',
      industry: data['industry'] ?? '',
      fundingNeeded: (data['fundingNeeded'] ?? 0.0).toDouble(),
      fundingCurrent: (data['fundingCurrent'] ?? 0.0).toDouble(),
      minInvestment: (data['minInvestment'] ?? 0.0).toDouble(),
      pitchDescription: data['pitchDescription'] ?? '',
      risksAndChallenges: data['risksAndChallenges'] ?? '',
      status: data['status'] ?? 'open',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'smeId': smeId,
      'companyName': companyName,
      'industry': industry,
      'fundingNeeded': fundingNeeded,
      'fundingCurrent': fundingCurrent,
      'minInvestment': minInvestment,
      'pitchDescription': pitchDescription,
      'risksAndChallenges': risksAndChallenges,
      'status': status,
    };
  }
}
