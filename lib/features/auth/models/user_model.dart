class UserModel {
  final int id;
  final String fullName;
  final String email;
  final String? phone;
  final String? cnic;
  final String? address;
  final String? age;
  final String role;
  final bool isBlocked;
  final String? profileImage;
  final String? createdAt;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
    this.cnic,
    this.address,
    this.age,
    required this.role,
    required this.isBlocked,
    this.profileImage,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      fullName: json['full_name'] ?? json['fullName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      cnic: json['cnic'],
      address: json['address'],
      age: json['age'],
      role: json['role'] ?? '',
      isBlocked: json['is_blocked'] == 1 || json['is_blocked'] == true,
      profileImage: json['profile_image'] ?? json['profileImage'],
      createdAt: json['created_at'] ?? json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'cnic': cnic,
      'address': address,
      'age': age,
      'role': role,
      'is_blocked': isBlocked ? 1 : 0,
      'profile_image': profileImage,
      'created_at': createdAt,
    };
  }
}
