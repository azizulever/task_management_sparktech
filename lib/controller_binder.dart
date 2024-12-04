import 'package:get/get.dart';
import 'package:task_manager/ui/controllers/new_task_screen_controller.dart';

import 'ui/controllers/sign_in_controller.dart';
import 'ui/controllers/sign_up_controller.dart';

class ControllerBinder extends Bindings{
  @override
  void dependencies() {
    Get.put(SignUpController());
    Get.put(SignInController());
    Get.put(NewTaskListController());

  }
}