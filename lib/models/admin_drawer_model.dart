class AdminDrawerModel {
  final int pendingProviders;
  final int pendingComplaints;
  final int unreadNotifications;
  final int pendingCommissions;
  final String adminName;
  final String adminEmail;

  AdminDrawerModel({
    required this.pendingProviders,
    required this.pendingComplaints,
    required this.unreadNotifications,
    required this.adminName,
    required this.adminEmail,
    this.pendingCommissions = 0,
  });

  factory AdminDrawerModel.fromJson(Map<String, dynamic> json) {
    return AdminDrawerModel(
      pendingProviders: json['pendingProviders'] ?? 0,

      pendingComplaints: json['openComplaints'] ?? 0,

      unreadNotifications: json['unreadNotifications'] ?? 0,

      adminName: json['adminName'] ?? '',
      adminEmail: json['adminEmail'] ?? '',
      pendingCommissions: json['pendingCommissions'] ?? 0,
    );
  }
}
