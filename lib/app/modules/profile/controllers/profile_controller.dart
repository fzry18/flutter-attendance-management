import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:presence/app/routes/app_pages.dart';

class ProfileController extends GetxController {
  RxBool isLoading = false.obs;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser() async* {
    String? uid = firebaseAuth.currentUser?.uid;

    yield* firestore.collection('pegawai').doc(uid).snapshots();
  }

  void logout() async {
    await firebaseAuth.signOut();
    Get.toNamed(Routes.LOGIN);
  }
}
