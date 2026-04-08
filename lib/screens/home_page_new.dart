import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/colors.dart';
import '../core/services/auth_service.dart';
import '../sections/app_bar_section.dart';
import '../sections/hero_section.dart';
import '../sections/services_section.dart';
import '../sections/how_it_works_section.dart';
import '../sections/features_section.dart';
import '../sections/user_types_section.dart';
import '../sections/cta_section.dart';
import '../sections/footer_section.dart';

/// HomePage - Main landing page with all sections
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late final AnimationController _orbitController;
  late final AnimationController _entryController;
  late final List<Animation<double>> _fadeAnimations;
  late final List<Animation<Offset>> _slideAnimations;

  // Login form state
  bool _showLoginForm = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  /// Initialize all animation controllers
  void _initializeAnimations() {
    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 22),
    )..repeat();

    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    // Create fade animations with staggered timing
    _fadeAnimations = List.generate(6, (i) {
      final start = (i * 0.13).clamp(0.0, 1.0);
      final end = (start + 0.38).clamp(0.0, 1.0);
      return CurvedAnimation(
        parent: _entryController,
        curve: Interval(start, end, curve: Curves.easeOut),
      );
    });

    // Create slide animations based on fade
    _slideAnimations = _fadeAnimations
        .map(
          (fade) => Tween<Offset>(
            begin: const Offset(0, 0.08),
            end: Offset.zero,
          ).animate(fade),
        )
        .toList();

    _entryController.forward();
  }

  @override
  void dispose() {
    _orbitController.dispose();
    _entryController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  /// Login function using AuthService
  Future<void> _login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter email and password');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final result = await AuthService.login(
        emailController.text,
        passwordController.text,
      );

      if (result['success']) {
        // Clear form
        emailController.clear();
        passwordController.clear();
        // Navigate to dashboard
        Get.toNamed('/dashboard');
      } else {
        Get.snackbar('Error', result['message'] ?? 'Login failed');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showLoginForm) {
      return Scaffold(
        backgroundColor: const Color(0xFFF3F4F6),
        body: Center(
          child: TweenAnimationBuilder(
            duration: const Duration(milliseconds: 700),
            tween: Tween<double>(begin: 0, end: 1),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 40 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: Container(
              width: 380,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(20),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  /// BACK BUTTON
                  Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _showLoginForm = false);
                        emailController.clear();
                        passwordController.clear();
                      },
                      child: const Icon(Icons.close, size: 28),
                    ),
                  ),
                  const SizedBox(height: 10),

                  /// ICON
                  const Icon(
                    Icons.home_rounded,
                    size: 50,
                    color: Color(0xFF3B82F6),
                  ),

                  const SizedBox(height: 15),

                  /// TITLE
                  const Text(
                    "Welcome Back!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    "Sign in to continue to ServEase",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 25),

                  /// EMAIL FIELD
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Enter your email',
                      prefixIcon: const Icon(Icons.email),
                      filled: true,
                      fillColor: const Color(0xFFF9FAFB),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  /// PASSWORD FIELD
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      prefixIcon: const Icon(Icons.lock),
                      filled: true,
                      fillColor: const Color(0xFFF9FAFB),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// REMEMBER + FORGOT
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Row(
                        children: [
                          Checkbox(value: false, onChanged: null),
                          Text("Remember me"),
                        ],
                      ),
                      Text(
                        "Forgot Password?",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  /// LOGIN BUTTON
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              "Sign In",
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  /// SIGNUP
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed('/register');
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: CustomScrollView(
        slivers: [
          AppBarSection(
            onLoginPressed: () {
              setState(() => _showLoginForm = true);
            },
          ),
          SliverToBoxAdapter(
            child: HeroSection(
              fadeAnimations: _fadeAnimations,
              slideAnimations: _slideAnimations,
              orbitController: _orbitController,
            ),
          ),
          SliverToBoxAdapter(child: const ServicesSection()),
          SliverToBoxAdapter(child: const HowItWorksSection()),
          SliverToBoxAdapter(child: const FeaturesSection()),
          SliverToBoxAdapter(child: const UserTypesSection()),
          SliverToBoxAdapter(child: const CtaSection()),
          SliverToBoxAdapter(child: const FooterSection()),
        ],
      ),
    );
  }
}
