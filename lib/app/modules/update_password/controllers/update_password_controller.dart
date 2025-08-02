import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UpdatePasswordController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  void updatePassword() async {
    if (isLoading.value) return; // Prevent double tap

    String currentPassword = currentPasswordController.text;
    String newPassword = newPasswordController.text;
    String confirmPassword = confirmPasswordController.text;

    FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    if (newPassword.isNotEmpty &&
        newPassword == confirmPassword &&
        currentPassword.isNotEmpty) {
      isLoading.value = true;
      try {
        String emailUser = firebaseAuth.currentUser!.email!;

        await firebaseAuth.signInWithEmailAndPassword(
          email: emailUser,
          password: currentPassword,
        );
        await firebaseAuth.currentUser?.updatePassword(newPassword);

        print('Password updated successfully');
        Get.back();
        Get.snackbar(
          'Success',
          'Password berhasil diperbarui',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'wrong-password') {
          Get.snackbar(
            'Error',
            'Password saat ini salah',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        } else if (e.code == 'weak-password') {
          Get.snackbar(
            'Error',
            'Password baru terlalu lemah',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            'Error',
            'Terjadi kesalahan: ${e.message}',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'Gagal memperbarui password: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isLoading.value = false;
      }
    } else {
      Get.snackbar(
        'Error',
        'Semua field harus diisi dan password baru harus cocok',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
