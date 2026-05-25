import 'package:flutter/material.dart';
import 'package:frontfile_servease/models/provider_verification_model.dart';
import 'package:frontfile_servease/services/provider_verficationservice.dart';

class ProviderVerification extends StatefulWidget {
  const ProviderVerification({super.key});

  @override
  State<ProviderVerification> createState() => _ProviderVerificationState();
}

class _ProviderVerificationState extends State<ProviderVerification> {
  final ProviderVerificationService service = ProviderVerificationService();

  List<ProviderVerificationModel> providers = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    fetchProviders();
  }

  Future<void> fetchProviders() async {
    final result = await service.getPendingProviders();

    setState(() {
      providers = result;

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F7F9),

      appBar: AppBar(
        backgroundColor: const Color(0xff00C853),

        elevation: 0,

        title: const Text(
          "Provider Verification",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : providers.isEmpty
          ? const Center(child: Text("No Pending Providers"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),

              itemCount: providers.length,

              itemBuilder: (context, index) {
                final provider = providers[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 18),

                  padding: const EdgeInsets.all(18),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    borderRadius: BorderRadius.circular(22),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.05),

                        blurRadius: 12,

                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 28,

                            backgroundColor: const Color(0xffFF8A00),

                            child: Text(
                              provider.fullName[0],

                              style: const TextStyle(
                                color: Colors.white,

                                fontSize: 22,

                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Text(
                                  provider.fullName,

                                  style: const TextStyle(
                                    fontSize: 18,

                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(provider.email),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      _infoRow("Phone", provider.phone),

                      _infoRow(
                        "Experience",
                        "${provider.yearsOfExperience} Years",
                      ),

                      _infoRow("Bio", provider.bio ?? ""),

                      const SizedBox(height: 16),

                      provider.cnicImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(15),

                              child: Image.network(
                                provider.cnicImage!,

                                height: 180,

                                width: double.infinity,

                                fit: BoxFit.cover,
                              ),
                            )
                          : const SizedBox(),

                      const SizedBox(height: 18),

                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff00C853),

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),

                              onPressed: () async {
                                bool success = await service.approveProvider(
                                  provider.id,
                                );

                                if (success) {
                                  fetchProviders();
                                }
                              },

                              child: const Text(
                                "Approve",

                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),

                              onPressed: () async {
                                bool success = await service.rejectProvider(
                                  provider.id,
                                );

                                if (success) {
                                  fetchProviders();
                                }
                              },

                              child: const Text(
                                "Reject",

                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            "$title : ",

            style: const TextStyle(fontWeight: FontWeight.bold),
          ),

          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
