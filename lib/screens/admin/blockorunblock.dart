import 'package:flutter/material.dart';
import 'package:frontfile_servease/models/all_user_model.dart';
import 'package:frontfile_servease/screens/admin/admindrawer.dart';
import 'package:frontfile_servease/screens/admin/admin_navbar.dart';
import 'package:frontfile_servease/services/all_users_service.dart';
import 'package:frontfile_servease/theme/app_theme.dart';
import 'package:get/get.dart';

class BlockOrUnblock extends StatefulWidget {
  const BlockOrUnblock({super.key});

  @override
  State<BlockOrUnblock> createState() => _BlockOrUnblockState();
}

class _BlockOrUnblockState extends State<BlockOrUnblock> {
  static const Color primaryGreen = AppColors.success;
  static const Color darkGreen = AppColors.mediumRed;
  static const Color accentOrange = AppColors.softPink;
  static const Color bgColor = AppColors.cream;

  List<UserModel> _blockedUsers = [];
  bool _isLoading = true;
  String? _errorMsg;
  final Map<int, bool> _processingIds = {};

  @override
  void initState() {
    super.initState();
    _loadBlockedUsers();
  }

  Future<void> _loadBlockedUsers() async {
    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });
    try {
      final users = await UserService.getBlockedUsers();
      setState(() {
        _blockedUsers = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMsg = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _unblockUser(UserModel user) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Unblock Karein?',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        content: Text(
          '${user.fullName} ko unblock karna chahte hain? Woh dobara login kar sakenge.',
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
              backgroundColor: primaryGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Unblock'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _processingIds[user.id] = true);
    try {
      await UserService.unblockUser(user.id);
      setState(() => _blockedUsers.removeWhere((u) => u.id == user.id));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${user.fullName} unblock ho gaya!'),
          backgroundColor: primaryGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      setState(() => _processingIds.remove(user.id));
    }
  }

  Widget _roleBadge(String role) {
    Color bg;
    Color fg;
    switch (role) {
      case 'admin':
        bg = AppColors.successBg;
        fg = AppColors.success;
        break;
      case 'provider':
        bg = const Color(0xFFFFF3E0);
        fg = const Color(0xFFE65100);
        break;
      default:
        bg = const Color(0xFFE3F2FD);
        fg = const Color(0xFF1565C0);
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        role.toUpperCase(),
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: fg),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      drawer: const AdminDrawer(),
      bottomNavigationBar: const AdminBottomNavBar(),
      appBar: AppBar(
        backgroundColor: Colors.red.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white, size: 20),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        title: const Text(
          'Blocked Users',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadBlockedUsers,
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
                    onPressed: _loadBlockedUsers,
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
          : _blockedUsers.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 70,
                    color: primaryGreen.withOpacity(0.4),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Koi user block nahi hai',
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Tamaam users active hain',
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Summary Banner
                Container(
                  margin: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.shade200, width: 1),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.block, color: Colors.red.shade600, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        '${_blockedUsers.length} user(s) block hain',
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                // List
                Expanded(
                  child: RefreshIndicator(
                    color: primaryGreen,
                    onRefresh: _loadBlockedUsers,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(14),
                      itemCount: _blockedUsers.length,
                      itemBuilder: (ctx, i) {
                        final user = _blockedUsers[i];
                        final isProcessing = _processingIds[user.id] == true;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.red.shade100,
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
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
                                Row(
                                  children: [
                                    // Avatar
                                    CircleAvatar(
                                      radius: 24,
                                      backgroundColor: Colors.red.shade50,
                                      backgroundImage:
                                          user.profileImage != null &&
                                              user.profileImage!.isNotEmpty
                                          ? NetworkImage(user.profileImage!)
                                          : null,
                                      child:
                                          user.profileImage == null ||
                                              user.profileImage!.isEmpty
                                          ? Text(
                                              user.fullName.isNotEmpty
                                                  ? user.fullName[0]
                                                        .toUpperCase()
                                                  : '?',
                                              style: TextStyle(
                                                color: Colors.red.shade600,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 18,
                                              ),
                                            )
                                          : null,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            user.fullName,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 15,
                                              color: Color(0xFF1A1A1A),
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            user.email,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade600,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    _roleBadge(user.role),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'ID: ${user.id}  •  ${user.phone ?? 'Phone N/A'}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    // View Detail Button
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: () async {
                                          await Get.toNamed(
                                            '/userdetail',
                                            arguments: user.id,
                                          );
                                          _loadBlockedUsers();
                                        },
                                        icon: const Icon(
                                          Icons.visibility_outlined,
                                          size: 16,
                                        ),
                                        label: const Text('Detail'),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: darkGreen,
                                          side: const BorderSide(
                                            color: primaryGreen,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 10,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    // Unblock Button
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: isProcessing
                                            ? null
                                            : () => _unblockUser(user),
                                        icon: isProcessing
                                            ? const SizedBox(
                                                height: 16,
                                                width: 16,
                                                child:
                                                    CircularProgressIndicator(
                                                      color: Colors.white,
                                                      strokeWidth: 2,
                                                    ),
                                              )
                                            : const Icon(
                                                Icons.lock_open,
                                                size: 16,
                                              ),
                                        label: Text(
                                          isProcessing ? 'Wait...' : 'Unblock',
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: accentOrange,
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 10,
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
                      },
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
