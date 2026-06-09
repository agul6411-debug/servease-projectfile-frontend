class CustomerService {
  final int id;
  final String name;
  final String icon;
  final String category;
  final int price;

  CustomerService({
    required this.id,
    required this.name,
    required this.icon,
    required this.category,
    required this.price,
  });

  factory CustomerService.fromJson(Map<String, dynamic> json) =>
      CustomerService(
        id: json['id'],
        name: json['name'] ?? '',
        icon: json['icon'] ?? '🔧',
        category: json['category'] ?? '',
        price: int.tryParse(json['price']?.toString() ?? '0') ?? 0,
      );
}

class TopProvider {
  final int id;
  final String name;
  final String service;
  final String category;
  final double rating;
  final int rate;
  final int jobsDone;
  final bool isVerified;
  final bool isNew;

  TopProvider({
    required this.id,
    required this.name,
    required this.service,
    required this.category,
    required this.rating,
    required this.rate,
    required this.jobsDone,
    required this.isVerified,
    required this.isNew,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name.substring(0, 2).toUpperCase() : 'P';
  }

  factory TopProvider.fromJson(Map<String, dynamic> json) => TopProvider(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    service: json['service'] ?? '',
    category: json['category'] ?? '',
    rating: double.tryParse(json['rating']?.toString() ?? '0') ?? 0,
    rate: int.tryParse(json['rate']?.toString() ?? '0') ?? 0,
    jobsDone: int.tryParse(json['jobs_done']?.toString() ?? '0') ?? 0,
    isVerified: json['is_verified'] == 1 || json['is_verified'] == true,
    isNew: json['is_new'] == 1 || json['is_new'] == true,
  );
}

class CustomerHomeData {
  final String customerName;
  final String city;
  final List<CustomerService> services;
  final List<TopProvider> topProviders;

  CustomerHomeData({
    required this.customerName,
    required this.city,
    required this.services,
    required this.topProviders,
  });

  factory CustomerHomeData.fromJson(Map<String, dynamic> json) =>
      CustomerHomeData(
        customerName: json['customer_name'] ?? 'Customer',
        city: json['city'] ?? '',
        services: (json['services'] as List? ?? [])
            .map((e) => CustomerService.fromJson(e))
            .toList(),
        topProviders: (json['top_providers'] as List? ?? [])
            .map((e) => TopProvider.fromJson(e))
            .toList(),
      );
}
