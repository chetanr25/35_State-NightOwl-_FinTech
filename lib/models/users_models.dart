import 'package:cloud_firestore/cloud_firestore.dart';

enum UserType { sme, investor }

class UserModel {
  final String id;
  final String email;
  final String name;
  final UserType userType;
  final String? companyName;
  final String? industry;
  final String? profileImageUrl;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.userType,
    this.companyName,
    this.industry,
    this.profileImageUrl,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      email: data['email'],
      name: data['name'],
      userType: UserType.values.firstWhere(
        (e) => e.toString() == 'UserType.${data['userType']}',
      ),
      companyName: data['companyName'],
      industry: data['industry'],
      profileImageUrl: data['profileImageUrl'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'userType': userType.toString().split('.').last,
      'companyName': companyName,
      'industry': industry,
      'profileImageUrl': profileImageUrl,
      'createdAt': createdAt,
    };
  }

  static UserModel dummyUser({UserType? type}) {
    return UserModel(
      id: 'dummy-user-123',
      email: 'test@example.com',
      name: 'John Doe',
      userType: type ?? UserType.sme,
      companyName: 'Test Company Ltd',
      industry: 'Technology',
      profileImageUrl: 'https://picsum.photos/200',
      createdAt: DateTime(2024, 1, 1),
    );
  }
}
