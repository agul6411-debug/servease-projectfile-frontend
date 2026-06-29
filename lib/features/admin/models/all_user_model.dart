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

  // Provider-specific fields
  final int? yearsOfExperience;
  final String? bio;
  final String? cnicFrontImage;
  final String? cnicBackImage;
  final String? approvalStatus;
  final double? rating;
  final double? hourlyRate;
  final String? securityDepositStatus;
  final String? securityDepositScreenshot;
  final String? securityDepositMethod;
  final double? pendingCommission;
  final double? commissionRate;

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
    this.yearsOfExperience,
    this.bio,
    this.cnicFrontImage,
    this.cnicBackImage,
    this.approvalStatus,
    this.rating,
    this.hourlyRate,
    this.securityDepositStatus,
    this.securityDepositScreenshot,
    this.securityDepositMethod,
    this.pendingCommission,
    this.commissionRate,
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
      yearsOfExperience: json['years_of_experience'] is int
          ? json['years_of_experience']
          : int.tryParse(json['years_of_experience'].toString()),
      bio: json['bio'],
      cnicFrontImage: json['cnic_front_image'],
      cnicBackImage: json['cnic_back_image'],
      approvalStatus: json['approval_status'],
      rating: json['rating'] != null
          ? double.tryParse(json['rating'].toString())
          : null,
      hourlyRate: json['hourly_rate'] != null
          ? double.tryParse(json['hourly_rate'].toString())
          : null,
      securityDepositStatus: json['security_deposit_status'],
      securityDepositScreenshot: json['security_deposit_screenshot'],
      securityDepositMethod: json['security_deposit_method'],
      pendingCommission: json['pending_commission'] != null
          ? double.tryParse(json['pending_commission'].toString())
          : null,
      commissionRate: json['commission_rate'] != null
          ? double.tryParse(json['commission_rate'].toString())
          : null,
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
      'years_of_experience': yearsOfExperience,
      'bio': bio,
      'cnic_front_image': cnicFrontImage,
      'cnic_back_image': cnicBackImage,
      'approval_status': approvalStatus,
      'rating': rating,
      'hourly_rate': hourlyRate,
      'security_deposit_status': securityDepositStatus,
      'security_deposit_screenshot': securityDepositScreenshot,
      'security_deposit_method': securityDepositMethod,
      'pending_commission': pendingCommission,
      'commission_rate': commissionRate,
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
    int? yearsOfExperience,
    String? bio,
    String? cnicFrontImage,
    String? cnicBackImage,
    String? approvalStatus,
    double? rating,
    double? hourlyRate,
    String? securityDepositStatus,
    String? securityDepositScreenshot,
    String? securityDepositMethod,
    double? pendingCommission,
    double? commissionRate,
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
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      bio: bio ?? this.bio,
      cnicFrontImage: cnicFrontImage ?? this.cnicFrontImage,
      cnicBackImage: cnicBackImage ?? this.cnicBackImage,
      approvalStatus: approvalStatus ?? this.approvalStatus,
      rating: rating ?? this.rating,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      securityDepositStatus: securityDepositStatus ?? this.securityDepositStatus,
      securityDepositScreenshot: securityDepositScreenshot ?? this.securityDepositScreenshot,
      securityDepositMethod: securityDepositMethod ?? this.securityDepositMethod,
      pendingCommission: pendingCommission ?? this.pendingCommission,
      commissionRate: commissionRate ?? this.commissionRate,
    );
  }
}
