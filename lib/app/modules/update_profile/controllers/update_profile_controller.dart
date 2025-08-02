import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdateProfileController extends GetxController {
  RxBool isLoading = false.obs;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final nipController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void updateProfile(String uid) async {
    if (nameController.text.isNotEmpty ||
        emailController.text.isNotEmpty ||
        nipController.text.isNotEmpty) {
      isLoading.value = true;

      try {
        await firestore.collection('pegawai').doc(uid).update({
          'name': nameController.text,
        });

        Get.snackbar(
          'Success',
          'Profil berhasil diperbarui',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } catch (e) {
        Get.snackbar(
          'Error',
          'Gagal memperbarui profil: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }
}
