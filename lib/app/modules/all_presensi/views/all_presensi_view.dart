import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presence/app/routes/app_pages.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../controllers/all_presensi_controller.dart';

class AllPresensiView extends GetView<AllPresensiController> {
  const AllPresensiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'All Attendance',
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
      ),
      body: Column(
        children: [
          // Search Bar Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.blue, Colors.blueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: Column(
              children: [
                // Search TextField
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search attendance records...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: Icon(Icons.search, color: Colors.blue[400]),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                    onChanged: (value) {
                      controller.setSearchQuery(value);
                    },
                  ),
                ),

                const SizedBox(height: 12),

                // Date Filter Section
                Row(
                  children: [
                    Expanded(
                      child: Obx(
                        () => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.date_range,
                                color: Colors.blue[400],
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  controller.dateFilterText.value,
                                  style: TextStyle(
                                    color:
                                        controller.dateFilterText.value ==
                                            'All Dates'
                                        ? Colors.grey[500]
                                        : Colors.black87,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Filter Button
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            _showDateFilterDialog();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            child: Icon(
                              Icons.filter_list,
                              color: Colors.blue[400],
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Clear Filter Button
                    Obx(
                      () => controller.dateFilterText.value != 'All Dates'
                          ? Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  onTap: () {
                                    controller.clearDateFilter();
                                    Get.snackbar(
                                      'Filter Cleared',
                                      'Date filter has been removed',
                                      backgroundColor: Colors.green.withOpacity(
                                        0.8,
                                      ),
                                      colorText: Colors.white,
                                      icon: const Icon(
                                        Icons.check_circle,
                                        color: Colors.white,
                                      ),
                                      duration: const Duration(seconds: 2),
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    child: Icon(
                                      Icons.clear,
                                      color: Colors.red[400],
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Statistics Section
          _buildStatisticsSection(),

          // Attendance List
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildAttendanceList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticsSection() {
    return Obx(() {
      // This will trigger rebuild when date filter changes
      final _ = controller.startDate.value;

      return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: controller.streamAllPresence(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Center(child: CircularProgressIndicator()),
            );
          }

          int totalDays = 0;
          int presentDays = 0;
          int outsideAreaDays = 0;

          if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
            final docs = snapshot.data!.docs;

            // Apply date filter to statistics as well
            final filteredDocs = docs.where((doc) {
              final data = doc.data();
              final dynamic dateField = data['date'];
              DateTime dateTime;

              if (dateField is Timestamp) {
                dateTime = dateField.toDate();
              } else if (dateField is String) {
                dateTime = DateTime.tryParse(dateField) ?? DateTime.now();
              } else {
                dateTime = DateTime.now();
              }

              return controller.isDateInRange(dateTime);
            }).toList();

            totalDays = filteredDocs.length;

            for (var doc in filteredDocs) {
              final data = doc.data();
              final masukData = data['masuk'];
              final keluarData = data['keluar'];

              // Count as present if both check-in and check-out exist
              if (masukData != null && keluarData != null) {
                presentDays++;
              }

              // Count outside area days
              if ((masukData?['status'] == 'Di Luar Area Kantor') ||
                  (keluarData?['status'] == 'Di Luar Area Kantor')) {
                outsideAreaDays++;
              }
            }
          }

          return Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Total Days',
                  '$totalDays',
                  Icons.calendar_today,
                  const Color(0xFF2196F3),
                ),
                Container(width: 1, height: 40, color: Colors.grey[300]),
                _buildStatItem(
                  'Present',
                  '$presentDays',
                  Icons.check_circle,
                  const Color(0xFF4CAF50),
                ),
                Container(width: 1, height: 40, color: Colors.grey[300]),
                _buildStatItem(
                  'Outside Area',
                  '$outsideAreaDays',
                  Icons.location_off,
                  Colors.orange,
                ),
              ],
            ),
          );
        },
      );
    });
  }

  Widget _buildAttendanceList() {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: controller.streamAllPresence(),
      builder: (context, snapPresensi) {
        if (snapPresensi.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapPresensi.data?.docs.isEmpty == true ||
            snapPresensi.data == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  'Belum ada data presensi',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return Obx(() {
          final docs = snapPresensi.data!.docs;
          final searchQuery = controller.searchQuery.value.toLowerCase();

          // Filter data based on search query
          final filteredDocs = docs
              .where((doc) {
                if (searchQuery.isEmpty) return true;

                final data = doc.data();
                final dynamic dateField = data['date'];
                DateTime dateTime;

                if (dateField is Timestamp) {
                  dateTime = dateField.toDate();
                } else if (dateField is String) {
                  dateTime = DateTime.tryParse(dateField) ?? DateTime.now();
                } else {
                  dateTime = DateTime.now();
                }

                final formattedDate = DateFormat(
                  'EEE, MMM dd, yyyy',
                ).format(dateTime);
                return formattedDate.toLowerCase().contains(searchQuery);
              })
              .where((doc) {
                // Add date range filter
                final data = doc.data();
                final dynamic dateField = data['date'];
                DateTime dateTime;

                if (dateField is Timestamp) {
                  dateTime = dateField.toDate();
                } else if (dateField is String) {
                  dateTime = DateTime.tryParse(dateField) ?? DateTime.now();
                } else {
                  dateTime = DateTime.now();
                }

                return controller.isDateInRange(dateTime);
              })
              .toList();

          return ListView.builder(
            itemCount: filteredDocs.length,
            itemBuilder: (context, index) {
              final data = filteredDocs[index].data();
              final docId = filteredDocs[index].id;

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
                'EEE, MMM dd, yyyy',
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
                  checkOutTime = DateFormat(
                    'HH:mm:ss a',
                  ).format(keluarDateTime);
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

              final bool isIncomplete =
                  checkInTime == 'N/A' || checkOutTime == 'N/A';
              final String attendanceStatus = isIncomplete
                  ? 'Incomplete'
                  : 'Present';

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
                      // Pass the real document data to detail page
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
                            // Date and status row
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
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        margin: const EdgeInsets.only(right: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.orange.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
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
                                        color: isIncomplete
                                            ? Colors.orange.withOpacity(0.1)
                                            : Colors.green.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        attendanceStatus,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: isIncomplete
                                              ? Colors.orange
                                              : Colors.green,
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
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
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
                                            'Check In',
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
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
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
                                            'Check Out',
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

                            const SizedBox(height: 12),

                            // Total hours
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 16,
                                  color: Colors.blue[400],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Total: $totalHours',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue[600],
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
        });
      },
    );
  }

  void _showDateFilterDialog() {
    DateTime? tempStartDate = controller.startDate.value;
    DateTime? tempEndDate = controller.endDate.value;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: Get.width * 0.95,
          height: Get.height * 0.7,
          constraints: const BoxConstraints(maxWidth: 400, maxHeight: 600),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Filter by Date',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2196F3),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                    color: Colors.grey[600],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Helper text
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Color(0xFF2196F3),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Pilih rentang tanggal untuk memfilter data presensi. tanggal awal dan akhir harus dipilih.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Date Picker
              Expanded(
                child: SfDateRangePicker(
                  onSelectionChanged:
                      (DateRangePickerSelectionChangedArgs args) {
                        if (args.value is PickerDateRange) {
                          final PickerDateRange range = args.value;
                          tempStartDate = range.startDate;
                          tempEndDate = range.endDate;
                        }
                      },
                  selectionMode: DateRangePickerSelectionMode.range,
                  initialSelectedRange:
                      controller.startDate.value != null &&
                          controller.endDate.value != null
                      ? PickerDateRange(
                          controller.startDate.value,
                          controller.endDate.value,
                        )
                      : null,
                  showActionButtons: false,
                  enablePastDates: true,
                  allowViewNavigation: true,
                  navigationDirection:
                      DateRangePickerNavigationDirection.horizontal,
                  headerStyle: const DateRangePickerHeaderStyle(
                    textAlign: TextAlign.center,
                    textStyle: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2196F3),
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                  monthViewSettings: DateRangePickerMonthViewSettings(
                    firstDayOfWeek: 1, // Monday as first day
                    dayFormat: 'EEE',
                    viewHeaderStyle: const DateRangePickerViewHeaderStyle(
                      textStyle: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    weekendDays: const [6, 7], // Saturday and Sunday
                    specialDates: [DateTime.now()], // Highlight today
                  ),
                  yearCellStyle: const DateRangePickerYearCellStyle(
                    textStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  monthCellStyle: const DateRangePickerMonthCellStyle(
                    textStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  selectionColor: const Color(0xFF2196F3),
                  startRangeSelectionColor: const Color(0xFF2196F3),
                  endRangeSelectionColor: const Color(0xFF2196F3),
                  rangeSelectionColor: const Color(0xFF2196F3).withOpacity(0.2),
                  todayHighlightColor: const Color(0xFF2196F3),
                  selectionTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  rangeTextStyle: const TextStyle(
                    color: Color(0xFF2196F3),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Only clear filter if there's actually a filter applied
                        if (controller.startDate.value != null ||
                            controller.endDate.value != null) {
                          controller.clearDateFilter();
                          Get.back();
                          Get.snackbar(
                            'Filter Cleared',
                            'Date filter has been removed',
                            backgroundColor: Colors.green.withOpacity(0.8),
                            colorText: Colors.white,
                            icon: const Icon(
                              Icons.check_circle,
                              color: Colors.white,
                            ),
                            duration: const Duration(seconds: 2),
                          );
                        } else {
                          Get.back();
                          Get.snackbar(
                            'No Filter',
                            'No date filter is currently applied',
                            backgroundColor: Colors.orange.withOpacity(0.8),
                            colorText: Colors.white,
                            icon: const Icon(Icons.info, color: Colors.white),
                            duration: const Duration(seconds: 2),
                          );
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF2196F3)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Clear Filter',
                        style: TextStyle(
                          color: Color(0xFF2196F3),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Validation: Check if both start and end dates are selected
                        if (tempStartDate == null || tempEndDate == null) {
                          Get.snackbar(
                            'Invalid Selection',
                            'Tolong pilih tanggal awal dan akhir untuk memilih rentang tanggal',
                            backgroundColor: Colors.red.withOpacity(0.8),
                            colorText: Colors.white,
                            icon: const Icon(Icons.error, color: Colors.white),
                            duration: const Duration(seconds: 3),
                          );
                          return;
                        }

                        // Validation: Check if start date is not after end date
                        if (tempStartDate!.isAfter(tempEndDate!)) {
                          Get.snackbar(
                            'Invalid Date Range',
                            'Tanggal awal tidak boleh setelah tanggal akhir',
                            backgroundColor: Colors.red.withOpacity(0.8),
                            colorText: Colors.white,
                            icon: const Icon(Icons.error, color: Colors.white),
                            duration: const Duration(seconds: 3),
                          );
                          return;
                        }

                        // Apply the filter if validation passes
                        controller.setDateFilter(tempStartDate, tempEndDate);
                        Get.back();
                        Get.snackbar(
                          'Filter Applied',
                          'Filter rentang tanggal telah diterapkan',
                          backgroundColor: Colors.green.withOpacity(0.8),
                          colorText: Colors.white,
                          icon: const Icon(
                            Icons.check_circle,
                            color: Colors.white,
                          ),
                          duration: const Duration(seconds: 2),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Apply Filter',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}
