class BookingModel {
  final int id;
  final int providerId;
  final String? customerName;
  final String? providerName;
  final String? serviceName;
  final String status;
  final String scheduledDate;
  final String scheduledTime;
  final String location;
  final double totalPrice;
  final String? createdAt;

  BookingModel({
    required this.id,
    required this.providerId,
    this.customerName,
    this.providerName,
    this.serviceName,
    required this.status,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.location,
    required this.totalPrice,
    this.createdAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      providerId: json['provider_id'] is int ? json['provider_id'] : int.parse((json['provider_id'] ?? 0).toString()),
      customerName: json['customer_name'] ?? json['customerName'],
      providerName: json['provider_name'] ?? json['providerName'],
      serviceName: json['service_name'] ?? json['serviceName'],
      status: json['status'] ?? 'pending',
      scheduledDate: json['scheduled_date'] ?? json['scheduledDate'] ?? '',
      scheduledTime: json['scheduled_time'] ?? json['scheduledTime'] ?? '',
      location: json['location'] ?? '',
      totalPrice: json['total_price'] is num ? (json['total_price'] as num).toDouble() : double.parse((json['total_price'] ?? 0.0).toString()),
      createdAt: json['created_at'] ?? json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'provider_id': providerId,
      'customer_name': customerName,
      'provider_name': providerName,
      'service_name': serviceName,
      'status': status,
      'scheduled_date': scheduledDate,
      'scheduled_time': scheduledTime,
      'location': location,
      'total_price': totalPrice,
      'created_at': createdAt,
    };
  }
}
