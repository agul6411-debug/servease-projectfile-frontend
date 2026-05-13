// users_screen.dart
import 'package:flutter/material.dart';
import 'package:frontfile_servease/services/provider_service.dart';

// ── Data Model ────────────────────────────────────────────────────
class ProviderModel {
  final int? dbId; // ← database primary key
  final String name;
  final String profession;
  final String id;
  final String phone;
  final String location;
  final String submitted;
  final String status;
  final Color avatarColor;

  const ProviderModel({
    this.dbId,
    required this.name,
    required this.profession,
    required this.id,
    required this.phone,
    required this.location,
    required this.submitted,
    required this.status,
    required this.avatarColor,
  });

  // Build from API JSON row
  factory ProviderModel.fromJson(Map<String, dynamic> json) {
    const colors = [
      Color(0xFFFF5722),
      Color(0xFF9C27B0),
      Color(0xFF4CAF50),
      Color(0xFF795548),
      Color(0xFF2196F3),
      Color(0xFFE91E63),
      Color(0xFF009688),
      Color(0xFFFF9800),
    ];
    final colorIndex = (json['id'] as int? ?? 0) % colors.length;
    return ProviderModel(
      dbId: json['id'] as int?,
      name: json['name'] ?? '',
      profession: json['profession'] ?? '',
      id: json['provider_id'] ?? '',
      phone: json['phone'] ?? '',
      location: json['location'] ?? '',
      submitted: json['submitted'] ?? '',
      status: json['status'] ?? 'Pending',
      avatarColor: colors[colorIndex],
    );
  }

  ProviderModel copyWith({
    int? dbId,
    String? name,
    String? profession,
    String? id,
    String? phone,
    String? location,
    String? submitted,
    String? status,
    Color? avatarColor,
  }) => ProviderModel(
    dbId: dbId ?? this.dbId,
    name: name ?? this.name,
    profession: profession ?? this.profession,
    id: id ?? this.id,
    phone: phone ?? this.phone,
    location: location ?? this.location,
    submitted: submitted ?? this.submitted,
    status: status ?? this.status,
    avatarColor: avatarColor ?? this.avatarColor,
  );
}

// ── Page ──────────────────────────────────────────────────────────
class ProvidersScreen extends StatefulWidget {
  const ProvidersScreen({super.key});
  static const routePath = '/admin/provider-verification';

  @override
  State<ProvidersScreen> createState() => _ProvidersScreenState();
}

class _ProvidersScreenState extends State<ProvidersScreen> {
  String _selectedFilter = 'All';
  final TextEditingController _searchCtrl = TextEditingController();
  final List<String> _filters = ['All', 'Pending', 'Approved', 'Rejected'];

