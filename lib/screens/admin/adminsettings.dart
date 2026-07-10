import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontfile_servease/services/admin_settings_service.dart';
import 'package:frontfile_servease/core/theme/app_theme.dart';
import 'package:frontfile_servease/screens/admin/admin_navbar.dart';
import 'package:get/get.dart';

class AdminSettingsPage extends StatefulWidget {
  const AdminSettingsPage({super.key});

  @override
  State<AdminSettingsPage> createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends State<AdminSettingsPage> {
  bool _isLoading = true;
  bool _isSaving = false;

  final _commissionController = TextEditingController();
  final _depositAmountController = TextEditingController();
  final _appNameController = TextEditingController();
  final _supportEmailController = TextEditingController();
  final _supportPhoneController = TextEditingController();
  final _termsController = TextEditingController();

  bool _depositRequired = true;
  bool _notifyBooking = true;
  bool _notifyRegistration = true;
  bool _notifyComplaint = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _commissionController.dispose();
    _depositAmountController.dispose();
    _appNameController.dispose();
    _supportEmailController.dispose();
    _supportPhoneController.dispose();
    _termsController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);
    final settings = await AdminSettingsService.getSettings();
    if (settings != null) {
      _commissionController.text =
          settings['commission_rate']?.toString() ?? '10';
      _depositAmountController.text =
          settings['security_deposit_amount']?.toString() ?? '2000';
      _appNameController.text = settings['app_name'] ?? 'ServEase';
      _supportEmailController.text = settings['support_email'] ?? '';
      _supportPhoneController.text = settings['support_phone'] ?? '';
      _termsController.text = settings['terms_and_conditions'] ?? '';
      _depositRequired =
          settings['security_deposit_required'] == true ||
          settings['security_deposit_required'] == 1;
      _notifyBooking =
          settings['notify_new_booking'] == true ||
          settings['notify_new_booking'] == 1;
      _notifyRegistration =
          settings['notify_new_registration'] == true ||
          settings['notify_new_registration'] == 1;
      _notifyComplaint =
          settings['notify_complaint'] == true ||
          settings['notify_complaint'] == 1;
    }
    setState(() => _isLoading = false);
  }

  Future<void> _saveSettings() async {
    setState(() => _isSaving = true);
    final success = await AdminSettingsService.updateSettings({
      'commission_rate': double.tryParse(_commissionController.text) ?? 10,
      'security_deposit_amount':
          double.tryParse(_depositAmountController.text) ?? 2000,
      'security_deposit_required': _depositRequired,
      'app_name': _appNameController.text.trim(),
      'support_email': _supportEmailController.text.trim(),
      'support_phone': _supportPhoneController.text.trim(),
      'terms_and_conditions': _termsController.text.trim(),
      'notify_new_booking': _notifyBooking,
      'notify_new_registration': _notifyRegistration,
      'notify_complaint': _notifyComplaint,
    });
    setState(() => _isSaving = false);
    Get.snackbar(
      success ? 'Success' : 'Error',
      success ? 'Settings saved successfully' : 'Failed to save settings',
      backgroundColor: success ? AppColors.secondary : AppColors.destructive,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            color: AppColors.foreground,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        actions: [
          if (!_isLoading)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: ElevatedButton(
                onPressed: _isSaving ? null : _saveSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                ),
                child: _isSaving
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Save',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildSection(
                    icon: Icons.percent_rounded,
                    title: 'Commission & Deposit',
                    children: [
                      _buildTextField(
                        label: 'Commission Rate (%)',
                        controller: _commissionController,
                        hint: 'e.g. 10',
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'Security Deposit Amount (Rs.)',
                        controller: _depositAmountController,
                        hint: 'e.g. 2000',
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      _buildToggle(
                        label: 'Security Deposit Required',
                        subtitle: 'Providers must pay security deposit',
                        value: _depositRequired,
                        onChanged: (v) => setState(() => _depositRequired = v),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    icon: Icons.info_outline_rounded,
                    title: 'App Information',
                    children: [
                      _buildTextField(
                        label: 'App Name',
                        controller: _appNameController,
                        hint: 'ServEase',
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'Support Email',
                        controller: _supportEmailController,
                        hint: 'adminservease@gmail.com',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        label: 'Support Phone',
                        controller: _supportPhoneController,
                        hint: '+92 300 0000000',
                        keyboardType: TextInputType.phone,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    icon: Icons.notifications_outlined,
                    title: 'Notification Preferences',
                    children: [
                      _buildToggle(
                        label: 'New Booking Alerts',
                        subtitle: 'Notify when a new booking is made',
                        value: _notifyBooking,
                        onChanged: (v) => setState(() => _notifyBooking = v),
                      ),
                      const Divider(color: AppColors.border, height: 24),
                      _buildToggle(
                        label: 'New Registration Alerts',
                        subtitle: 'Notify when new user registers',
                        value: _notifyRegistration,
                        onChanged: (v) =>
                            setState(() => _notifyRegistration = v),
                      ),
                      const Divider(color: AppColors.border, height: 24),
                      _buildToggle(
                        label: 'Complaint Alerts',
                        subtitle: 'Notify when a complaint is submitted',
                        value: _notifyComplaint,
                        onChanged: (v) => setState(() => _notifyComplaint = v),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildSection(
                    icon: Icons.article_outlined,
                    title: 'Terms & Conditions',
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.inputBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: TextField(
                          controller: _termsController,
                          maxLines: 8,
                          decoration: const InputDecoration(
                            hintText: 'Enter Terms & Conditions text...',
                            hintStyle: TextStyle(
                              color: AppColors.mutedForeground,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.all(16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
      bottomNavigationBar: const AdminBottomNavBar(),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 22),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.foreground,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? hint,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: AppColors.foreground,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: AppColors.mutedForeground),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggle({
    required String label,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.foreground,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.mutedForeground,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.primary,
          activeTrackColor: Color(0x4DE8845A),
        ),
      ],
    );
  }
}
