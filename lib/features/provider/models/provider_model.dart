class ProviderModel {
  final int id;
  final String name;
  final String? service;
  final String? category;
  final double rating;
  final double? rate;
  final int jobsDone;
  final String approvalStatus;
  final bool isNew;

  ProviderModel({
    required this.id,
    required this.name,
    this.service,
    this.category,
    required this.rating,
    this.rate,
    required this.jobsDone,
    required this.approvalStatus,
    required this.isNew,
  });

  factory ProviderModel.fromJson(Map<String, dynamic> json) {
    return ProviderModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      name: json['name'] ?? json['full_name'] ?? '',
      service: json['service'] ?? json['service_name'],
      category: json['category'],
      rating: json['rating'] is num ? (json['rating'] as num).toDouble() : double.parse((json['rating'] ?? 0.0).toString()),
      rate: json['rate'] is num ? (json['rate'] as num).toDouble() : (json['rate'] != null ? double.parse(json['rate'].toString()) : null),
      jobsDone: json['jobs_done'] is int ? json['jobs_done'] : int.parse((json['jobs_done'] ?? 0).toString()),
      approvalStatus: json['approval_status'] ?? 'pending',
      isNew: json['is_new'] == 1 || json['is_new'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'service': service,
      'category': category,
      'rating': rating,
      'rate': rate,
      'jobs_done': jobsDone,
      'approval_status': approvalStatus,
      'is_new': isNew ? 1 : 0,
    };
  }
}