  List<ProviderModel> _providers = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProviders();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  // ── READ ──────────────────────────────────────────────────────────
  Future<void> _loadProviders() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final data = await ProviderService.getProviders();
      setState(() {
        _providers = data
            .map((e) => ProviderModel.fromJson(e as Map<String, dynamic>))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load providers.\nCheck your connection.';
        _isLoading = false;
      });
    }
  }

  List<ProviderModel> get _filtered {
    final query = _searchCtrl.text.toLowerCase();
    return _providers.where((p) {
      final matchesSearch =
          query.isEmpty ||
          p.name.toLowerCase().contains(query) ||
          p.id.toLowerCase().contains(query);
      final matchesFilter =
          _selectedFilter == 'All' || p.status == _selectedFilter;
      return matchesSearch && matchesFilter;
    }).toList();
  }

  // ── CREATE ────────────────────────────────────────────────────────
  void _openAddSheet() => _showProviderSheet(null, null);

  // ── UPDATE (open edit) ────────────────────────────────────────────
  void _openEditSheet(ProviderModel provider, int realIndex) =>
      _showProviderSheet(provider, realIndex);

  // ── Quick status UPDATE ───────────────────────────────────────────
  Future<void> _setStatus(int index, String newStatus) async {
    final p = _providers[index];
    if (p.dbId == null) return;

    // Optimistic update
    setState(() {
      _providers[index] = p.copyWith(status: newStatus);
    });

    try {
      await ProviderService.updateProvider(
        id: p.dbId!,
        name: p.name,
        profession: p.profession,
        providerId: p.id,
        phone: p.phone,
        location: p.location,
        submitted: p.submitted,
        status: newStatus,
      );
    } catch (_) {
      setState(() {
        _providers[index] = p;
      }); // rollback
      _showSnack('Status update failed', Colors.red);
    }
  }

  // ── DELETE ────────────────────────────────────────────────────────
  Future<void> _deleteProvider(int index) async {
    final p = _providers[index];
    if (p.dbId == null) return;

    Navigator.pop(context); // close sheet
    setState(() => _providers.removeAt(index));

    try {
      await ProviderService.deleteProvider(p.dbId!);
      _showSnack('${p.name} deleted', const Color(0xFFE53935));
    } catch (_) {
      setState(() => _providers.insert(index, p)); // rollback
      _showSnack('Delete failed', Colors.red);
    }
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ── Bottom Sheet (shared for Add & Edit) ──────────────────────────
  void _showProviderSheet(ProviderModel? existing, int? index) {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final profCtrl = TextEditingController(text: existing?.profession ?? '');
    final idCtrl = TextEditingController(text: existing?.id ?? '');
    final phoneCtrl = TextEditingController(text: existing?.phone ?? '');
    final locCtrl = TextEditingController(text: existing?.location ?? '');
    final dateCtrl = TextEditingController(text: existing?.submitted ?? '');
    String selectedStatus = existing?.status ?? 'Pending';
    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  existing == null ? 'Add New Provider' : 'Edit Provider',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 20),

                _SheetField(
                  label: 'Full Name',
                  ctrl: nameCtrl,
                  hint: 'e.g. Rahul Verma',
                ),
                _SheetField(
                  label: 'Profession',
                  ctrl: profCtrl,
                  hint: 'e.g. Electrician',
                ),
                _SheetField(
                  label: 'Provider ID',
                  ctrl: idCtrl,
                  hint: 'e.g. PV005',
                ),
                _SheetField(
                  label: 'Phone',
                  ctrl: phoneCtrl,
                  hint: '+91 XXXXX XXXXX',
                  keyboardType: TextInputType.phone,
                ),
                _SheetField(
                  label: 'Location',
                  ctrl: locCtrl,
                  hint: 'City, State',
                ),
                _SheetField(
                  label: 'Submitted Date',
                  ctrl: dateCtrl,
                  hint: 'YYYY-MM-DD',
                ),

                // Status dropdown
                const Text(
                  'Status',
                  style: TextStyle(fontSize: 12, color: Color(0xFF9E9E9E)),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                  ),
                  items: ['Pending', 'Approved', 'Rejected']
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (v) =>
                      setSheetState(() => selectedStatus = v ?? 'Pending'),
                ),

                const SizedBox(height: 24),

                // Save / Cancel
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          side: const BorderSide(color: Color(0xFFE0E0E0)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Color(0xFF757575)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: isSaving
                            ? null
                            : () async {
                                if (nameCtrl.text.trim().isEmpty) return;
                                setSheetState(() => isSaving = true);
                                try {
                                  if (index != null && existing?.dbId != null) {
                                    // ── UPDATE ──────────────────────────
                                    await ProviderService.updateProvider(
                                      id: existing!.dbId!,
                                      name: nameCtrl.text.trim(),
                                      profession: profCtrl.text.trim(),
                                      providerId: idCtrl.text.trim(),
                                      phone: phoneCtrl.text.trim(),
                                      location: locCtrl.text.trim(),
                                      submitted: dateCtrl.text.trim(),
                                      status: selectedStatus,
                                    );
                                    setState(() {
                                      _providers[index] = existing.copyWith(
                                        name: nameCtrl.text.trim(),
                                        profession: profCtrl.text.trim(),
                                        id: idCtrl.text.trim(),
                                        phone: phoneCtrl.text.trim(),
                                        location: locCtrl.text.trim(),
                                        submitted: dateCtrl.text.trim(),
                                        status: selectedStatus,
                                      );
                                    });
                                    Navigator.pop(ctx);
                                    _showSnack(
                                      '${nameCtrl.text.trim()} updated',
                                      const Color(0xFF4CAF50),
                                    );
                                  } else {
                                    // ── CREATE ──────────────────────────
                                    await ProviderService.createProvider(
                                      name: nameCtrl.text.trim(),
                                      profession: profCtrl.text.trim(),
                                      providerId: idCtrl.text.trim(),
                                      phone: phoneCtrl.text.trim(),
                                      location: locCtrl.text.trim(),
                                      submitted: dateCtrl.text.trim(),
                                      status: selectedStatus,
                                    );
                                    Navigator.pop(ctx);
                                    _showSnack(
                                      '${nameCtrl.text.trim()} added',
                                      const Color(0xFF4CAF50),
                                    );
                                    await _loadProviders(); // reload to get DB id
                                  }
                                } catch (_) {
                                  setSheetState(() => isSaving = false);
                                  _showSnack(
                                    'Save failed. Try again.',
                                    Colors.red,
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: isSaving
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                existing == null
                                    ? 'Add Provider'
                                    : 'Save Changes',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),

                // DELETE — edit mode only
                if (existing != null) ...[
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _showDeleteConfirm(index!),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFEBEE),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: Color(0xFFE53935),
                        size: 18,
                      ),
                      label: const Text(
                        'Delete Provider',
                        style: TextStyle(
                          color: Color(0xFFE53935),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Delete Confirmation Dialog ────────────────────────────────────
  void _showDeleteConfirm(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Provider',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        content: Text(
          'Are you sure you want to delete ${_providers[index].name}? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF757575)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _deleteProvider(index);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddSheet,
        backgroundColor: const Color(0xFF4CAF50),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
      body: Column(
        children: [
          _buildHeader(context),
          _buildSearchBar(),
          _buildFilterChips(),
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF4CAF50)),
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
              onPressed: _loadProviders,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
              ),
              icon: const Icon(Icons.refresh_rounded, color: Colors.white),
              label: const Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }
    if (_filtered.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, size: 48, color: Color(0xFFBDBDBD)),
            SizedBox(height: 12),
            Text(
              'No providers found',
              style: TextStyle(color: Color(0xFF9E9E9E)),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      color: const Color(0xFF4CAF50),
      onRefresh: _loadProviders,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
        itemCount: _filtered.length,
        itemBuilder: (_, i) {
          final p = _filtered[i];
          final realIdx = _providers.indexOf(p);
          return _ProviderCard(
            provider: p,
            onEdit: () => _openEditSheet(p, realIdx),
            onApprove: p.status != 'Approved'
                ? () => _setStatus(realIdx, 'Approved')
                : null,
            onReject: p.status != 'Rejected'
                ? () => _setStatus(realIdx, 'Rejected')
                : null,
          );
        },
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF43A047), Color(0xFFFF9800)],
        ),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 14,
        left: 16,
        right: 16,
        bottom: 20,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.22),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Provider Verification',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
              Text(
                '${_providers.length} providers',
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Search ────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: TextField(
        controller: _searchCtrl,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          hintText: 'Search by name or ID...',
          hintStyle: const TextStyle(color: Color(0xFFBDBDBD), fontSize: 14),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: Color(0xFFBDBDBD),
          ),
          filled: true,
          fillColor: const Color(0xFFF9F9F9),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 1.5),
          ),
        ),
      ),
    );
  }

  // ── Filter Chips ──────────────────────────────────────────────────
  Widget _buildFilterChips() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _filters
              .map(
                (f) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedFilter = f),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: _selectedFilter == f
                            ? const Color(0xFF4CAF50)
                            : const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _selectedFilter == f
                              ? const Color(0xFF4CAF50)
                              : const Color(0xFFE0E0E0),
                        ),
                      ),
                      child: Text(
                        f,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _selectedFilter == f
                              ? Colors.white
                              : const Color(0xFF757575),
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

// ── Sheet Field Helper ────────────────────────────────────────────
class _SheetField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController ctrl;
  final TextInputType keyboardType;

  const _SheetField({
    required this.label,
    required this.ctrl,
    this.hint = '',
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF9E9E9E)),
          ),
          const SizedBox(height: 5),
          TextField(
            controller: ctrl,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Color(0xFFBDBDBD),
                fontSize: 13,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xFF4CAF50),
                  width: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Provider Card ─────────────────────────────────────────────────
