import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:frontfile_servease/features/auth/services/providerpagereg_service.dart';
import 'package:frontfile_servease/services/service_request_service.dart';
import 'package:frontfile_servease/features/auth/services/auth_service.dart';
import 'package:frontfile_servease/features/auth/screens/otp_verify_screen.dart';
import 'package:frontfile_servease/core/theme/app_theme.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:frontfile_servease/features/auth/screens/cnic_scanner_screen.dart';

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

  final _customServiceCtrl = TextEditingController();
  final _customCategoryCtrl = TextEditingController();
  bool _isCustomService = false;

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
    "Other (Custom)": ["Other — Specify Below"],
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
    _customServiceCtrl.dispose();
    _customCategoryCtrl.dispose();
    super.dispose();
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? AppColors.destructive : AppColors.secondary,
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
    if (v.length < 8) return 'Minimum 8 characters';
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

  void _showImageSourceSheet(bool isFront) {
    if (kIsWeb) {
      _pickImage(isFront);
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              const Text(
                "Choose Option",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.foreground,
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(
                  Icons.document_scanner_outlined,
                  color: AppColors.primary,
                ),
                title: const Text("Scan Card (Auto-capture)"),
                onTap: () {
                  Navigator.pop(ctx);
                  _scanCnicCard(isFront);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library_outlined,
                  color: AppColors.primary,
                ),
                title: const Text("Choose from Gallery"),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(isFront);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Future<void> _scanCnicCard(bool isFront) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CnicScannerScreen()),
    );

    if (result != null && result is Map<String, dynamic>) {
      final detectedCnic = result['cnic'] as String;
      final imageFile = result['image'] as XFile;
      final bytes = await imageFile.readAsBytes();

      setState(() {
        _cnicCtrl.text = detectedCnic;
        if (isFront) {
          _cnicFrontBytes = bytes;
          _cnicFrontName = imageFile.name;
        } else {
          _cnicBackBytes = bytes;
          _cnicBackName = imageFile.name;
        }
      });

      _showSnack("CNIC scanned and auto-filled successfully!", isError: false);
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

    // Client-side image format validation before OTP
    final allowedExtensions = ['.jpg', '.jpeg', '.png', '.webp'];
    final frontName = _cnicFrontName?.toLowerCase() ?? '';
    final backName = _cnicBackName?.toLowerCase() ?? '';

    bool isFrontValid = allowedExtensions.any((ext) => frontName.endsWith(ext)) || frontName.isEmpty;
    bool isBackValid = allowedExtensions.any((ext) => backName.endsWith(ext)) || backName.isEmpty;

    if (!isFrontValid || !isBackValid) {
      _showSnack(
        'Only JPG, JPEG, PNG and WEBP images are allowed for CNIC.',
        isError: true,
      );
      return;
    }

    setState(() => _isLoading = true);
    final otpResult = await AuthService.sendOtp(
      email: _emailCtrl.text.trim(),
      fullName: _fullNameCtrl.text.trim(),
    );
    setState(() => _isLoading = false);

    if (otpResult['success'] != true) {
      _showSnack(otpResult['message'] ?? 'Failed to send OTP', isError: true);
      return;
    }

    if (!mounted) return;

    Get.to(
      () => OtpVerifyScreen(
        email: _emailCtrl.text.trim(),
        fullName: _fullNameCtrl.text.trim(),
        onVerified: () async {
          Get.back();
          setState(() => _isLoading = true);
          try {
            final finalCategory = _isCustomService
                ? (_customCategoryCtrl.text.trim().isNotEmpty
                      ? _customCategoryCtrl.text.trim()
                      : "Other")
                : _selectedCategory;
            final finalService = _isCustomService
                ? _customServiceCtrl.text.trim()
                : _selectedService;

            final result = await ProviderService().registerProviderWeb(
              {
                'full_name': _fullNameCtrl.text.trim(),
                'email': _emailCtrl.text.trim(),
                'phone': _phoneCtrl.text.trim(),
                'cnic': _cnicCtrl.text.trim(),
                'address': _addressCtrl.text.trim(),
                'password': _passwordCtrl.text,
                'role': 'provider',
                'category': finalCategory,
                'service_name': finalService,
                'years_of_experience':
                    int.tryParse(_yearsExpCtrl.text.trim()) ?? 0,
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
              if (_isCustomService) {
                await ServiceRequestService.submitRequest(
                  serviceName: _customServiceCtrl.text.trim(),
                  category: "Other (Custom)",
                  customCategory: _customCategoryCtrl.text.trim(),
                  description: _bioCtrl.text.trim(),
                  yearsOfExperience:
                      int.tryParse(_yearsExpCtrl.text.trim()) ?? 0,
                  providerName: _fullNameCtrl.text.trim(),
                  providerEmail: _emailCtrl.text.trim(),
                );
                _showSnack(
                  'Registration successful! Your custom service request has been sent to admin for approval.',
                );
              } else {
                _showSnack('Registration successful! Awaiting admin approval.');
              }
              await Future.delayed(const Duration(seconds: 1));
              if (!mounted) return;
              Get.offAllNamed('/login_screen');
            } else {
              _showSnack(
                result['message'] ?? 'Registration failed',
                isError: true,
              );
            }
          } catch (e) {
            if (!mounted) return;
            setState(() => _isLoading = false);
            _showSnack('An error occurred. Please try again.', isError: true);
          }
        },
      ),
    );
  }

  // ─────────────────────────── UI HELPERS ───────────────────────────

  InputDecoration _dec({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: AppColors.mutedForeground,
        fontSize: 13,
      ),
      prefixIcon: Icon(icon, color: AppColors.primary, size: 18),
      suffixIcon: suffix,
      filled: true,
      fillColor: AppColors.inputBackground,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.destructive),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: const BorderSide(color: AppColors.destructive, width: 1.6),
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.foreground,
        letterSpacing: 0.3,
      ),
    ),
  );

  Widget _row(Widget left, Widget right) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          left,
          const SizedBox(height: 14),
          right,
        ],
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: left),
          const SizedBox(width: 16),
          Expanded(child: right),
        ],
      );
    }
  }

  Widget _eyeBtn(bool visible, VoidCallback onTap) => IconButton(
    icon: Icon(
      visible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
      color: AppColors.mutedForeground,
      size: 18,
    ),
    onPressed: onTap,
  );

  /// Section header with a left-side accent bar
  Widget _sectionHeader(String title, IconData icon) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Row(
      children: [
        Container(
          width: 3,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.foreground,
            letterSpacing: 0.2,
          ),
        ),
      ],
    ),
  );

  Widget _imagePreview(Uint8List? bytes, bool isFront) {
    final uploaded = bytes != null;
    return GestureDetector(
      onTap: () => _showImageSourceSheet(isFront),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 130,
        width: double.infinity,
        decoration: BoxDecoration(
          color: uploaded ? AppColors.accent : AppColors.inputBackground,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(
            color: uploaded ? AppColors.secondary : AppColors.border,
            width: uploaded ? 1.8 : 1.2,
          ),
        ),
        child: uploaded
            ? ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                child: Stack(
                  children: [
                    Image.memory(
                      bytes,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 130,
                    ),
                    Positioned(
                      bottom: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Change',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.muted,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add_a_photo_outlined,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tap to upload',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.mutedForeground,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // ─────────────────────────── BUILD ───────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  children: [
                    // ── HERO HEADER (outside card) ──
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 36,
                        vertical: 36,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, Color(0xFFD4956A)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.work_outline_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Join as Service Provider',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Start earning by providing professional services',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── FORM CARD ──
                    Container(
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 32,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        border: const Border(
                          left: BorderSide(color: AppColors.border),
                          right: BorderSide(color: AppColors.border),
                          bottom: BorderSide(color: AppColors.border),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.06),
                            blurRadius: 24,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ── SECTION: Personal Info ──
                            _sectionHeader(
                              'Personal Information',
                              Icons.person_outline,
                            ),

                            _row(
                              _field(
                                label: 'Full Name',
                                child: TextFormField(
                                  controller: _fullNameCtrl,
                                  decoration: _dec(
                                    hint: 'Enter your full name',
                                    icon: Icons.person_outline,
                                  ),
                                  validator: (v) => _required(v, 'Full name'),
                                ),
                              ),
                              _field(
                                label: 'Email Address',
                                child: TextFormField(
                                  controller: _emailCtrl,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: _dec(
                                    hint: 'Enter your email',
                                    icon: Icons.mail_outline,
                                  ),
                                  validator: _emailVal,
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),

                            _row(
                              _field(
                                label: 'Phone Number',
                                child: TextFormField(
                                  controller: _phoneCtrl,
                                  keyboardType: TextInputType.phone,
                                  decoration: _dec(
                                    hint: 'Enter your phone number',
                                    icon: Icons.phone_outlined,
                                  ),
                                  validator: (v) =>
                                      _required(v, 'Phone number'),
                                ),
                              ),
                              _field(
                                label: 'CNIC Number',
                                child: TextFormField(
                                  controller: _cnicCtrl,
                                  decoration: _dec(
                                    hint: 'XXXXX-XXXXXXX-X',
                                    icon: Icons.credit_card_outlined,
                                  ),
                                  validator: _cnicVal,
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),

                            _field(
                              label: 'Address',
                              child: TextFormField(
                                controller: _addressCtrl,
                                maxLength: 150,
                                decoration: _dec(
                                  hint: 'Enter your address',
                                  icon: Icons.location_on_outlined,
                                ),
                                validator: (v) => _required(v, 'Address'),
                              ),
                            ),
                            const SizedBox(height: 14),

                            _row(
                              _field(
                                label: 'Password',
                                child: TextFormField(
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
                              ),
                              _field(
                                label: 'Confirm Password',
                                child: TextFormField(
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
                              ),
                            ),

                            const SizedBox(height: 28),
                            _divider(),
                            const SizedBox(height: 24),

                            // ── SECTION: Professional Info ──
                            _sectionHeader(
                              'Professional Information',
                              Icons.work_outline_rounded,
                            ),

                            _row(
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _field(
                                    label: 'Category',
                                    child: DropdownButtonFormField<String>(
                                      value: _selectedCategory,
                                      decoration: _dec(
                                        hint: 'Select Category',
                                        icon: Icons.category_outlined,
                                      ),
                                      dropdownColor: AppColors.card,
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
                                        _isCustomService =
                                            v == "Other (Custom)";
                                      }),
                                      validator: (v) =>
                                          v == null ? 'Select Category' : null,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  _field(
                                    label: 'Service',
                                    child: DropdownButtonFormField<String>(
                                      value: _selectedService,
                                      decoration: _dec(
                                        hint: 'Select Service',
                                        icon:
                                            Icons.home_repair_service_outlined,
                                      ),
                                      dropdownColor: AppColors.card,
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
                                          v == null ? 'Select Service' : null,
                                    ),
                                  ),
                                  if (_isCustomService) ...[
                                    const SizedBox(height: 14),
                                    TextFormField(
                                      controller: _customServiceCtrl,
                                      decoration: _dec(
                                        hint: 'e.g. AC Repair, Plumbing...',
                                        icon: Icons.edit_outlined,
                                      ),
                                      validator: (v) =>
                                          _isCustomService &&
                                              (v == null || v.trim().isEmpty)
                                          ? 'Please enter your service name'
                                          : null,
                                    ),
                                    const SizedBox(height: 10),
                                    TextFormField(
                                      controller: _customCategoryCtrl,
                                      decoration: _dec(
                                        hint: 'e.g. Home Repair, Technical...',
                                        icon: Icons.category_outlined,
                                      ),
                                      validator: (v) =>
                                          _isCustomService &&
                                              (v == null || v.trim().isEmpty)
                                          ? 'Please enter category'
                                          : null,
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: AppColors.warningBg,
                                        borderRadius: BorderRadius.circular(
                                          AppRadius.md,
                                        ),
                                        border: Border.all(
                                          color: AppColors.yellowBorder,
                                        ),
                                      ),
                                      child: const Row(
                                        children: [
                                          Icon(
                                            Icons.info_outline,
                                            size: 15,
                                            color: AppColors.accentYellow,
                                          ),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              'Your service request will be sent to admin for approval.',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: AppColors.darkMaroon,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              _field(
                                label: 'Years of Experience',
                                child: TextFormField(
                                  controller: _yearsExpCtrl,
                                  keyboardType: TextInputType.number,
                                  decoration: _dec(
                                    hint: 'e.g. 5',
                                    icon: Icons.access_time_outlined,
                                  ),
                                  validator: _yearsVal,
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),

                            _field(
                              label: 'Professional Bio',
                              child: TextFormField(
                                controller: _bioCtrl,
                                maxLines: 4,
                                maxLength: 150,
                                decoration: _dec(
                                  hint: 'Tell us about your skills...',
                                  icon: Icons.edit_note_outlined,
                                ),
                                validator: (v) =>
                                    _required(v, 'Professional bio'),
                              ),
                            ),

                            const SizedBox(height: 28),
                            _divider(),
                            const SizedBox(height: 24),

                            // ── SECTION: CNIC ──
                            _sectionHeader(
                              'CNIC Verification',
                              Icons.badge_outlined,
                            ),
                            const Text(
                              'Upload clear photos of both sides of your CNIC',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.mutedForeground,
                              ),
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

                            const SizedBox(height: 24),

                            // ── Terms ──
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.muted,
                                borderRadius: BorderRadius.circular(
                                  AppRadius.md,
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: Checkbox(
                                      value: _agreeToTerms,
                                      activeColor: AppColors.primary,
                                      side: const BorderSide(
                                        color: AppColors.mutedForeground,
                                        width: 1.5,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      onChanged: (v) => setState(
                                        () => _agreeToTerms = v ?? false,
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
                                            color: AppColors.foreground,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () =>
                                              _showSnack('Opening Terms...'),
                                          child: const Text(
                                            'Terms and Conditions',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.w600,
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor:
                                                  AppColors.primary,
                                            ),
                                          ),
                                        ),
                                        const Text(
                                          ' and ',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: AppColors.foreground,
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
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.w600,
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor:
                                                  AppColors.primary,
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
                              height: 52,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      AppColors.primary,
                                      Color(0xFFD4956A),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.xl,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withOpacity(
                                        0.35,
                                      ),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _handleSubmit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    shadowColor: Colors.transparent,
                                    disabledBackgroundColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        AppRadius.xl,
                                      ),
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
                                            Icon(
                                              Icons.check_circle_outline,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              'Create Account',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),

                            Center(
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                children: [
                                  const Text(
                                    'Already have an account? ',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.mutedForeground,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => Get.toNamed('/login_screen'),
                                    child: const Text(
                                      'Sign In',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w700,
                                        decoration: TextDecoration.underline,
                                        decorationColor: AppColors.primary,
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
          ),
        ),
      ),
    );
  }

  /// Wraps a label + child together for consistent spacing
  Widget _field({required String label, required Widget child}) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [_label(label), child],
  );

  Widget _divider() => Row(
    children: [
      Expanded(
        child: Container(
          height: 1,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                AppColors.border,
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
