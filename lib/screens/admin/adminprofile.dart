import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
      backgroundColor: const Color(0xffF6F7F9),

      appBar: AppBar(
        backgroundColor: const Color(0xff00C853),

        elevation: 0,

        title: const Text(
          "Admin Profile",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),

              child: Column(
                children: [
                  // PROFILE IMAGE
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.orange,

                        child: selectedImage != null
                            ? ClipOval(
                                child: kIsWeb
                                    ? Image.network(
                                        selectedImage!.path,
                                        width: 110,
                                        height: 110,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(
                                        File(selectedImage!.path),
                                        width: 110,
                                        height: 110,
                                        fit: BoxFit.cover,
                                      ),
                              )
                            : profile?.profileImage != null
                            ? ClipOval(
                                child: Image.network(
                                  profile!.profileImage!,
                                  width: 110,
                                  height: 110,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(
                                Icons.person,
                                size: 55,
                                color: Colors.white,
                              ),
                      ),

                      Positioned(
                        bottom: 0,
                        right: 0,

                        child: GestureDetector(
                          onTap: pickImage,

                          child: Container(
                            padding: const EdgeInsets.all(8),

                            decoration: const BoxDecoration(
                              color: Color(0xff00C853),
                              shape: BoxShape.circle,
                            ),

                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  _buildField(
                    controller: nameController,
                    label: "Full Name",
                    icon: Icons.person,
                  ),

                  const SizedBox(height: 15),

                  _buildField(
                    controller: emailController,
                    label: "Email",
                    icon: Icons.email,
                  ),

                  const SizedBox(height: 15),

                  _buildField(
                    controller: phoneController,
                    label: "Phone",
                    icon: Icons.phone,
                  ),

                  const SizedBox(height: 25),

                  // SAVE BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 55,

                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffFF8A00),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
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

                        if (updateSuccess) {
                          fetchProfile();
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              updateSuccess
                                  ? "Profile Updated"
                                  : "Update Failed",
                            ),
                          ),
                        );
                      },

                      child: const Text(
                        "Save Changes",

                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 35),

                  Align(
                    alignment: Alignment.centerLeft,

                    child: Text(
                      "Reset Password",

                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  _buildField(
                    controller: oldPasswordController,
                    label: "Old Password",
                    icon: Icons.lock,
                    isPassword: true,
                  ),

                  const SizedBox(height: 15),

                  _buildField(
                    controller: newPasswordController,
                    label: "New Password",
                    icon: Icons.lock_outline,
                    isPassword: true,
                  ),

                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    height: 55,

                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff00C853),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
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
                              passwordSuccess
                                  ? "Password Updated"
                                  : "Wrong Old Password",
                            ),
                          ),
                        );
                      },

                      child: const Text(
                        "Reset Password",

                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,

      obscureText: isPassword,

      decoration: InputDecoration(
        filled: true,

        fillColor: Colors.white,

        prefixIcon: Icon(icon, color: const Color(0xff00C853)),

        labelText: label,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
