import 'package:flutter/material.dart';
import 'package:projectfile/models/acceptance_model.dart';
import 'package:projectfile/services/acceptance_service.dart';
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

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final result = await service.getAcceptanceList();

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
        elevation: 0,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),

          onPressed: () {
            Get.offAllNamed('/admindrawer');
          },
        ),

        title: const Text(
          "Acceptance List",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),

        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff00C853), Color(0xffFF8A00)],
            ),
          ),
        ),
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xff00C853)),
            )
          : providers.isEmpty
          ? const Center(
              child: Text(
                "No Data Found",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            )
          : ListView.builder(
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
                        color: Colors.black.withOpacity(.05),
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
                              ? const Color(0xff00C853)
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
    );
  }
}

