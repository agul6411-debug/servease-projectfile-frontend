import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frontfile_servease/features/auth/services/auth_service.dart';
import 'package:frontfile_servease/core/theme/app_theme.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class OtpVerifyScreen extends StatefulWidget {
  final String email;
  final String fullName;
  final VoidCallback onVerified; // Registration complete karo

  const OtpVerifyScreen({
    super.key,
    required this.email,
    required this.fullName,
    required this.onVerified,
  });

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool _isLoading = false;
  bool _isResending = false;
  int _resendSeconds = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    super.dispose();
  }

  void _startTimer() {
    _resendSeconds = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_resendSeconds == 0) {
        t.cancel();
      } else {
        setState(() => _resendSeconds--);
      }
    });
  }

  String get _otp => _controllers.map((c) => c.text).join();

  void _verify() async {
    if (_otp.length < 6) {
      Get.snackbar('Error', 'Please enter the 6-digit OTP',
          backgroundColor: AppColors.destructive,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    setState(() => _isLoading = true);
    final result = await AuthService.verifyOtp(
      email: widget.email,
      otp: _otp,
    );
    setState(() => _isLoading = false);

    if (result['success'] == true) {
      widget.onVerified();
    } else {
      Get.snackbar('Invalid OTP', result['message'] ?? 'Please try again',
          backgroundColor: AppColors.destructive,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void _resend() async {
    if (_resendSeconds > 0) return;
    setState(() => _isResending = true);
    final result = await AuthService.sendOtp(
      email: widget.email,
      fullName: widget.fullName,
    );
    setState(() => _isResending = false);

    if (result['success'] == true) {
      _startTimer();
      Get.snackbar('OTP Sent', 'New OTP sent to ${widget.email}',
          backgroundColor: AppColors.secondary,
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
        title: Text(
          'Verify Email',
          style: GoogleFonts.outfit(
            color: AppColors.foreground,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
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
                child: const Icon(Icons.mark_email_unread_outlined,
                    size: 40, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Email Verification',
              style: GoogleFonts.outfit(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: AppColors.foreground,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                style: GoogleFonts.inter(
                  color: AppColors.mutedForeground,
                  fontSize: 14,
                  height: 1.5,
                ),
                children: [
                  const TextSpan(text: 'We sent a 6-digit OTP to\n'),
                  TextSpan(
                    text: widget.email,
                    style: GoogleFonts.inter(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            // OTP Input boxes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (i) {
                return SizedBox(
                  width: 48,
                  height: 56,
                  child: TextField(
                    controller: _controllers[i],
                    focusNode: _focusNodes[i],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    style: GoogleFonts.outfit(
                        fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.foreground),
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: AppColors.inputBackground,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primary, width: 2),
                      ),
                    ),
                    onChanged: (val) {
                      if (val.isNotEmpty && i < 5) {
                        _focusNodes[i + 1].requestFocus();
                      }
                      if (val.isEmpty && i > 0) {
                        _focusNodes[i - 1].requestFocus();
                      }
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _verify,
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
                    : Text(
                        'Verify & Continue',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: _resendSeconds > 0
                  ? Text(
                      'Resend OTP in $_resendSeconds seconds',
                      style: GoogleFonts.inter(color: AppColors.mutedForeground, fontSize: 13),
                    )
                  : TextButton(
                      onPressed: _isResending ? null : _resend,
                      child: _isResending
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(
                                  color: AppColors.primary, strokeWidth: 2))
                          : Text(
                              'Resend OTP',
                              style: GoogleFonts.inter(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
