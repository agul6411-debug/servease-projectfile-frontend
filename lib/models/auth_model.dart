class AuthModel {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String? serviceCategory;
  final String? city;
  final String token;

  AuthModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.serviceCategory,
    this.city,
    required this.token,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      role: json['role'],
      serviceCategory: json['service_category'],
      city: json['city'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'service_category': serviceCategory,
      'city': city,
      'token': token,
    };
  }
}