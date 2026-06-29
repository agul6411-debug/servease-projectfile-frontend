import 'package:flutter/material.dart';
import 'package:frontfile_servease/core/theme/app_theme.dart';
import 'package:frontfile_servease/features/admin/models/acceptance_model.dart';
import 'package:frontfile_servease/features/admin/services/acceptance_service.dart';
import 'package:frontfile_servease/features/admin/screens/admindrawer.dart';
import 'package:frontfile_servease/features/admin/screens/admin_navbar.dart';

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
                "No pending providers found.",
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
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.orange.shade100,
                          backgroundImage: item.cnicImage.isNotEmpty
                              ? NetworkImage(item.cnicImage)
                              : null,
                          child: item.cnicImage.isEmpty
                              ? const Icon(Icons.person, color: Colors.orange)
                              : null,
                        ),

                        const SizedBox(width: 15),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.fullName,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                item.email,
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: item.status == "approved"
                                ? AppColors.success
                                : Colors.red,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Text(
                            item.status.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
