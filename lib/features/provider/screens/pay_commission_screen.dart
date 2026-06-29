import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontfile_servease/features/provider/services/providerapiservice.dart';
import 'package:frontfile_servease/features/provider/screens/commission_submitted_screen.dart';
import 'package:frontfile_servease/features/provider/screens/provider_home_screen.dart';
import 'package:frontfile_servease/features/provider/screens/provider_profile_screen.dart';
import 'package:frontfile_servease/features/provider/screens/my_jobs_screen.dart';
import 'package:frontfile_servease/features/provider/screens/providernavbar.dart';
import 'package:frontfile_servease/core/theme/app_theme.dart';

class PayCommissionScreen extends StatefulWidget {
  final int providerId;
  final double commissionAmount;
  const PayCommissionScreen({
    super.key,
    required this.providerId,
    required this.commissionAmount,
  });

  @override
  State<PayCommissionScreen> createState() => _PayCommissionScreenState();
}

class _PayCommissionScreenState extends State<PayCommissionScreen> {
  String _selectedMethod = 'JazzCash';
  Uint8List? _screenshotBytes;
  String? _screenshotName;
  bool _isSubmitting = false;

  final _methods = [
    {'name': 'JazzCash', 'number': '0314-7549904'},
    {'name': 'EasyPaisa', 'number': '0314-7549904'},
    {'name': 'Bank Transfer', 'number': 'HBL – Account: 00427901781803'},
  ];

  Future<void> _pickScreenshot() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        _screenshotBytes = bytes;
        _screenshotName = picked.name;
      });
    }
  }

  Future<void> _submit() async {
    if (_screenshotBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload payment screenshot'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() => _isSubmitting = true);
    final success = await ProviderApiService.submitCommissionWeb(
      providerId: widget.providerId,
      amount: widget.commissionAmount,
      paymentMethod: _selectedMethod,
      screenshotBytes: _screenshotBytes!,
      screenshotName: _screenshotName ?? 'screenshot.jpg',
    );
    setState(() => _isSubmitting = false);
    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              CommissionSubmittedScreen(amount: widget.commissionAmount),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgGrey,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        title: const Text(
          'Pay Commission',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            // Amount Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.lightYellow,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.yellowBorder),
              ),
              child: Column(
                children: [
                  const Text(
                    'Commission due to ServEase',
                    style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'RS ${widget.commissionAmount.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const Text(
                    'For completed jobs — commission rate set by admin',
                    style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Payment Method
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pay via',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ..._methods
                      .map(
                        (m) => RadioListTile<String>(
                          value: m['name']!,
                          groupValue: _selectedMethod,
                          onChanged: (v) =>
                              setState(() => _selectedMethod = v!),
                          title: Text(
                            m['name']!,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            m['number']!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textMuted,
                            ),
                          ),
                          activeColor: AppColors.primaryGreen,
                          contentPadding: EdgeInsets.zero,
                        ),
                      )
                      .toList(),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Screenshot Upload
            GestureDetector(
              onTap: _pickScreenshot,
              child: Container(
                width: double.infinity,
                height: _screenshotBytes != null ? 180 : 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: _screenshotBytes != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.memory(
                          _screenshotBytes!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.upload_outlined,
                            size: 32,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap to upload screenshot',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentYellow,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isSubmitting
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Submit Payment Proof',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ProviderBottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ProviderHomeScreen(providerId: widget.providerId),
              ),
            );
            return;
          }
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MyJobsScreen(providerId: widget.providerId),
              ),
            );
            return;
          }
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ProviderProfileScreen(providerId: widget.providerId),
              ),
            );
            return;
          }
        },
      ),
    );
  }
}
