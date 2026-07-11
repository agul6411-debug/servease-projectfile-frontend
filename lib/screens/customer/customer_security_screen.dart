import 'package:flutter/material.dart';
import 'package:frontfile_servease/services/customer/customerserviceali.dart';
import 'package:frontfile_servease/core/theme/app_theme.dart';

class CustomerSecurityScreen extends StatefulWidget {
  final int userId;
  const CustomerSecurityScreen({super.key, required this.userId});

  @override
  State<CustomerSecurityScreen> createState() => _CustomerSecurityScreenState();
}

class _CustomerSecurityScreenState extends State<CustomerSecurityScreen> {
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _showCurrent = false, _showNew = false, _showConfirm = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (_newCtrl.text != _confirmCtrl.text) {
      _showSnack('Passwords do not match', Colors.red);
      return;
    }
    if (_newCtrl.text.length < 6) {
      _showSnack('Password must be at least 6 characters', Colors.red);
      return;
    }
    setState(() => _isSaving = true);
    final result = await CustomerApiService.changePassword(
      userId: widget.userId,
      currentPassword: _currentCtrl.text,
      newPassword: _newCtrl.text,
    );
    if (result['success']) {
      _showSnack('Password changed successfully!', AppColors.primaryGreen);
      _currentCtrl.clear();
      _newCtrl.clear();
      _confirmCtrl.clear();
    } else {
      _showSnack(result['message'] ?? 'Failed to change password', Colors.red);
    }
    setState(() => _isSaving = false);
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        title: const Text(
          'Security',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Change password card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.lock_outline,
                          color: AppColors.primaryGreen,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Change Password',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _passField(
                    'Current Password',
                    _currentCtrl,
                    _showCurrent,
                    () => setState(() => _showCurrent = !_showCurrent),
                  ),
                  const SizedBox(height: 14),
                  _passField(
                    'New Password',
                    _newCtrl,
                    _showNew,
                    () => setState(() => _showNew = !_showNew),
                  ),
                  const SizedBox(height: 14),
                  _passField(
                    'Confirm New Password',
                    _confirmCtrl,
                    _showConfirm,
                    () => setState(() => _showConfirm = !_showConfirm),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isSaving ? null : _changePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: _isSaving
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          )
                        : const Text(
                            'Update Password',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Forgot password card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.accentYellow.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.help_outline,
                          color: AppColors.accentYellow,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'If you forgot your password, contact admin or use the reset option below.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textMuted,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ForgotPasswordScreen(),
                      ),
                    ),
                    icon: const Icon(Icons.email_outlined, size: 16),
                    label: const Text('Reset via Email'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryGreen,
                      side: const BorderSide(color: AppColors.primaryGreen),
                      minimumSize: const Size(double.infinity, 46),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _passField(
    String label,
    TextEditingController ctrl,
    bool show,
    VoidCallback toggle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          obscureText: !show,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFFFF8EF),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                show
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                size: 18,
                color: AppColors.textMuted,
              ),
              onPressed: toggle,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Forgot Password Screen ────────────────────────────────────────
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();
  bool _isSending = false;
  bool _sent = false;

  Future<void> _sendReset() async {
    if (_emailCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() => _isSending = true);
    final result = await CustomerApiService.forgotPassword(
      _emailCtrl.text.trim(),
    );
    if (result['success']) {
      setState(() => _sent = true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
    setState(() => _isSending = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        title: const Text(
          'Reset Password',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: _sent ? _buildSuccess() : _buildForm(),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.lock_reset,
            color: AppColors.primaryGreen,
            size: 32,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Forgot your password?',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Enter your registered email address and we\'ll send you a reset link.',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textMuted,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 28),
        const Text(
          'EMAIL ADDRESS',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.textMuted,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _emailCtrl,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'your@email.com',
            hintStyle: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 13,
            ),
            filled: true,
            fillColor: Colors.white,
            prefixIcon: const Icon(
              Icons.email_outlined,
              size: 18,
              color: AppColors.textMuted,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _isSending ? null : _sendReset,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            minimumSize: const Size(double.infinity, 52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: _isSending
              ? const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                )
              : const Text(
                  'Send Reset Link',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildSuccess() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.mark_email_read_outlined,
            color: AppColors.primaryGreen,
            size: 40,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Email Sent!',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryGreen,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'A password reset link has been sent to\n${_emailCtrl.text}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textMuted,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 28),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Back to Security',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
