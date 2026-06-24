import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:frontfile_servease/models/customer/customer_model.dart';
import 'package:frontfile_servease/services/customer/customerserviceali.dart';
import 'package:frontfile_servease/theme/app_theme.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  final box = GetStorage();
  List<CustomerBooking> _bookings = [];
  bool _isLoading = true;
  String _filter = 'All';

  int get _customerId => box.read('user_id') ?? 0;

  final _filters = ['All', 'Active users', 'Completed Bookings'];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    final data = await CustomerApiService.fetchMyBookings(_customerId);
    setState(() {
      _bookings = data;
      _isLoading = false;
    });
  }

  List<CustomerBooking> get _filtered {
    switch (_filter) {
      case 'Active users':
        return _bookings
            .where(
              (b) => [
                'pending',
                'accepted',
                'in_progress',
                'on_the_way',
              ].contains(b.status),
            )
            .toList();
      case 'Completed Bookings':
        return _bookings.where((b) => b.status == 'completed').toList();
      default:
        return _bookings;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        title: const Text(
          'My Bookings',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: _filters.map((f) {
                final isSelected = _filter == f;
                return GestureDetector(
                  onTap: () => setState(() => _filter = f),
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryGreen
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryGreen
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Text(
                      f,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : AppColors.textMuted,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryGreen,
                    ),
                  )
                : RefreshIndicator(
                    color: AppColors.primaryGreen,
                    onRefresh: _load,
                    child: _filtered.isEmpty
                        ? const Center(
                            child: Text(
                              'No bookings found',
                              style: TextStyle(color: AppColors.textMuted),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(12),
                            itemCount: _filtered.length,
                            itemBuilder: (_, i) => _BookingCard(
                              booking: _filtered[i],
                              customerId: _customerId,
                            ),
                          ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _BookingCard extends StatefulWidget {
  final CustomerBooking booking;
  final int customerId;
  const _BookingCard({required this.booking, required this.customerId});

  @override
  State<_BookingCard> createState() => _BookingCardState();
}

class _BookingCardState extends State<_BookingCard> {
  CustomerBooking get booking => widget.booking;

  Color get _statusColor {
    switch (booking.status) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return const Color(0xFF1565C0);
      case 'completed':
        return AppColors.primaryGreen;
      case 'declined':
        return AppColors.declineRed;
      case 'in_progress':
        return const Color(0xFFE65100);
      default:
        return AppColors.textMuted;
    }
  }

  String get _statusLabel {
    switch (booking.status) {
      case 'pending':
        return 'Pending';
      case 'accepted':
        return 'Confirmed';
      case 'completed':
        return 'Completed';
      case 'declined':
        return 'Declined';
      case 'in_progress':
        return 'In Progress';
      default:
        return booking.status;
    }
  }

  Color get _avatarColor {
    final colors = [
      const Color(0xFF4CAF50),
      const Color(0xFF2196F3),
      const Color(0xFFFF9800),
      const Color(0xFF9C27B0),
    ];
    return colors[booking.providerName.length % colors.length];
  }

  // ── RATING DIALOG ─────────────────────────────────────────────
  void _showRatingDialog() {
    int selectedRating = 5;
    final noteCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Rate this Provider'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                booking.providerName,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  return IconButton(
                    onPressed: () =>
                        setDialogState(() => selectedRating = i + 1),
                    icon: Icon(
                      i < selectedRating
                          ? Icons.star_rounded
                          : Icons.star_outline_rounded,
                      color: AppColors.accentYellow,
                      size: 32,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: noteCtrl,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Short note (optional)',
                  hintStyle: const TextStyle(fontSize: 13),
                  filled: true,
                  fillColor: const Color(0xFFFFF8EF),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
              ),
              onPressed: () async {
                Navigator.pop(ctx);
                final success = await CustomerApiService.submitRating(
                  bookingId: booking.id,
                  customerId: widget.customerId,
                  providerId: booking.providerId,
                  rating: selectedRating,
                  note: noteCtrl.text.trim().isEmpty
                      ? null
                      : noteCtrl.text.trim(),
                );
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        success
                            ? 'Thanks for your rating!'
                            : 'Failed to submit rating',
                      ),
                      backgroundColor: success
                          ? AppColors.primaryGreen
                          : Colors.red,
                    ),
                  );
                }
              },
              child: const Text(
                'Submit',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── REPORT DIALOG ─────────────────────────────────────────────
  void _showReportDialog() {
    final titleCtrl = TextEditingController();
    final messageCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Report Provider'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: InputDecoration(
                hintText: 'Issue title (e.g. Late arrival)',
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
                  messageCtrl.text.trim().isEmpty) {
                return;
              }
              Navigator.pop(ctx);
              final success = await CustomerApiService.submitComplaint(
                customerId: widget.customerId,
                bookingId: booking.id,
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

  @override
  Widget build(BuildContext context) {
    final canReport = [
      'accepted',
      'in_progress',
      'on_the_way',
      'completed',
    ].contains(booking.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: _avatarColor.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          booking.initials,
                          style: TextStyle(
                            color: _avatarColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.providerName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: AppColors.textDark,
                          ),
                        ),
                        Text(
                          booking.serviceName,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _statusLabel,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: _statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 13,
                  color: AppColors.textMuted,
                ),
                const SizedBox(width: 5),
                Text(
                  '${booking.scheduledDate}, ${booking.scheduledTime}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
            if (booking.status == 'completed' || canReport) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  if (booking.status == 'completed')
                    GestureDetector(
                      onTap: _showRatingDialog,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accentYellow.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.accentYellow.withOpacity(0.3),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star_outline,
                              size: 14,
                              color: AppColors.accentYellow,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Leave Review ★',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.accentYellow,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (canReport) const SizedBox(width: 8),
                  if (canReport)
                    GestureDetector(
                      onTap: _showReportDialog,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.red.withOpacity(0.3),
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.flag_outlined,
                              size: 14,
                              color: Colors.red,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Report',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
