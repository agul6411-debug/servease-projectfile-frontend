import 'package:flutter/material.dart';
import 'package:frontfile_servease/features/customer/models/servicedetailmodel.dart';
import 'package:frontfile_servease/features/customer/models/servicemanagmentmodel.dart';
import 'package:frontfile_servease/services/addservicedetailapi.dart';
import 'package:frontfile_servease/features/admin/screens/admindrawer.dart';
import 'package:frontfile_servease/features/admin/screens/admin_navbar.dart';

// ── Category helpers (mirrored from service_management.dart) ──────
Color _catBg(String cat) {
  switch (cat) {
    case 'Fashion':
      return const Color(0xFFFCE4EC);
    case 'Education':
      return const Color(0xFFE3F2FD);
    case 'Cleaning':
      return const Color(0xFFE8F5E9);
    case 'Beauty':
      return const Color(0xFFFCE4EC);
    case 'Crafts':
      return const Color(0xFFFFF8E1);
    default:
      return const Color(0xFFF3E5F5);
  }
}

Color _catText(String cat) {
  switch (cat) {
    case 'Fashion':
      return const Color(0xFF880E4F);
    case 'Education':
      return const Color(0xFF0D47A1);
    case 'Cleaning':
      return const Color(0xFF1B5E20);
    case 'Beauty':
      return const Color(0xFF880E4F);
    case 'Crafts':
      return const Color(0xFFE65100);
    default:
      return const Color(0xFF6A1B9A);
  }
}

// ── Screen ────────────────────────────────────────────────────────
class ServiceDetailScreen extends StatefulWidget {
  final ServiceModel service;

  const ServiceDetailScreen({super.key, required this.service});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  ServiceDetailModel? _detail;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _loadDetail();
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadDetail() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      if (widget.service.dbId == null) throw Exception('No ID');
      final raw = await AddServiceDetailApi.fetchServiceDetail(
        widget.service.dbId!,
      );
      setState(() {
        _detail = ServiceDetailModel.fromJson(raw);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load details.\nCheck your connection.';
        _isLoading = false;
      });
    }
  }

  // ── Build ─────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      drawer: const AdminDrawer(),
      bottomNavigationBar: const AdminBottomNavBar(),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            if (!_isLoading && _error == null && _detail != null)
              _buildStatsRow(),
            _buildTabBar(),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    final svc = widget.service;
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
      child: Row(
        children: [
          Builder(
            builder: (context) {
              return GestureDetector(
                onTap: () => Scaffold.of(context).openDrawer(),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.22),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Icon(Icons.menu, color: Colors.white, size: 18),
                ),
              );
            },
          ),
          const SizedBox(width: 12),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _catBg(svc.category),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(svc.icon, style: const TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  svc.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        svc.category,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'PKR ${svc.price}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Active badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
            decoration: BoxDecoration(
              color: svc.isActive
                  ? Colors.white.withOpacity(0.2)
                  : Colors.orange.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.4)),
            ),
            child: Text(
              svc.isActive ? '● Active' : '● Inactive',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Stats Row ─────────────────────────────────────────────────────
  Widget _buildStatsRow() {
    final d = _detail!;
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 10, 12, 0),
      child: Row(
        children: [
          _StatCard(
            label: 'Providers',
            value: '${d.providerCount}',
            icon: Icons.person_pin_rounded,
            color: const Color(0xFF1E88E5),
          ),
          const SizedBox(width: 8),
          _StatCard(
            label: 'Customers',
            value: '${d.customerCount}',
            icon: Icons.people_alt_rounded,
            color: const Color(0xFF8E24AA),
          ),
          const SizedBox(width: 8),
          _StatCard(
            label: 'Bookings',
            value: '${d.totalBookings}',
            icon: Icons.receipt_long_rounded,
            color: const Color(0xFFE65100),
          ),
          const SizedBox(width: 8),
          _StatCard(
            label: 'Rating',
            value: d.avgRating.toStringAsFixed(1),
            icon: Icons.star_rounded,
            color: const Color(0xFFFDD835),
            textColor: const Color(0xFF795548),
          ),
        ],
      ),
    );
  }

  // ── Tab Bar ───────────────────────────────────────────────────────
  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 10, 12, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: TabBar(
        controller: _tabCtrl,
        labelColor: const Color(0xFF1565C0),
        unselectedLabelColor: const Color(0xFF9E9E9E),
        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
        unselectedLabelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        indicator: BoxDecoration(
          color: const Color(0xFFE3F2FD),
          borderRadius: BorderRadius.circular(10),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.person_pin_rounded, size: 15),
                const SizedBox(width: 5),
                Text(
                  _detail != null
                      ? 'Providers (${_detail!.providerCount})'
                      : 'Providers',
                ),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.people_alt_rounded, size: 15),
                const SizedBox(width: 5),
                Text(
                  _detail != null
                      ? 'Customers (${_detail!.customerCount})'
                      : 'Customers',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Body ──────────────────────────────────────────────────────────
  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF1565C0)),
      );
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              size: 48,
              color: Color(0xFFBDBDBD),
            ),
            const SizedBox(height: 12),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF9E9E9E)),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _loadDetail,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1565C0),
              ),
              icon: const Icon(Icons.refresh_rounded, color: Colors.white),
              label: const Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    return TabBarView(
      controller: _tabCtrl,
      children: [_buildProviderList(), _buildCustomerList()],
    );
  }

  // ── Providers List ────────────────────────────────────────────────
  Widget _buildProviderList() {
    final providers = _detail?.providers ?? [];
    if (providers.isEmpty) {
      return _emptyState(
        icon: Icons.person_off_rounded,
        message: 'No providers assigned yet.',
      );
    }
    return RefreshIndicator(
      color: const Color(0xFF1565C0),
      onRefresh: _loadDetail,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 24),
        itemCount: providers.length,
        itemBuilder: (_, i) => _ProviderCard(provider: providers[i]),
      ),
    );
  }

  // ── Customers List ────────────────────────────────────────────────
  Widget _buildCustomerList() {
    final customers = _detail?.customers ?? [];
    if (customers.isEmpty) {
      return _emptyState(
        icon: Icons.people_outline_rounded,
        message: 'No customers yet.',
      );
    }
    return RefreshIndicator(
      color: const Color(0xFF1565C0),
      onRefresh: _loadDetail,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 24),
        itemCount: customers.length,
        itemBuilder: (_, i) => _CustomerCard(customer: customers[i]),
      ),
    );
  }

  Widget _emptyState({required IconData icon, required String message}) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: const Color(0xFFBDBDBD)),
          const SizedBox(height: 12),
          Text(message, style: const TextStyle(color: Color(0xFF9E9E9E))),
        ],
      ),
    );
  }
}

