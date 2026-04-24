import 'package:flutter/material.dart';
import 'package:projectfile/core/utils/theme.dart';
import 'package:projectfile/core/services/auth_service.dart';

class ServiceProviderSignupPage extends StatefulWidget {
  const ServiceProviderSignupPage({super.key});

  @override
  State<ServiceProviderSignupPage> createState() =>
      _ServiceProviderSignupPageState();
}

class _ServiceProviderSignupPageState
    extends State<ServiceProviderSignupPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _fullNameCtrl    = TextEditingController();
  final _emailCtrl       = TextEditingController();
  final _phoneCtrl       = TextEditingController();
  final _cnicCtrl        = TextEditingController();
  final _addressCtrl     = TextEditingController();
  final _passwordCtrl    = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  final _yearsExpCtrl    = TextEditingController();
  final _bioCtrl         = TextEditingController();

  bool _showPassword        = false;
  bool _showConfirmPassword = false;
  bool _agreeToTerms        = false;
  bool _isLoading           = false;
  String? _selectedCategory;

  static const List<String> _categories = [
    'Electrician',
    'Plumber',
    'Cleaner',
    'Carpenter',
    'Painter',
    'Tutor',
    'Gardener',
    'Driver',
    'Mechanic',
    'Appliance Repair',
    'Other',
  ];

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _cnicCtrl.dispose();
    _addressCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPassCtrl.dispose();
    _yearsExpCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  // ── Snackbar ─────────────────────────────────
  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? AppTheme.errorRed : AppTheme.primaryGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ── Validators ───────────────────────────────
  String? _required(String? v, String field) {
    if (v == null || v.trim().isEmpty) return '$field is required';
    return null;
  }

  String? _emailVal(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    if (!RegExp(r'^[\w\-.]+@([\w\-]+\.)+[\w]{2,4}$')
        .hasMatch(v.trim())) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _cnicVal(String? v) {
    if (v == null || v.trim().isEmpty) return 'CNIC is required';
    if (!RegExp(r'^\d{5}-\d{7}-\d$').hasMatch(v.trim())) {
      return 'Format: XXXXX-XXXXXXX-X';
    }
    return null;
  }

  String? _passVal(String? v) {
    if (v == null || v.isEmpty) return 'Password is required';
    if (v.length < 6) return 'Minimum 6 characters';
    return null;
  }

  String? _confirmPassVal(String? v) {
    if (v == null || v.isEmpty) return 'Please confirm password';
    if (v != _passwordCtrl.text) return 'Passwords do not match';
    return null;
  }

  String? _yearsVal(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    final n = int.tryParse(v.trim());
    if (n == null || n < 0) return 'Enter valid number';
    return null;
  }

  // ── Submit using AuthService ─────────────────
  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeToTerms) {
      _showSnack(
        'Please agree to Terms and Conditions and Privacy Policy.',
        isError: true,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final result = await AuthService.registerProvider({
        'full_name': _fullNameCtrl.text.trim(),
        'email': _emailCtrl.text.trim(),
        'phone': _phoneCtrl.text.trim(),
        'cnic': _cnicCtrl.text.trim(),
        'address': _addressCtrl.text.trim(),
        'password': _passwordCtrl.text,
        'category': _selectedCategory,
        'years_of_experience': int.tryParse(_yearsExpCtrl.text.trim()) ?? 0,
        'bio': _bioCtrl.text.trim(),
      });

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (result['success'] == true) {
        _showSnack(result['message'] ?? 'Account created successfully! Welcome to ServEase.');
        
        // Navigate to provider home or dashboard
        // Navigator.pushReplacementNamed(context, '/provider-home');
        
        // For now, just show success and go back
        await Future.delayed(const Duration(seconds: 1));
        if (!mounted) return;
        Navigator.pop(context);
      } else {
        _showSnack(result['message'] ?? 'Registration failed', isError: true);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showSnack('An error occurred. Please try again.', isError: true);
    }
  }

  // ── Input Decoration ─────────────────────────
  InputDecoration _dec({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle:
          const TextStyle(color: AppTheme.textLight, fontSize: 13),
      prefixIcon: Icon(icon, color: AppTheme.textLight, size: 18),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppTheme.borderLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppTheme.borderLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppTheme.primaryGreen, width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppTheme.errorRed),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide:
            const BorderSide(color: AppTheme.errorRed, width: 1.6),
      ),
    );
  }

  // ── Label ────────────────────────────────────
  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppTheme.textDark,
          ),
        ),
      );

  // ── Two-column row ───────────────────────────
  Widget _row(Widget left, Widget right) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: left),
          const SizedBox(width: 16),
          Expanded(child: right),
        ],
      );

  // ── Eye icon button ──────────────────────────
  Widget _eyeBtn(bool visible, VoidCallback onTap) => IconButton(
        icon: Icon(
          visible
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: const Color(0xFFBBBBBB),
          size: 18,
        ),
        onPressed: onTap,
      );

  // ── Build ────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    Color? green = AppTheme.primaryGreen;
    return Scaffold(
      backgroundColor: const Color(0xFFEEECE8),
      body: SafeArea(
        child: Stack(
          children: [
            // Main scrollable content
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(top: 60, bottom: 40),
                child: Center(
                  child: ConstrainedBox(
                    constraints:
                        const BoxConstraints(maxWidth: 580),
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
                            // ── Icon + Title ──────────────
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
                                          AppTheme.primaryGreen,
                                          AppTheme.accentOrange,
                                        ],
                                        begin: Alignment.topLeft,
                                        end:
                                            Alignment.bottomRight,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(
                                              16),
                                    ),
                                    child: const Icon(
                                      Icons.work_outline_rounded,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'Join as Service Provider',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    'Start earning by providing your professional services',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black45),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 28),

                            // ── Row 1: Full Name + Email ──
                            _row(
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  _label('Full Name'),
                                  TextFormField(
                                    controller: _fullNameCtrl,
                                    decoration: _dec(
                                      hint: 'Enter your full name',
                                      icon: Icons.person_outline,
                                    ),
                                    validator: (v) =>
                                        _required(v, 'Full name'),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  _label('Email Address'),
                                  TextFormField(
                                    controller: _emailCtrl,
                                    keyboardType:
                                        TextInputType.emailAddress,
                                    decoration: _dec(
                                      hint: 'Enter your email',
                                      icon: Icons.mail_outline,
                                    ),
                                    validator: _emailVal,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // ── Row 2: Phone + CNIC ──────
                            _row(
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  _label('Phone Number'),
                                  TextFormField(
                                    controller: _phoneCtrl,
                                    keyboardType:
                                        TextInputType.phone,
                                    decoration: _dec(
                                      hint: 'Enter your phone number',
                                      icon: Icons.phone_outlined,
                                    ),
                                    validator: (v) =>
                                        _required(v, 'Phone number'),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  _label('CNIC Number'),
                                  TextFormField(
                                    controller: _cnicCtrl,
                                    decoration: _dec(
                                      hint: 'XXXXX-XXXXXXX-X',
                                      icon: Icons
                                          .credit_card_outlined,
                                    ),
                                    validator: _cnicVal,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // ── Row 3: Address + Password ─
                            _row(
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  _label('Address'),
                                  TextFormField(
                                    controller: _addressCtrl,
                                    decoration: _dec(
                                      hint: 'Enter your address',
                                      icon: Icons
                                          .location_on_outlined,
                                    ),
                                    validator: (v) =>
                                        _required(v, 'Address'),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  _label('Password'),
                                  TextFormField(
                                    controller: _passwordCtrl,
                                    obscureText: !_showPassword,
                                    decoration: _dec(
                                      hint: 'Create a password',
                                      icon: Icons.lock_outline,
                                      suffix: _eyeBtn(
                                        _showPassword,
                                        () => setState(() =>
                                            _showPassword =
                                                !_showPassword),
                                      ),
                                    ),
                                    validator: _passVal,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // ── Confirm Password (left half)
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
                                            _confirmPassCtrl,
                                        obscureText:
                                            !_showConfirmPassword,
                                        decoration: _dec(
                                          hint: 'Confirm your password',
                                          icon: Icons.lock_outline,
                                          suffix: _eyeBtn(
                                            _showConfirmPassword,
                                            () => setState(() =>
                                                _showConfirmPassword =
                                                    !_showConfirmPassword),
                                          ),
                                        ),
                                        validator: _confirmPassVal,
                                      ),
                                    ],
                                  ),
                                ),
                                const Expanded(child: SizedBox()),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // ── Professional Information ──
                            const Text(
                              'Professional Information',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),

                            const SizedBox(height: 16),

                            // ── Row 4: Category + Experience
                            _row(
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  _label('Service Category'),
                                  DropdownButtonFormField<String>(
                                    initialValue: _selectedCategory,
                                    isExpanded: true,
                                    icon: const Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Color(0xFFBBBBBB)),
                                    hint: const Text(
                                      'Select a category',
                                      style: TextStyle(
                                          color: Color(0xFFBBBBBB),
                                          fontSize: 13),
                                    ),
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                          Icons.grid_view_outlined,
                                          color: Color(0xFFBBBBBB),
                                          size: 18),
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 14,
                                              horizontal: 12),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFE0E0E0)),
                                      ),
                                      enabledBorder:
                                          OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Color(0xFFE0E0E0)),
                                      ),
                                      focusedBorder:
                                          OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: AppTheme.primaryGreen,
                                            width: 1.6),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.redAccent),
                                      ),
                                      focusedErrorBorder:
                                          OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                            color: Colors.redAccent,
                                            width: 1.6),
                                      ),
                                    ),
                                    items: _categories
                                        .map(
                                          (c) => DropdownMenuItem(
                                            value: c,
                                            child: Text(c,
                                                style: const TextStyle(
                                                    fontSize: 13)),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (val) => setState(
                                        () => _selectedCategory = val),
                                    validator: (v) => v == null
                                        ? 'Please select a category'
                                        : null,
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  _label('Years of Experience'),
                                  TextFormField(
                                    controller: _yearsExpCtrl,
                                    keyboardType:
                                        TextInputType.number,
                                    decoration: _dec(
                                      hint: 'e.g. 5',
                                      icon: Icons
                                          .access_time_outlined,
                                    ),
                                    validator: _yearsVal,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 16),

                            // ── Professional Bio ──────────
                            _label('Professional Bio'),
                            TextFormField(
                              controller: _bioCtrl,
                              maxLines: 4,
                              decoration: InputDecoration(
                                hintText:
                                    'Tell us about your skills, experience, and what makes you stand out...',
                                hintStyle: const TextStyle(
                                    color: Color(0xFFBBBBBB),
                                    fontSize: 13),
                                prefixIcon: const Padding(
                                  padding:
                                      EdgeInsets.only(bottom: 56),
                                  child: Icon(
                                      Icons.edit_note_outlined,
                                      color: Color(0xFFBBBBBB),
                                      size: 20),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding:
                                    const EdgeInsets.symmetric(
                                        vertical: 14,
                                        horizontal: 12),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Color(0xFFE0E0E0)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Color(0xFFE0E0E0)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: AppTheme.primaryGreen, width: 1.6),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Colors.redAccent),
                                ),
                                focusedErrorBorder:
                                    OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(10),
                                  borderSide: const BorderSide(
                                      color: Colors.redAccent,
                                      width: 1.6),
                                ),
                              ),
                              validator: (v) =>
                                  _required(v, 'Professional bio'),
                            ),

                            const SizedBox(height: 22),

                            // ── Terms Checkbox ────────────
                            Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Checkbox(
                                    value: _agreeToTerms,
                                    activeColor: AppTheme.primaryGreen,
                                    side: const BorderSide(
                                        color: Color(0xFF555555),
                                        width: 1.5),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(
                                                3)),
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
                                        child: Text(
                                          'Terms and Conditions',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: green,
                                            fontWeight:
                                                FontWeight.w600,
                                            decoration: TextDecoration
                                                .underline,
                                            decorationColor: green,
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
                                        child: Text(
                                          'Privacy Policy',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: green,
                                            fontWeight:
                                                FontWeight.w600,
                                            decoration: TextDecoration
                                                .underline,
                                            decorationColor: green,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // ── Create Account Button ─────
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      green,
                                      const Color(0xFF2DAA55),
                                      AppTheme.accentOrange,
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.primaryGreen.withAlpha(89),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: _isLoading
                                      ? null
                                      : _handleSubmit,
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

                            // ── Sign In link ──────────────
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
                                    onTap: () => Navigator.of(context).pushNamed('/login'),
                                    child: Text(
                                      'Sign In',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: green,
                                        fontWeight: FontWeight.w700,
                                        decoration:
                                            TextDecoration.underline,
                                        decorationColor: green,
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
