import 'package:flutter/material.dart';
import 'package:frontfile_servease/routes.dart';
import 'package:get/get.dart';
import 'package:frontfile_servease/screens/admin/admindrawer.dart';
import 'package:frontfile_servease/screens/admin/admin_navbar.dart';

class Complainresolution extends StatefulWidget {
  const Complainresolution({super.key});

  @override
  State<Complainresolution> createState() => _ComplainresolutionState();
}

class _ComplainresolutionState extends State<Complainresolution> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AdminDrawer(),
      bottomNavigationBar: const AdminBottomNavBar(),
      appBar: AppBar(title: const Text("complain resolution")),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("complain resolution", style: TextStyle(fontSize: 22)),

            const SizedBox(height: 20),

            GestureDetector(
              onTap: () {
                Get.offAllNamed(AppRoutes.admindrawer);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
