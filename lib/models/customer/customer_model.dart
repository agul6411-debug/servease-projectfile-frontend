// ── Service Model ─────────────────────────────────────────────────
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
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        icon: json['icon'] ?? '🔧',
        category: json['category'] ?? '',
        price: int.tryParse(json['price']?.toString() ?? '0') ?? 0,
      );
}

// ── Top Provider Model ────────────────────────────────────────────
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

// ── Home Data Model ───────────────────────────────────────────────
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

// ── Provider Detail Model ─────────────────────────────────────────
class ProviderDetail {
  final int id;
  final String name;
  final String service;
  final String category;
  final double rating;
  final int rate;
  final int jobsDone;
  final String location;
  final String bio;
  final bool isVerified;
  final List<String> servicesOffered;
  final List<ReviewModel> reviews;

  ProviderDetail({
    required this.id,
    required this.name,
    required this.service,
    required this.category,
    required this.rating,
    required this.rate,
    required this.jobsDone,
    required this.location,
    required this.bio,
    required this.isVerified,
    required this.servicesOffered,
    required this.reviews,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name.substring(0, 2).toUpperCase() : 'P';
  }

  factory ProviderDetail.fromJson(Map<String, dynamic> json) => ProviderDetail(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    service: json['service'] ?? '',
    category: json['category'] ?? '',
    rating: double.tryParse(json['rating']?.toString() ?? '0') ?? 0,
    rate: int.tryParse(json['rate']?.toString() ?? '0') ?? 0,
    jobsDone: int.tryParse(json['jobs_done']?.toString() ?? '0') ?? 0,
    location: json['location'] ?? '',
    bio: json['bio'] ?? '',
    isVerified: json['is_verified'] == 1 || json['is_verified'] == true,
    servicesOffered: List<String>.from(json['services_offered'] ?? []),
    reviews: (json['reviews'] as List? ?? [])
        .map((e) => ReviewModel.fromJson(e))
        .toList(),
  );
}

// ── Review Model ──────────────────────────────────────────────────
class ReviewModel {
  final String reviewerName;
  final double rating;
  final String comment;
  final bool isVerified;

  ReviewModel({
    required this.reviewerName,
    required this.rating,
    required this.comment,
    required this.isVerified,
  });

  String get initials {
    final parts = reviewerName.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return reviewerName.isNotEmpty
        ? reviewerName.substring(0, 2).toUpperCase()
        : 'U';
  }

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
    reviewerName: json['reviewer_name'] ?? '',
    rating: double.tryParse(json['rating']?.toString() ?? '0') ?? 0,
    comment: json['comment'] ?? '',
    isVerified: json['is_verified'] == 1 || json['is_verified'] == true,
  );
}

// ── Booking Model ─────────────────────────────────────────────────
class CustomerBooking {
  final int id;
  final String providerName;
  final String serviceName;
  final String scheduledDate;
  final String scheduledTime;
  final String status;
  final double totalPrice;

  CustomerBooking({
    required this.id,
    required this.providerName,
    required this.serviceName,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.status,
    required this.totalPrice,
  });

  String get initials {
    final parts = providerName.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return providerName.isNotEmpty
        ? providerName.substring(0, 2).toUpperCase()
        : 'P';
  }

  factory CustomerBooking.fromJson(Map<String, dynamic> json) {
    String formatDate(dynamic val) {
      if (val == null) return 'TBD';
      try {
        final date = DateTime.parse(val.toString()).toLocal();
        return '${date.day} ${['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][date.month - 1]}';
      } catch (_) {
        return val.toString();
      }
    }

    return CustomerBooking(
      id: json['id'] ?? 0,
      providerName: json['provider_name'] ?? '',
      serviceName: json['service_name'] ?? '',
      scheduledDate: formatDate(json['scheduled_date']),
      scheduledTime: json['scheduled_time'] ?? '',
      status: json['status'] ?? '',
      totalPrice: double.tryParse(json['total_price']?.toString() ?? '0') ?? 0,
    );
  }
}
