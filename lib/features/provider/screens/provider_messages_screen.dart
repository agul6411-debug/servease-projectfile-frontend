// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:frontfile_servease/core/theme/app_theme.dart';

class ProviderMessagesScreen extends StatelessWidget {
  final int providerId;

  const ProviderMessagesScreen({super.key, required this.providerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: const Center(child: Text('Messages content will go here.')),
    );
  }
}
