// models/service_model.dart

class ServiceModel {
  final int? dbId;
  final String name;
  final String description;
  final int price;
  final String category;
  final String icon;
  final bool isActive;
  final int providerCount;
  final int customerCount;

  const ServiceModel({
    this.dbId,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.icon,
    this.isActive = true,
    this.providerCount = 0,
    this.customerCount = 0,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      dbId: json['id'] as int?,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] is int
          ? json['price']
          : int.tryParse(json['price'].toString()) ?? 0,
      category: json['category'] ?? 'Other',
      icon: json['icon'] ?? '🔧',
      isActive: (json['is_active'] == 1 || json['is_active'] == true),
      providerCount: json['provider_count'] is int
          ? json['provider_count']
          : int.tryParse(json['provider_count']?.toString() ?? '0') ?? 0,
      customerCount: json['customer_count'] is int
          ? json['customer_count']
          : int.tryParse(json['customer_count']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': dbId,
    'name': name,
    'description': description,
    'price': price,
    'category': category,
    'icon': icon,
    'is_active': isActive,
    'provider_count': providerCount,
    'customer_count': customerCount,
  };

  ServiceModel copyWith({
    int? dbId,
    String? name,
    String? description,
    int? price,
    String? category,
    String? icon,
    bool? isActive,
    int? providerCount,
    int? customerCount,
  }) => ServiceModel(
    dbId: dbId ?? this.dbId,
    name: name ?? this.name,
    description: description ?? this.description,
    price: price ?? this.price,
    category: category ?? this.category,
    icon: icon ?? this.icon,
    isActive: isActive ?? this.isActive,
    providerCount: providerCount ?? this.providerCount,
    customerCount: customerCount ?? this.customerCount,
  );
}
