class ProviderVerificationModel {
  final int id;

  final String fullName;

  final String email;

  final String phone;

  final String? cnicImage;

  final String? bio;

  final int yearsOfExperience;

  final String approvalStatus;

  ProviderVerificationModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.cnicImage,
    required this.bio,
    required this.yearsOfExperience,
    required this.approvalStatus,
  });

  factory ProviderVerificationModel.fromJson(Map<String, dynamic> json) {
    return ProviderVerificationModel(
      id: json["id"],
      fullName: json["full_name"] ?? "",
      email: json["email"] ?? "",
      phone: json["phone"] ?? "",
      cnicImage: json["cnic_image"],
      bio: json["bio"],
      yearsOfExperience: json["years_of_experience"] ?? 0,
      approvalStatus: json["approval_status"] ?? "",
    );
  }
}
