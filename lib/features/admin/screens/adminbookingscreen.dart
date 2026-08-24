import 'package:flutter/material.dart';
import 'package:frontfile_servease/features/admin/screens/admindrawer.dart';
import 'package:frontfile_servease/features/admin/screens/admin_navbar.dart';
import 'package:frontfile_servease/features/admin/services/adminbookingsevice.dart';
import 'package:frontfile_servease/core/theme/app_theme.dart';

class AdminBookingsScreen extends StatefulWidget {
  const AdminBookingsScreen({super.key});

  @override
  State<AdminBookingsScreen> createState() => _AdminBookingsScreenState();
}

class _AdminBookingsScreenState extends State<AdminBookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  List<Map<String, dynamic>> _all = [];
  String _selectedFilter = 'all';
  bool _isLoading = true;
  final _searchCtrl = TextEditingController();
  String _search = '';

  final _filters = ['all', 'pending', 'accepted', 'completed', 'declined'];
  final _filterLabels = {
    'all': 'All',
    'pending': 'Pending',
    'accepted': 'Active',
    'completed': 'Completed',
    'declined': 'Declined',
  };

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    final data = await AdminBookingsService.fetchAll();
    setState(() {
      _all = data;
      _isLoading = false;
    });
  }

  List<Map<String, dynamic>> get _filtered {
    var list = _selectedFilter == 'all'
        ? _all
        : _all.where((b) => b['status'] == _selectedFilter).toList();
    if (_search.isNotEmpty) {
      list = list
          .where(
            (b) =>
                (b['customer_name'] ?? '').toString().toLowerCase().contains(
                  _search.toLowerCase(),
                ) ||
                (b['provider_name'] ?? '').toString().toLowerCase().contains(
                  _search.toLowerCase(),
                ) ||
                (b['service_name'] ?? '').toString().toLowerCase().contains(
                  _search.toLowerCase(),
                ),
          )
          .toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgGrey,
      drawer: const AdminDrawer(),
      bottomNavigationBar: const AdminBottomNavBar(),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearch(),
            _buildFilterRow(),
            _buildStatsRow(),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.success,
                      ),
                    )
                  : RefreshIndicator(
                      color: AppColors.success,
                      onRefresh: _load,
                      child: _filtered.isEmpty
                          ? _emptyState()
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
                              itemCount: _filtered.length,
                              itemBuilder: (_, i) =>
                                  _BookingCard(data: _filtered[i]),
                            ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F5A34), Color(0xFF1B8B4B)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
      child: Row(
        children: [
          Builder(
            builder: (ctx) => GestureDetector(
              onTap: () => Scaffold.of(ctx).openDrawer(),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(Icons.menu, color: Colors.white, size: 18),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Booking Management',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  '${_all.length} total bookings',
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '${_all.where((b) => b['status'] == 'pending').length} Pending',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE0E0E0)),
        ),
        child: TextField(
          controller: _searchCtrl,
          onChanged: (v) => setState(() => _search = v),
          decoration: InputDecoration(
            hintText: 'Search customer, provider, service...',
            hintStyle: const TextStyle(
              fontSize: 13,
              color: AppColors.textMuted,
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: AppColors.textMuted,
              size: 20,
            ),
            suffixIcon: _search.isNotEmpty
                ? IconButton(
                    icon: const Icon(
                      Icons.clear,
                      size: 18,
                      color: AppColors.textMuted,
                    ),
                    onPressed: () {
                      _searchCtrl.clear();
                      setState(() => _search = '');
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterRow() {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
        itemCount: _filters.length,
        itemBuilder: (_, i) {
          final f = _filters[i];
          final isSelected = _selectedFilter == f;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = f),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1B8B4B) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF1B8B4B)
                      : Colors.grey.shade300,
                ),
              ),
              child: Text(
                _filterLabels[f]!,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.textMuted,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsRow() {
    final pending = _all.where((b) => b['status'] == 'pending').length;
    final active = _all.where((b) => b['status'] == 'accepted').length;
    final completed = _all.where((b) => b['status'] == 'completed').length;
    final declined = _all.where((b) => b['status'] == 'declined').length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
      child: Row(
        children: [
          _miniStat('$pending', 'Pending', Colors.orange),
          const SizedBox(width: 8),
          _miniStat('$active', 'Active', const Color(0xFF1B8B4B)),
          const SizedBox(width: 8),
          _miniStat('$completed', 'Completed', AppColors.success),
          const SizedBox(width: 8),
          _miniStat('$declined', 'Declined', AppColors.declineRed),
        ],
      ),
    );
  }

  Widget _miniStat(String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 9, color: AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 48,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 12),
          const Text(
            'No bookings found',
            style: TextStyle(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _BookingCard({required this.data});

  Color get _statusColor {
    switch (data['status']) {
      case 'pending':
        return Colors.orange;
      case 'accepted':
        return const Color(0xFF1B8B4B);
      case 'completed':
        return AppColors.success;
      case 'declined':
        return AppColors.declineRed;
      case 'in_progress':
        return const Color(0xFFE65100);
      default:
        return AppColors.textMuted;
    }
  }

  String get _statusLabel {
    switch (data['status']) {
      case 'pending':
        return 'Pending';
      case 'accepted':
        return 'Active';
      case 'completed':
        return 'Completed';
      case 'declined':
        return 'Declined';
      case 'in_progress':
        return 'In Progress';
      default:
        return data['status'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEBF6EE),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          (data['customer_name'] ?? '?')[0].toUpperCase(),
                          style: const TextStyle(
                            color: Color(0xFF1B8B4B),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['customer_name'] ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: AppColors.textDark,
                          ),
                        ),
                        Text(
                          data['service_name'] ?? '',
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
                    color: _statusColor.withValues(alpha: 0.1),
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
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            const SizedBox(height: 10),

            // Details
            Row(
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 13,
                  color: AppColors.textMuted,
                ),
                const SizedBox(width: 4),
                Text(
                  'Provider: ',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
                Text(
                  data['provider_name'] ?? 'N/A',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 13,
                  color: AppColors.textMuted,
                ),
                const SizedBox(width: 4),
                Text(
                  '${data['scheduled_date'] ?? 'N/A'}  ${data['scheduled_time'] ?? ''}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
                const Spacer(),
                Text(
                  'RS ${data['total_price'] ?? 0}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
            if (data['location'] != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 13,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      data['location'],
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                      overflow: TextOverflow.ellipsis,
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
