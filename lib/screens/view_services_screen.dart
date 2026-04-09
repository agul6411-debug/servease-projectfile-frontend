import 'package:flutter/material.dart';
import '../constants/colors.dart';

// ─────────────────────────────────────────────
// Data Model
// ─────────────────────────────────────────────
class ServiceItem {
  final String name;
  final IconData icon;
  final Color bgColor;
  int providers;

  ServiceItem({
    required this.name,
    required this.icon,
    required this.bgColor,
    required this.providers,
  });
}

class ViewServicesPage extends StatefulWidget {
  const ViewServicesPage({super.key});

  @override
  State<ViewServicesPage> createState() => _ViewServicesPageState();
}

class _ViewServicesPageState extends State<ViewServicesPage> {
  int _selectedNavIndex = 1; // 0 = Home, 1 = View Services

  // Left column
  final List<ServiceItem> _leftServices = [
    ServiceItem(name: 'Electrician', icon: Icons.bolt_rounded, bgColor: AppColors.orange, providers: 234),
    ServiceItem(name: 'Tutor', icon: Icons.school_rounded, bgColor: AppColors.teal, providers: 312),
    ServiceItem(name: 'Cleaner', icon: Icons.add_circle_outline_rounded, bgColor: AppColors.mid, providers: 267),
    ServiceItem(name: 'Carpenter', icon: Icons.handyman_rounded, bgColor: AppColors.dark, providers: 184),
    ServiceItem(name: 'Painter', icon: Icons.brush_rounded, bgColor: AppColors.teal, providers: 178),
    ServiceItem(name: 'Appliance Repair', icon: Icons.build_rounded, bgColor: AppColors.dark, providers: 217),
  ];

  // Right column
  final List<ServiceItem> _rightServices = [
    ServiceItem(name: 'Plumber', icon: Icons.water_drop_rounded, bgColor: AppColors.teal, providers: 189),
    ServiceItem(name: 'Labour', icon: Icons.person_rounded, bgColor: AppColors.orange, providers: 156),
    ServiceItem(name: 'Cleaner', icon: Icons.star_outline_rounded, bgColor: AppColors.dark, providers: 267),
    ServiceItem(name: 'Carpenter', icon: Icons.handyman_rounded, bgColor: AppColors.mid, providers: 184),
    ServiceItem(name: 'Driver', icon: Icons.directions_car_rounded, bgColor: AppColors.teal, providers: 91),
    ServiceItem(name: 'Appliance Repair', icon: Icons.build_rounded, bgColor: AppColors.dark, providers: 217),
  ];

