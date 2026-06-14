import 'package:flutter/material.dart';
import 'package:frontfile_servease/services/providerapiservices/providerapiservice.dart';
import 'package:frontfile_servease/theme/app_theme.dart';

class ProviderNotificationsScreen extends StatefulWidget {
  final int providerId;
  const ProviderNotificationsScreen({super.key, required this.providerId});

  @override
  State<ProviderNotificationsScreen> createState() =>
      _ProviderNotificationsScreenState();
}

class _ProviderNotificationsScreenState
    extends State<ProviderNotificationsScreen> {
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    final data = await ProviderApiService.fetchNotifications(widget.providerId);
    setState(() {
      _notifications = data;
      _isLoading = false;
    });
  }

  Future<void> _markRead(int index) async {
    final n = _notifications[index];
    final isUnread = n['is_read'] == 0 || n['is_read'] == false;
    if (!isUnread) return;

    final success = await ProviderApiService.markNotificationRead(n['id']);
    if (success) {
      setState(() {
        _notifications[index] = {..._notifications[index], 'is_read': 1};
      });
    }
  }

  Future<void> _confirmClearAll() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear All Notifications?'),
        content: const Text('This action will not be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Clear All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await ProviderApiService.clearNotifications(
        widget.providerId,
      );
      if (success) {
        setState(() => _notifications.clear());
      }
    }
  }

  IconData _iconForType(String type) {
    switch (type) {
      case 'booking':
        return Icons.calendar_today_outlined;
      case 'system':
        return Icons.info_outline;
      case 'complaint':
        return Icons.warning_amber_outlined;
      case 'admin':
        return Icons.admin_panel_settings_outlined;
      case 'verification':
        return Icons.verified_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _colorForType(String type) {
    switch (type) {
      case 'booking':
        return AppColors.primaryGreen;
      case 'system':
        return Colors.blueGrey;
      case 'complaint':
        return Colors.orange.shade400;
      case 'admin':
        return Colors.purple;
      case 'verification':
        return Colors.blue;
      default:
        return Colors.blueGrey;
    }
  }

  String _timeAgo(int? minutes) {
    if (minutes == null) return '';
    if (minutes < 60) return '$minutes min ago';
    if (minutes < 1440) return '${(minutes / 60).floor()} hours ago';
    return '${(minutes / 1440).floor()} days ago';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgGrey,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (_notifications.isNotEmpty)
            IconButton(
              icon: const Icon(
                Icons.delete_sweep_outlined,
                color: Colors.white,
              ),
              onPressed: _confirmClearAll,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryGreen),
            )
          : _notifications.isEmpty
          ? const Center(
              child: Text(
                'No notifications yet',
                style: TextStyle(color: AppColors.textMuted),
              ),
            )
          : RefreshIndicator(
              color: AppColors.primaryGreen,
              onRefresh: _load,
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: _notifications.length,
                itemBuilder: (_, i) {
                  final n = _notifications[i];
                  final isUnread = n['is_read'] == 0 || n['is_read'] == false;
                  final color = _colorForType(n['type']);
                  return GestureDetector(
                    onTap: () => _markRead(i),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: isUnread
                            ? color.withOpacity(0.05)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border(
                          left: BorderSide(
                            color: isUnread ? color : Colors.transparent,
                            width: 3,
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _iconForType(n['type']),
                                color: color,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          n['title'] ?? '',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: isUnread
                                                ? FontWeight.w700
                                                : FontWeight.w600,
                                            color: AppColors.textDark,
                                          ),
                                        ),
                                      ),
                                      if (isUnread)
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: color,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    n['message'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    n['minutes_ago'] != null &&
                                            (n['minutes_ago'] as int) < 1440
                                        ? _timeAgo(n['minutes_ago'] as int?)
                                        : n['date'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
