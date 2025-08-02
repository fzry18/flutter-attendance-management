import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence/app/routes/app_pages.dart';

class ForgotPasswordController extends GetxController {
  TextEditingController emailController = TextEditingController();
  RxBool isLoading = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> resetPassword() async {
    if (isLoading.value) return; // Prevent double tap

    if (emailController.text.isNotEmpty) {
      isLoading.value = true;

      try {
        await auth.sendPasswordResetEmail(email: emailController.text);
        Get.snackbar(
          'Success',
          'Berhasil mengirim email reset password',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        emailController.clear(); // Clear the email field after sending
        Get.toNamed(Routes.LOGIN); // Redirect to login page
      } catch (e) {
        Get.snackbar(
          'Error',
          'Tidak dapat mengirim email reset: ${e.toString()}',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isLoading.value = false;
      }
    } else {
      Get.snackbar(
        'Error',
        'Silakan masukkan email Anda',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
