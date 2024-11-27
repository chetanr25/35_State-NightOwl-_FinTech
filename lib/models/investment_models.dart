import 'package:cloud_firestore/cloud_firestore.dart';

class InvestmentModel {
  final String id;
  final String smeId;
  final String investorId;
  final double amount;
  final String status;
  final Timestamp investmentDate;

  InvestmentModel({
    required this.id,
    required this.smeId,
    required this.investorId,
    required this.amount,
    required this.status,
    required this.investmentDate,
  });

  factory InvestmentModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return InvestmentModel(
      id: doc.id,
      smeId: data['smeId'] ?? '',
      investorId: data['investorId'] ?? '',
      amount: (data['amount'] ?? 0.0).toDouble(),
      status: data['status'] ?? 'pending',
      investmentDate: data['investmentDate'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'smeId': smeId,
      'investorId': investorId,
      'amount': amount,
      'status': status,
      'investmentDate': investmentDate,
    };
  }
}
