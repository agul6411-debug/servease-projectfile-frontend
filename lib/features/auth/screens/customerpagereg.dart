import 'package:flutter/material.dart';
import 'package:frontfile_servease/features/auth/services/cust_registerservice.dart';
import 'package:frontfile_servease/features/auth/services/auth_service.dart';
import 'package:frontfile_servease/features/auth/screens/otp_verify_screen.dart';
import 'package:get/get.dart';

class CustomerPagereg extends StatefulWidget {
  const CustomerPagereg({super.key});

  @override
  State<CustomerPagereg> createState() => _CustomerPageregState();
}

class _CustomerPageregState extends State<CustomerPagereg> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cnicController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPassController = TextEditingController();

  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _agreeToTerms = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cnicController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  String? _requiredValidator(String? v, String field) {
    if (v == null || v.trim().isEmpty) return '$field is required';
    return null;
  }

  String? _emailValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    final regex = RegExp(r'^[\w\-.]+@([\w\-]+\.)+[\w]{2,4}$');
    if (!regex.hasMatch(v.trim())) return 'Enter a valid email';
    return null;
  }

  String? _cnicValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'CNIC is required';
    final regex = RegExp(r'^\d{5}-\d{7}-\d{1}$');
    if (!regex.hasMatch(v.trim())) return 'Format: XXXXX-XXXXXXX-X';
    return null;
  }

  String? _passwordValidator(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 6) return 'Minimum 6 characters';
    return null;
  }

  String? _confirmPasswordValidator(String? v) {
    if (v == null || v.isEmpty) return 'Please confirm password';
    if (v != _passwordController.text) return 'Passwords do not match';
    return null;
  }

  Future<void> _handleCreateAccount() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeToTerms) {
      _showSnack('Please agree to Terms and Conditions and Privacy Policy.', isError: true);
      return;
    }

    // Step 1: Send OTP
    setState(() => _isLoading = true);
    final otpResult = await AuthService.sendOtp(
      email: _emailController.text.trim(),
      fullName: _fullNameController.text.trim(),
    );
    setState(() => _isLoading = false);

    if (otpResult['success'] != true) {
      _showSnack(otpResult['message'] ?? 'Failed to send OTP', isError: true);
      return;
    }

    if (!mounted) return;

    // Step 2: OTP verify screen
    Get.to(() => OtpVerifyScreen(
      email: _emailController.text.trim(),
      fullName: _fullNameController.text.trim(),
      onVerified: () async {
        Get.back();
        setState(() => _isLoading = true);
        try {
          final result = await CustomerService().registerCustomer(
            _fullNameController.text.trim(),
            _emailController.text.trim(),
            _phoneController.text.trim(),
            _cnicController.text.trim(),
            _addressController.text.trim(),
            _passwordController.text,
          );
          if (!mounted) return;
          setState(() => _isLoading = false);
          if (result == 'Registration successful') {
            _showSnack('Account created successfully! Please login.');
            await Future.delayed(const Duration(seconds: 1));
            if (!mounted) return;
            Get.offAllNamed('/login_screen');
          } else {
            _showSnack(result, isError: true);
          }
        } catch (e) {
          if (!mounted) return;
          setState(() => _isLoading = false);
          _showSnack('An error occurred. Please try again.', isError: true);
        }
      },
    ));
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.redAccent : const Color(0xFF1A5C35),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF9A8878), fontSize: 13),
      prefixIcon: Icon(prefixIcon, color: const Color(0xFF9A8878), size: 18),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color(0xFFFFF6EC),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFEDD9C8)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFEDD9C8)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2DAA55), width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.8),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF3A3A3A),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
    Widget? suffix,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscure,
          style: const TextStyle(color: Color(0xFF2D2A24), fontSize: 13),
          decoration: _inputDecoration(
            hint: hint,
            prefixIcon: icon,
            suffixIcon: suffix,
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _sectionHeader({required IconData icon, required String title}) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1A5C35), Color(0xFFF5A623)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Icon(icon, size: 16, color: const Color(0xFF1A5C35)),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1C1B1F),
          ),
        ),
      ],
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8E2DA)),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: Column(
        children: [
          // ── Gradient Header ───────────────────────────────────
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF1A5C35),
                  Color(0xFF2DAA55),
                  Color(0xFFF5A623),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 12,
              bottom: 44,
              left: 20,
              right: 20,
            ),
            child: Column(
              children: [
                // Top bar — back + title
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'Register',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 36),
                  ],
                ),

                const SizedBox(height: 28),

                // Centered icon + title
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Join as Customer',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Book trusted home service professionals',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.75),
                  ),
                ),
              ],
            ),
          ),

          // ── Scrollable Form ───────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF0F4F8),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Personal Info ──
                          _sectionHeader(
                            icon: Icons.person_outline_rounded,
                            title: 'Personal Information',
                          ),
                          const SizedBox(height: 12),
                          _card(
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: _buildField(
                                        label: 'Full Name',
                                        controller: _fullNameController,
                                        hint: 'Your full name',
                                        icon: Icons.person_outline_rounded,
                                        validator: (v) =>
                                            _requiredValidator(v, 'Full name'),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildField(
                                        label: 'Email Address',
                                        controller: _emailController,
                                        hint: 'your@email.com',
                                        icon: Icons.mail_outline_rounded,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        validator: _emailValidator,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: _buildField(
                                        label: 'Phone Number',
                                        controller: _phoneController,
                                        hint: '03001234567',
                                        icon: Icons.phone_outlined,
                                        keyboardType: TextInputType.phone,
                                        validator: (v) => _requiredValidator(
                                          v,
                                          'Phone number',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildField(
                                        label: 'CNIC Number',
                                        controller: _cnicController,
                                        hint: 'XXXXX-XXXXXXX-X',
                                        icon: Icons.credit_card_outlined,
                                        validator: _cnicValidator,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                _buildField(
                                  label: 'Address',
                                  controller: _addressController,
                                  hint: 'Enter your address',
                                  icon: Icons.location_on_outlined,
                                  validator: (v) =>
                                      _requiredValidator(v, 'Address'),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // ── Security ──
                          _sectionHeader(
                            icon: Icons.lock_outline_rounded,
                            title: 'Security',
                          ),
                          const SizedBox(height: 12),
                          _card(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: _buildField(
                                    label: 'Password',
                                    controller: _passwordController,
                                    hint: 'Min. 6 characters',
                                    icon: Icons.lock_outline_rounded,
                                    obscure: !_showPassword,
                                    suffix: IconButton(
                                      icon: Icon(
                                        _showPassword
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: const Color(0xFF9A8878),
                                        size: 18,
                                      ),
                                      onPressed: () => setState(
                                        () => _showPassword = !_showPassword,
                                      ),
                                    ),
                                    validator: _passwordValidator,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildField(
                                    label: 'Confirm Password',
                                    controller: _confirmPassController,
                                    hint: 'Re-enter password',
                                    icon: Icons.lock_outline_rounded,
                                    obscure: !_showConfirmPassword,
                                    suffix: IconButton(
                                      icon: Icon(
                                        _showConfirmPassword
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: const Color(0xFF9A8878),
                                        size: 18,
                                      ),
                                      onPressed: () => setState(
                                        () => _showConfirmPassword =
                                            !_showConfirmPassword,
                                      ),
                                    ),
                                    validator: _confirmPasswordValidator,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),

                          // ── Terms ──
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEF7EE),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFC8DFC9),
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: Checkbox(
                                    value: _agreeToTerms,
                                    activeColor: const Color(0xFF1A5C35),
                                    side: const BorderSide(
                                      color: Color(0xFF1A5C35),
                                      width: 1.5,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    onChanged: (val) => setState(
                                      () => _agreeToTerms = val ?? false,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    children: [
                                      const Text(
                                        'I agree to the ',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF3A5E3A),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () =>
                                            _showSnack('Opening Terms...'),
                                        child: const Text(
                                          'Terms & Conditions',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFF1A5C35),
                                            fontWeight: FontWeight.w700,
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor: Color(0xFF1A5C35),
                                          ),
                                        ),
                                      ),
                                      const Text(
                                        ' and ',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF3A5E3A),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => _showSnack(
                                          'Opening Privacy Policy...',
                                        ),
                                        child: const Text(
                                          'Privacy Policy',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFF1A5C35),
                                            fontWeight: FontWeight.w700,
                                            decoration:
                                                TextDecoration.underline,
                                            decorationColor: Color(0xFF1A5C35),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 24),

                          // ── Submit Button ──
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF1A5C35),
                                    Color(0xFF2DAA55),
                                    Color(0xFFF5A623),
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: ElevatedButton(
                                onPressed: _isLoading
                                    ? null
                                    : _handleCreateAccount,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  disabledBackgroundColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2.5,
                                        ),
                                      )
                                    : const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Create Account',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Icon(
                                            Icons.arrow_forward_rounded,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // ── Sign In Link ──
                          Center(
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              children: [
                                const Text(
                                  'Already have an account? ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Color(0xFF9A8878),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => Get.toNamed('/login_screen'),
                                  child: const Text(
                                    'Sign In',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF1A5C35),
                                      fontWeight: FontWeight.w700,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Color(0xFF1A5C35),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
