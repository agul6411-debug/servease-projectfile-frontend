import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:frontfile_servease/services/providerpagereg_service.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProviderPagereg extends StatefulWidget {
  const ProviderPagereg({super.key});

  @override
  State<ProviderPagereg> createState() => _ProviderPageregState();
}

class _ProviderPageregState extends State<ProviderPagereg> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _cnicCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  final _yearsExpCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();

  Uint8List? _cnicFrontBytes;
  String? _cnicFrontName;
  Uint8List? _cnicBackBytes;
  String? _cnicBackName;

  final ImagePicker _picker = ImagePicker();
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _agreeToTerms = false;
  bool _isLoading = false;

  String? _selectedCategory;
  String? _selectedService;

  final Map<String, List<String>> _categoryServices = {
    "Home Services": ["Cleaning", "Baby Sitter"],
    "Fashion & Design": ["Tailoring", "Embroidery"],
    "Beauty & Care": ["Beauty", "Mehndi"],
    "Education": ["Tutoring"],
    "Media": ["Photography"],
  };

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

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError
            ? const Color(0xFFF44336)
            : const Color(0xFF4CAF50),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  String? _required(String? v, String field) =>
      (v == null || v.trim().isEmpty) ? '$field is required' : null;

  String? _emailVal(String? v) {
    if (v == null || v.trim().isEmpty) return 'Email is required';
    if (!RegExp(r'^[\w\-.]+@([\w\-]+\.)+[\w]{2,4}$').hasMatch(v.trim()))
      return 'Enter a valid email';
    return null;
  }

  String? _cnicVal(String? v) {
    if (v == null || v.trim().isEmpty) return 'CNIC is required';
    if (!RegExp(r'^\d{5}-\d{7}-\d$').hasMatch(v.trim()))
      return 'Format: XXXXX-XXXXXXX-X';
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

  Future<void> _pickImage(bool isFront) async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        if (isFront) {
          _cnicFrontBytes = bytes;
          _cnicFrontName = picked.name;
        } else {
          _cnicBackBytes = bytes;
          _cnicBackName = picked.name;
        }
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeToTerms) {
      _showSnack('Please agree to Terms and Conditions.', isError: true);
      return;
    }
    if (_cnicFrontBytes == null || _cnicBackBytes == null) {
      _showSnack(
        'Please upload both CNIC front and back images.',
        isError: true,
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final result = await ProviderService().registerProviderWeb(
        {
          'full_name': _fullNameCtrl.text.trim(),
          'email': _emailCtrl.text.trim(),
          'phone': _phoneCtrl.text.trim(),
          'cnic': _cnicCtrl.text.trim(),
          'address': _addressCtrl.text.trim(),
          'password': _passwordCtrl.text,
          'role': 'provider',
          'category': _selectedCategory,
          'service_name': _selectedService,
          'years_of_experience': int.tryParse(_yearsExpCtrl.text.trim()) ?? 0,
          'bio': _bioCtrl.text.trim(),
        },
        cnicFrontBytes: _cnicFrontBytes!,
        cnicFrontName: _cnicFrontName ?? 'front.jpg',
        cnicBackBytes: _cnicBackBytes!,
        cnicBackName: _cnicBackName ?? 'back.jpg',
      );
      if (!mounted) return;
      setState(() => _isLoading = false);
      if (result['success'] == true) {
        _showSnack('Registration successful!');
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

  InputDecoration _dec({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFFBBBBBB), fontSize: 13),
      prefixIcon: Icon(icon, color: const Color(0xFFBBBBBB), size: 18),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
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
        borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFF44336)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFF44336), width: 1.6),
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Color(0xFF333333),
      ),
    ),
  );

  Widget _row(Widget left, Widget right) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(child: left),
      const SizedBox(width: 16),
      Expanded(child: right),
    ],
  );

  Widget _eyeBtn(bool visible, VoidCallback onTap) => IconButton(
    icon: Icon(
      visible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
      color: const Color(0xFFBBBBBB),
      size: 18,
    ),
    onPressed: onTap,
  );

  // Web-safe image preview
  Widget _imagePreview(Uint8List? bytes, bool isFront) {
    return GestureDetector(
      onTap: () => _pickImage(isFront),
      child: Container(
        height: 140,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: bytes == null
                ? const Color(0xFFE0E0E0)
                : const Color(0xFF4CAF50),
            width: bytes == null ? 1 : 1.6,
          ),
        ),
        child: bytes == null
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_a_photo_outlined,
                    color: Color(0xFFBBBBBB),
                    size: 28,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tap to upload',
                    style: TextStyle(fontSize: 12, color: Color(0xFFBBBBBB)),
                  ),
                ],
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.memory(
                  bytes,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 140,
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF4CAF50);
    return Scaffold(
      backgroundColor: const Color(0xFFEEECE8),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 580),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 36,
                    vertical: 36,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(18),
                        blurRadius: 28,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Center(
                          child: Column(
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF4CAF50),
                                      Color(0xFFFF9800),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
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
                                  color: Colors.black45,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Row 1: Name + Email
                        _row(
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('Full Name'),
                              TextFormField(
                                controller: _fullNameCtrl,
                                decoration: _dec(
                                  hint: 'Enter your full name',
                                  icon: Icons.person_outline,
                                ),
                                validator: (v) => _required(v, 'Full name'),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('Email Address'),
                              TextFormField(
                                controller: _emailCtrl,
                                keyboardType: TextInputType.emailAddress,
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

                        // Row 2: Phone + CNIC
                        _row(
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('Phone Number'),
                              TextFormField(
                                controller: _phoneCtrl,
                                keyboardType: TextInputType.phone,
                                decoration: _dec(
                                  hint: 'Enter your phone number',
                                  icon: Icons.phone_outlined,
                                ),
                                validator: (v) => _required(v, 'Phone number'),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('CNIC Number'),
                              TextFormField(
                                controller: _cnicCtrl,
                                decoration: _dec(
                                  hint: 'XXXXX-XXXXXXX-X',
                                  icon: Icons.credit_card_outlined,
                                ),
                                validator: _cnicVal,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Row 3: Address + Password
                        _row(
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('Address'),
                              TextFormField(
                                controller: _addressCtrl,
                                decoration: _dec(
                                  hint: 'Enter your address',
                                  icon: Icons.location_on_outlined,
                                ),
                                validator: (v) => _required(v, 'Address'),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                    () => setState(
                                      () => _showPassword = !_showPassword,
                                    ),
                                  ),
                                ),
                                validator: _passVal,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Confirm Password
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _label('Confirm Password'),
                                  TextFormField(
                                    controller: _confirmPassCtrl,
                                    obscureText: !_showConfirmPassword,
                                    decoration: _dec(
                                      hint: 'Confirm your password',
                                      icon: Icons.lock_outline,
                                      suffix: _eyeBtn(
                                        _showConfirmPassword,
                                        () => setState(
                                          () => _showConfirmPassword =
                                              !_showConfirmPassword,
                                        ),
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
                        

                        // Professional Info
                        const Text(
                          'Professional Information',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),

                        _row(
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('Category'),
                              DropdownButtonFormField<String>(
                                value: _selectedCategory,
                                decoration: _dec(
                                  hint: "Select Category",
                                  icon: Icons.category_outlined,
                                ),
                                items: _categoryServices.keys
                                    .map(
                                      (c) => DropdownMenuItem(
                                        value: c,
                                        child: Text(c),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (v) => setState(() {
                                  _selectedCategory = v;
                                  _selectedService = null;
                                }),
                                validator: (v) =>
                                    v == null ? "Select Category" : null,
                              ),
                              const SizedBox(height: 15),
                              _label('Service'),
                              DropdownButtonFormField<String>(
                                value: _selectedService,
                                decoration: _dec(
                                  hint: "Select Service",
                                  icon: Icons.home_repair_service_outlined,
                                ),
                                items:
                                    (_selectedCategory == null
                                            ? <String>[]
                                            : _categoryServices[_selectedCategory]!)
                                        .map(
                                          (s) => DropdownMenuItem(
                                            value: s,
                                            child: Text(s),
                                          ),
                                        )
                                        .toList(),
                                onChanged: (v) =>
                                    setState(() => _selectedService = v),
                                validator: (v) =>
                                    v == null ? "Select Service" : null,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('Years of Experience'),
                              TextFormField(
                                controller: _yearsExpCtrl,
                                keyboardType: TextInputType.number,
                                decoration: _dec(
                                  hint: 'e.g. 5',
                                  icon: Icons.access_time_outlined,
                                ),
                                validator: _yearsVal,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Bio
                        _label('Professional Bio'),
                        TextFormField(
                          controller: _bioCtrl,
                          maxLines: 4,
                          decoration: _dec(
                            hint: 'Tell us about your skills...',
                            icon: Icons.edit_note_outlined,
                          ),
                          validator: (v) => _required(v, 'Professional bio'),
                        ),
                        const SizedBox(height: 24),

                        // CNIC
                        const Text(
                          'CNIC Verification',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Upload clear photos of both sides of your CNIC',
                          style: TextStyle(fontSize: 12, color: Colors.black45),
                        ),
                        const SizedBox(height: 16),

                        _row(
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('CNIC Front'),
                              _imagePreview(_cnicFrontBytes, true),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('CNIC Back'),
                              _imagePreview(_cnicBackBytes, false),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Terms
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Checkbox(
                                value: _agreeToTerms,
                                activeColor: green,
                                side: const BorderSide(
                                  color: Color(0xFF555555),
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                onChanged: (v) =>
                                    setState(() => _agreeToTerms = v ?? false),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  const Text(
                                    'I agree to the ',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF555555),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => _showSnack('Opening Terms...'),
                                    child: const Text(
                                      'Terms and Conditions',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: green,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.underline,
                                        decorationColor: green,
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    ' and ',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF555555),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () =>
                                        _showSnack('Opening Privacy Policy...'),
                                    child: const Text(
                                      'Privacy Policy',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: green,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.underline,
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

                        // Submit
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF4CAF50),
                                  Color(0xFF2DAA55),
                                  Color(0xFFFF9800),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleSubmit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                disabledBackgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
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
                                  : const Text(
                                      'Create Account',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        Center(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            children: [
                              const Text(
                                'Already have an account? ',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black45,
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
              ),
            ),
          ),
        ),
      ),
    );
  }
}
