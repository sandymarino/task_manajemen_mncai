import 'package:get/get.dart';

import '../controllers/Task_detail_controller.dart';


class TaskDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TaskDetailController>(
          () => TaskDetailController(),
    );
  }
}
