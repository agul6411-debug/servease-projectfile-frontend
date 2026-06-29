class ReviewModel {
  final int id;
  final int bookingId;
  final int customerId;
  final int providerId;
  final String? customerName;
  final double rating;
  final String? note;
  final String? createdAt;

  ReviewModel({
    required this.id,
    required this.bookingId,
    required this.customerId,
    required this.providerId,
    this.customerName,
    required this.rating,
    this.note,
    this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      bookingId: json['booking_id'] is int ? json['booking_id'] : int.parse((json['booking_id'] ?? 0).toString()),
      customerId: json['customer_id'] is int ? json['customer_id'] : int.parse((json['customer_id'] ?? 0).toString()),
      providerId: json['provider_id'] is int ? json['provider_id'] : int.parse((json['provider_id'] ?? 0).toString()),
      customerName: json['customer_name'] ?? json['customerName'],
      rating: json['rating'] is num ? (json['rating'] as num).toDouble() : double.parse((json['rating'] ?? 0.0).toString()),
      note: json['note'],
      createdAt: json['created_at'] ?? json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'booking_id': bookingId,
      'customer_id': customerId,
      'provider_id': providerId,
      'customer_name': customerName,
      'rating': rating,
      'note': note,
      'created_at': createdAt,
    };
  }
}
