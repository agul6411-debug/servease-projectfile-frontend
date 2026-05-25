class AdminProfileModel {
  final int id;
  final String fullName;
  final String email;
  final String phone;
  final String? profileImage;

  AdminProfileModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    this.profileImage,
  });

  factory AdminProfileModel.fromJson(Map<String, dynamic> json) {
    return AdminProfileModel(
      id: json['id'],
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      profileImage: json['profile_image'],
    );
  }
}
