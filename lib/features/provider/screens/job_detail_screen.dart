import 'package:flutter/material.dart';
import 'package:frontfile_servease/models/providermodel/providermodelapi.dart';
import 'package:frontfile_servease/features/provider/services/providerapiservice.dart';
import 'package:frontfile_servease/features/provider/screens/pay_commission_screen.dart';
import 'package:frontfile_servease/features/provider/screens/provider_home_screen.dart';
import 'package:frontfile_servease/features/provider/screens/provider_profile_screen.dart';
import 'package:frontfile_servease/features/provider/screens/earningscreen.dart';
import 'package:frontfile_servease/features/provider/screens/providernavbar.dart';
import 'package:frontfile_servease/core/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class JobDetailScreen extends StatefulWidget {
  final JobRequest job;
  final int providerId;
  final double? commissionRate;
  const JobDetailScreen({
    super.key,
    required this.job,
    required this.providerId,
    this.commissionRate,
  });

  @override
  State<JobDetailScreen> createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  late String _currentStatus;

  // Status flow order
  final List<Map<String, dynamic>> _statusSteps = [
    {
      'status': 'accepted',
      'label': 'Confirmed',
      'sub': 'Booking accepted',
      'icon': Icons.check_circle_outline,
    },
    {
      'status': 'on_the_way',
      'label': 'On the way',
      'sub': 'Heading to customer',
      'icon': Icons.directions_walk,
    },
    {
      'status': 'in_progress',
      'label': 'In progress',
      'sub': 'Currently working',
      'icon': Icons.build_circle_outlined,
    },
    {
      'status': 'completed',
      'label': 'Completed',
      'sub': 'Mark job as done',
      'icon': Icons.task_alt,
    },
  ];

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.job.status;
  }

  int get _currentStepIndex =>
      _statusSteps.indexWhere((s) => s['status'] == _currentStatus);

  Future<void> _updateStatus(String newStatus) async {
    final success = await ProviderApiService.updateJobStatus(
      widget.job.id,
      newStatus,
    );
    if (success && mounted) {
      setState(() => _currentStatus = newStatus);
      if (newStatus == 'completed') {
        // Check if commission needed
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PayCommissionScreen(
              providerId: widget.providerId,
              commissionAmount:
                  widget.job.price * (widget.commissionRate ?? 0.10),
            ),
          ),
        );
      }
    }
  }

  void _messageCustomer() async {
    final phone = widget.job.customerPhone.replaceAll(RegExp(r'[^0-9]'), '');
    final url = Uri.parse('https://wa.me/92$phone');
    if (await canLaunchUrl(url)) await launchUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgGrey,
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        title: const Text(
          'Job Details',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            _buildJobCard(),
            const SizedBox(height: 12),
            _buildStatusStepper(),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildMessageButton(),
          _buildReportButton(),
          ProviderBottomNavBar(
            currentIndex: 1,
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
              if (index == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        EarningsScreen(providerId: widget.providerId),
                  ),
                );
                return;
              }
              if (index == 3) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        ProviderProfileScreen(providerId: widget.providerId),
                  ),
                );
                return;
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildJobCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.job.customerName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  Text(
                    widget.job.serviceType,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _statusLabel(_currentStatus),
                  style: const TextStyle(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _infoItem(
                  'Date',
                  '${widget.job.scheduledDate}, ${widget.job.scheduledTime}',
                ),
              ),
              Expanded(
                child: _infoItem(
                  'Amount',
                  'RS ${widget.job.price.toStringAsFixed(0)}',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _infoItem('Address', widget.job.location),
        ],
      ),
    );
  }

  Widget _infoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusStepper() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Update Job Status',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 16),
          ..._statusSteps.asMap().entries.map((entry) {
            final i = entry.key;
            final step = entry.value;
            final isDone = i <= _currentStepIndex;
            final isCurrent = i == _currentStepIndex;
            final isNext = i == _currentStepIndex + 1;

            return GestureDetector(
              onTap: isNext ? () => _updateStatus(step['status']) : null,
              child: Row(
                children: [
                  Column(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDone
                              ? AppColors.primaryGreen
                              : Colors.grey.shade200,
                          border: isCurrent
                              ? Border.all(
                                  color: AppColors.primaryGreen,
                                  width: 2,
                                )
                              : null,
                        ),
                        child: Icon(
                          step['icon'] as IconData,
                          size: 16,
                          color: isDone ? Colors.white : AppColors.textMuted,
                        ),
                      ),
                      if (i < _statusSteps.length - 1)
                        Container(
                          width: 2,
                          height: 32,
                          color: i < _currentStepIndex
                              ? AppColors.primaryGreen
                              : Colors.grey.shade200,
                        ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step['label'] as String,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isDone
                                  ? AppColors.primaryGreen
                                  : AppColors.textMuted,
                            ),
                          ),
                          Text(
                            step['sub'] as String,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                          if (isNext)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                'Tap to update →',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.accentYellow,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildMessageButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 20),
      child: ElevatedButton.icon(
        onPressed: _messageCustomer,
        icon: const Icon(Icons.message, color: Colors.white),
        label: const Text(
          'Message Customer',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF25D366),
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildReportButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
      child: OutlinedButton.icon(
        onPressed: _showReportDialog,
        icon: const Icon(Icons.flag_outlined, color: Colors.red),
        label: const Text(
          'Report Customer',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.red),
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _showReportDialog() {
    final titleCtrl = TextEditingController();
    final messageCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Report Customer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: InputDecoration(
                hintText: 'Issue title (e.g. Rude behavior)',
                filled: true,
                fillColor: const Color(0xFFFFF8EF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: messageCtrl,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Describe the issue...',
                filled: true,
                fillColor: const Color(0xFFFFF8EF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              if (titleCtrl.text.trim().isEmpty ||
                  messageCtrl.text.trim().isEmpty)
                return;
              Navigator.pop(ctx);
              final success = await ProviderApiService.submitComplaint(
                providerId: widget.providerId,
                bookingId: widget.job.id,
                title: titleCtrl.text.trim(),
                message: messageCtrl.text.trim(),
              );
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Complaint submitted to admin'
                          : 'Failed to submit complaint',
                    ),
                    backgroundColor: success
                        ? AppColors.primaryGreen
                        : Colors.red,
                  ),
                );
              }
            },
            child: const Text('Submit', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _statusLabel(String s) {
    switch (s) {
      case 'accepted':
        return 'Confirmed';
      case 'on_the_way':
        return 'On the way';
      case 'in_progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      default:
        return s;
    }
  }
}
