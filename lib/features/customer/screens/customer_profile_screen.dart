import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontfile_servease/routes.dart';
import 'package:frontfile_servease/core/theme/app_theme.dart';
import 'package:frontfile_servease/core/services/app_config.dart';
import 'package:frontfile_servease/features/customer/screens/customer_security_screen.dart';
import 'package:frontfile_servease/features/customer/services/customerserviceali.dart';
import 'navbar.dart';

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  final box = GetStorage();
  Map<String, dynamic>? _profile;
  bool _isLoading = true;
  bool _isSaving = false;
  XFile? _selectedImage;

  late TextEditingController _nameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _cityCtrl;

  int get _userId => box.read('user_id') ?? 0;

  static const Color primaryGreen = AppColors.primary;
  static const Color darkGreen = Color(0xFF145E33);
  static const Color accentOrange = AppColors.secondary;
  static const Color bgColor = AppColors.background;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _emailCtrl = TextEditingController();
    _phoneCtrl = TextEditingController();
    _cityCtrl = TextEditingController();
    _load();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    final data = await CustomerApiService.fetchProfile(_userId);
    if (data != null) {
      setState(() {
        _profile = data;
        _nameCtrl.text = data['full_name'] ?? '';
        _emailCtrl.text = data['email'] ?? '';
        _phoneCtrl.text = data['phone'] ?? '';
        _cityCtrl.text = data['address'] ?? '';
      });
    }
    setState(() => _isLoading = false);
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() {
        _selectedImage = picked;
      });
    }
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Name cannot be empty'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() => _isSaving = true);
    final success = await CustomerApiService.updateProfile(
      userId: _userId,
      fullName: _nameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      address: _cityCtrl.text.trim(),
      image: _selectedImage,
    );
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully! ✅'),
          backgroundColor: primaryGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
      _selectedImage = null;
      _load();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update profile ❌'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    setState(() => _isSaving = false);
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Sign Out', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to sign out from ServEase?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey.shade600)),
          ),
          ElevatedButton(
            onPressed: () {
              box.erase();
              Get.offAllNamed(AppRoutes.loginScreen);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  String get _initials {
    final name = _nameCtrl.text.trim();
    final parts = name.split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name.substring(0, 1).toUpperCase() : 'C';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      bottomNavigationBar: const CustomerNavBar(currentIndex: 3),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: primaryGreen),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 10),
                  _buildPersonalInfo(),
                  const SizedBox(height: 14),
                  _buildQuickActions(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader() {
    final bookings = _profile?['total_bookings'] ?? 0;
    final memberSince = _profile?['member_since'] ?? '';
    final city = _profile?['address'] ?? '';
    final profileImage = _profile?['profile_image'];

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryGreen, darkGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 56, 16, 24),
      child: Column(
        children: [
          // Avatar with Edit Button
          GestureDetector(
            onTap: _pickImage,
            child: Stack(
              children: [
                Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.4),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: _selectedImage != null
                        ? (kIsWeb
                            ? Image.network(_selectedImage!.path, fit: BoxFit.cover)
                            : Image.file(File(_selectedImage!.path), fit: BoxFit.cover))
                        : (profileImage != null && profileImage.toString().isNotEmpty)
                            ? Image.network(
                                profileImage.toString().startsWith('http')
                                    ? profileImage.toString()
                                    : "${AppConfig.baseUrl}${profileImage.toString()}",
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Center(
                                  child: Text(
                                    _initials,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                            : Center(
                                child: Text(
                                  _initials,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 14,
                      color: primaryGreen,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _nameCtrl.text.isNotEmpty ? _nameCtrl.text : 'Customer',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Member since $memberSince${city.isNotEmpty ? ' · $city' : ''}',
            style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 12),
          ),
          const SizedBox(height: 16),
          // Stats
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _headerStat('$bookings', 'Total Bookings'),
                Container(width: 1, height: 24, color: Colors.white12),
                _headerStat('${_profile?['active_bookings'] ?? 0}', 'Active Bookings'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildPersonalInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PERSONAL INFORMATION',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: darkGreen,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 16),
          _field('FULL NAME', _nameCtrl, icon: Icons.person_outline),
          _field('EMAIL ADDRESS', _emailCtrl, enabled: false, icon: Icons.email_outlined),
          _field('PHONE NUMBER', _phoneCtrl, type: TextInputType.phone, icon: Icons.phone_outlined),
          _field('CITY / ADDRESS', _cityCtrl, isLast: true, icon: Icons.location_on_outlined),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _isSaving ? null : _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            child: _isSaving
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Save Changes',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController ctrl, {
    bool enabled = true,
    TextInputType? type,
    bool isLast = false,
    required IconData icon,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: ctrl,
            enabled: enabled,
            keyboardType: type,
            style: TextStyle(
              fontSize: 14,
              color: enabled ? Colors.black87 : Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, size: 18, color: enabled ? primaryGreen : Colors.grey),
              filled: true,
              fillColor: enabled ? const Color(0xFFFBFBFD) : Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade100),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: primaryGreen, width: 1.5),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'QUICK ACTIONS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: darkGreen,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),

          _actionTile(
            icon: Icons.lock_outline,
            iconBg: const Color(0xFFFFF3E0),
            iconColor: Colors.orange.shade700,
            title: 'Security & Privacy',
            subtitle: 'Update password & credentials',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CustomerSecurityScreen(userId: _userId),
              ),
            ),
          ),
          _divider(),
          _actionTile(
            icon: Icons.logout,
            iconBg: const Color(0xFFFFEBEE),
            iconColor: Colors.red.shade600,
            title: 'Logout',
            subtitle: 'Sign out from your account',
            onTap: _logout,
            titleColor: Colors.red.shade600,
          ),
        ],
      ),
    );
  }

  Widget _actionTile({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? titleColor,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: iconBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: titleColor ?? Colors.black87,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 14,
        color: Colors.grey.shade400,
      ),
    );
  }

  Widget _divider() =>
      const Divider(height: 1, indent: 70, color: Color(0xFFF5F5F5));
}
