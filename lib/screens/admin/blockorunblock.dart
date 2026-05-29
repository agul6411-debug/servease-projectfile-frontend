import 'package:flutter/material.dart';
import 'package:frontfile_servease/routes.dart';
import 'package:get/get.dart';
import 'package:frontfile_servease/screens/admin/admindrawer.dart';

class Blockorunblock extends StatefulWidget {
  const Blockorunblock({super.key});

  @override
  State<Blockorunblock> createState() => _BlockorunblockState();
}

class _BlockorunblockState extends State<Blockorunblock> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("blockorunblock"),

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
            const Text("blockorunblock", style: TextStyle(fontSize: 22)),

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
