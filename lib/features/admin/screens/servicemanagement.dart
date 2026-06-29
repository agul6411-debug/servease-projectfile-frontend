import 'package:flutter/material.dart';
import 'package:frontfile_servease/features/customer/models/servicemanagmentmodel.dart';
import 'package:frontfile_servease/features/admin/screens/admindrawer.dart';
import 'package:frontfile_servease/features/admin/screens/admin_navbar.dart';
import 'package:frontfile_servease/features/admin/screens/servicedetailspage.dart';
import 'package:frontfile_servease/services/addserviceapi.dart';

// ── Category helpers ──────────────────────────────────────────────
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
class Servicemanagement extends StatefulWidget {
  const Servicemanagement({super.key});

  @override
  State<Servicemanagement> createState() => _ServicemanagementState();
}

class _ServicemanagementState extends State<Servicemanagement> {
  final TextEditingController _searchCtrl = TextEditingController();

  List<ServiceModel> _services = [];
  bool _isLoading = true;
  String? _error;

  // ── Predefined services list ──────────────────────────────────────
  static const List<Map<String, String>> _predefinedServices = [
    {'name': 'Tailoring', 'icon': '🧵', 'category': 'Fashion'},
    {'name': 'Embroidery', 'icon': '🪡', 'category': 'Fashion'},
    {'name': 'Cleaning', 'icon': '🧹', 'category': 'Cleaning'},
    {'name': 'Tutoring', 'icon': '📚', 'category': 'Education'},
    {'name': 'Beauty', 'icon': '💄', 'category': 'Beauty'},
    {'name': 'Mehndi', 'icon': '🌿', 'category': 'Beauty'},
    {'name': 'Babysitting', 'icon': '👶', 'category': 'Crafts'},
    {'name': 'Photography', 'icon': '📸', 'category': 'Other'},
  ];