  void _onServiceTap(ServiceItem service) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${service.name} — ${service.providers} providers'),
        backgroundColor: AppColors.teal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showAddServiceDialog() {
    final nameController = TextEditingController();
    final providersController = TextEditingController();
    Color selectedColor = AppColors.teal;
    IconData selectedIcon = Icons.build_rounded;

    final colorOptions = [
      AppColors.teal,
      AppColors.dark,
      AppColors.orange,
      AppColors.mid,
    ];

    final iconOptions = [
      Icons.bolt_rounded,
      Icons.water_drop_rounded,
      Icons.school_rounded,
      Icons.handyman_rounded,
      Icons.brush_rounded,
      Icons.build_rounded,
      Icons.person_rounded,
      Icons.directions_car_rounded,
      Icons.cleaning_services_rounded,
      Icons.yard_rounded,
    ];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Text(
                'Add New Service',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Service Name
                    const Text('Service Name',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF444444))),
                    const SizedBox(height: 6),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintText: 'e.g. Gardener',
                        hintStyle: const TextStyle(color: Color(0xFFBBBBBB), fontSize: 13),
                        filled: true,
                        fillColor: const Color(0xFFF5F5F5),
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
                          borderSide: const BorderSide(color: AppColors.teal, width: 1.5),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Providers count
                    const Text('Number of Providers',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF444444))),
                    const SizedBox(height: 6),
                    TextField(
                      controller: providersController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'e.g. 100',
                        hintStyle: const TextStyle(color: Color(0xFFBBBBBB), fontSize: 13),
                        filled: true,
                        fillColor: const Color(0xFFF5F5F5),
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
                          borderSide: const BorderSide(color: AppColors.orange, width: 1.5),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Color picker
                    const Text('Icon Color',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF444444))),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: colorOptions.map((color) {
                        final isSelected = selectedColor == color;
                        return GestureDetector(
                          onTap: () => setDialogState(() => selectedColor = color),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? Colors.black54 : Colors.transparent,
                                width: 2.5,
                              ),
                              boxShadow: isSelected
                                  ? [BoxShadow(color: color.withAlpha((0.5 * 255).round()), blurRadius: 6)]
                                  : [],
                            ),
                            child: isSelected
                                ? const Icon(Icons.check, color: Colors.white, size: 16)
                                : null,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),

                    // Icon picker
                    const Text('Icon',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF444444))),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: iconOptions.map((icon) {
                        final isSelected = selectedIcon == icon;
                        return GestureDetector(
                          onTap: () => setDialogState(() => selectedIcon = icon),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isSelected ? selectedColor : AppColors.cream,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected ? selectedColor : Colors.transparent,
                              ),
                            ),
                            child: Icon(icon,
                                color: isSelected ? Colors.white : Colors.black54,
                                size: 20),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel',
                      style: TextStyle(color: Colors.black45, fontSize: 14)),
                ),
                ElevatedButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    final provCount = int.tryParse(providersController.text.trim()) ?? 0;
                    if (name.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a service name.'),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                      return;
                    }
                    final newService = ServiceItem(
                      name: name,
                      icon: selectedIcon,
                      bgColor: selectedColor,
                      providers: provCount,
                    );
                    setState(() {
                      if (_leftServices.length <= _rightServices.length) {
                        _leftServices.add(newService);
                      } else {
                        _rightServices.add(newService);
                      }
                    });
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('"$name" service added successfully!'),
                        backgroundColor: AppColors.teal,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                  child: const Text('Add Service',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Column(
        children: [
          // ── Top green header ──
          _buildHeader(),

          // ── Body ──
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const Text(
                    'View Services',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Choose from a wide range of professional services.',
                    style: TextStyle(fontSize: 13, color: Colors.black45),
                  ),
                  const SizedBox(height: 20),

                  // + Add Service button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _showAddServiceDialog,
                      icon: const Icon(Icons.add, color: Colors.white, size: 20),
                      label: const Text(
                        '+ Add Service',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.teal,
                        elevation: 2,
                        shadowColor: AppColors.teal.withAlpha(102),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Services 2-column list
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(13),
                          blurRadius: 12,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: _buildServiceColumns(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom nav
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ─────────────────────────────────────────────
  // Two-column service list
  // ─────────────────────────────────────────────
  Widget _buildServiceColumns() {
    final maxRows = _leftServices.length > _rightServices.length
        ? _leftServices.length
        : _rightServices.length;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left column
        Expanded(
          child: Column(
            children: List.generate(maxRows, (i) {
              if (i >= _leftServices.length) return const SizedBox.shrink();
              return _ServiceRow(
                service: _leftServices[i],
                onTap: () => _onServiceTap(_leftServices[i]),
                showDivider: i < _leftServices.length - 1,
              );
            }),
          ),
        ),

        // Vertical divider
        Container(
          width: 1,
          color: const Color(0xFFEEEEEE).withAlpha(230),
        ),

        // Right column
        Expanded(
          child: Column(
            children: List.generate(maxRows, (i) {
              if (i >= _rightServices.length) return const SizedBox.shrink();
              return _ServiceRow(
                service: _rightServices[i],
                onTap: () => _onServiceTap(_rightServices[i]),
                showDivider: i < _rightServices.length - 1,
              );
            }),
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  // Header
  // ─────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      color: AppColors.teal,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
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
                ),
              ),
              const Spacer(),
              // Home
              GestureDetector(
                onTap: () => setState(() => _selectedNavIndex = 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Home',
                      style: TextStyle(
                        color: _selectedNavIndex == 0
                            ? Colors.white
                            : Colors.white70,
                        fontSize: 14,
                        fontWeight: _selectedNavIndex == 0
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                    if (_selectedNavIndex == 0)
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
              // View Services
              GestureDetector(
                onTap: () => setState(() => _selectedNavIndex = 1),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View Services',
                      style: TextStyle(
                        color: _selectedNavIndex == 1
                            ? Colors.white
                            : Colors.white70,
                        fontSize: 14,
                        fontWeight: _selectedNavIndex == 1
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                    if (_selectedNavIndex == 1)
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        height: 2,
                        width: 80,
                        color: Colors.white,
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              // Profile
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Opening profile...'),
                        backgroundColor: AppColors.teal,
                    ),
                  );
                },
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
      ),
    );
  }

  // ─────────────────────────────────────────────
  // Bottom Nav
  // ─────────────────────────────────────────────
  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha(18),
              blurRadius: 12,
              offset: const Offset(0, -2)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => setState(() => _selectedNavIndex = 0),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    border: Border(
                        right: BorderSide(
                            color: Colors.grey.shade200, width: 1)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.home_rounded,
                          color: _selectedNavIndex == 0
                              ? const Color(0xFF2D6A4F)
                              : Colors.black38,
                          size: 24),
                      const SizedBox(height: 4),
                      Text('Home',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: _selectedNavIndex == 0
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: _selectedNavIndex == 0
                                ? const Color(0xFF2D6A4F)
                                : Colors.black45,
                          )),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () => setState(() => _selectedNavIndex = 1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.work_outline_rounded,
                          color: _selectedNavIndex == 1
                              ? const Color(0xFF2D6A4F)
                              : Colors.black38,
                          size: 24),
                      const SizedBox(height: 4),
                      Text('View Services',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: _selectedNavIndex == 1
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: _selectedNavIndex == 1
                                ? const Color(0xFF2D6A4F)
                                : Colors.black45,
                          )),
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
// Service Row Widget
// ─────────────────────────────────────────────
class _ServiceRow extends StatefulWidget {
  final ServiceItem service;
  final VoidCallback onTap;
  final bool showDivider;

  const _ServiceRow({
    required this.service,
    required this.onTap,
    required this.showDivider,
  });

  @override
  State<_ServiceRow> createState() => _ServiceRowState();
}

class _ServiceRowState extends State<_ServiceRow> {
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
          color: _hovered
              ? const Color(0xFFF8FFF8).withAlpha(240)
              : Colors.transparent,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 18, vertical: 16),
                child: Row(
                  children: [
                    // Icon
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: widget.service.bgColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(widget.service.icon,
                          color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 12),
                    // Name
                    Expanded(
                      child: Text(
                        widget.service.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ),
                    // Provider count
                    Text(
                      '${widget.service.providers} providers',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black38,
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.showDivider)
                Divider(
                    height: 1,
                    thickness: 1,
                    color: Colors.grey.shade100,
                    indent: 18,
                    endIndent: 18),
            ],
          ),
        ),
      ),
    );
  }
}