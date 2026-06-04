import 'package:flutter/material.dart';
import 'package:projectfile/models/all_user_model.dart';
import 'package:projectfile/screens/admin/allusers.dart';
import 'package:projectfile/services/all_users_service.dart';
import 'package:get/get.dart';

class UserDetail extends StatefulWidget {
  const UserDetail({super.key});

  @override
  State<UserDetail> createState() => _UserDetailState();
}

class _UserDetailState extends State<UserDetail> {
  static const Color primaryGreen = Color(0xFF1B8B4B);
  static const Color darkGreen = Color(0xFF145E33);
  static const Color accentOrange = Color(0xFFE8671A);
  static const Color bgColor = Color(0xFFF5F7F5);

  late final int userId = Get.arguments as int;

  UserModel? _user;
  bool _isLoading = true;
  bool _blocking = false;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });
    try {
      final user = await UserService.getUserById(userId);
      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMsg = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleBlock() async {
    if (_user == null) return;
    final wasBlocked = _user!.isBlocked; // save karo pehle
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          wasBlocked ? 'Unblock Karein?' : 'Block Karein?',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        content: Text(
          wasBlocked
              ? '${_user!.fullName} ko unblock karna chahte hain?'
              : '${_user!.fullName} ko block karna chahte hain? Woh login nahi kar sakenge.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: wasBlocked ? primaryGreen : Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(wasBlocked ? 'Unblock' : 'Block'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _blocking = true);
    try {
      if (wasBlocked) {
        await UserService.unblockUser(_user!.id);
      } else {
        await UserService.blockUser(_user!.id);
      }
      await _loadUser();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              wasBlocked ? 'User unblock ho gaya ✅' : 'User block ho gaya 🚫',
            ),
            backgroundColor: wasBlocked ? primaryGreen : Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() => _blocking = false);
    }
  }

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String? value,
    Color? iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (iconColor ?? primaryGreen).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: iconColor ?? primaryGreen),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value?.isNotEmpty == true ? value! : 'Maujood nahi',
                  style: TextStyle(
                    fontSize: 15,
                    color: value?.isNotEmpty == true
                        ? const Color(0xFF1A1A1A)
                        : Colors.grey.shade400,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard(String title, List<Widget> rows) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: darkGreen,
              letterSpacing: 0.3,
            ),
          ),
          const Divider(height: 20),
          ...rows,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Get.offAllNamed('/allusers'),
        ),
        title: Text(
          _user?.fullName ?? 'User Detail',
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, size: 22),
            onPressed: _loadUser,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryGreen))
          : _errorMsg != null
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 60,
                    color: Colors.red.shade300,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _errorMsg!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _loadUser,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Dobara Try Karein'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          : _user == null
          ? const Center(child: Text('User nahi mila'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Profile Header ─────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [primaryGreen, darkGreen],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 42,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          backgroundImage:
                              _user!.profileImage != null &&
                                  _user!.profileImage!.isNotEmpty
                              ? NetworkImage(_user!.profileImage!)
                              : null,
                          child:
                              _user!.profileImage == null ||
                                  _user!.profileImage!.isEmpty
                              ? Text(
                                  _user!.fullName.isNotEmpty
                                      ? _user!.fullName[0].toUpperCase()
                                      : '?',
                                  style: const TextStyle(
                                    fontSize: 34,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _user!.fullName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _pillBadge(_user!.role),
                            const SizedBox(width: 8),
                            if (_user!.isBlocked)
                              _pillBadge('Blocked', color: Colors.red.shade400),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'ID: ${_user!.id}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Basic Info ────────────────────────────────
                  _sectionCard('📋 Bunyaadi Malumat', [
                    _infoRow(
                      icon: Icons.email_outlined,
                      label: 'EMAIL',
                      value: _user!.email,
                    ),
                    const Divider(height: 1),
                    _infoRow(
                      icon: Icons.phone_outlined,
                      label: 'PHONE',
                      value: _user!.phone,
                    ),
                    const Divider(height: 1),
                    _infoRow(
                      icon: Icons.credit_card_outlined,
                      label: 'CNIC',
                      value: _user!.cnic,
                    ),
                    const Divider(height: 1),
                    _infoRow(
                      icon: Icons.location_on_outlined,
                      label: 'ADDRESS',
                      value: _user!.address,
                    ),
                  ]),

                  // ── Account Info ──────────────────────────────
                  _sectionCard('⚙️ Account Info', [
                    _infoRow(
                      icon: Icons.manage_accounts_outlined,
                      label: 'ROLE',
                      value: _user!.role.toUpperCase(),
                    ),
                    const Divider(height: 1),
                    _infoRow(
                      icon: Icons.calendar_today_outlined,
                      label: 'REGISTERED',
                      value: _user!.createdAt != null
                          ? '${_user!.createdAt!.day}/${_user!.createdAt!.month}/${_user!.createdAt!.year}'
                          : null,
                    ),
                    const Divider(height: 1),
                    _infoRow(
                      icon: Icons.info_outline,
                      label: 'STATUS',
                      value: _user!.status ?? 'Active',
                    ),
                    const Divider(height: 1),
                    _infoRow(
                      icon: Icons.block,
                      label: 'BLOCK STATUS',
                      value: _user!.isBlocked ? 'Blocked' : 'Active',
                      iconColor: _user!.isBlocked ? Colors.red : primaryGreen,
                    ),
                  ]),

                  const SizedBox(height: 8),

                  // ── Block/Unblock Button ───────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _blocking ? null : _toggleBlock,
                      icon: _blocking
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Icon(
                              _user!.isBlocked ? Icons.lock_open : Icons.block,
                              size: 20,
                            ),
                      label: Text(
                        _blocking
                            ? 'Processing...'
                            : _user!.isBlocked
                            ? 'User Unblock Karein'
                            : 'User Block Karein',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _user!.isBlocked
                            ? primaryGreen
                            : Colors.red.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _pillBadge(String text, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        color: (color ?? accentOrange).withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
