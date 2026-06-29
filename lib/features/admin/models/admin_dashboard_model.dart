class AdminDashboardModel {
  final int totalUsers;
  final int totalCustomers;
  final int totalProviders;
  final int totalServices;
  final int totalBookings;
  final int openComplaints;
  final int pendingProviders;
  final double commissionEarned;
  final int securityDeposits;
  final double securityAmount;
  final double totalEarnings;
  final int resolvedComplaints;
  final int totalComplaints;

  AdminDashboardModel({
    required this.totalUsers,
    required this.totalCustomers,
    required this.totalProviders,
    required this.totalServices,
    required this.totalBookings,
    required this.openComplaints,
    required this.pendingProviders,
    required this.commissionEarned,
    required this.securityDeposits,
    required this.securityAmount,
    required this.totalEarnings,
    required this.resolvedComplaints,
    required this.totalComplaints,
  });

  factory AdminDashboardModel.fromJson(Map<String, dynamic> json) =>
      AdminDashboardModel(
        totalUsers: json['totalUsers'] ?? 0,
        totalCustomers: json['totalCustomers'] ?? 0,
        totalProviders: json['totalProviders'] ?? 0,
        totalServices: json['totalServices'] ?? 0,
        totalBookings: json['totalBookings'] ?? 0,
        openComplaints: json['openComplaints'] ?? 0,
        pendingProviders: json['pendingProviders'] ?? 0,
        commissionEarned: double.parse(
          json['commissionEarned']?.toString() ?? '0',
        ),
        securityDeposits: json['securityDeposits'] ?? 0,
        securityAmount: double.parse(json['securityAmount']?.toString() ?? '0'),
        totalEarnings: double.parse(json['totalEarnings']?.toString() ?? '0'),
        resolvedComplaints: json['resolvedComplaints'] ?? 0,
        totalComplaints: json['totalComplaints'] ?? 0,
      );
}
