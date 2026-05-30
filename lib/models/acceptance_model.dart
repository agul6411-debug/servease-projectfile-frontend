class AcceptanceModel {
  final int id;
  final String fullName;
  final String email;
  final String cnicImage;
  final String status;

  AcceptanceModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.cnicImage,
    required this.status,
  });

  factory AcceptanceModel.fromJson(Map<String, dynamic> json) {
    return AcceptanceModel(
      id: json['id'],
      fullName: json['full_name'] ?? "",
      email: json['email'] ?? "",
      cnicImage: json['cnic_image'] ?? "",
      status: json['approval_status'] ?? "",
    );
  }
}
