import 'package:flutter/material.dart';
import 'package:frontfile_servease/routes.dart';
import 'package:get/get.dart';
import 'package:frontfile_servease/screens/admin/admindrawer.dart';

class Complainhandling extends StatefulWidget {
  const Complainhandling({super.key});

  @override
  State<Complainhandling> createState() => _ComplainhandlingState();
}

class _ComplainhandlingState extends State<Complainhandling> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("complain handling"),

        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.offAllNamed('/admindrawer');
          },
        ),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("complain handling", style: TextStyle(fontSize: 22)),

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
