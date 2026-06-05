import 'package:flutter/material.dart';

class ProviderProfileScreen extends StatelessWidget {
  const ProviderProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: const Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(radius: 50, child: Text("AR")),
            SizedBox(height: 20),
            Text("Ali Raza"),
            Text("Electrician"),
            Text("03001234567"),
          ],
        ),
      ),
    );
  }
}
