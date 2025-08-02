import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AllPresensiController extends GetxController {
  RxBool isLoading = false.obs;
  RxString searchQuery = ''.obs;
  Rx<DateTime?> startDate = Rx<DateTime?>(null);
  Rx<DateTime?> endDate = Rx<DateTime?>(null);
  RxString dateFilterText = 'All Dates'.obs;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamAllPresence() async* {
    String? uid = firebaseAuth.currentUser?.uid;

    yield* firestore
        .collection('pegawai')
        .doc(uid)
        .collection('presensi')
        .orderBy('date', descending: true)
        .snapshots();
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  void setDateFilter(DateTime? start, DateTime? end) {
    // Validation: Both dates should be provided for range filter
    if (start != null && end != null) {
      // Validation: Start date should not be after end date
      if (start.isAfter(end)) {
        return; // Don't set invalid date range
      }

      startDate.value = start;
      endDate.value = end;

      // Format dates nicely
      final String startFormatted =
          '${start.day.toString().padLeft(2, '0')}/${start.month.toString().padLeft(2, '0')}/${start.year}';
      final String endFormatted =
          '${end.day.toString().padLeft(2, '0')}/${end.month.toString().padLeft(2, '0')}/${end.year}';
      dateFilterText.value = '$startFormatted - $endFormatted';
    } else if (start != null) {
      startDate.value = start;
      endDate.value = null;
      final String startFormatted =
          '${start.day.toString().padLeft(2, '0')}/${start.month.toString().padLeft(2, '0')}/${start.year}';
      dateFilterText.value = 'From $startFormatted';
    } else if (end != null) {
      startDate.value = null;
      endDate.value = end;
      final String endFormatted =
          '${end.day.toString().padLeft(2, '0')}/${end.month.toString().padLeft(2, '0')}/${end.year}';
      dateFilterText.value = 'Until $endFormatted';
    } else {
      startDate.value = null;
      endDate.value = null;
      dateFilterText.value = 'All Dates';
    }
  }

  void clearDateFilter() {
    startDate.value = null;
    endDate.value = null;
    dateFilterText.value = 'All Dates';
  }

  bool isDateInRange(DateTime date) {
    if (startDate.value == null && endDate.value == null) {
      return true;
    }

    if (startDate.value != null && endDate.value != null) {
      return date.isAfter(startDate.value!.subtract(const Duration(days: 1))) &&
          date.isBefore(endDate.value!.add(const Duration(days: 1)));
    }

    if (startDate.value != null) {
      return date.isAfter(startDate.value!.subtract(const Duration(days: 1)));
    }

    if (endDate.value != null) {
      return date.isBefore(endDate.value!.add(const Duration(days: 1)));
    }

    return true;
  }
}
