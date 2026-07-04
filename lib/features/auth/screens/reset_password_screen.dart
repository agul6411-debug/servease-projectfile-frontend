import 'package:flutter/material.dart';
import 'package:frontfile_servease/features/auth/services/auth_service.dart';
import 'package:frontfile_servease/core/theme/app_theme.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String token;

  const ResetPasswordScreen({super.key, required this.token});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isLoading = false;
  bool _showPassword = false;
  bool _showConfirm = false;
  bool _isVerifying = true;
  bool _tokenValid = false;

  @override
  void initState() {
    super.initState();
    _verifyToken();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _verifyToken() async {
    final result = await AuthService.verifyResetToken(widget.token);
    setState(() {
      _tokenValid = result['valid'] == true;
      _isVerifying = false;
    });
  }

  Future<void> _submit() async {
    final password = _passwordController.text.trim();
    final confirm = _confirmController.text.trim();

    if (password.isEmpty || confirm.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields',
          backgroundColor: AppColors.destructive,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (password.length < 8) {
      Get.snackbar('Error', 'Password must be at least 8 characters',
          backgroundColor: AppColors.destructive,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    if (password != confirm) {
      Get.snackbar('Error', 'Passwords do not match',
          backgroundColor: AppColors.destructive,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    setState(() => _isLoading = true);
    final result = await AuthService.resetPassword(
      token: widget.token,
      newPassword: password,
    );
    setState(() => _isLoading = false);

    if (result['success'] == true) {
      Get.snackbar('Success', 'Password reset successfully!',
          backgroundColor: AppColors.secondary,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      await Future.delayed(const Duration(seconds: 1));
      Get.offAllNamed('/login_screen');
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
          onPressed: () => Get.offAllNamed('/login_screen'),
        ),
        title: const Text('Reset Password',
            style: TextStyle(color: AppColors.foreground, fontWeight: FontWeight.w600)),
      ),
      body: _isVerifying
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : !_tokenValid
              ? _buildInvalidToken()
              : _buildForm(),
    );
  }

  Widget _buildInvalidToken() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.destructive.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.link_off, size: 40, color: AppColors.destructive),
            ),
            const SizedBox(height: 24),
            const Text('Link Expired',
                style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.foreground)),
            const SizedBox(height: 12),
            const Text(
              'This reset link is invalid or has expired.\nPlease request a new one.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.mutedForeground, height: 1.5),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.offAllNamed('/forgot_password'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Request New Link',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
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
              child: const Icon(Icons.lock_open_rounded, size: 40, color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 32),
          const Text('Set New Password',
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.foreground)),
          const SizedBox(height: 8),
          const Text('Enter your new password below.',
              style: TextStyle(color: AppColors.mutedForeground, fontSize: 14)),
          const SizedBox(height: 32),

          // New Password
          const Text('New Password',
              style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.foreground)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: TextField(
              controller: _passwordController,
              obscureText: !_showPassword,
              decoration: InputDecoration(
                hintText: 'Min 6 characters',
                hintStyle: const TextStyle(color: AppColors.mutedForeground),
                prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary),
                suffixIcon: IconButton(
                  icon: Icon(
                    _showPassword ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.mutedForeground,
                  ),
                  onPressed: () => setState(() => _showPassword = !_showPassword),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Confirm Password
          const Text('Confirm Password',
              style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.foreground)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: AppColors.inputBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: TextField(
              controller: _confirmController,
              obscureText: !_showConfirm,
              decoration: InputDecoration(
                hintText: 'Re-enter password',
                hintStyle: const TextStyle(color: AppColors.mutedForeground),
                prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary),
                suffixIcon: IconButton(
                  icon: Icon(
                    _showConfirm ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.mutedForeground,
                  ),
                  onPressed: () => setState(() => _showConfirm = !_showConfirm),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
          const SizedBox(height: 40),

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
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Reset Password',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}
