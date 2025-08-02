import 'package:get/get.dart';
import 'package:presence/app/controllers/index_page_controller.dart';

import '../controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<IndexPageController>(() => IndexPageController());
  }
}
