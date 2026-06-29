class ProviderVerificationModel {
  final int id;
  final String fullName;
  final String email;
  final String phone;
  final String? cnicFrontImage;
  final String? cnicBackImage;
  final String? bio;
  final int? yearsOfExperience;
  final String approvalStatus;

  ProviderVerificationModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    this.cnicFrontImage,
    this.cnicBackImage,
    this.bio,
    this.yearsOfExperience,
    required this.approvalStatus,
  });

  factory ProviderVerificationModel.fromJson(Map<String, dynamic> json) {
    return ProviderVerificationModel(
      id: json['id'],
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      cnicFrontImage: json['cnic_front_image'],
      cnicBackImage: json['cnic_back_image'],
      bio: json['bio'],
      yearsOfExperience: json['years_of_experience'],
      approvalStatus: json['approval_status'] ?? 'pending',
    );
  }

  String get initials {
    final parts = fullName.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';
  }

  String get providerIdLabel => 'ID: PV${id.toString().padLeft(3, '0')}';
}
