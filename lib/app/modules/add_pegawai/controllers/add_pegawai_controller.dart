import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPegawaiController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingAddPegawai = false.obs;
  RxBool isPasswordHidden = true.obs;

  TextEditingController nipController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordAdminController = TextEditingController();
  TextEditingController jobTitleController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> addPegawai() async {
    if (isLoading.value) return; // Prevent double tap

    if (nipController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        jobTitleController.text.isNotEmpty) {
      isLoading.value = true;

      Get.dialog(
        Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: Get.width * 0.9,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header with icon
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2196F3).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Icon(
                    Icons.security,
                    size: 32,
                    color: Color(0xFF2196F3),
                  ),
                ),

                const SizedBox(height: 20),

                // Title
                const Text(
                  'Konfirmasi Admin',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 8),

                // Subtitle
                Text(
                  'Masukkan password admin untuk mengkonfirmasi penambahan pegawai baru',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 24),

                // Password field
                Obx(
                  () => TextFormField(
                    controller: passwordAdminController,
                    obscureText: isPasswordHidden.value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Password Admin',
                      hintText: 'Masukkan password admin',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontWeight: FontWeight.normal,
                      ),
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Colors.grey[400],
                      ),
                      suffixIcon: IconButton(
                        onPressed: togglePasswordVisibility,
                        icon: Icon(
                          isPasswordHidden.value
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.grey[400],
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF2196F3),
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: isLoadingAddPegawai.value
                            ? null
                            : () {
                                isLoading.value = false;
                                isLoadingAddPegawai.value = false;
                                passwordAdminController.clear();
                                Get.back();
                              },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Batal',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Obx(
                        () => ElevatedButton(
                          onPressed: isLoadingAddPegawai.value
                              ? null
                              : () async {
                                  await savePegawai();
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2196F3),
                            disabledBackgroundColor: Colors.grey[300],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 0,
                          ),
                          child: isLoadingAddPegawai.value
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                )
                              : const Text(
                                  'Konfirmasi',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
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
        barrierDismissible: false,
      );
    } else {
      isLoading.value = false; // Reset loading state
      Get.snackbar(
        'Error',
        'NIP, Nama, Email, dan Job Title harus diisi',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  Future<void> savePegawai() async {
    if (passwordAdminController.text.isNotEmpty) {
      isLoadingAddPegawai.value = true;

      try {
        String emailAdmin = auth.currentUser!.email!;
        await auth.signInWithEmailAndPassword(
          email: emailAdmin,
          password: passwordAdminController.text,
        );

        UserCredential pegawaiCredential = await auth
            .createUserWithEmailAndPassword(
              email: emailController.text,
              password: 'password',
            );

        if (pegawaiCredential.user != null) {
          String uid = pegawaiCredential.user!.uid;
          await firestore.collection('pegawai').doc(uid).set({
            'nip': nipController.text,
            'name': nameController.text,
            'email': emailController.text,
            'uid': uid,
            'role': 'pegawai',
            'jobTitle': jobTitleController.text,
            'createdAt': DateTime.now().toIso8601String(),
          });

          await pegawaiCredential.user!.sendEmailVerification();

          await auth.signOut();

          await auth.signInWithEmailAndPassword(
            email: emailAdmin,
            password: passwordAdminController.text,
          );

          // Reset loading states
          isLoadingAddPegawai.value = false;
          isLoading.value = false;

          // Clear password field
          passwordAdminController.clear();

          Get.back(); // Close the dialog
          Get.back(); // back to home

          Get.snackbar(
            'Success',
            'Pegawai berhasil ditambahkan',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            icon: const Icon(Icons.check_circle, color: Colors.white),
            borderRadius: 12,
            margin: const EdgeInsets.all(16),
          );
        }
      } on FirebaseAuthException catch (e) {
        isLoadingAddPegawai.value = false;

        if (e.code == 'weak-password') {
          Get.snackbar(
            'Error',
            'Password terlalu lemah',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            icon: const Icon(Icons.error, color: Colors.white),
            borderRadius: 12,
            margin: const EdgeInsets.all(16),
          );
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar(
            'Error',
            'Email sudah digunakan',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            icon: const Icon(Icons.error, color: Colors.white),
            borderRadius: 12,
            margin: const EdgeInsets.all(16),
          );
        } else if (e.code == 'wrong-password' ||
            e.code == 'invalid-credential') {
          Get.snackbar(
            'Error',
            'Password admin salah',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            icon: const Icon(Icons.error, color: Colors.white),
            borderRadius: 12,
            margin: const EdgeInsets.all(16),
          );
        } else if (e.code == 'user-not-found') {
          Get.snackbar(
            'Error',
            'Email admin tidak ditemukan',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            icon: const Icon(Icons.error, color: Colors.white),
            borderRadius: 12,
            margin: const EdgeInsets.all(16),
          );
        } else if (e.code == 'invalid-email') {
          Get.snackbar(
            'Error',
            'Format email tidak valid',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            icon: const Icon(Icons.error, color: Colors.white),
            borderRadius: 12,
            margin: const EdgeInsets.all(16),
          );
        } else if (e.code == 'too-many-requests') {
          Get.snackbar(
            'Error',
            'Terlalu banyak percobaan login. Coba lagi nanti',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            icon: const Icon(Icons.error, color: Colors.white),
            borderRadius: 12,
            margin: const EdgeInsets.all(16),
          );
        } else {
          Get.snackbar(
            'Error',
            'Terjadi kesalahan: ${e.code} - ${e.message}',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            icon: const Icon(Icons.error, color: Colors.white),
            borderRadius: 12,
            margin: const EdgeInsets.all(16),
          );
        }
      } catch (e) {
        isLoadingAddPegawai.value = false;
        print('General exception caught: $e');
        Get.snackbar(
          'Error',
          'Terjadi kesalahan saat menambahkan pegawai: $e',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: const Icon(Icons.error, color: Colors.white),
          borderRadius: 12,
          margin: const EdgeInsets.all(16),
        );
      }
    } else {
      isLoadingAddPegawai.value = false;
      Get.snackbar(
        'Error',
        'Password konfirmasi harus diisi',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  @override
  void onClose() {
    nipController.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordAdminController.dispose();
    jobTitleController.dispose();
    super.onClose();
  }
}
