class UserModel {
  final int id;
  final String fullName;
  final String email;
  final String? phone;
  final String? cnic;
  final String? address;
  final String role; // 'customer', 'provider', 'admin'
  final DateTime? createdAt;
  final bool isBlocked;
  final String? profileImage;
  final String? status;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.phone,
    this.cnic,
    this.address,
    required this.role,
    this.createdAt,
    required this.isBlocked,
    this.profileImage,
    this.status,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      cnic: json['cnic'],
      address: json['address'],
      role: json['role'] ?? 'customer',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      isBlocked: json['is_blocked'] == 1 || json['is_blocked'] == true,
      profileImage: json['profile_image'],
      status: json['status'],
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
      'created_at': createdAt?.toIso8601String(),
      'is_blocked': isBlocked ? 1 : 0,
      'profile_image': profileImage,
      'status': status,
    };
  }

  UserModel copyWith({
    int? id,
    String? fullName,
    String? email,
    String? phone,
    String? cnic,
    String? address,
    String? role,
    DateTime? createdAt,
    bool? isBlocked,
    String? profileImage,
    String? status,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      cnic: cnic ?? this.cnic,
      address: address ?? this.address,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      isBlocked: isBlocked ?? this.isBlocked,
      profileImage: profileImage ?? this.profileImage,
      status: status ?? this.status,
    );
  }
}
