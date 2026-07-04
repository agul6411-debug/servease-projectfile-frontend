import 'package:flutter/material.dart';
import 'package:frontfile_servease/core/theme/app_theme.dart';
import 'package:frontfile_servease/features/admin/models/acceptance_model.dart';
import 'package:frontfile_servease/features/admin/services/acceptance_service.dart';
import 'package:frontfile_servease/features/admin/screens/admindrawer.dart';
import 'package:frontfile_servease/features/admin/screens/admin_navbar.dart';
import 'package:get/get.dart';

class Acceptance extends StatefulWidget {
  const Acceptance({super.key});

  @override
  State<Acceptance> createState() => _AcceptanceState();
}

class _AcceptanceState extends State<Acceptance> {
  final AcceptanceService service = AcceptanceService();

  List<AcceptanceModel> providers = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final result = await service.getAcceptanceList();
      setState(() {
        providers = result;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  void _confirmDelete(int id, String name) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text("Delete Account Permanently?"),
          content: Text(
            "Are you sure you want to permanently delete $name? This will completely remove their user profile, details, and bookings from the database. This action cannot be undone.",
            style: const TextStyle(fontSize: 14, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                setState(() => isLoading = true);
                final success = await service.deleteProvider(id);
                if (success) {
                  Get.snackbar(
                    'Success',
                    'Provider account deleted permanently',
                    backgroundColor: AppColors.primary,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                    margin: const EdgeInsets.all(16),
                  );
                  fetchData();
                } else {
                  setState(() => isLoading = false);
                  Get.snackbar(
                    'Error',
                    'Failed to delete provider account',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                    margin: const EdgeInsets.all(16),
                  );
                }
              },
              child: const Text(
                "Delete Permanently",
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      drawer: const AdminDrawer(),
      bottomNavigationBar: const AdminBottomNavBar(),

      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Acceptance List",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.success, AppColors.softPink],
            ),
          ),
        ),
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.success),
            )
          : hasError
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.wifi_off, size: 48, color: Colors.grey),
                  const SizedBox(height: 12),
                  const Text(
                    'Could not load data. Check your connection.',
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: fetchData,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try Again'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          : providers.isEmpty
          ? const Center(
              child: Text(
                "No pending or approved providers found.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            )
          : RefreshIndicator(
              color: AppColors.success,
              onRefresh: fetchData,
              child: ListView.builder(
                padding: const EdgeInsets.all(15),
                itemCount: providers.length,
                itemBuilder: (context, index) {
                  final item = providers[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.orange.shade100,
                          backgroundImage: item.cnicImage.isNotEmpty
                              ? NetworkImage(item.cnicImage)
                              : null,
                          child: item.cnicImage.isEmpty
                              ? const Icon(Icons.person, color: Colors.orange)
                              : null,
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.fullName,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.email,
                                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Status Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: item.status == "approved"
                                ? AppColors.success
                                : Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            item.status.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Permanent Delete Button
                        IconButton(
                          icon: const Icon(
                            Icons.delete_forever_rounded,
                            color: Colors.red,
                            size: 22,
                          ),
                          onPressed: () => _confirmDelete(item.id, item.fullName),
                          tooltip: "Delete Provider Permanently",
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
