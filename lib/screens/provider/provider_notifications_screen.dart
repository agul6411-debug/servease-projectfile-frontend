import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
        Uri.parse("$_base/notifications?provider_id=${widget.providerId}"),
      );
      if (res.statusCode == 200) {
        setState(() {
          _notifications = List<Map<String, dynamic>>.from(
            jsonDecode(res.body),
          );
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  IconData _getIcon(String? type) {
    switch (type) {
      case 'job_request':
        return Icons.work_outline;
      case 'commission':
        return Icons.payments_outlined;
      case 'review':
        return Icons.star_outline;
      case 'booking':
        return Icons.check_circle_outline;
      case 'verification':
        return Icons.verified_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _getColor(String? type) {
    switch (type) {
      case 'job_request':
        return AppColors.primaryGreen;
      case 'commission':
        return AppColors.accentYellow;
      case 'review':
        return Colors.purple;
      case 'booking':
        return const Color(0xFF1565C0);
      case 'verification':
        return AppColors.primaryGreen;
      default:
        return AppColors.textMuted;
    }
  }

  String _timeAgo(int? minutes) {
    if (minutes == null) return '';
    if (minutes < 60) return '${minutes} min ago';
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
                  final color = _getColor(n['type']);
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: isUnread ? color.withOpacity(0.05) : Colors.white,
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
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _getIcon(n['type']),
                              color: color,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  n['title'] ?? '',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isUnread
                                        ? FontWeight.w700
                                        : FontWeight.w600,
                                    color: AppColors.textDark,
                                  ),
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
                  );
                },
              ),
            ),
    );
  }
}
