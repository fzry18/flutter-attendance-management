import 'package:get/get.dart';
import 'package:presence/app/controllers/index_page_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<IndexPageController>(() => IndexPageController());
  }
}
