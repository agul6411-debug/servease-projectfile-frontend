import 'package:flutter/material.dart';
import 'package:frontfile_servease/features/provider/models/provider_verification_model.dart';
import 'package:frontfile_servease/routes.dart';
import 'package:frontfile_servease/features/admin/screens/admindrawer.dart';
import 'package:frontfile_servease/core/services/app_config.dart';
import 'package:frontfile_servease/features/admin/screens/admin_navbar.dart';
import 'package:frontfile_servease/features/provider/services/provider_verficationservice.dart';
import 'package:get/get.dart';

class ProviderVerificationPage extends StatefulWidget {
  const ProviderVerificationPage({super.key});

  @override
  State<ProviderVerificationPage> createState() =>
      _ProviderVerificationPageState();
}

class _ProviderVerificationPageState extends State<ProviderVerificationPage> {
  final _service = ProviderVerificationService();
  final _searchController = TextEditingController();

  List<ProviderVerificationModel> _all = [];
  List<ProviderVerificationModel> _filtered = [];
  String _activeFilter = 'All';
  bool _loading = true;

  static const _green = Color(0xFF3A7D44);
  static const _orange = Color(0xFFFF6B35);
  static const _pendingBg = Color(0xFFFFF3E0);
  static const _pendingText = Color(0xFFE65100);

  @override
  void initState() {
    super.initState();
    _load();
    _searchController.addListener(_applyFilters);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final data = await _service.getPendingProviders();
      setState(() {
        _all = data;
        _applyFilters();
      });
    } catch (e) {
      _showSnack('Error: $e', isError: true);
    } finally {
      setState(() => _loading = false);
    }
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();
    final today = DateTime.now();

    setState(() {
      _filtered = _all.where((p) {
        final matchSearch =
            p.fullName.toLowerCase().contains(query) ||
            p.providerIdLabel.toLowerCase().contains(query);
        return matchSearch;
      }).toList();
    });
  }

  void _setFilter(String f) {
    setState(() => _activeFilter = f);
    _applyFilters();
  }

  Future<void> _review(ProviderVerificationModel provider) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _ReviewSheet(provider: provider),
    );
    if (result == null) return;

    try {
      if (result == 'approve') {
        await _service.approveProvider(provider.id);
        _showSnack('${provider.fullName} approved');
      } else {
        await _service.rejectProvider(provider.id);
        _showSnack('${provider.fullName} rejected');
      }
      await _load();
    } catch (e) {
      _showSnack('Error: $e', isError: true);
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : _green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AdminDrawer(),
      bottomNavigationBar: const AdminBottomNavBar(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF3A7D44), _orange],
            begin: Alignment.topLeft,
            end: Alignment.topRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Container(
                  color: const Color(0xFFF5F5F5),
                  child: Column(
                    children: [
                      _buildSearch(),
                      _buildFilterTabs(),
                      Expanded(
                        child: _loading
                            ? const Center(child: CircularProgressIndicator())
                            : _filtered.isEmpty
                            ? const Center(child: Text('No pending providers'))
                            : RefreshIndicator(
                                onRefresh: _load,
                                child: ListView.builder(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: _filtered.length,
                                  itemBuilder: (_, i) => _ProviderCard(
                                    provider: _filtered[i],
                                    onReview: () => _review(_filtered[i]),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() => Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .25),
            shape: BoxShape.circle,
          ),
          child: Builder(
            builder: (context) {
              return GestureDetector(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: const Icon(Icons.menu, color: Colors.white),
              );
            },
          ),
        ),

        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Provider Verification',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${_all.length} Pending',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _buildSearch() => Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
    child: TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search by name or ID...',
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
      ),
    ),
  );

  Widget _buildFilterTabs() => Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
    child: Row(
      children: ['All', 'Pending', 'Today'].map((f) {
        final active = _activeFilter == f;
        return GestureDetector(
          onTap: () => _setFilter(f),
          child: Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
              color: active ? _green : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: active ? _green : Colors.grey.shade300),
            ),
            child: Text(
              f,
              style: TextStyle(
                color: active ? Colors.white : Colors.grey.shade700,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        );
      }).toList(),
    ),
  );
}

// ── Card ──────────────────────────────────────────────────────────────────────

class _ProviderCard extends StatelessWidget {
  const _ProviderCard({required this.provider, required this.onReview});
  final ProviderVerificationModel provider;
  final VoidCallback onReview;

  static const _avatarColors = [
    Color(0xFF3A7D44),
    Color(0xFFFF6B35),
    Color(0xFF1565C0),
    Color(0xFF6A1B9A),
    Color(0xFF00838F),
  ];

  Color get _avatarColor => _avatarColors[provider.id % _avatarColors.length];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: _avatarColor,
                  child: Text(
                    provider.initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider.fullName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        provider.bio ?? 'Service Provider',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        provider.providerIdLabel,
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFFFB74D)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 12,
                        color: Color(0xFFE65100),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Pending',
                        style: TextStyle(
                          color: Color(0xFFE65100),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _infoRow('Phone:', provider.phone),
            _infoRow('Location:', 'N/A'),
            _infoRow('Experience:', '${provider.yearsOfExperience ?? 0} yrs'),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: provider.cnicFrontImage != null
                        ? () => _showCnic(
                            context,
                            provider.cnicFrontImage!,
                            'CNIC Front',
                          )
                        : null,
                    icon: const Icon(Icons.remove_red_eye_outlined, size: 16),
                    label: const Text('Front'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey.shade700,
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: provider.cnicBackImage != null
                        ? () => _showCnic(
                            context,
                            provider.cnicBackImage!,
                            'CNIC Back',
                          )
                        : null,
                    icon: const Icon(Icons.remove_red_eye_outlined, size: 16),
                    label: const Text('Back'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey.shade700,
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: onReview,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3A7D44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: const Text(
                      'Review',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
          ),
        ),
      ],
    ),
  );

  void _showCnic(BuildContext context, String imagePath, String title) {
    final String baseUrl = AppConfig.baseUrl;
    final fullUrl = imagePath.startsWith('http')
        ? imagePath
        : (imagePath.startsWith('/') ? "$baseUrl$imagePath" : "$baseUrl/$imagePath");

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Image.network(
          fullUrl,
          errorBuilder: (_, __, ___) => const Text('Image not available'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

// ── Review Bottom Sheet ───────────────────────────────────────────────────────

class _ReviewSheet extends StatelessWidget {
  const _ReviewSheet({required this.provider});
  final ProviderVerificationModel provider;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Review ${provider.fullName}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            provider.bio ?? 'Service Provider',
            style: TextStyle(color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context, 'reject'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Reject',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, 'approve'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3A7D44),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Approve',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
