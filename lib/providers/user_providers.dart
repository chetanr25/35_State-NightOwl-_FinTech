import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_models.dart';

final userProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(UserState()) {
    // Initialize by listening to Firebase Auth changes
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        _loadUserData(user.uid);
      } else {
        state = UserState();
      }
    });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _loadUserData(String uid) async {
    try {
      final docSnapshot = await _firestore.collection('users').doc(uid).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data()!;
        state = UserState(
          userId: uid,
          username: data['username'],
          email: data['email'],
          userType: data['userType'],
          profileImageUrl: data['profileImageUrl'],
          isAuthenticated: true,
          phoneNumber: data['phoneNumber'],
          additionalData: data['additionalData'],
        );
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> updateUserProfile({
    String? username,
    String? userType,
    String? profileImageUrl,
    String? phoneNumber,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final uid = state.userId;
      if (uid == null) return;

      final updates = {
        if (username != null) 'username': username,
        if (userType != null) 'userType': userType,
        if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
        if (phoneNumber != null) 'phoneNumber': phoneNumber,
        if (additionalData != null) 'additionalData': additionalData,
      };

      await _firestore.collection('users').doc(uid).update(updates);

      state = state.copyWith(
        username: username ?? state.username,
        userType: userType != null
            ? UserType.values.firstWhere(
                (e) => e.toString().split('.').last == userType,
                orElse: () => state.userType!)
            : state.userType,
        profileImageUrl: profileImageUrl ?? state.profileImageUrl,
        phoneNumber: phoneNumber ?? state.phoneNumber,
        additionalData: additionalData ?? state.additionalData,
      );
    } catch (e) {
      print('Error updating user profile: $e');
      throw e;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      state = UserState();
    } catch (e) {
      print('Error signing out: $e');
      throw e;
    }
  }

  // Getter methods for easy access
  String? get username => state.username;
  UserType? get userType => state.userType;
  bool get isAuthenticated => state.isAuthenticated;
  bool get isInvestor => state.userType == UserType.investor;
  bool get isSME => state.userType == UserType.sme;
}
