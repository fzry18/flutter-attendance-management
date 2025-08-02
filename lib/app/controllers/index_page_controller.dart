import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:presence/app/routes/app_pages.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class IndexPageController extends GetxController {
  RxInt pageIndex = 0.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void changePage(int i) async {
    switch (i) {
      case 0:
        // Home page
        pageIndex.value = i;
        if (Get.currentRoute != Routes.HOME) {
          Get.offAllNamed(Routes.HOME);
        }
        break;
      case 1:
        // Absensi/Scan functionality

        Map<String, dynamic> dataRespone = await determinePosition();
        if (dataRespone['error'] != true) {
          Position position = dataRespone['position'];

          List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude,
            position.longitude,
          );
          String address =
              '${placemarks[0].name}, '
              '${placemarks[0].locality}, ${placemarks[0].subLocality}';
          await UpdatePosition(position, address);

          // cek jarak dengan kantor
          double distanceInMeters = Geolocator.distanceBetween(
            37.4219983, // Latitude kantor
            -122.084, // Longitude kantor
            position.latitude,
            position.longitude,
          );
          // presensi
          await presence(position, address, distanceInMeters);
        } else {
          Get.snackbar(
            'Error',
            dataRespone['message'],
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color(0xFFF44336),
            colorText: Colors.white,
            borderRadius: 12,
            margin: const EdgeInsets.all(16),
            icon: const Icon(Icons.error, color: Colors.white),
            duration: const Duration(seconds: 4),
          );
        }
        break;
      case 2:
        // Profile page
        pageIndex.value = i;
        if (Get.currentRoute != Routes.PROFILE) {
          Get.offAllNamed(Routes.PROFILE);
        }
        break;
    }
  }

  Future<void> presence(
    Position position,
    String address,
    double distanceInMeters,
  ) async {
    String uid = await auth.currentUser!.uid;

    CollectionReference<Map<String, dynamic>> presensiCollection =
        await firestore.collection('pegawai').doc(uid).collection('presensi');

    QuerySnapshot<Map<String, dynamic>> snapPresensi = await presensiCollection
        .get();

    DateTime now = DateTime.now();

    String todayDocID = DateFormat(
      'yyyy-MM-dd',
    ).format(now).replaceAll('/', '-');

    String status = "Di Luar Area Kantor";
    // cek jarak dengan kantor jauh atau tidak dari kantor
    if (distanceInMeters < 200) {
      // jika jarak kurang dari 200 meter dari kantor, presensi masuk dengan keterangan "Di Dalam Area Kantor"
      status = "Di Dalam Area Kantor";
    } else {
      // jika jarak lebih dari 200 meter dari kantor, presensi masuk dengan keterangan "Di Luar Area Kantor"
    }

    if (snapPresensi.docs.length == 0) {
      // belum pernah presensi & di set absen masuk

      await Get.dialog(
        AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.login,
                  color: Color(0xFF2196F3),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Presensi Masuk',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Anda akan melakukan presensi masuk pada hari ini.',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.blue.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Color(0xFF2196F3),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Pastikan lokasi Anda sudah benar',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Apakah Anda yakin ingin melanjutkan?',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Batal',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await presensiCollection.doc(todayDocID).set({
                  'date': now.toIso8601String(),
                  'masuk': {
                    "date": now.toIso8601String(),
                    "latitude": position.latitude,
                    "longitude": position.longitude,
                    "address": address,
                    "status": status,
                    "distance": distanceInMeters,
                  },
                });
                Get.back();
                Get.snackbar(
                  'Berhasil',
                  'Berhasil melakukan presensi (MASUK) pada hari ini',
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: const Color(0xFF4CAF50),
                  colorText: Colors.white,
                  borderRadius: 12,
                  margin: const EdgeInsets.all(16),
                  icon: const Icon(Icons.check_circle, color: Colors.white),
                  duration: const Duration(seconds: 3),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              child: const Text(
                'Lanjutkan',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );
    } else {
      // sudah pernah presensi -> cek apakah sudah absen masuk/keluar hari ini
      DocumentSnapshot<Map<String, dynamic>> todayDoc = await presensiCollection
          .doc(todayDocID)
          .get();

      if (todayDoc.exists == true) {
        // tinggal absen keluar atau sudah absen masuk dan keluar
        Map<String, dynamic> dataPresenceToday = todayDoc.data()!;
        if (dataPresenceToday['keluar'] != null) {
          // sudah absen masuk dan keluar hari ini
          Get.snackbar(
            'Informasi',
            'Anda sudah melakukan presensi masuk dan keluar hari ini.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color(0xFF2196F3),
            colorText: Colors.white,
            borderRadius: 12,
            margin: const EdgeInsets.all(16),
            icon: const Icon(Icons.info, color: Colors.white),
            duration: const Duration(seconds: 3),
          );
        } else {
          // sudah absen masuk hari ini, tinggal absen keluar
          await Get.dialog(
            AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.logout,
                      color: Colors.orange,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Presensi Keluar',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Anda akan melakukan presensi keluar pada hari ini.',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.orange.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.orange,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Pastikan lokasi Anda sudah benar',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.orange[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Apakah Anda yakin ingin melanjutkan?',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Batal',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await presensiCollection.doc(todayDocID).update({
                      'keluar': {
                        "date": now.toIso8601String(),
                        "latitude": position.latitude,
                        "longitude": position.longitude,
                        "address": address,
                        "status": status,
                        "distance": distanceInMeters,
                      },
                    });
                    Get.back();
                    Get.snackbar(
                      'Berhasil',
                      'Berhasil melakukan presensi (KELUAR) pada hari ini',
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.orange,
                      colorText: Colors.white,
                      borderRadius: 12,
                      margin: const EdgeInsets.all(16),
                      icon: const Icon(Icons.check_circle, color: Colors.white),
                      duration: const Duration(seconds: 3),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Lanjutkan',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          );
        }
      } else {
        // belum absen masuk hari ini
        await Get.dialog(
          AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2196F3).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.login,
                    color: Color(0xFF2196F3),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Presensi Masuk',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Anda akan melakukan presensi masuk pada hari ini.',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.blue.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color: Color(0xFF2196F3),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Pastikan lokasi Anda sudah benar',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Apakah Anda yakin ingin melanjutkan?',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Batal',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await presensiCollection.doc(todayDocID).set({
                    'date': now.toIso8601String(),
                    'masuk': {
                      "date": now.toIso8601String(),
                      "latitude": position.latitude,
                      "longitude": position.longitude,
                      "address": address,
                      "status": status,
                      "distance": distanceInMeters,
                    },
                  });
                  Get.back();
                  Get.snackbar(
                    'Berhasil',
                    'Berhasil melakukan presensi (MASUK) pada hari ini',
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: const Color(0xFF4CAF50),
                    colorText: Colors.white,
                    borderRadius: 12,
                    margin: const EdgeInsets.all(16),
                    icon: const Icon(Icons.check_circle, color: Colors.white),
                    duration: const Duration(seconds: 3),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2196F3),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'Lanjutkan',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> UpdatePosition(Position position, String address) async {
    String uid = await auth.currentUser!.uid;

    await firestore.collection('pegawai').doc(uid).update({
      "position": {
        'latitude': position.latitude,
        'longitude': position.longitude,
      },
      "address": address,
    });
  }

  Future<Map<String, dynamic>> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return {
        'message': 'Tidak dapat mengakses lokasi device ini',
        'error': true,
      };
      // return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.

        return {
          'message':
              'Akses lokasi ditolak, silakan aktifkan izin lokasi di pengaturan perangkat Anda.',
          'error': true,
        };
        // return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.

      return {
        'message':
            'Tidak dapat mengakses lokasi, silakan aktifkan izin lokasi di pengaturan perangkat Anda.',
        'error': true,
      };
      // return Future.error(
      //   'Location permissions are permanently denied, we cannot request permissions.',
      // );
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition();
    return {
      'position': position,
      'message': 'Berhasil mengakses lokasi device ini',
      'error': false,
    };
  }
}
