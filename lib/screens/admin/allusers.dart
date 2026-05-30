import 'package:flutter/material.dart';
import 'package:frontfile_servease/models/all_user_model.dart';
import 'package:frontfile_servease/screens/admin/userdetail.dart';
import 'package:frontfile_servease/services/all_users_service.dart';
import 'package:get/get.dart';

class AllUsers extends StatefulWidget {
  const AllUsers({super.key});

  @override
  State<AllUsers> createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  // ── Theme Colors ───────────────────────────────────────────
  static const Color primaryGreen = Color(0xFF1B8B4B);
  static const Color darkGreen = Color(0xFF145E33);
  static const Color accentOrange = Color(0xFFE8671A);
  static const Color lightOrange = Color(0xFFFFF3EC);
  static const Color bgColor = Color(0xFFF5F7F5);

  List<UserModel> _users = [];
  bool _isLoading = true;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });
    try {
      final users = await UserService.getAllUsers();
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMsg = e.toString();
        _isLoading = false;
      });
    }
  }

  // ── Add User Bottom Sheet ──────────────────────────────────
  void _showAddUserSheet() {
    final _nameCtrl = TextEditingController();
    final _emailCtrl = TextEditingController();
    final _passCtrl = TextEditingController();
    final _phoneCtrl = TextEditingController();
    final _cnicCtrl = TextEditingController();
    final _addressCtrl = TextEditingController();
    String _selectedRole = 'customer';
    final _formKey = GlobalKey<FormState>();
    bool _submitting = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheet) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 24,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: primaryGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.person_add,
                              color: primaryGreen,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'add new user',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: darkGreen,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Role Selector
                      const Text(
                        'Role',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: ['customer', 'provider'].map((role) {
                          final selected = _selectedRole == role;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => setSheet(() => _selectedRole = role),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: EdgeInsets.only(
                                  right: role == 'customer' ? 8 : 0,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? primaryGreen
                                      : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: selected
                                        ? primaryGreen
                                        : Colors.grey.shade300,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    role == 'customer'
                                        ? '🛒 Customer'
                                        : '🔧 Provider',
                                    style: TextStyle(
                                      color: selected
                                          ? Colors.white
                                          : Colors.grey.shade700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),

                      _buildField(
                        _nameCtrl,
                        'Poora Naam *',
                        Icons.person_outline,
                      ),
                      _buildField(
                        _emailCtrl,
                        'Email *',
                        Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      _buildField(
                        _passCtrl,
                        'Password *',
                        Icons.lock_outline,
                        obscure: true,
                      ),
                      _buildField(
                        _phoneCtrl,
                        'Phone',
                        Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        required: false,
                      ),
                      _buildField(
                        _cnicCtrl,
                        'CNIC',
                        Icons.credit_card_outlined,
                        required: false,
                      ),
                      _buildField(
                        _addressCtrl,
                        'Address',
                        Icons.location_on_outlined,
                        required: false,
                      ),

                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submitting
                              ? null
                              : () async {
                                  if (!_formKey.currentState!.validate())
                                    return;
                                  setSheet(() => _submitting = true);
                                  try {
                                    await UserService.addUser(
                                      fullName: _nameCtrl.text.trim(),
                                      email: _emailCtrl.text.trim(),
                                      password: _passCtrl.text,
                                      role: _selectedRole,
                                      phone: _phoneCtrl.text.isEmpty
                                          ? null
                                          : _phoneCtrl.text.trim(),
                                      cnic: _cnicCtrl.text.isEmpty
                                          ? null
                                          : _cnicCtrl.text.trim(),
                                      address: _addressCtrl.text.isEmpty
                                          ? null
                                          : _addressCtrl.text.trim(),
                                    );
                                    Get.back();
                                    _loadUsers();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: const Text(
                                          'User successfully add ho gaya!',
                                        ),
                                        backgroundColor: primaryGreen,
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  } catch (e) {
                                    setSheet(() => _submitting = false);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Error: ${e.toString()}'),
                                        backgroundColor: Colors.red.shade600,
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: accentOrange,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: _submitting
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'User Add Karein',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildField(
    TextEditingController ctrl,
    String label,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
    bool required = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        keyboardType: keyboardType,
        obscureText: obscure,
        validator: required
            ? (v) =>
                  (v == null || v.trim().isEmpty) ? '$label zaroori hai' : null
            : null,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: primaryGreen, size: 20),
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: primaryGreen, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          labelStyle: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
      ),
    );
  }

  // ── Role Badge ─────────────────────────────────────────────
  Widget _roleBadge(String role) {
    Color bg;
    Color fg;
    String label;
    IconData icon;
    switch (role) {
      case 'admin':
        bg = const Color(0xFFE8F5E9);
        fg = const Color(0xFF2E7D32);
        label = 'Admin';
        icon = Icons.admin_panel_settings;
        break;
      case 'provider':
        bg = const Color(0xFFFFF3E0);
        fg = const Color(0xFFE65100);
        label = 'Provider';
        icon = Icons.build_circle_outlined;
        break;
      default:
        bg = const Color(0xFFE3F2FD);
        fg = const Color(0xFF1565C0);
        label = 'Customer';
        icon = Icons.shopping_bag_outlined;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: fg),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: fg,
            ),
          ),
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
        leading: Get.routing.previous.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                onPressed: () => Get.offAllNamed('/admindrawer'),
              )
            : null,
        title: const Text(
          'All Users',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        actions: [
          // Block/Unblock Page
          IconButton(
            tooltip: 'Blocked Users',
            icon: const Icon(Icons.block, color: Colors.white),
            onPressed: () async {
              await Get.toNamed('/blockorunblock');
              _loadUsers();
            },
          ),
          // Add User
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              tooltip: 'Add new user',
              icon: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: accentOrange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 20),
              ),
              onPressed: _showAddUserSheet,
            ),
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
                    onPressed: _loadUsers,
                    icon: const Icon(Icons.refresh),
                    label: const Text('again'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryGreen,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          : _users.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.group_off, size: 70, color: Colors.grey.shade300),
                  const SizedBox(height: 12),
                  Text(
                    'Koi user nahi mila',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 16),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              color: primaryGreen,
              onRefresh: _loadUsers,
              child: ListView.builder(
                padding: const EdgeInsets.all(14),
                itemCount: _users.length,
                itemBuilder: (ctx, i) {
                  final user = _users[i];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
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
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      leading: CircleAvatar(
                        radius: 26,
                        backgroundColor: primaryGreen.withOpacity(0.12),
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
                                    ? user.fullName[0].toUpperCase()
                                    : '?',
                                style: const TextStyle(
                                  color: primaryGreen,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
                              )
                            : null,
                      ),
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              user.fullName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                                color: Color(0xFF1A1A1A),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 6),
                          _roleBadge(user.role),
                        ],
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ID: ${user.id}  •  ${user.email}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (user.isBlocked)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '🚫 Blocked',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.red.shade700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      trailing: ElevatedButton(
                        onPressed: () async {
                          await Get.toNamed('/userdetail', arguments: user.id);
                          _loadUsers();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: accentOrange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                          minimumSize: const Size(0, 0),
                        ),
                        child: const Text(
                          'Detail',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
