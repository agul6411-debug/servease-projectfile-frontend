import 'package:flutter/material.dart';

class ProviderJobsScreen extends StatelessWidget {
  const ProviderJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Jobs")),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.work),
            title: Text("Cleaning Service"),
            subtitle: Text("Pending"),
          ),
          ListTile(
            leading: Icon(Icons.work),
            title: Text("tutor"),
            subtitle: Text("Completed"),
          ),
        ],
      ),
    );
  }
}
