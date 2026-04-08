import 'package:flutter/material.dart';

class CustomerSignupPage extends StatefulWidget {
  const CustomerSignupPage({super.key});

  @override
  State<CustomerSignupPage> createState() => _CustomerSignupPageState();
}

class _CustomerSignupPageState extends State<CustomerSignupPage> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController    = TextEditingController();
  final _emailController       = TextEditingController();
  final _phoneController       = TextEditingController();
  final _cnicController        = TextEditingController();
  final _addressController     = TextEditingController();
  final _passwordController    = TextEditingController();
  final _confirmPassController = TextEditingController();

  bool _showPassword        = false;
  bool _showConfirmPassword = false;
  bool _agreeToTerms        = false;
  bool _isLoading           = false;

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

  // ── Validators ──────────────────────────────
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

  // ── Submit ───────────────────────────────────
  Future<void> _handleCreateAccount() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_agreeToTerms) {
      _showSnack(
        'Please agree to Terms and Conditions and Privacy Policy.',
        isError: true,
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isLoading = false);

    _showSnack('Account created successfully! Welcome to ServEase.');
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor:
            isError ? Colors.redAccent : const Color(0xFF1A5C35),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ── Input Decoration ─────────────────────────
  InputDecoration _inputDecoration({
    required String hint,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFFBBBBBB), fontSize: 13),
      prefixIcon:
          Icon(prefixIcon, color: const Color(0xFFBBBBBB), size: 18),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:
            const BorderSide(color: Color(0xFF1A5C35), width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:
            const BorderSide(color: Colors.redAccent, width: 1.6),
      ),
    );
  }

  // ── Label ────────────────────────────────────
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Color(0xFF444444),
        ),
      ),
    );
  }

  // ── Two-column row helper ────────────────────
  Widget _fieldRow(Widget left, Widget right) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: left),
        const SizedBox(width: 16),
        Expanded(child: right),
      ],
    );
  }

  // ── Build ────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEECE8),
      body: SafeArea(
        child: Stack(
          children: [
            // Scrollable form
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 60, bottom: 40),
                child: Center(
                  child: ConstrainedBox(
                    constraints:
                        const BoxConstraints(maxWidth: 560),
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 36, vertical: 36),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withAlpha(18),
                            blurRadius: 28,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            // ── Icon + Title ──
                            Center(
                              child: Column(
                                children: [
                                  Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                      gradient:
                                          const LinearGradient(
                                        colors: [
                                          Color(0xFF1A5C35),
                                          Color(0xFFF5A623),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(
                                              16),
                                    ),
                                    child: const Icon(
                                      Icons.person_rounded,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Join as Customer',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight:
                                          FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Get access to trusted home service professionals',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black45),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 28),

                            // ── Row 1: Full Name + Email ──
                            _fieldRow(
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  _label('Full Name'),
                                  TextFormField(
                                    controller:
                                        _fullNameController,
                                    decoration: _inputDecoration(
                                      hint: 'Enter your full name',
                                      prefixIcon:
                                          Icons.person_outline,
                                    ),
                                    validator: (v) =>
                                        _requiredValidator(
                                            v, 'Full name'),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  _label('Email Address'),
                                  TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType
                                        .emailAddress,
                                    decoration: _inputDecoration(
                                      hint: 'Enter your email',
                                      prefixIcon:
                                          Icons.mail_outline,
                                    ),
                                    validator: _emailValidator,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // ── Row 2: Phone + CNIC ──
                            _fieldRow(
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  _label('Phone Number'),
                                  TextFormField(
                                    controller: _phoneController,
                                    keyboardType:
                                        TextInputType.phone,
                                    decoration: _inputDecoration(
                                      hint: 'Enter your phone number',
                                      prefixIcon:
                                          Icons.phone_outlined,
                                    ),
                                    validator: (v) =>
                                        _requiredValidator(
                                            v, 'Phone number'),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  _label('CNIC Number'),
                                  TextFormField(
                                    controller: _cnicController,
                                    decoration: _inputDecoration(
                                      hint: 'XXXXX-XXXXXXX-X',
                                      prefixIcon: Icons
                                          .credit_card_outlined,
                                    ),
                                    validator: _cnicValidator,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // ── Row 3: Address + Password ──
                            _fieldRow(
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  _label('Address'),
                                  TextFormField(
                                    controller:
                                        _addressController,
                                    decoration: _inputDecoration(
                                      hint: 'Enter your address',
                                      prefixIcon: Icons
                                          .location_on_outlined,
                                    ),
                                    validator: (v) =>
                                        _requiredValidator(
                                            v, 'Address'),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  _label('Password'),
                                  TextFormField(
                                    controller:
                                        _passwordController,
                                    obscureText: !_showPassword,
                                    decoration: _inputDecoration(
                                      hint: 'Create a password',
                                      prefixIcon:
                                          Icons.lock_outline,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _showPassword
                                              ? Icons
                                                  .visibility_outlined
                                              : Icons
                                                  .visibility_off_outlined,
                                          color: const Color(
                                              0xFFBBBBBB),
                                          size: 18,
                                        ),
                                        onPressed: () =>
                                            setState(() =>
                                                _showPassword =
                                                    !_showPassword),
                                      ),
                                    ),
                                    validator: _passwordValidator,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // ── Confirm Password (left half) ──
                            Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _label('Confirm Password'),
                                      TextFormField(
                                        controller:
                                            _confirmPassController,
                                        obscureText:
                                            !_showConfirmPassword,
                                        decoration:
                                            _inputDecoration(
                                          hint: 'Confirm your password',
                                          prefixIcon:
                                              Icons.lock_outline,
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _showConfirmPassword
                                                  ? Icons
                                                      .visibility_outlined
                                                  : Icons
                                                      .visibility_off_outlined,
                                              color: const Color(
                                                  0xFFBBBBBB),
                                              size: 18,
                                            ),
                                            onPressed: () => setState(
                                                () => _showConfirmPassword =
                                                    !_showConfirmPassword),
                                          ),
                                        ),
                                        validator:
                                            _confirmPasswordValidator,
                                      ),
                                    ],
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                              ],
                            ),

                            const SizedBox(height: 22),

                            // ── Terms Checkbox ──
                            Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Checkbox(
                                    value: _agreeToTerms,
                                    activeColor:
                                        const Color(0xFF1A5C35),
                                    side: const BorderSide(
                                      color: Color(0xFF555555),
                                      width: 1.5,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(3),
                                    ),
                                    onChanged: (val) => setState(
                                        () => _agreeToTerms =
                                            val ?? false),
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
                                            color:
                                                Color(0xFF555555)),
                                      ),
                                      GestureDetector(
                                        onTap: () => _showSnack(
                                            'Opening Terms and Conditions...'),
                                        child: const Text(
                                          'Terms and Conditions',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color:
                                                Color(0xFF1A5C35),
                                            fontWeight:
                                                FontWeight.w600,
                                            decoration:
                                                TextDecoration
                                                    .underline,
                                            decorationColor:
                                                Color(0xFF1A5C35),
                                          ),
                                        ),
                                      ),
                                      const Text(
                                        ' and ',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color:
                                                Color(0xFF555555)),
                                      ),
                                      GestureDetector(
                                        onTap: () => _showSnack(
                                            'Opening Privacy Policy...'),
                                        child: const Text(
                                          'Privacy Policy',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color:
                                                Color(0xFF1A5C35),
                                            fontWeight:
                                                FontWeight.w600,
                                            decoration:
                                                TextDecoration
                                                    .underline,
                                            decorationColor:
                                                Color(0xFF1A5C35),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // ── Create Account Button ──
                            SizedBox(
                              width: double.infinity,
                              height: 52,
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
                                  borderRadius:
                                      BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF1A5C35)
                                          .withAlpha(89),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: _isLoading
                                      ? null
                                      : _handleCreateAccount,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    disabledBackgroundColor:
                                        Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child:
                                              CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2.5,
                                          ),
                                        )
                                      : const Text(
                                          'Create Account',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight:
                                                FontWeight.w600,
                                            letterSpacing: 0.3,
                                          ),
                                        ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // ── Sign In Link ──
                            Center(
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment:
                                    WrapCrossAlignment.center,
                                children: [
                                  const Text(
                                    'Already have an account? ',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black45),
                                  ),
                                  GestureDetector(
                                    onTap: () => _showSnack(
                                        'Navigating to Sign In...'),
                                    child: const Text(
                                      'Sign In',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF1A5C35),
                                        fontWeight: FontWeight.w700,
                                        decoration:
                                            TextDecoration.underline,
                                        decorationColor:
                                            Color(0xFF1A5C35),
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