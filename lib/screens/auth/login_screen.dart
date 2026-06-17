// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:frontfile_servease/services/api_service.dart';
import 'package:frontfile_servease/theme/app_theme.dart';
import 'package:get/get.dart';
import 'package:frontfile_servease/routes.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;
  final box = GetStorage();
  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnim = CurvedAnimation(parent: _animController, curve: Curves.easeIn);

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ===============================
  // LOGIN LOGIC
  // ===============================
  void _handleSignIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Email and password required',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final api = ApiService();

      // ONLY ONE CALL
      final result = await api.login(email, password, "customer");
      // 👆 role can be anything now BUT backend already returns real role

      setState(() => _isLoading = false);

      print("LOGIN RESPONSE: $result");

      if (result['success'] == true) {
        final role = result['role'];

        Get.snackbar(
          'Success',
          'Login successful as $role',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        final token = result['token'];
        box.write('auth_token', token);
        await Future.delayed(const Duration(milliseconds: 300));

        final userId = result['user']['id'];
        final userRole = result['user']['role'];
        box.write('user_id', userId);
        box.write('user_role', userRole);

        // SAFE NAVIGATION
        if (role == 'admin') {
          Get.offAllNamed(AppRoutes.adminDashboard);
        } else if (role == 'provider') {
          Get.offAllNamed(AppRoutes.providerHomeScreen);
        } else if (role == 'customer') {
          Get.offAllNamed(AppRoutes.customerHomeScreen);
        } else {
          Get.snackbar("Error", "Unknown role");
        }
      } else {
        Get.snackbar(
          'Error',
          result['message'] ?? 'Login failed',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      print("LOGIN ERROR: $e");

      Get.snackbar(
        'Error',
        'Server error',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Login'),
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: SlideTransition(
              position: _slideAnim,
              child: Column(
                children: [
                  // ── Top area with logo ──
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(
                      top: isMobile ? 40 : 56,
                      bottom: isMobile ? 28 : 40,
                    ),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFEAF2E8), Color(0xFFF5F8F0)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: isMobile ? 80 : 96,
                          height: isMobile ? 80 : 96,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.success, AppColors.softPink],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(
                              isMobile ? 22 : 28,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF2ECC71).withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.home_rounded,
                            color: Colors.white,
                            size: isMobile ? 44 : 52,
                          ),
                        ),

                        SizedBox(height: isMobile ? 20 : 28),

                        Text(
                          'Welcome Back',
                          style: TextStyle(
                            color: const Color(0xFF1A1A1A),
                            fontSize: isMobile ? 28 : 36,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          'Sign in to continue to ServEase',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: isMobile ? 14 : 15,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 24 : 48,
                      vertical: isMobile ? 28 : 36,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Email Field
                        _FieldLabel(label: 'Email'),

                        const SizedBox(height: 8),

                        _InputField(
                          controller: _emailController,
                          hint: 'your.email@example.com',
                          prefixIcon: Icons.mail_outline_rounded,
                          suffixIcon: Icons.mark_email_read_outlined,
                          suffixColor: Colors.grey.shade400,
                          enabled: !_isLoading,
                          keyboardType: TextInputType.emailAddress,
                        ),

                        SizedBox(height: isMobile ? 18 : 24),

                        // Password Field
                        _FieldLabel(label: 'Password'),

                        const SizedBox(height: 8),

                        _InputField(
                          controller: _passwordController,
                          hint: 'Enter your password',
                          prefixIcon: Icons.lock_outline_rounded,
                          obscureText: _obscurePassword,
                          enabled: !_isLoading,
                          suffixWidget: IconButton(
                            onPressed: _isLoading
                                ? null
                                : () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Colors.grey.shade500,
                              size: 20,
                            ),
                          ),
                        ),

                        SizedBox(height: isMobile ? 12 : 16),

                        // Remember Me + Forgot
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Checkbox(
                                    value: _rememberMe,
                                    onChanged: _isLoading
                                        ? null
                                        : (v) {
                                            setState(() {
                                              _rememberMe = v ?? false;
                                            });
                                          },
                                    activeColor: const Color(0xFF2ECC71),
                                  ),
                                ),

                                const SizedBox(width: 8),

                                Text(
                                  'Remember me',
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: isMobile ? 13 : 14,
                                  ),
                                ),
                              ],
                            ),

                            GestureDetector(
                              onTap: () => Get.toNamed('/forgot_password'),
                              child: Text(
                                'Forgot?',
                                style: TextStyle(
                                  color: const Color(0xFFD44000),
                                  fontSize: isMobile ? 13 : 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: isMobile ? 24 : 32),

                        // SIGN IN BUTTON
                        GestureDetector(
                          onTap: _isLoading ? null : _handleSignIn,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              vertical: isMobile ? 16 : 18,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF1A7A3C),
                                  Color(0xFF2ECC71),
                                  Color(0xFFF5A623),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: _isLoading
                                ? const Center(
                                    child: SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    ),
                                  )
                                : Text(
                                    'Sign In',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: isMobile ? 16 : 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),

                        SizedBox(height: isMobile ? 24 : 32),

                        // Create Account
                        Center(
                          child: GestureDetector(
                            onTap: () => Get.offNamed('/register'),
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: isMobile ? 13 : 14,
                                  color: Colors.grey.shade600,
                                ),
                                children: [
                                  const TextSpan(text: 'New to ServEase? '),
                                  TextSpan(
                                    text: 'Create Account',
                                    style: TextStyle(
                                      color: const Color(0xFF2ECC71),
                                      fontWeight: FontWeight.bold,
                                      fontSize: isMobile ? 13 : 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: isMobile ? 16 : 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ===============================
// FIELD LABEL
// ===============================

class _FieldLabel extends StatelessWidget {
  final String label;

  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: Color(0xFF333333),
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

// ===============================
// INPUT FIELD
// ===============================

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final Color? suffixColor;
  final Widget? suffixWidget;
  final bool obscureText;
  final bool enabled;
  final TextInputType keyboardType;

  const _InputField({
    required this.controller,
    required this.hint,
    required this.prefixIcon,
    this.suffixIcon,
    this.suffixColor,
    this.suffixWidget,
    this.obscureText = false,
    this.enabled = true,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: controller,
        enabled: enabled,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(prefixIcon),
          suffixIcon:
              suffixWidget ?? (suffixIcon != null ? Icon(suffixIcon) : null),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}
