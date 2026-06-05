class ProviderDashboardModel {
  final String providerName;
  final String providerInitials;
  final bool isCnicVerified;
  final int totalJobs;
  final int pendingJobs;
  final int doneJobs;
  final double earned;
  final CommissionModel commissionModel;
  final List<IncomingRequest> incomingRequests;

  ProviderDashboardModel({
    required this.providerName,
    required this.providerInitials,
    required this.isCnicVerified,
    required this.totalJobs,
    required this.pendingJobs,
    required this.doneJobs,
    required this.earned,
    required this.commissionModel,
    required this.incomingRequests,
  });

  factory ProviderDashboardModel.fromJson(Map<String, dynamic> json) {
    return ProviderDashboardModel(
      providerName: json['provider_name'] ?? '',
      providerInitials: json['provider_initials'] ?? '',
      isCnicVerified: json['is_cnic_verified'] ?? false,
      totalJobs: json['total_jobs'] ?? 0,
      pendingJobs: json['pending_jobs'] ?? 0,
      doneJobs: json['done_jobs'] ?? 0,
      earned: (json['earned'] ?? 0).toDouble(),
      commissionModel: CommissionModel.fromJson(json['commission_model'] ?? {}),
      incomingRequests: (json['incoming_requests'] as List<dynamic>? ?? [])
          .map((e) => IncomingRequest.fromJson(e))
          .toList(),
    );
  }
}

class CommissionModel {
  final String description;
  final double commissionRate;
  final int freeJobsCount;

  CommissionModel({
    required this.description,
    required this.commissionRate,
    required this.freeJobsCount,
  });

  factory CommissionModel.fromJson(Map<String, dynamic> json) {
    return CommissionModel(
      description: json['description'] ?? '',
      commissionRate: (json['commission_rate'] ?? 0).toDouble(),
      freeJobsCount: json['free_jobs_count'] ?? 2,
    );
  }
}

class IncomingRequest {
  final String jobId;
  final String customerName;
  final String scheduledDate;
  final String scheduledTime;
  final String location;
  final double amount;
  final String status;

  IncomingRequest({
    required this.jobId,
    required this.customerName,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.location,
    required this.amount,
    required this.status,
  });

  factory IncomingRequest.fromJson(Map<String, dynamic> json) {
    return IncomingRequest(
      jobId: json['job_id'] ?? '',
      customerName: json['customer_name'] ?? '',
      scheduledDate: json['scheduled_date'] ?? '',
      scheduledTime: json['scheduled_time'] ?? '',
      location: json['location'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      status: json['status'] ?? 'Pending',
    );
  }
}
