import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:frontfile_servease/screens/admin/admindrawer.dart';
import 'package:frontfile_servease/screens/admin/admin_navbar.dart';
import 'package:frontfile_servease/theme/app_theme.dart';

class AdminNotification extends StatefulWidget {
  const AdminNotification({super.key});

  @override
  State<AdminNotification> createState() => _AdminNotificationState();
}

class _AdminNotificationState extends State<AdminNotification> {
  static const String _base = "http://localhost:3000/api/admin/notifications";

  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = true;

  // Send form controllers
  final _titleCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  final _userIdCtrl = TextEditingController();
  String _selectedType = 'system';
  String _selectedRole = 'customer';
  bool _isSending = false;

  final _types = ['system', 'booking', 'admin', 'verification', 'complaint'];
  final _roles = ['customer', 'provider'];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);
    try {
      final res = await http.get(Uri.parse("$_base/all"));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(
          () => _notifications = List<Map<String, dynamic>>.from(
            data['data'] ?? [],
          ),
        );
      }
    } catch (e) {
      debugPrint('Load error: $e');
    }
    setState(() => _isLoading = false);
  }

  Future<void> _sendNotification() async {
    if (_titleCtrl.text.trim().isEmpty || _messageCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Title aur Message zaroor bharo'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSending = true);
    try {
      final res = await http.post(
        Uri.parse("$_base/send"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "user_id": _userIdCtrl.text.trim().isEmpty
              ? null
              : int.tryParse(_userIdCtrl.text.trim()),
          "title": _titleCtrl.text.trim(),
          "message": _messageCtrl.text.trim(),
          "type": _selectedType,
          "role": _selectedRole,
        }),
      );

      if (res.statusCode == 200) {
        _titleCtrl.clear();
        _messageCtrl.clear();
        _userIdCtrl.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notification send ho gayi!'),
            backgroundColor: Colors.green,
          ),
        );
        _loadNotifications();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Send failed, dobara try karo'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint('Send error: $e');
    }
    setState(() => _isSending = false);
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'booking':
        return AppColors.primaryGreen;
      case 'admin':
        return Colors.purple;
      case 'verification':
        return Colors.blue;
      case 'complaint':
        return Colors.orange;
      default:
        return Colors.blueGrey;
    }
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'booking':
        return Icons.calendar_today_outlined;
      case 'admin':
        return Icons.admin_panel_settings_outlined;
      case 'verification':
        return Icons.verified_outlined;
      case 'complaint':
        return Icons.warning_amber_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      drawer: const AdminDrawer(),
      bottomNavigationBar: const AdminBottomNavBar(),
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: AppColors.primaryGreen,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadNotifications,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSendCard(),
            const SizedBox(height: 16),
            _buildNotificationsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSendCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Send Notification',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 14),

          // User ID (optional)
          _label('User ID (optional — khali choro broadcast ke liye)'),
          const SizedBox(height: 6),
          TextField(
            controller: _userIdCtrl,
            keyboardType: TextInputType.number,
            decoration: _inputDecor('e.g. 5'),
          ),
          const SizedBox(height: 12),

          // Role
          _label('Send To'),
          const SizedBox(height: 6),
          Row(
            children: _roles.map((r) {
              final selected = _selectedRole == r;
              return GestureDetector(
                onTap: () => setState(() => _selectedRole = r),
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.primaryGreen
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selected
                          ? AppColors.primaryGreen
                          : Colors.grey.shade300,
                    ),
                  ),
                  child: Text(
                    r[0].toUpperCase() + r.substring(1),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : AppColors.textMuted,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),

          // Type
          _label('Type'),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: _selectedType,
            decoration: _inputDecor(''),
            items: _types
                .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                .toList(),
            onChanged: (v) => setState(() => _selectedType = v ?? 'system'),
          ),
          const SizedBox(height: 12),

          // Title
          _label('Title'),
          const SizedBox(height: 6),
          TextField(
            controller: _titleCtrl,
            decoration: _inputDecor('Notification title...'),
          ),
          const SizedBox(height: 12),

          // Message
          _label('Message'),
          const SizedBox(height: 6),
          TextField(
            controller: _messageCtrl,
            maxLines: 3,
            decoration: _inputDecor('Notification message...'),
          ),
          const SizedBox(height: 16),

          // Send button
          ElevatedButton.icon(
            onPressed: _isSending ? null : _sendNotification,
            icon: _isSending
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.send, color: Colors.white),
            label: const Text(
              'Send Notification',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Notifications',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            Text(
              '${_notifications.length} total',
              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primaryGreen),
              )
            : _notifications.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    'Koi notification nahi mili',
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                ),
              )
            : Column(
                children: _notifications
                    .map(
                      (n) => _NotifTile(
                        n: n,
                        typeColor: _typeColor(n['type'] ?? 'system'),
                        typeIcon: _typeIcon(n['type'] ?? 'system'),
                      ),
                    )
                    .toList(),
              ),
      ],
    );
  }

  Widget _label(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: AppColors.textDark,
    ),
  );

  InputDecoration _inputDecor(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(fontSize: 13, color: AppColors.textMuted),
    filled: true,
    fillColor: const Color(0xFFFFF8EF),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
  );
}

class _NotifTile extends StatelessWidget {
  final Map<String, dynamic> n;
  final Color typeColor;
  final IconData typeIcon;

  const _NotifTile({
    required this.n,
    required this.typeColor,
    required this.typeIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: typeColor.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(typeIcon, size: 18, color: typeColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        n['title'] ?? '',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: typeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        n['type'] ?? 'system',
                        style: TextStyle(
                          fontSize: 10,
                          color: typeColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  n['message'] ?? '',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    if (n['user_name'] != null)
                      Text(
                        'To: ${n['user_name']}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    if (n['user_name'] == null)
                      Text(
                        'Broadcast — ${n['role'] ?? ''}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    const Spacer(),
                    Text(
                      n['created_at']?.toString().substring(0, 10) ?? '',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
