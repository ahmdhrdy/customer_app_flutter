class User {
  final String token;
  final String userName;
  final int userId;
  final int comId;
  final String email;
  final String companyName;

  User({
    required this.token,
    required this.userName,
    required this.userId,
    required this.comId,
    required this.email,
    required this.companyName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      token: json['Token'] ?? '',
      userName: json['UserName'] ?? '',
      userId: json['UserId'] ?? 0,
      comId: json['ComId'] ?? 0,
      email: json['Email'] ?? '',
      companyName: json['CompanyName'] ?? '',
    );
  }
}