import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontfile_servease/core/theme/app_theme.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontfile_servease/screens/admin/admindrawer.dart';
import 'package:frontfile_servease/screens/admin/admin_navbar.dart';
import 'package:frontfile_servease/models/adminprofilemodel.dart';
import 'package:frontfile_servease/services/adminprofileservice.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({super.key});

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  final AdminProfileService service = AdminProfileService();
  AdminProfileModel? profile;
  bool isLoading = true;
  XFile? selectedImage;
  Uint8List? webImage;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    final result = await service.getProfile(1);
    if (result != null) {
      setState(() {
        profile = result;
        nameController.text = result.fullName;
        emailController.text = result.email;
        phoneController.text = result.phone;
        isLoading = false;
      });
    }
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        selectedImage = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      drawer: const AdminDrawer(),
      bottomNavigationBar: const AdminBottomNavBar(),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.success),
            )
          : CustomScrollView(
              slivers: [
                // ─── Attractive SliverAppBar ───
                SliverAppBar(
                  expandedHeight: 220,
                  pinned: true,
                  backgroundColor: AppColors.success,
                  title: const Text(
                    "Admin Profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: [
                        // Decorative circles
                        Positioned(
                          top: -30,
                          right: -30,
                          child: Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.08),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -20,
                          left: -20,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.06),
                            ),
                          ),
                        ),
                        // Avatar centered
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 3,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 52,
                                    backgroundColor: AppColors.softPink,
                                    child: selectedImage != null
                                        ? ClipOval(
                                            child: kIsWeb
                                                ? Image.network(
                                                    selectedImage!.path,
                                                    width: 104,
                                                    height: 104,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.file(
                                                    File(selectedImage!.path),
                                                    width: 104,
                                                    height: 104,
                                                    fit: BoxFit.cover,
                                                  ),
                                          )
                                        : profile?.profileImage != null
                                        ? ClipOval(
                                            child: Image.network(
                                              profile!.profileImage!,
                                              width: 104,
                                              height: 104,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : const Icon(
                                            Icons.person,
                                            size: 52,
                                            color: Colors.white,
                                          ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 2,
                                  right: 2,
                                  child: GestureDetector(
                                    onTap: pickImage,
                                    child: Container(
                                      padding: const EdgeInsets.all(7),
                                      decoration: BoxDecoration(
                                        color: AppColors.softPink,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                        size: 16,
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

                // ─── Body Content ───
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name & role hint
                        Center(
                          child: Column(
                            children: [
                              Text(
                                nameController.text.isNotEmpty
                                    ? nameController.text
                                    : "Admin",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff1A1A2E),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xff00C853,
                                  ).withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  "Super Administrator",
                                  style: TextStyle(
                                    color: Color(0xff00C853),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),
                        _sectionLabel("Personal Info"),
                        const SizedBox(height: 12),

                        _buildField(
                          controller: nameController,
                          label: "Full Name",
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 14),
                        _buildField(
                          controller: emailController,
                          label: "Email",
                          icon: Icons.email_outlined,
                        ),
                        const SizedBox(height: 14),
                        _buildField(
                          controller: phoneController,
                          label: "Phone",
                          icon: Icons.phone_outlined,
                        ),

                        const SizedBox(height: 24),
                        _saveButton(),

                        const SizedBox(height: 32),
                        _dividerWithLabel("Reset Password"),
                        const SizedBox(height: 16),

                        _buildField(
                          controller: oldPasswordController,
                          label: "Old Password",
                          icon: Icons.lock_outline,
                          isPassword: true,
                        ),
                        const SizedBox(height: 14),
                        _buildField(
                          controller: newPasswordController,
                          label: "New Password",
                          icon: Icons.lock_reset_outlined,
                          isPassword: true,
                        ),

                        const SizedBox(height: 24),
                        _resetButton(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _sectionLabel(String text) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: AppColors.success,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: Color(0xff1A1A2E),
          ),
        ),
      ],
    );
  }

  Widget _dividerWithLabel(String text) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xffE0E0E0))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xff1A1A2E),
            ),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xffE0E0E0))),
      ],
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: const TextStyle(fontSize: 15, color: AppColors.textDark),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.transparent,
          prefixIcon: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.successBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.success, size: 20),
          ),
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 16,
          ),
        ),
      ),
    );
  }

  Widget _saveButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.softPink,
          elevation: 4,
          shadowColor: AppColors.softPink.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: () async {
          bool updateSuccess = await service.updateProfile(
            id: 1,
            fullName: nameController.text,
            email: emailController.text,
            phone: phoneController.text,
            image: selectedImage,
          );
          if (updateSuccess) fetchProfile();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                updateSuccess ? "✅ Profile Updated" : "❌ Update Failed",
              ),
              backgroundColor: updateSuccess
                  ? const Color(0xff00C853)
                  : Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.save_rounded, color: Colors.white, size: 20),
            SizedBox(width: 10),
            Text(
              "Save Changes",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _resetButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.success,
          elevation: 4,
          shadowColor: AppColors.success.withValues(alpha: 0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: () async {
          bool passwordSuccess = await service.resetPassword(
            id: 1,
            oldPassword: oldPasswordController.text,
            newPassword: newPasswordController.text,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                passwordSuccess ? "✅ Password Updated" : "❌ Wrong Old Password",
              ),
              backgroundColor: passwordSuccess
                  ? const Color(0xff00C853)
                  : Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_reset, color: Colors.white, size: 20),
            SizedBox(width: 10),
            Text(
              "Reset Password",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