class _ProviderCard extends StatelessWidget {
  final ProviderModel provider;
  final VoidCallback onEdit;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  const _ProviderCard({
    required this.provider,
    required this.onEdit,
    this.onApprove,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar + Name + Status
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: provider.avatarColor,
                  child: Text(
                    provider.name.isNotEmpty
                        ? provider.name[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
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
                        provider.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      Text(
                        provider.profession,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9E9E9E),
                        ),
                      ),
                      Text(
                        'ID: ${provider.id}',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFFBDBDBD),
                        ),
                      ),
                    ],
                  ),
                ),
                _StatusBadge(status: provider.status),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFFF0F0F0)),
            const SizedBox(height: 10),

            _DetailRow(label: 'Phone:', value: provider.phone),
            const SizedBox(height: 4),
            _DetailRow(label: 'Location:', value: provider.location),
            const SizedBox(height: 4),
            _DetailRow(label: 'Submitted:', value: provider.submitted),

            const SizedBox(height: 14),

            // Row 1: Edit + View CNIC
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onEdit,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFE0E0E0)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 9),
                    ),
                    icon: const Icon(
                      Icons.edit_rounded,
                      size: 15,
                      color: Color(0xFF757575),
                    ),
                    label: const Text(
                      'Edit',
                      style: TextStyle(
                        color: Color(0xFF757575),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF4CAF50)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 9),
                    ),
                    icon: const Icon(
                      Icons.credit_card_rounded,
                      size: 15,
                      color: Color(0xFF4CAF50),
                    ),
                    label: const Text(
                      'View CNIC',
                      style: TextStyle(
                        color: Color(0xFF4CAF50),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Row 2: Approve / Reject
            if (onApprove != null || onReject != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  if (onApprove != null)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onApprove,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 9),
                        ),
                        icon: const Icon(
                          Icons.check_rounded,
                          size: 15,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Approve',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  if (onApprove != null && onReject != null)
                    const SizedBox(width: 8),
                  if (onReject != null)
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onReject,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE53935),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 9),
                        ),
                        icon: const Icon(
                          Icons.close_rounded,
                          size: 15,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Reject',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
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

// ── Status Badge ──────────────────────────────────────────────────
class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  Color get _bg => status == 'Approved'
      ? const Color(0xFF4CAF50).withOpacity(0.12)
      : status == 'Rejected'
      ? const Color(0xFFE53935).withOpacity(0.12)
      : const Color(0xFFFF9800).withOpacity(0.12);

  Color get _border => status == 'Approved'
      ? const Color(0xFF4CAF50).withOpacity(0.4)
      : status == 'Rejected'
      ? const Color(0xFFE53935).withOpacity(0.4)
      : const Color(0xFFFF9800).withOpacity(0.4);

  Color get _text => status == 'Approved'
      ? const Color(0xFF2E7D32)
      : status == 'Rejected'
      ? const Color(0xFFC62828)
      : const Color(0xFFE65100);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: _text, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            status,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: _text,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Detail Row ────────────────────────────────────────────────────
class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF9E9E9E),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF1A1A1A),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
