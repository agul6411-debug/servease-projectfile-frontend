class UserDetailModel {
  final int id;
  final String fullName;
  final String email;
  final String? phone;
  final String? cnic;
  final String? address;
  final String role;
  final bool isBlocked;
  final String? profileImage;

  UserDetailModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
    this.cnic,
    this.address,
    required this.role,
    required this.isBlocked,
    this.profileImage,
  });

  factory UserDetailModel.fromJson(Map<String, dynamic> json) {
    return UserDetailModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      fullName: json['full_name'] ?? json['fullName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      cnic: json['cnic'],
      address: json['address'],
      role: json['role'] ?? '',
      isBlocked: json['is_blocked'] == 1 || json['is_blocked'] == true,
      profileImage: json['profile_image'] ?? json['profileImage'],
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
      'role': role,
      'is_blocked': isBlocked ? 1 : 0,
      'profile_image': profileImage,
    };
  }
}
