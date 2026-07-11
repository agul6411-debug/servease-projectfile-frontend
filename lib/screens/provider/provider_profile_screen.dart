import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:frontfile_servease/routes.dart';
import 'package:frontfile_servease/core/theme/app_theme.dart';
import 'package:frontfile_servease/screens/provider/provider_home_screen.dart';
import 'package:frontfile_servease/screens/provider/providernavbar.dart';
import 'package:frontfile_servease/screens/provider/my_jobs_screen.dart';
import 'package:frontfile_servease/screens/provider/earningscreen.dart';
import 'package:frontfile_servease/screens/provider/provider_notifications_screen.dart';

class ProviderProfileScreen extends StatefulWidget {
  final int providerId;
  const ProviderProfileScreen({super.key, required this.providerId});

  @override
  State<ProviderProfileScreen> createState() => _ProviderProfileScreenState();
}

class _ProviderProfileScreenState extends State<ProviderProfileScreen> {
  Map<String, dynamic>? _profile;
  bool _isLoading = true;
  static const String _base = "http://localhost:3000/api/providerside";

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    try {
      final res = await http.get(
        Uri.parse("$_base/profile?provider_id=${widget.providerId}"),
      );
      if (res.statusCode == 200) {
        setState(() {
          _profile = jsonDecode(res.body);
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  void _logout() {
    GetStorage().erase();
    Get.offAllNamed(AppRoutes.loginScreen);
  }

  String get _initials {
    final name = _profile?['full_name'] ?? '';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name.substring(0, 2).toUpperCase() : 'P';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgGrey,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryGreen),
            )
          : RefreshIndicator(
              color: AppColors.primaryGreen,
              onRefresh: _load,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    _buildHeader(),
                    _buildStatsRow(),
                    const SizedBox(height: 12),
                    _buildMenuList(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: ProviderBottomNavBar(
        currentIndex: 3,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ProviderHomeScreen(providerId: widget.providerId),
              ),
            );
            return;
          }
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MyJobsScreen(providerId: widget.providerId),
              ),
            );
            return;
          }
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EarningsScreen(providerId: widget.providerId),
              ),
            );
            return;
          }
        },
      ),
    );
  }

  Widget _buildHeader() {
    final isVerified = _profile?['approval_status'] == 'approved';
    final rating = double.tryParse(_profile?['rating']?.toString() ?? '0') ?? 0;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
      decoration: const BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.25),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                _initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _profile?['full_name'] ?? '',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _profile?['service_name'] ?? '',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isVerified)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white38),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.verified, color: Colors.white, size: 13),
                      SizedBox(width: 4),
                      Text(
                        'CNIC Verified',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white38),
                ),
                child: Row(
                  children: [
                    Text(
                      rating.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 3),
                    const Icon(
                      Icons.star,
                      color: AppColors.accentYellow,
                      size: 13,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    final jobs = _profile?['jobs_done'] ?? 0;
    final rating = double.tryParse(_profile?['rating']?.toString() ?? '0') ?? 0;
    final rate = _profile?['hourly_rate'] ?? 0;
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _statItem('$jobs', 'Jobs done'),
          _divider(),
          _statItem(rating.toStringAsFixed(1), 'Rating'),
          _divider(),
          _statItem('RS $rate', 'Per hour'),
        ],
      ),
    );
  }

  Widget _statItem(String value, String label) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() =>
      Container(width: 1, height: 40, color: Colors.grey.shade200);

  Widget _buildMenuList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _menuItem(
            icon: Icons.edit_outlined,
            iconColor: AppColors.primaryGreen,
            title: 'Edit Profile & Services',
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditProviderProfileScreen(
                    providerId: widget.providerId,
                    profile: _profile!,
                  ),
                ),
              );
              _load();
            },
          ),
          _menuDivider(),
          _menuItem(
            icon: Icons.badge_outlined,
            iconColor: const Color(0xFF1565C0),
            title: 'CNIC Verification Status',
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.successBg,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                _profile?['approval_status'] == 'approved'
                    ? 'Verified'
                    : 'Pending',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: _profile?['approval_status'] == 'approved'
                      ? AppColors.primaryGreen
                      : Colors.orange,
                ),
              ),
            ),
            onTap: () {},
          ),
          _menuDivider(),
          _menuItem(
            icon: Icons.star_outline,
            iconColor: AppColors.accentYellow,
            title: 'My Reviews',
            onTap: () {},
          ),
          _menuDivider(),
          _menuItem(
            icon: Icons.notifications_outlined,
            iconColor: Colors.purple,
            title: 'Notifications',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    ProviderNotificationsScreen(providerId: widget.providerId),
              ),
            ),
          ),
          _menuDivider(),
          _menuItem(
            icon: Icons.logout,
            iconColor: AppColors.declineRed,
            title: 'Sign Out',
            titleColor: AppColors.declineRed,
            showArrow: false,
            onTap: () => showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text('Sign Out'),
                content: const Text('Are you sure you want to sign out?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: _logout,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.declineRed,
                    ),
                    child: const Text('Sign Out'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    Color? titleColor,
    Widget? trailing,
    bool showArrow = true,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 18),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: titleColor ?? AppColors.textDark,
        ),
      ),
      trailing:
          trailing ??
          (showArrow
              ? const Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: AppColors.textMuted,
                )
              : null),
    );
  }

  Widget _menuDivider() =>
      const Divider(height: 1, indent: 56, color: Color(0xFFF0F0F0));
}

