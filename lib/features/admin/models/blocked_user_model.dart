class BlockedUserModel {
  final int id;
  final String fullName;
  final String email;
  final String role;

  BlockedUserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
  });

  factory BlockedUserModel.fromJson(Map<String, dynamic> json) {
    return BlockedUserModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      fullName: json['full_name'] ?? json['fullName'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'role': role,
    };
  }
}
