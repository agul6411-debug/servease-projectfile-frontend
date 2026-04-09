import 'package:flutter/material.dart';

void main() {
  runApp(const ServEaseApp());
}

class ServEaseApp extends StatelessWidget {
  const ServEaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ServEase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF0F0F0),
      ),
      home: const CustomerHomePage(),
    );
  }
}

// ─────────────────────────────────────────────
// Data model
// ─────────────────────────────────────────────
class ServiceCategory {
  final String name;
  final IconData icon;
  final Color bgColor;

  const ServiceCategory({
    required this.name,
    required this.icon,
    required this.bgColor,
  });
}

// ─────────────────────────────────────────────
// Home Page
// ─────────────────────────────────────────────
class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key});

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<ServiceCategory> _allServices = const [
    ServiceCategory(
        name: 'Electrician',
        icon: Icons.bolt_rounded,
        bgColor: Color(0xFFF5A623)),
    ServiceCategory(
        name: 'Plumber',
        icon: Icons.water_drop_rounded,
        bgColor: Color(0xFF3B7DD8)),
    ServiceCategory(
        name: 'Cleaner',
        icon: Icons.auto_awesome_rounded,
        bgColor: Color(0xFF7B3FD4)),
    ServiceCategory(
        name: 'Tutor',
        icon: Icons.school_rounded,
        bgColor: Color(0xFF2DAA55)),
    ServiceCategory(
        name: 'Carpenter',
        icon: Icons.handyman_rounded,
        bgColor: Color(0xFFE8652A)),
    ServiceCategory(
        name: 'Painter',
        icon: Icons.format_paint_rounded,
        bgColor: Color(0xFFE83060)),
    ServiceCategory(
        name: 'Gardener',
        icon: Icons.yard_rounded,
        bgColor: Color(0xFF2DAA55)),
    ServiceCategory(
        name: 'Mechanic',
        icon: Icons.build_rounded,
        bgColor: Color(0xFF555555)),
  ];

  List<ServiceCategory> get _filteredServices {
    if (_searchQuery.isEmpty) return _allServices;
    return _allServices
        .where((s) =>
            s.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onServiceTap(ServiceCategory service) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${service.name} services...'),
        backgroundColor: const Color(0xFF2D6A4F),
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _onProfileTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening profile...'),
        backgroundColor: Color(0xFF2D6A4F),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: Column(
        children: [
          // ── Top green header ──
          _buildHeader(),

          // ── Body content ──
          Expanded(
            child: _selectedIndex == 0
                ? _buildHomeContent()
                : _buildViewServicesContent(),
          ),
        ],
      ),

      // ── Bottom Navigation Bar ──
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ─────────────────────────────────────────────
  // Header
  // ─────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF2D6A4F),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nav row
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  // Logo
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.home_rounded,
                        color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'ServEase',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const Spacer(),
                  // Home nav link
                  GestureDetector(
                    onTap: () => setState(() => _selectedIndex = 0),
                    child: Column(
                      children: [
                        Text(
                          'Home',
                          style: TextStyle(
                            color: _selectedIndex == 0
                                ? Colors.white
                                : Colors.white70,
                            fontSize: 14,
                            fontWeight: _selectedIndex == 0
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                        if (_selectedIndex == 0)
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            height: 2,
                            width: 40,
                            color: Colors.white,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  // View Services nav link
                  GestureDetector(
                    onTap: () => setState(() => _selectedIndex = 1),
                    child: Text(
                      'View Services',
                      style: TextStyle(
                        color: _selectedIndex == 1
                            ? Colors.white
                            : Colors.white70,
                        fontSize: 14,
                        fontWeight: _selectedIndex == 1
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Profile icon
                  GestureDetector(
                    onTap: _onProfileTap,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person_rounded,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),

            // Welcome text
            const Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Welcome Back 👋',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                  left: 20, top: 4, bottom: 16),
              child: Text(
                'Find your home services easily',
                style: TextStyle(
                    color: Colors.white70, fontSize: 14),
              ),
            ),

            // Search bar
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, bottom: 24),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (v) =>
                      setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: 'Search for services...',
                    hintStyle: const TextStyle(
                        color: Color(0xFFAAAAAA), fontSize: 14),
                    prefixIcon: const Icon(Icons.search_rounded,
                        color: Color(0xFFAAAAAA), size: 22),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close,
                                color: Color(0xFFAAAAAA),
                                size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Home Content — Our Services grid
  // ─────────────────────────────────────────────
  Widget _buildHomeContent() {
    final services = _filteredServices;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Our Services',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Choose from a wide range of professional services',
            style: TextStyle(
                fontSize: 13, color: Colors.black45),
          ),
          const SizedBox(height: 20),

          if (services.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Column(
                  children: [
                    Icon(Icons.search_off_rounded,
                        size: 48,
                        color: Colors.black26),
                    const SizedBox(height: 12),
                    Text(
                      'No services found for "$_searchQuery"',
                      style: const TextStyle(
                          color: Colors.black45, fontSize: 14),
                    ),
                  ],
                ),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(),
              itemCount: services.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.95,
              ),
              itemBuilder: (context, index) {
                final s = services[index];
                return _ServiceCard(
                  service: s,
                  onTap: () => _onServiceTap(s),
                );
              },
            ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // View Services Content
  // ─────────────────────────────────────────────
  Widget _buildViewServicesContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'All Services',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Browse all available professional services',
            style: TextStyle(
                fontSize: 13, color: Colors.black45),
          ),
          const SizedBox(height: 20),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _allServices.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final s = _allServices[index];
              return _ServiceListTile(
                service: s,
                onTap: () => _onServiceTap(s),
              );
            },
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Bottom Navigation
  // ─────────────────────────────────────────────
  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Home tab
            Expanded(
              child: InkWell(
                onTap: () => setState(() => _selectedIndex = 0),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                          color: Colors.grey.shade200, width: 1),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.home_rounded,
                        color: _selectedIndex == 0
                            ? const Color(0xFF2D6A4F)
                            : Colors.black38,
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Home',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: _selectedIndex == 0
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: _selectedIndex == 0
                              ? const Color(0xFF2D6A4F)
                              : Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // View Services tab
            Expanded(
              child: InkWell(
                onTap: () => setState(() => _selectedIndex = 1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.work_outline_rounded,
                        color: _selectedIndex == 1
                            ? const Color(0xFF2D6A4F)
                            : Colors.black38,
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'View Services',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: _selectedIndex == 1
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: _selectedIndex == 1
                              ? const Color(0xFF2D6A4F)
                              : Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Service Card Widget (Grid)
// ─────────────────────────────────────────────
class _ServiceCard extends StatefulWidget {
  final ServiceCategory service;
  final VoidCallback onTap;

  const _ServiceCard({required this.service, required this.onTap});

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          transform: Matrix4.identity()
            ..scale(_hovered ? 1.03 : 1.0),
          transformAlignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black
                    .withOpacity(_hovered ? 0.10 : 0.05),
                blurRadius: _hovered ? 16 : 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: widget.service.bgColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  widget.service.icon,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                widget.service.name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Service List Tile Widget (View Services tab)
// ─────────────────────────────────────────────
class _ServiceListTile extends StatelessWidget {
  final ServiceCategory service;
  final VoidCallback onTap;

  const _ServiceListTile(
      {required this.service, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: service.bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(service.icon,
                  color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                service.name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: Colors.black38),
          ],
        ),
      ),
    );
  }
}