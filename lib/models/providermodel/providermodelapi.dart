class JobRequest {
  final int id;
  final String customerName;
  final String customerPhone;
  final String serviceType;
  final String scheduledDate;
  final String scheduledTime;
  final String location;
  final double price;
  final String status;
  final bool isNew;

  JobRequest({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.serviceType,
    required this.scheduledDate,
    required this.scheduledTime,
    required this.location,
    required this.price,
    required this.status,
    this.isNew = false,
  });

  String get initials {
    final parts = customerName.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return parts[0].substring(0, 2).toUpperCase();
  }

  factory JobRequest.fromJson(Map<String, dynamic> json) {
    String formatDate(dynamic val) {
      if (val == null) return 'TBD';
      try {
        final date = DateTime.parse(val.toString()).toLocal();
        return '${date.day} ${['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'][date.month - 1]} ${date.year}';
      } catch (_) {
        return val.toString();
      }
    }

    return JobRequest(
      id: json['id'],
      customerName: json['customer_name'] ?? '',
      customerPhone: json['customer_phone'] ?? '',
      serviceType: json['service_type'] ?? '',
      scheduledDate: formatDate(json['scheduled_date']),
      scheduledTime: json['scheduled_time'] ?? 'TBD',
      location: json['location'] ?? '',
      price: double.parse(json['price'].toString()),
      status: json['status'] ?? '',
      isNew: json['is_new'] == 1 || json['is_new'] == true,
    );
  }

  JobRequest copyWith({String? status}) => JobRequest(
    id: id,
    customerName: customerName,
    customerPhone: customerPhone,
    serviceType: serviceType,
    scheduledDate: scheduledDate,
    scheduledTime: scheduledTime,
    location: location,
    price: price,
    status: status ?? this.status,
    isNew: isNew,
  );
}

class DashboardStats {
  final int newRequests;
  final double earningsThisMonth;
  final int jobsDone;
  final double rating;
  final int totalJobsCompleted;
  final double commissionRate;
  final double pendingCommission;
  final String providerName;

  DashboardStats({
    required this.newRequests,
    required this.earningsThisMonth,
    required this.jobsDone,
    required this.rating,
    required this.totalJobsCompleted,
    required this.commissionRate,
    required this.pendingCommission,
    required this.providerName,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) => DashboardStats(
    newRequests: json['new_requests'],
    earningsThisMonth: double.parse(json['earnings_this_month'].toString()),
    jobsDone: json['jobs_done'],
    rating: double.parse(json['rating'].toString()),
    totalJobsCompleted: json['total_jobs_completed'],
    commissionRate: double.parse(json['commission_rate'].toString()),
    pendingCommission: double.parse(json['pending_commission'].toString()),
    providerName: json['provider_name'],
  );
}

class CommissionStatus {
  final double amount;
  final int completedJobs;
  final double rate;
  final String paymentStatus;

  CommissionStatus({
    required this.amount,
    required this.completedJobs,
    required this.rate,
    required this.paymentStatus,
  });

  factory CommissionStatus.fromJson(Map<String, dynamic> json) =>
      CommissionStatus(
        amount: double.parse(json['amount'].toString()),
        completedJobs: json['completed_jobs'],
        rate: double.parse(json['rate'].toString()),
        paymentStatus: json['payment_status'] ?? 'pending',
      );
}
