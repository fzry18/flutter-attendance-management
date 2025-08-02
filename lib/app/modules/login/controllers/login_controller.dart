import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presence/app/routes/app_pages.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxBool isLoading = false.obs;

  FirebaseAuth auth = FirebaseAuth.instance;

  void login() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      isLoading.value = true;
      update();

      try {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text,
        );

        if (userCredential.user != null) {
          if (userCredential.user!.emailVerified == true) {
            isLoading.value = false;
            update();

            if (passwordController.text == 'password') {
              Get.offAllNamed(Routes.NEW_PASSWORD);
            } else {
              Get.snackbar(
                'Success',
                'Login berhasil',
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.green,
                colorText: Colors.white,
                icon: const Icon(Icons.check_circle, color: Colors.white),
                borderRadius: 12,
                margin: const EdgeInsets.all(16),
              );
              Get.offAllNamed(Routes.HOME);
            }
          } else {
            isLoading.value = false;
            update();

            Get.defaultDialog(
              backgroundColor: Colors.white,
              title: 'Email Belum Diverifikasi',
              middleText: 'Silakan verifikasi email Anda terlebih dahulu.',
              textConfirm: 'Kirim Ulang',
              onConfirm: () {
                verifiedEmail();
                Get.back();
              },
              textCancel: 'Tutup',
            );
          }
        } else {
          isLoading.value = false;
          update();

          Get.snackbar(
            'Error',
            'Login gagal, user tidak ditemukan',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            icon: const Icon(Icons.error, color: Colors.white),
            borderRadius: 12,
            margin: const EdgeInsets.all(16),
          );
        }
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;
        update();

        String errorMessage;
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'Email tidak terdaftar di sistem';
            break;
          case 'wrong-password':
            errorMessage = 'Password yang Anda masukkan salah';
            break;
          case 'invalid-credential':
            errorMessage = 'Email atau password salah';
            break;
          case 'invalid-email':
            errorMessage = 'Format email tidak valid';
            break;
          case 'user-disabled':
            errorMessage = 'Akun telah dinonaktifkan';
            break;
          case 'too-many-requests':
            errorMessage = 'Terlalu banyak percobaan login. Coba lagi nanti';
            break;
          case 'network-request-failed':
            errorMessage = 'Tidak dapat terhubung ke server';
            break;
          default:
            errorMessage = 'Login gagal: ${e.message}';
        }

        Get.snackbar(
          'Error Login',
          errorMessage,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: const Icon(Icons.error, color: Colors.white),
          borderRadius: 12,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 4),
        );

        // Debug print
        print('Firebase Auth Error: ${e.code} - ${e.message}');
      } catch (e) {
        isLoading.value = false;
        update();

        Get.snackbar(
          'Error',
          'Terjadi kesalahan tidak terduga: ${e.toString()}',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: const Icon(Icons.error, color: Colors.white),
          borderRadius: 12,
          margin: const EdgeInsets.all(16),
        );

        print('General Error: $e');
      }
    } else {
      Get.snackbar(
        'Error',
        'Email dan Password harus diisi',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.warning, color: Colors.white),
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  void verifiedEmail() async {
    User? user = auth.currentUser;
    if (user != null && !user.emailVerified) {
      try {
        await user.sendEmailVerification();
        Get.snackbar(
          'Success',
          'Email verifikasi telah dikirim ke ${user.email}',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: const Icon(Icons.mark_email_read, color: Colors.white),
          borderRadius: 12,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 4),
        );
      } catch (e) {
        Get.snackbar(
          'Error',
          'Gagal mengirim email verifikasi. Silahkan coba lagi',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: const Icon(Icons.error, color: Colors.white),
          borderRadius: 12,
          margin: const EdgeInsets.all(16),
        );
      }
    } else {
      Get.snackbar(
        'Info',
        'Email sudah diverifikasi atau tidak ada user yang login',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        icon: const Icon(Icons.info, color: Colors.white),
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
      );
    }
  }
}