  static const List<String> _categories = [
    'Fashion',
    'Education',
    'Cleaning',
    'Beauty',
    'Crafts',
    'Other',
  ];
  static const List<String> _icons = [
    '🧵',
    '🪡',
    '🧹',
    '📚',
    '💄',
    '🌿',
    '🎨',
    '👶',
    '🏠',
    '📸',
    '🔧',
    '🪠',
  ];

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  // ── READ ──────────────────────────────────────────────────────────
  Future<void> _loadServices() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final data = await ServiceApiService.getServices();
      setState(() {
        _services = data
            .map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load services.\nCheck your connection.';
        _isLoading = false;
      });
    }
  }

  List<ServiceModel> get _filtered {
    final q = _searchCtrl.text.toLowerCase();
    return _services
        .where(
          (s) =>
              q.isEmpty ||
              s.name.toLowerCase().contains(q) ||
              s.category.toLowerCase().contains(q),
        )
        .toList();
  }

  // ── NAVIGATE TO DETAIL ────────────────────────────────────────────
  void _openDetail(ServiceModel svc) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ServiceDetailScreen(service: svc)),
    );
  }

  // ── TOGGLE ACTIVE ─────────────────────────────────────────────────
  Future<void> _toggleActive(int idx) async {
    final svc = _services[idx];
    final newState = !svc.isActive;
    setState(() {
      _services[idx] = svc.copyWith(isActive: newState);
    });
    try {
      if (svc.dbId != null) {
        await ServiceApiService.toggleActive(id: svc.dbId!, isActive: newState);
      }
    } catch (_) {
      setState(() {
        _services[idx] = svc;
      });
      _showSnack('Update failed', Colors.red);
    }
  }

  // ── DELETE ────────────────────────────────────────────────────────
  Future<void> _deleteService(int idx) async {
    final svc = _services[idx];
    setState(() => _services.removeAt(idx));
    _showSnack('${svc.name} deleted', const Color(0xFFE53935));
    try {
      if (svc.dbId != null) {
        await ServiceApiService.deleteService(svc.dbId!);
      }
    } catch (_) {
      setState(() => _services.insert(idx, svc));
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

  // ── Bottom Sheet ──────────────────────────────────────────────────
  void _showSheet(ServiceModel? existing, int? index) {
    // Pre-fill with predefined if no name selected yet
    String selName = existing?.name ?? _predefinedServices[0]['name']!;
    String selCat = existing?.category ?? _predefinedServices[0]['category']!;
    String selIcon = existing?.icon ?? _predefinedServices[0]['icon']!;

    final descCtrl = TextEditingController(text: existing?.description ?? '');
    final priceCtrl = TextEditingController(
      text: existing?.price != null && existing!.price > 0
          ? existing.price.toString()
          : '',
    );
    bool isSaving = false;

    final serviceNames = _predefinedServices.map((s) => s['name']!).toList();
    if (existing != null && !serviceNames.contains(existing.name)) {
      serviceNames.insert(0, existing.name);
    }

    final categories = [..._categories];
    if (existing != null && !categories.contains(existing.category)) {
      categories.insert(0, existing.category);
    }

    final icons = [..._icons];
    if (existing != null && !icons.contains(existing.icon)) {
      icons.insert(0, existing.icon);
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, ss) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle
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
                  existing == null ? 'Add Service' : 'Edit Service',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 20),

                // ── Service Name Dropdown ─────────────────────────
                _dropLabel('Service Name'),
                const SizedBox(height: 5),
                DropdownButtonFormField<String>(
                  value: selName,
                  decoration: _dropDecor(),
                  items: serviceNames.map((name) {
                    final predefined = _predefinedServices.firstWhere(
                      (s) => s['name'] == name,
                      orElse: () => <String, String>{},
                    );
                    return DropdownMenuItem(
                      value: name,
                      child: Row(
                        children: [
                          if (predefined.isNotEmpty) ...[
                            Text(
                              predefined['icon']!,
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Text(name),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (v) {
                    if (v == null) return;
                    final match = _predefinedServices.firstWhere(
                      (s) => s['name'] == v,
                      orElse: () => <String, String>{},
                    );
                    ss(() {
                      selName = v;
                      if (match.isNotEmpty) {
                        selCat = match['category']!;
                        selIcon = match['icon']!;
                      }
                    });
                  },
                ),
                const SizedBox(height: 12),

                _Field(
                  label: 'Description',
                  ctrl: descCtrl,
                  hint: 'Short description',
                ),
                _Field(
                  label: 'Base Price (PKR)',
                  ctrl: priceCtrl,
                  hint: 'e.g. 500',
                  keyboardType: TextInputType.number,
                ),

                // Category (auto-synced but editable)
                _dropLabel('Category'),
                const SizedBox(height: 5),
                DropdownButtonFormField<String>(
                  value: selCat,
                  decoration: _dropDecor(),
                  items: categories
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => ss(() => selCat = v ?? 'Fashion'),
                ),
                const SizedBox(height: 12),

                // Icon (auto-synced but editable)
                _dropLabel('Icon'),
                const SizedBox(height: 5),
                DropdownButtonFormField<String>(
                  value: selIcon,
                  decoration: _dropDecor(),
                  items: icons
                      .map(
                        (ic) => DropdownMenuItem(
                          value: ic,
                          child: Text(
                            '$ic  $ic',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => ss(() => selIcon = v ?? '🧵'),
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
                                if (selName.trim().isEmpty) return;
                                ss(() => isSaving = true);
                                try {
                                  final price =
                                      int.tryParse(priceCtrl.text.trim()) ?? 0;

                                  if (index != null && existing?.dbId != null) {
                                    // UPDATE
                                    await ServiceApiService.updateService(
                                      id: existing!.dbId!,
                                      name: selName,
                                      description: descCtrl.text.trim(),
                                      price: price,
                                      category: selCat,
                                      icon: selIcon,
                                      isActive: existing.isActive,
                                    );
                                    setState(() {
                                      _services[index] = existing.copyWith(
                                        name: selName,
                                        description: descCtrl.text.trim(),
                                        price: price,
                                        category: selCat,
                                        icon: selIcon,
                                      );
                                    });
                                    Navigator.pop(ctx);
                                    _showSnack(
                                      '$selName updated',
                                      const Color(0xFF43A047),
                                    );
                                  } else {
                                    // CREATE
                                    await ServiceApiService.createService(
                                      name: selName,
                                      description: descCtrl.text.trim(),
                                      price: price,
                                      category: selCat,
                                      icon: selIcon,
                                      isActive: true,
                                    );
                                    Navigator.pop(ctx);
                                    _showSnack(
                                      '$selName added',
                                      const Color(0xFF43A047),
                                    );
                                    await _loadServices();
                                  }
                                } catch (_) {
                                  ss(() => isSaving = false);
                                  _showSnack(
                                    'Save failed. Try again.',
                                    Colors.red,
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF43A047),
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
                                    ? 'Add Service'
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

                // Delete — edit mode only
                if (existing != null) ...[
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _confirmDelete(ctx, index!),
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
                        'Delete Service',
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

  void _confirmDelete(BuildContext sheetCtx, int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete Service',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        content: Text(
          'Delete "${_services[index].name}"? This cannot be undone.',
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
              Navigator.pop(sheetCtx);
              _deleteService(index);
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
      backgroundColor: const Color(0xFFF2F2F2),
      drawer: const AdminDrawer(),
      bottomNavigationBar: const AdminBottomNavBar(),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildSearch(),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF43A047), Color(0xFFFF9800)],
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Service Management',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  '${_services.length} total services',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _showSheet(null, null),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF43A047),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.4),
                  width: 3,
                ),
              ),
              child: const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 10, 12, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: Color(0xFFBDBDBD), size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchCtrl,
              onChanged: (_) => setState(() {}),
              style: const TextStyle(fontSize: 14, color: Color(0xFF1A1A1A)),
              decoration: const InputDecoration(
                hintText: 'Search services...',
                hintStyle: TextStyle(color: Color(0xFFBDBDBD), fontSize: 14),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF43A047)),
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
              onPressed: _loadServices,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF43A047),
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
              'No services found',
              style: TextStyle(color: Color(0xFF9E9E9E)),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      color: const Color(0xFF43A047),
      onRefresh: _loadServices,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 24),
        itemCount: _filtered.length,
        itemBuilder: (_, i) {
          final svc = _filtered[i];
          final realIdx = _services.indexWhere((e) => e.dbId == svc.dbId);
          return _ServiceCard(
            service: svc,
            onEdit: () => _showSheet(svc, realIdx),
            onToggle: () => _toggleActive(realIdx),
            onDelete: () => _confirmDelete(context, realIdx),
            onDetails: () => _openDetail(svc), // ← NEW
          );
        },
      ),
    );
  }
}

// ── Service Card ──────────────────────────────────────────────────
class _ServiceCard extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback onEdit;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onDetails; // ← NEW

  const _ServiceCard({
    required this.service,
    required this.onEdit,
    required this.onToggle,
    required this.onDelete,
    required this.onDetails,
  });

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
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top row — icon / name / badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: _catBg(service.category),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      service.icon,
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        service.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        service.description,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF9E9E9E),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            'PKR ${service.price} base',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF43A047),
                            ),
                          ),
                          const SizedBox(width: 8),
                          _CatBadge(label: service.category),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                _ActiveBadge(isActive: service.isActive),
              ],
            ),

            // Provider / Customer mini-stats row ── NEW ──
            const SizedBox(height: 10),
            Row(
              children: [
                _StatChip(
                  icon: Icons.person_pin_rounded,
                  color: const Color(0xFF1E88E5),
                  label: '${service.providerCount} Providers',
                ),
                const SizedBox(width: 8),
                _StatChip(
                  icon: Icons.people_alt_rounded,
                  color: const Color(0xFF8E24AA),
                  label: '${service.customerCount} Customers',
                ),
              ],
            ),

            const SizedBox(height: 10),
            const Divider(height: 1, color: Color(0xFFF0F0F0)),
            const SizedBox(height: 10),

            // Action buttons row
            Row(
              children: [
                // Activate / Deactivate
                Expanded(
                  child: OutlinedButton(
                    onPressed: onToggle,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      side: BorderSide(
                        color: service.isActive
                            ? const Color(0xFFE0E0E0)
                            : const Color(0xFF43A047),
                      ),
                      backgroundColor: service.isActive
                          ? const Color(0xFFF5F5F5)
                          : const Color(0xFFEAF3DE),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      service.isActive ? 'Deactivate' : 'Activate',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: service.isActive
                            ? const Color(0xFF757575)
                            : const Color(0xFF2E7D32),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Details button ── NEW ──
                _IconBtn(
                  icon: Icons.bar_chart_rounded,
                  color: const Color(0xFF1565C0),
                  borderColor: const Color(0xFFBBDEFB),
                  onTap: onDetails,
                  tooltip: 'Details',
                ),
                const SizedBox(width: 8),

                // Edit
                _IconBtn(
                  icon: Icons.edit_rounded,
                  color: const Color(0xFF43A047),
                  borderColor: const Color(0xFFE0E0E0),
                  onTap: onEdit,
                  tooltip: 'Edit',
                ),
                const SizedBox(width: 8),

                // Delete
                _IconBtn(
                  icon: Icons.delete_outline_rounded,
                  color: const Color(0xFFE53935),
                  borderColor: const Color(0xFFFFCDD2),
                  onTap: onDelete,
                  tooltip: 'Delete',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Stat Chip (Provider / Customer count) ─────────────────────────
class _StatChip extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;

  const _StatChip({
    required this.icon,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: color.withOpacity(0.08),
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: color.withOpacity(0.2)),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    ),
  );
}

// ── Reusable Widgets ──────────────────────────────────────────────
class _CatBadge extends StatelessWidget {
  final String label;
  const _CatBadge({required this.label});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(
      color: _catBg(label),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Text(
      label,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: _catText(label),
      ),
    ),
  );
}

class _ActiveBadge extends StatelessWidget {
  final bool isActive;
  const _ActiveBadge({required this.isActive});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
    decoration: BoxDecoration(
      color: isActive ? const Color(0xFFEAF3DE) : const Color(0xFFFFF3E0),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: isActive ? const Color(0xFF97C459) : const Color(0xFFFFB74D),
      ),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? const Color(0xFF3B6D11) : const Color(0xFFE65100),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          isActive ? 'Active' : 'Inactive',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: isActive ? const Color(0xFF3B6D11) : const Color(0xFFE65100),
          ),
        ),
      ],
    ),
  );
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color borderColor;
  final VoidCallback onTap;
  final String tooltip;

  const _IconBtn({
    required this.icon,
    required this.color,
    required this.borderColor,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) => Tooltip(
    message: tooltip,
    child: GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: borderColor),
        ),
        child: Icon(icon, color: color, size: 17),
      ),
    ),
  );
}

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController ctrl;
  final String hint;
  final TextInputType keyboardType;

  const _Field({
    required this.label,
    required this.ctrl,
    this.hint = '',
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) => Padding(
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
            hintStyle: const TextStyle(color: Color(0xFFBDBDBD), fontSize: 13),
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
                color: Color(0xFF43A047),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget _dropLabel(String text) =>
    Text(text, style: const TextStyle(fontSize: 12, color: Color(0xFF9E9E9E)));

InputDecoration _dropDecor() => InputDecoration(
  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
    borderSide: const BorderSide(color: Color(0xFF43A047), width: 1.5),
  ),
);
