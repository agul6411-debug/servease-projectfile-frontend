import 'package:flutter/material.dart';
import 'package:frontfile_servease/models/customer/customer_model.dart';
import 'package:frontfile_servease/features/customer/screens/navbar.dart';
import 'package:frontfile_servease/features/customer/screens/provider_detail_screen.dart';
import 'package:frontfile_servease/features/customer/services/customerserviceali.dart';
import 'package:frontfile_servease/core/theme/app_theme.dart';

class ProvidersListScreen extends StatefulWidget {
  final String selectedCategory;
  const ProvidersListScreen({super.key, required this.selectedCategory});

  @override
  State<ProvidersListScreen> createState() => _ProvidersListScreenState();
}

class _ProvidersListScreenState extends State<ProvidersListScreen> {
  List<TopProvider> _providers = [];
  List<TopProvider> _filtered = [];
  bool _isLoading = true;
  late String _selectedCategory;
  final _searchCtrl = TextEditingController();

  static const Color primaryGreen = AppColors.primary;
  static const Color darkGreen = Color(0xFF145E33);
  static const Color accentOrange = AppColors.secondary;
  static const Color bgColor = AppColors.background;

  final _categories = [
    'all',
    'Cleaning',
    'Tailoring',
    'Beauty',
    'Education',
    'Mehndi',
    'Crafts',
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.selectedCategory;
    _loadProviders();
  }

  Future<void> _loadProviders() async {
    setState(() => _isLoading = true);
    final data = await CustomerApiService.fetchAllProviders();
    setState(() {
      _providers = data;
      _applyFilter();
      _isLoading = false;
    });
  }

  void _applyFilter() {
    var list = _selectedCategory == 'all'
        ? _providers
        : _providers
            .where((p) =>
                p.category.toLowerCase() == _selectedCategory.toLowerCase() ||
                p.service.toLowerCase() == _selectedCategory.toLowerCase())
            .toList();

    final q = _searchCtrl.text.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list
          .where(
            (p) =>
                p.name.toLowerCase().contains(q) ||
                p.service.toLowerCase().contains(q) ||
                p.category.toLowerCase().contains(q),
          )
          .toList();
    }
    setState(() => _filtered = list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Find Providers',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
      ),
      bottomNavigationBar: const CustomerNavBar(currentIndex: 1), // 1 = Search
      body: Column(
        children: [
          // Search Field
          Padding(
            padding: const EdgeInsets.all(14),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (_) => _applyFilter(),
                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search by name, service, or category...',
                  hintStyle: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade400,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: primaryGreen,
                    size: 22,
                  ),
                  suffixIcon: _searchCtrl.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear_rounded, size: 18, color: Colors.grey.shade600),
                          onPressed: () {
                            _searchCtrl.clear();
                            _applyFilter();
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),

          // Category filters
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: _categories.length,
              itemBuilder: (_, i) {
                final cat = _categories[i];
                final isSelected = _selectedCategory == cat;
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedCategory = cat);
                    _applyFilter();
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? primaryGreen : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: primaryGreen.withOpacity(0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              )
                            ]
                          : null,
                      border: Border.all(
                        color: isSelected ? primaryGreen : Colors.grey.shade200,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        cat == 'all' ? 'All Services' : cat,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Results count
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_filtered.length} providers found',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // List
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: primaryGreen,
                    ),
                  )
                : _filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.search_off_rounded, size: 50, color: Colors.grey.shade300),
                            const SizedBox(height: 10),
                            Text(
                              'No providers found',
                              style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
                        itemCount: _filtered.length,
                        itemBuilder: (_, i) =>
                            _ProviderListCard(provider: _filtered[i]),
                      ),
          ),
        ],
      ),
    );
  }
}

class _ProviderListCard extends StatelessWidget {
  final TopProvider provider;
  const _ProviderListCard({required this.provider});

  static const Color primaryGreen = AppColors.primary;

  Color get _avatarColor {
    final colors = [
      const Color(0xFF4CAF50),
      const Color(0xFF2196F3),
      const Color(0xFFFF9800),
      const Color(0xFF9C27B0),
      const Color(0xFF00BCD4),
    ];
    return colors[provider.name.length % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: _avatarColor.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              provider.initials,
              style: TextStyle(
                color: _avatarColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        title: Text(
          provider.name,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(
              provider.service,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.star_rounded,
                  size: 16,
                  color: Colors.amber,
                ),
                const SizedBox(width: 4),
                Text(
                  provider.rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                if (provider.isVerified)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Verified',
                      style: TextStyle(
                        fontSize: 10,
                        color: primaryGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (provider.isNew) ...[
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'New',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.orange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                Text(
                  'RS ${provider.rate}/hr',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: primaryGreen,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14,
          color: Colors.grey.shade400,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProviderDetailScreen(providerId: provider.id),
            ),
          );
        },
      ),
    );
  }
}
