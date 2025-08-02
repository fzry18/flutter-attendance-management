import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:presence/app/controllers/index_page_controller.dart';

import 'package:get/get.dart';
import 'package:presence/app/routes/app_pages.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    final indexPageController = Get.find<IndexPageController>();

    // Set current page index to 2 (Profile)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      indexPageController.pageIndex.value = 2;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: controller.streamUser(),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (asyncSnapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text('Error fetching user data'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Get.back(),
                    child: Text('Go Back'),
                  ),
                ],
              ),
            );
          }

          if (!asyncSnapshot.hasData || asyncSnapshot.data!.data() == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_off, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('User not found'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Get.back(),
                    child: Text('Go Back'),
                  ),
                ],
              ),
            );
          }

          final userData = asyncSnapshot.data!.data()!;
          final name = userData['name'] ?? 'Unknown User';
          final email = userData['email'] ?? 'No Email';
          final role = userData['role'] ?? 'user';
          final nip = userData['nip'] ?? 'N/A';
          final uid = userData['uid'] ?? asyncSnapshot.data!.id;

          return SingleChildScrollView(
            child: Column(
              children: [
                // Profile Header with gradient background
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.blueAccent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 30),
                      // Profile Avatar
                      Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: CircleAvatar(
                          radius: 45,
                          backgroundImage: NetworkImage(
                            "https://ui-avatars.com/api/?name=${name}&background=0D8ABC&color=fff&size=90",
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      // User Name
                      Text(
                        name.toUpperCase(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      // User Email
                      Text(
                        email,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      // Role Badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          role.toUpperCase(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),

                // Profile Options
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      // Update Profile Card
                      _buildProfileOption(
                        icon: Icons.person_outline,
                        title: 'Update Profile',
                        subtitle: 'Edit your personal information',
                        onTap: () {
                          Get.toNamed(
                            Routes.UPDATE_PROFILE,
                            arguments: {
                              'uid': uid,
                              'nip': nip,
                              'name': name,
                              'email': email,
                            },
                          );
                        },
                      ),

                      SizedBox(height: 12),

                      // Update Password Card
                      _buildProfileOption(
                        icon: Icons.lock_outline,
                        title: 'Update Password',
                        subtitle: 'Change your account password',
                        onTap: () {
                          Get.toNamed(Routes.UPDATE_PASSWORD);
                        },
                      ),

                      SizedBox(height: 12),
                      // Logout Card
                      _buildProfileOption(
                        icon: Icons.logout,
                        title: 'Logout',
                        subtitle: 'Sign out from your account',
                        onTap: () {
                          _showLogoutDialog();
                        },
                        isDestructive: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar:
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: controller.streamUser(),
            builder: (context, asyncSnapshot) {
              if (asyncSnapshot.connectionState == ConnectionState.waiting ||
                  asyncSnapshot.hasError ||
                  !asyncSnapshot.hasData ||
                  asyncSnapshot.data?.data() == null) {
                return const SizedBox.shrink();
              }

              final userData = asyncSnapshot.data!.data()!;
              final role = userData['role'] as String?;

              // Only show bottom bar for non-admin users
              if (role != 'admin') {
                return Obx(
                  () => ConvexAppBar(
                    backgroundColor: const Color(0xFF2196F3),
                    activeColor: Colors.white,
                    color: Colors.white70,
                    style: TabStyle.fixedCircle,
                    height: 60,
                    top: -25,
                    curveSize: 80,
                    items: const [
                      TabItem(icon: Icons.home_rounded, title: 'Home'),
                      TabItem(
                        icon: Icons.fingerprint_rounded,
                        title: 'Absensi',
                      ),
                      TabItem(icon: Icons.person_rounded, title: 'Profile'),
                    ],
                    initialActiveIndex: indexPageController.pageIndex.value,
                    onTap: (int index) {
                      indexPageController.changePage(index);
                    },
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDestructive
                      ? Colors.red.withOpacity(0.1)
                      : Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: isDestructive ? Colors.red : Colors.blue,
                  size: 24,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDestructive ? Colors.red : Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    Get.defaultDialog(
      title: 'Logout',
      middleText: 'Are you sure you want to logout?',
      textCancel: 'Cancel',
      textConfirm: 'Logout',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        Get.back();
        controller.logout();
      },
    );
  }
}
