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

  final _filters = ['All booking', 'Active', 'Completed'];

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
      case 'Active':
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
      case 'Completed':
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
        backgroundColor: const Color.fromARGB(255, 27, 89, 139),
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
                            itemBuilder: (_, i) =>
                                _BookingCard(booking: _filtered[i]),
                          ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final CustomerBooking booking;
  const _BookingCard({required this.booking});

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

  @override
  Widget build(BuildContext context) {
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
            if (booking.status == 'completed') ...[
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {},
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
            ],
          ],
        ),
      ),
    );
  }
}