// ── Stat Card ─────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final Color? textColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: textColor ?? color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: Color(0xFF9E9E9E)),
          ),
        ],
      ),
    ),
  );
}

// ── Provider Card ─────────────────────────────────────────────────
class _ProviderCard extends StatelessWidget {
  final ProviderModel provider;
  const _ProviderCard({required this.provider});

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
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Center(
                child: Text(
                  provider.name.isNotEmpty
                      ? provider.name[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1565C0),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    provider.phone,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9E9E9E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 13,
                        color: Color(0xFFFDD835),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        provider.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF795548),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.check_circle_outline_rounded,
                        size: 13,
                        color: Color(0xFF43A047),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${provider.jobsDone} jobs',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF757575),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Availability badge
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: provider.isAvailable
                        ? const Color(0xFFEAF3DE)
                        : const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: provider.isAvailable
                          ? const Color(0xFF97C459)
                          : const Color(0xFFFFB74D),
                    ),
                  ),
                  child: Text(
                    provider.isAvailable ? 'Available' : 'Busy',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: provider.isAvailable
                          ? const Color(0xFF3B6D11)
                          : const Color(0xFFE65100),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Since ${provider.joinedDate}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFFBDBDBD),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Customer Card ─────────────────────────────────────────────────
class _CustomerCard extends StatelessWidget {
  final CustomerModel customer;
  const _CustomerCard({required this.customer});

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
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF3E5F5),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Center(
                child: Text(
                  customer.name.isNotEmpty
                      ? customer.name[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF8E24AA),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customer.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    customer.phone,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9E9E9E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.receipt_long_rounded,
                        size: 13,
                        color: Color(0xFF8E24AA),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${customer.totalBookings} bookings',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF8E24AA),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Last booking
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'Last Booking',
                  style: TextStyle(fontSize: 10, color: Color(0xFFBDBDBD)),
                ),
                const SizedBox(height: 2),
                Text(
                  customer.lastBooking,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF757575),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
