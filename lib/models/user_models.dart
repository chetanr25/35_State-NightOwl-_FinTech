enum UserType { sme, investor }

class UserState {
  final String? userId;
  final String? username;
  final String? email;
  final UserType? userType; // 'sme' or 'investor'
  final String? profileImageUrl;
  final bool isAuthenticated;
  final String? phoneNumber;
  final Map<String, dynamic>? additionalData;

  UserState({
    this.userId,
    this.username,
    this.email,
    this.userType,
    this.profileImageUrl,
    this.isAuthenticated = false,
    this.phoneNumber,
    this.additionalData,
  });

  UserState copyWith({
    String? userId,
    String? username,
    String? email,
    UserType? userType,
    String? profileImageUrl,
    bool? isAuthenticated,
    String? phoneNumber,
    Map<String, dynamic>? additionalData,
  }) {
    return UserState(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      email: email ?? this.email,
      userType: userType,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      additionalData: additionalData ?? this.additionalData,
    );
  }
}