// ── Edit Profile Screen ───────────────────────────────────────────
class EditProviderProfileScreen extends StatefulWidget {
  final int providerId;
  final Map<String, dynamic> profile;
  const EditProviderProfileScreen({
    super.key,
    required this.providerId,
    required this.profile,
  });

  @override
  State<EditProviderProfileScreen> createState() =>
      _EditProviderProfileScreenState();
}

class _EditProviderProfileScreenState extends State<EditProviderProfileScreen> {
  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _addressCtrl;
  late TextEditingController _bioCtrl;
  late TextEditingController _rateCtrl;
  bool _isSaving = false;
  static const String _base = "http://localhost:3000/api/providerside";

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.profile['full_name'] ?? '');
    _phoneCtrl = TextEditingController(text: widget.profile['phone'] ?? '');
    _addressCtrl = TextEditingController(text: widget.profile['address'] ?? '');
    _bioCtrl = TextEditingController(text: widget.profile['bio'] ?? '');
    _rateCtrl = TextEditingController(
      text: widget.profile['hourly_rate']?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _bioCtrl.dispose();
    _rateCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    final res = await http.put(
      Uri.parse("$_base/profile?provider_id=${widget.providerId}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "full_name": _nameCtrl.text,
        "phone": _phoneCtrl.text,
        "address": _addressCtrl.text,
        "bio": _bioCtrl.text,
        "hourly_rate": int.tryParse(_rateCtrl.text) ?? 0,
      }),
    );
    setState(() => _isSaving = false);
    if (res.statusCode == 200 && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated!'),
          backgroundColor: AppColors.primaryGreen,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgGrey,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        _nameCtrl.text.isNotEmpty
                            ? _nameCtrl.text[0].toUpperCase()
                            : 'P',
                        style: const TextStyle(
                          color: AppColors.primaryGreen,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _field('Full Name', _nameCtrl),
            _field('Phone / WhatsApp', _phoneCtrl, type: TextInputType.phone),
            _field('Location / Area', _addressCtrl),
            _field('Hourly Rate (RS)', _rateCtrl, type: TextInputType.number),
            _field('About / Bio', _bioCtrl, maxLines: 4),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isSaving ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _isSaving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Save Changes',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController ctrl, {
    TextInputType? type,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: ctrl,
            keyboardType: type,
            maxLines: maxLines,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
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
}
