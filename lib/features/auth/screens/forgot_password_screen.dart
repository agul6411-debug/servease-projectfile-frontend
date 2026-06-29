import 'package:flutter/material.dart';
import 'package:frontfile_servease/features/auth/services/auth_service.dart';
import 'package:frontfile_servease/core/theme/app_theme.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      Get.snackbar('Error', 'Please enter your email',
          backgroundColor: AppColors.destructive,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    setState(() => _isLoading = true);
    final result = await AuthService.forgotPassword(email);
    setState(() => _isLoading = false);

    if (result['success'] == true) {
      setState(() => _emailSent = true);
    } else {
      Get.snackbar('Error', result['message'] ?? 'Something went wrong',
          backgroundColor: AppColors.destructive,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.foreground),
          onPressed: () => Get.back(),
        ),
        title: const Text('Forgot Password',
            style: TextStyle(color: AppColors.foreground, fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: _emailSent ? _buildSuccessView() : _buildFormView(),
      ),
    );
  }

  Widget _buildFormView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.lock_reset, size: 40, color: AppColors.primary),
          ),
        ),
        const SizedBox(height: 32),
        const Text('Reset Password',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.foreground)),
        const SizedBox(height: 8),
        const Text(
          'Enter your registered email. We will send a password reset link to your email.',
          style: TextStyle(color: AppColors.mutedForeground, fontSize: 14, height: 1.5),
        ),
        const SizedBox(height: 32),
        const Text('Email Address',
            style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.foreground)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Enter your email',
              hintStyle: TextStyle(color: AppColors.mutedForeground),
              prefixIcon: Icon(Icons.email_outlined, color: AppColors.primary),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20, width: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text('Send Reset Link',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.secondary.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.mark_email_read_outlined, size: 50, color: AppColors.secondary),
        ),
        const SizedBox(height: 32),
        const Text('Email Sent!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.foreground)),
        const SizedBox(height: 12),
        Text(
          'A password reset link has been sent to\n${_emailController.text.trim()}\n\nCheck your inbox and follow the link to reset your password.',
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.mutedForeground, fontSize: 14, height: 1.6),
        ),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Back to Login',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => setState(() => _emailSent = false),
          child: const Text('Resend Email',
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}
