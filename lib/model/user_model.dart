class UserModel {
  final String userId;
  final String name;
  final String phone;
  final String username;
  // final String otp;

  UserModel({
    required this.userId,
    required this.name,
    required this.phone,
    required this.username,
    // required this.otp,
  });

  // Factory constructor to create an instance from a JSON map
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      phone: json['phone_no'] ?? '',
      username: json['email'] ?? '',
      // otp: json['otp']?.toString() ?? ''
    );
  }

  // Method to convert an instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'phone': phone,
      'username': username,
      // 'otp': otp,
    };
  }
}
