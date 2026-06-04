class AdminDashboardModel {
  final int totalUsers;
  final int totalCustomers;
  final int totalProviders;
  final int totalServices;
  final int totalBookings;
  final int openComplaints;
  final int pendingProviders;

  AdminDashboardModel({
    required this.totalUsers,
    required this.totalCustomers,
    required this.totalProviders,
    required this.totalServices,
    required this.totalBookings,
    required this.openComplaints,
    required this.pendingProviders,
  });

  factory AdminDashboardModel.fromJson(Map<String, dynamic> json) {
    return AdminDashboardModel(
      totalUsers: json['totalUsers'] ?? 0,
      totalCustomers: json['totalCustomers'] ?? 0,
      totalProviders: json['totalProviders'] ?? 0,
      totalServices: json['totalServices'] ?? 0,
      totalBookings: json['totalBookings'] ?? 0,
      openComplaints: json['openComplaints'] ?? 0,
      pendingProviders: json['pendingProviders'] ?? 0,
    );
  }
}
