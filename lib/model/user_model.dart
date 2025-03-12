class UserModel {
  final String userId;
  final String name;
  final String phone;
  final String username;
  final String otp;

  UserModel({
    required this.userId,
    required this.name,
    required this.phone,
    required this.username,
    required this.otp,
  });

  // Factory constructor to create an instance from a JSON map
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        userId: json['id'] ?? '',
        name: json['name'] ?? '',
        phone: json['phone'] ?? '',
        username: json['username'] ?? '',
        otp: json['otp'] ?? '');
  }

  // Method to convert an instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'phone': phone,
      'username': username,
      'otp': otp,
    };
  }
}
