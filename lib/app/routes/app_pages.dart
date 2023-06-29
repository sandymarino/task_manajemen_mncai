import 'package:get/get.dart';
import 'package:task_management_app/app/modules/task/bindings/task_detail_binding.dart';
import 'package:task_management_app/app/modules/task/views/task_detail.dart';

import '../modules/friends/bindings/friends_binding.dart';
import '../modules/friends/views/friends_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/task/bindings/task_binding.dart';
import '../modules/task/views/task_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(seconds: 1),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(seconds: 1),
    ),
    GetPage(
      name: _Paths.TASK,
      page: () => TaskView(),
      binding: TaskBinding(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(seconds: 1),
    ),
    GetPage(
      name: _Paths.FRIENDS,
      page: () => FriendsView(),
      binding: FriendsBinding(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(seconds: 1),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(seconds: 1),
    ),
    GetPage(
      name: _Paths.TASK_DETAIL,
      page: () => TaskDetail(),
      binding: TaskDetailBinding(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: Duration(seconds: 1),
    ),
  ];
}
