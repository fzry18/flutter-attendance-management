import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence/app/routes/app_pages.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:intl/intl.dart';
import 'package:presence/app/controllers/index_page_controller.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final indexPageController = Get.find<IndexPageController>();

    // Set current page index to 0 (Home)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      indexPageController.pageIndex.value = 0;
    });

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.blueAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // Profile and Admin panel icons for admin only
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: controller.streamRole(),
            builder: (context, asyncSnapshot) {
              if (asyncSnapshot.connectionState == ConnectionState.waiting ||
                  asyncSnapshot.hasError ||
                  !asyncSnapshot.hasData ||
                  asyncSnapshot.data?.data() == null) {
                return const SizedBox.shrink();
              }

              final userData = asyncSnapshot.data!.data()!;
              final role = userData['role'] as String?;

              if (role == 'admin') {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.person),
                      tooltip: 'Profile',
                      onPressed: () {
                        Get.toNamed(Routes.PROFILE);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.admin_panel_settings),
                      tooltip: 'Admin Panel',
                      onPressed: () {
                        _showAdminMenu(context);
                      },
                    ),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: controller.streamRole(),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (asyncSnapshot.hasError ||
              !asyncSnapshot.hasData ||
              asyncSnapshot.data?.data() == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text('Error loading user data'),
                ],
              ),
            );
          }

          final userData = asyncSnapshot.data!.data()!;
          final role = userData['role'] as String?;
          final name = userData['name'] as String?;
          final nip = userData['nip'] as String?;
          final jobTitle = userData['jobTitle'] as String?;

          // Show admin view
          if (role == 'admin') {
            return _buildAdminView(role, name, nip);
          }

          // Show employee view with convex bottom bar
          return _buildEmployeeView(jobTitle, name, nip);
        },
      ),
      bottomNavigationBar:
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: controller.streamRole(),
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

  Widget _buildAdminView(String? role, String? name, String? nip) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.blue, Colors.blueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome back!',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(
                  name ?? 'Admin',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    (role ?? 'admin').toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Quick Actions
          const Text(
            'Quick Actions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Admin Actions
          _buildActionCard(
            icon: Icons.person_add,
            title: 'Add Employee',
            subtitle: 'Add new employee to the system',
            color: Colors.blue,
            onTap: () {
              Get.toNamed(Routes.ADD_PEGAWAI);
            },
          ),
          const SizedBox(height: 12),
          _buildActionCard(
            icon: Icons.people,
            title: 'Manage Employees',
            subtitle: 'View and manage all employees',
            color: Colors.blue,
            onTap: () {
              Get.snackbar('Info', 'Employee management will be implemented');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeView(String? jobTitle, String? name, String? nip) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main ID Card with gradient background
          Card(
            elevation: 8,
            shadowColor: Colors.blue.withOpacity(0.3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFE3F2FD), // Light blue
                    Color(0xFF2196F3), // Blue
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.6, 1.0],
                ),
              ),
              child: Column(
                children: [
                  // Name label at top
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      (name ?? 'Unknown User').toUpperCase(),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Job Title - Main focus
                  Text(
                    jobTitle ?? 'Mobile Developer',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // NIP
                  Text(
                    nip ?? '6563123',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Attendance Status Section - Real data from Firestore
                  _buildTodayAttendanceStatus(),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Last 5 days section with improved styling
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Last 5 days',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Get.toNamed(Routes.ALL_PRESENSI);
                    },
                    child: const Text(
                      'See more',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Attendance History List
          _buildAttendanceHistory(),
        ],
      ),
    );
  }

  Widget _buildAttendanceHistory() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: controller.streamLastPresence(),
      builder: (context, snapPresensi) {
        if (snapPresensi.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapPresensi.data?.docs.isEmpty == true ||
            snapPresensi.data == null) {
          return Container(
            height: 250,
            child: Center(child: Text('Belum ada data presensi')),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: snapPresensi.data!.docs.length,
          itemBuilder: (context, index) {
            final data = snapPresensi.data!.docs[index].data();
            final docId = snapPresensi.data!.docs[index].id;

            // Parse date from Firestore
            final dynamic dateField = data['date'];
            DateTime dateTime;

            if (dateField is Timestamp) {
              dateTime = dateField.toDate();
            } else if (dateField is String) {
              dateTime = DateTime.tryParse(dateField) ?? DateTime.now();
            } else {
              dateTime = DateTime.now();
            }

            final String formattedDate = DateFormat(
              'EEE, MMM dd',
            ).format(dateTime);

            // Get masuk and keluar data
            final Map<String, dynamic>? masukData = data['masuk'];
            final Map<String, dynamic>? keluarData = data['keluar'];

            // Parse check-in time
            String checkInTime = 'N/A';
            if (masukData != null && masukData['date'] != null) {
              final dynamic masukDate = masukData['date'];
              if (masukDate is Timestamp) {
                final DateTime masukDateTime = masukDate.toDate();
                checkInTime = DateFormat('HH:mm:ss a').format(masukDateTime);
              } else if (masukDate is String) {
                final DateTime? parsed = DateTime.tryParse(masukDate);
                if (parsed != null) {
                  checkInTime = DateFormat('HH:mm:ss a').format(parsed);
                }
              }
            }

            // Parse check-out time
            String checkOutTime = 'N/A';
            if (keluarData != null && keluarData['date'] != null) {
              final dynamic keluarDate = keluarData['date'];
              if (keluarDate is Timestamp) {
                final DateTime keluarDateTime = keluarDate.toDate();
                checkOutTime = DateFormat('HH:mm:ss a').format(keluarDateTime);
              } else if (keluarDate is String) {
                final DateTime? parsed = DateTime.tryParse(keluarDate);
                if (parsed != null) {
                  checkOutTime = DateFormat('HH:mm:ss a').format(parsed);
                }
              }
            }

            // Calculate total hours
            String totalHours = 'N/A';
            if (masukData != null &&
                keluarData != null &&
                masukData['date'] != null &&
                keluarData['date'] != null) {
              DateTime? masukDateTime;
              DateTime? keluarDateTime;

              // Parse masuk date
              final dynamic masukDate = masukData['date'];
              if (masukDate is Timestamp) {
                masukDateTime = masukDate.toDate();
              } else if (masukDate is String) {
                masukDateTime = DateTime.tryParse(masukDate);
              }

              // Parse keluar date
              final dynamic keluarDate = keluarData['date'];
              if (keluarDate is Timestamp) {
                keluarDateTime = keluarDate.toDate();
              } else if (keluarDate is String) {
                keluarDateTime = DateTime.tryParse(keluarDate);
              }

              if (masukDateTime != null && keluarDateTime != null) {
                final Duration difference = keluarDateTime.difference(
                  masukDateTime,
                );
                final int hours = difference.inHours;
                final int minutes = difference.inMinutes % 60;
                totalHours = '${hours}h ${minutes}m';
              }
            }

            // Check location status
            final String masukStatus = masukData?['status'] ?? 'N/A';
            final String keluarStatus = keluarData?['status'] ?? 'N/A';
            final bool isOutsideArea =
                masukStatus == 'Di Luar Area Kantor' ||
                keluarStatus == 'Di Luar Area Kantor';

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Card(
                elevation: 3,
                shadowColor: Colors.grey.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    // Pass the document data to detail page
                    Get.toNamed(
                      Routes.DETAIL_PRESENSI,
                      arguments: {
                        'docId': docId,
                        'date': dateTime,
                        'masuk': masukData,
                        'keluar': keluarData,
                        'checkIn': checkInTime,
                        'checkOut': checkOutTime,
                        'totalHours': totalHours,
                      },
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Date and total hours row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                formattedDate,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Row(
                                children: [
                                  if (isOutsideArea)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      margin: const EdgeInsets.only(right: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text(
                                        'Outside',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.orange,
                                        ),
                                      ),
                                    ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      totalHours,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Check-in and Check-out times
                          Row(
                            children: [
                              // Check-in
                              Expanded(
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: masukData != null
                                            ? Colors.green.withOpacity(0.1)
                                            : Colors.grey.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.login,
                                        color: masukData != null
                                            ? Colors.green
                                            : Colors.grey,
                                        size: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Masuk',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          checkInTime,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Divider
                              Container(
                                width: 1,
                                height: 40,
                                color: Colors.grey[300],
                              ),

                              // Check-out
                              Expanded(
                                child: Row(
                                  children: [
                                    const SizedBox(width: 12),
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: keluarData != null
                                            ? Colors.orange.withOpacity(0.1)
                                            : Colors.grey.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.logout,
                                        color: keluarData != null
                                            ? Colors.orange
                                            : Colors.grey,
                                        size: 16,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Keluar',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          checkOutTime,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showAdminMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Admin Panel',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ListTile(
                leading: Icon(Icons.person_add, color: Colors.green),
                title: Text('Add Employee'),
                subtitle: Text('Add new employee to the system'),
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.ADD_PEGAWAI);
                },
              ),
              ListTile(
                leading: Icon(Icons.people, color: Colors.blue),
                title: Text('Manage Employees'),
                subtitle: Text('View and manage all employees'),
                onTap: () {
                  Get.back();
                  Get.snackbar(
                    'Info',
                    'Employee management will be implemented',
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
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
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
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

  Widget _buildTodayAttendanceStatus() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: controller.streamLastPresence(),
      builder: (context, snapshot) {
        String masukTime = '--:--:--';
        String keluarTime = '--:--:--';

        // Debug: Check if we have data
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          'Masuk',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const CircularProgressIndicator(strokeWidth: 2),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Container(width: 2, height: 65, color: Colors.white54),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          'Keluar',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const CircularProgressIndicator(strokeWidth: 2),
                  ],
                ),
              ),
            ],
          );
        }

        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          // Get today's data (first document should be the most recent)
          DateTime today = DateTime.now();
          DocumentSnapshot<Map<String, dynamic>>? todayDoc;

          // Find today's document
          for (var doc in snapshot.data!.docs) {
            final data = doc.data();
            final dynamic dateField = data['date'];
            DateTime docDate;

            if (dateField is Timestamp) {
              docDate = dateField.toDate();
            } else if (dateField is String) {
              docDate = DateTime.tryParse(dateField) ?? DateTime.now();
            } else {
              continue;
            }

            // Check if this document is from today
            if (docDate.year == today.year &&
                docDate.month == today.month &&
                docDate.day == today.day) {
              todayDoc = doc;
              break;
            }
          }

          if (todayDoc != null) {
            final todayData = todayDoc.data()!;

            // Parse masuk time
            final masukData = todayData['masuk'];
            if (masukData != null && masukData['date'] != null) {
              final dynamic masukDate = masukData['date'];
              if (masukDate is Timestamp) {
                final DateTime masukDateTime = masukDate.toDate();
                masukTime = DateFormat('HH:mm:ss a').format(masukDateTime);
              } else if (masukDate is String) {
                final DateTime? parsed = DateTime.tryParse(masukDate);
                if (parsed != null) {
                  masukTime = DateFormat('HH:mm:ss a').format(parsed);
                }
              }
            }

            // Parse keluar time
            final keluarData = todayData['keluar'];
            if (keluarData != null && keluarData['date'] != null) {
              final dynamic keluarDate = keluarData['date'];
              if (keluarDate is Timestamp) {
                final DateTime keluarDateTime = keluarDate.toDate();
                keluarTime = DateFormat('HH:mm:ss a').format(keluarDateTime);
              } else if (keluarDate is String) {
                final DateTime? parsed = DateTime.tryParse(keluarDate);
                if (parsed != null) {
                  keluarTime = DateFormat('HH:mm:ss a').format(parsed);
                }
              }
            }
          }
        }

        return Row(
          children: [
            // Masuk Section
            Expanded(
              child: Column(
                children: [
                  Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Masuk',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    masukTime,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),

            // Vertical Divider
            Container(
              width: 2,
              height: 65,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
            const SizedBox(width: 6),

            // Keluar Section
            Expanded(
              child: Column(
                children: [
                  Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'Keluar',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    keluarTime,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
