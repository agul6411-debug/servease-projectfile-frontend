import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:projectfile/core/utils/theme.dart';
import 'package:projectfile/core/services/auth_service.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final heroHorizontalPadding = isMobile ? 24.0 : 40.0;
    final heroVerticalPadding = isMobile ? 40.0 : 56.0;
    final formHorizontalPadding = isMobile ? 16.0 : 40.0;
    final formVerticalPadding = isMobile ? 30.0 : 56.0;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Hero Section ──
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  horizontal: heroHorizontalPadding, vertical: heroVerticalPadding),
              decoration: const BoxDecoration(
                gradient: AppTheme.primaryGradient,
              ),
              child: Column(
                children: [
                  Text(
                    'Welcome Back!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMobile ? 28 : 42,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: isMobile ? 12 : 16),
                  Text(
                    'Sign in to access your account and manage your services.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: const Color.fromARGB(179, 26, 24, 24),
                        fontSize: isMobile ? 14 : 16,
                        height: 1.6),
                  ),
                ],
              ),
            ),

            // ── Sign In Form ──
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: formHorizontalPadding, vertical: formVerticalPadding),
              child: _SignInForm(isMobile: isMobile, controller: _controller),
            ),

            // ── Footer ──
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  horizontal: formHorizontalPadding, vertical: formVerticalPadding),
              color: AppTheme.surfaceWhite,
              child: Column(
                children: [
                  const Text(
                    '© 2024 ServEase. All rights reserved.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromARGB(255, 19, 13, 13),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: isMobile ? 12 : 20,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: const Text(
                          'Privacy Policy',
                          style: TextStyle(
                            color: AppTheme.primaryGreen,
                            fontSize: 12,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const Text(
                          'Terms of Service',
                          style: TextStyle(
                            color: AppTheme.primaryGreen,
                            fontSize: 12,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Sign In Form Widget
// ─────────────────────────────────────────────
class _SignInForm extends StatefulWidget {
  final bool isMobile;
  final AnimationController controller;

  const _SignInForm({required this.isMobile, required this.controller});

  @override
  State<_SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<_SignInForm> with TickerProviderStateMixin {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignIn() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter name, email and password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await AuthService.login(name, email, password);

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (result['success'] == true) {
        Get.snackbar(
          'Success',
          result['message'] ?? 'Login successful',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        // Navigate to dashboard after showing message
        Future.delayed(const Duration(milliseconds: 500), () {
          Get.offNamed('/dashboard');
        });
      } else {
        Get.snackbar(
          'Login Failed',
          result['message'] ?? 'Invalid name, email or password',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);

      Get.snackbar(
        'Error',
        'An error occurred: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  void _goToSignUp() {
    Get.offNamed('/register');
  }

  @override
  Widget build(BuildContext context) {
    final verticalPadding = widget.isMobile ? 40.0 : 56.0;
    final horizontalPadding = widget.isMobile ? 24.0 : 40.0;
    final fieldSpacing = widget.isMobile ? 16.0 : 20.0;
    final fontSize = widget.isMobile ? 13.0 : 14.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        children: [
          // ── Gradient background ──
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
                vertical: verticalPadding, horizontal: horizontalPadding),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF1A5C35),
                  Color(0xFF2DAA55),
                  Color(0xFFF5A623),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),

          // ── Animated pattern overlay ──
          Positioned.fill(
            child: AnimatedBuilder(
              animation: widget.controller,
              builder: (_, _) {
                return CustomPaint(
                  painter: _CrossPatternPainter(offset: widget.controller.value * 60),
                );
              },
            ),
          ),

          // ── Content ──
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: verticalPadding - 4, horizontal: horizontalPadding),
            child: Column(
              children: [
                // Email Field
                TextField(
                  controller: _nameController,
                  enabled: !_isLoading,
                  style: TextStyle(color: const Color.fromARGB(255, 14, 8, 8), fontSize: fontSize),
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(
                        color: const Color.fromARGB(255, 19, 18, 18).withAlpha(179), fontSize: fontSize),
                    hintText: 'Enter your name',
                    hintStyle: TextStyle(color: const Color.fromARGB(255, 10, 10, 10).withAlpha(102)),
                    prefixIcon: const Icon(Icons.person_outline,
                        color: Color.fromARGB(179, 24, 23, 23), size: 20),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: const Color.fromARGB(255, 24, 22, 22).withAlpha(77), width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Color.fromARGB(255, 12, 12, 12), width: 2),
                    ),
                  ),
                ),
                SizedBox(height: fieldSpacing),
                TextField(

                  controller: _emailController,
                  enabled: !_isLoading,
                  style: TextStyle(color: const Color.fromARGB(255, 14, 8, 8), fontSize: fontSize),
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    labelStyle: TextStyle(
                        color: const Color.fromARGB(255, 19, 18, 18).withAlpha(179), fontSize: fontSize),
                    hintText: 'Enter your email',
                    hintStyle: TextStyle(color: const Color.fromARGB(255, 10, 10, 10).withAlpha(102)),
                    prefixIcon: const Icon(Icons.email_outlined,
                        color: Color.fromARGB(179, 24, 23, 23), size: 20),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: const Color.fromARGB(255, 24, 22, 22).withAlpha(77), width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Color.fromARGB(255, 12, 12, 12), width: 2),
                    ),
                  ),
                ),
                SizedBox(height: fieldSpacing),

                // Password Field
                TextField(
                  controller: _passwordController,
                  enabled: !_isLoading,
                  obscureText: _obscurePassword,
                  style: TextStyle(color: const Color.fromARGB(255, 20, 20, 20), fontSize: fontSize),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(
                        color: const Color.fromARGB(255, 14, 13, 13).withAlpha(179), fontSize: fontSize),
                    hintText: 'Enter your password',
                    hintStyle: TextStyle(color: const Color.fromARGB(255, 10, 10, 10).withAlpha(102)),
                    prefixIcon: const Icon(Icons.lock_outline,
                        color: Color.fromARGB(179, 26, 24, 24), size: 20),
                    suffixIcon: IconButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: const Color.fromARGB(179, 12, 11, 11),
                        size: 20,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: const Color.fromARGB(255, 19, 18, 18).withAlpha(77), width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          const BorderSide(color: Color.fromARGB(255, 12, 12, 12), width: 2),
                    ),
                  ),
                ),
                SizedBox(height: widget.isMobile ? 10 : 12),

                // Forgot Password Link
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: _isLoading ? null : () {},
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 20, 20, 20),
                        fontSize: widget.isMobile ? 11 : 12,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationColor: const Color.fromARGB(255, 20, 20, 20),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: widget.isMobile ? 20 : 28),

                // Sign In Button
                GestureDetector(
                  onTap: _isLoading ? null : _handleSignIn,
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        vertical: widget.isMobile ? 12 : 15),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5A623),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: _isLoading
                        ? const Center(
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color.fromARGB(255, 20, 19, 19)),
                                strokeWidth: 2,
                              ),
                            ),
                          )
                        : Text(
                            'Sign In',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color.fromARGB(255, 17, 17, 17),
                              fontSize: widget.isMobile ? 14 : 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: widget.isMobile ? 18 : 28),

                // Sign Up option
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: widget.isMobile ? 12 : 24,
                      vertical: widget.isMobile ? 10 : 12),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border(
                      top: BorderSide(color: const Color.fromARGB(255, 19, 18, 18).withAlpha(77), width: 1),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: _isLoading ? null : _goToSignUp,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                            color: const Color.fromARGB(255, 10, 10, 10).withAlpha(179),
                            fontSize: widget.isMobile ? 12 : 14),
                        children: [
                          const TextSpan(text: "Don't have an account? "),
                          TextSpan(
                            text: 'Sign Up',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 20, 20, 20),
                              fontWeight: FontWeight.bold,
                              fontSize: widget.isMobile ? 13 : 15,
                              decoration: TextDecoration.underline,
                              decorationColor: const Color.fromARGB(255, 20, 20, 20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Cross Pattern Painter
// ─────────────────────────────────────────────
class _CrossPatternPainter extends CustomPainter {
  final double offset;
  _CrossPatternPainter({required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(255, 26, 25, 25).withAlpha(18)
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    const spacing = 36.0;
    const armLen = 8.0;

    final cols = (size.width / spacing).ceil() + 2;
    final rows = (size.height / spacing).ceil() + 2;
    final dx = offset % spacing;

    for (int r = -1; r < rows; r++) {
      for (int c = -1; c < cols; c++) {
        final cx = c * spacing + dx;
        final cy = r * spacing;
        canvas.drawLine(
            Offset(cx - armLen, cy), Offset(cx + armLen, cy), paint);
        canvas.drawLine(
            Offset(cx, cy - armLen), Offset(cx, cy + armLen), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_CrossPatternPainter old) => old.offset != offset;
}
