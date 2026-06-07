// models/service_detail_model.dart

class ProviderModel {
  final int id;
  final String name;
  final String phone;
  final double rating;
  final int jobsDone;
  final bool isAvailable;
  final String joinedDate;

  const ProviderModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.rating,
    required this.jobsDone,
    required this.isAvailable,
    required this.joinedDate,
  });

  factory ProviderModel.fromJson(Map<String, dynamic> json) {
    return ProviderModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      rating: (json['rating'] is num)
          ? (json['rating'] as num).toDouble()
          : double.tryParse(json['rating']?.toString() ?? '0') ?? 0.0,
      jobsDone: json['jobs_done'] is int
          ? json['jobs_done']
          : int.tryParse(json['jobs_done']?.toString() ?? '0') ?? 0,
      isAvailable: (json['is_available'] == 1 || json['is_available'] == true),
      joinedDate: json['joined_date'] ?? '',
    );
  }
}

class CustomerModel {
  final int id;
  final String name;
  final String phone;
  final int totalBookings;
  final String lastBooking;

  const CustomerModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.totalBookings,
    required this.lastBooking,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      totalBookings: json['total_bookings'] is int
          ? json['total_bookings']
          : int.tryParse(json['total_bookings']?.toString() ?? '0') ?? 0,
      lastBooking: json['last_booking'] ?? '',
    );
  }
}

class ServiceDetailModel {
  final int serviceId;
  final String serviceName;
  final String serviceIcon;
  final String category;
  final int price;
  final bool isActive;
  final int providerCount;
  final int customerCount;
  final int totalBookings;
  final double avgRating;
  final List<ProviderModel> providers;
  final List<CustomerModel> customers;

  const ServiceDetailModel({
    required this.serviceId,
    required this.serviceName,
    required this.serviceIcon,
    required this.category,
    required this.price,
    required this.isActive,
    required this.providerCount,
    required this.customerCount,
    required this.totalBookings,
    required this.avgRating,
    required this.providers,
    required this.customers,
  });

  factory ServiceDetailModel.fromJson(Map<String, dynamic> json) {
    return ServiceDetailModel(
      serviceId: json['service_id'] as int? ?? 0,
      serviceName: json['service_name'] ?? '',
      serviceIcon: json['service_icon'] ?? '🔧',
      category: json['category'] ?? '',
      price: json['price'] is int
          ? json['price']
          : int.tryParse(json['price']?.toString() ?? '0') ?? 0,
      isActive: (json['is_active'] == 1 || json['is_active'] == true),
      providerCount: json['provider_count'] is int
          ? json['provider_count']
          : int.tryParse(json['provider_count']?.toString() ?? '0') ?? 0,
      customerCount: json['customer_count'] is int
          ? json['customer_count']
          : int.tryParse(json['customer_count']?.toString() ?? '0') ?? 0,
      totalBookings: json['total_bookings'] is int
          ? json['total_bookings']
          : int.tryParse(json['total_bookings']?.toString() ?? '0') ?? 0,
      avgRating: (json['avg_rating'] is num)
          ? (json['avg_rating'] as num).toDouble()
          : double.tryParse(json['avg_rating']?.toString() ?? '0') ?? 0.0,
      providers: (json['providers'] as List<dynamic>? ?? [])
          .map((e) => ProviderModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      customers: (json['customers'] as List<dynamic>? ?? [])
          .map((e) => CustomerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
