import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:task_management_app/app/utils/widget/PeopleYouWayKnow.dart';
import 'package:task_management_app/app/utils/widget/SideBar.dart';
import '../../../data/controller/auth_controller.dart';
import '../../../utils/style/AppColors.dart';
import '../../../utils/widget/Header.dart';
import '../../../utils/widget/MyFriends.dart';
import '../../../utils/widget/MyTask.dart';
import '../../../utils/widget/UpComingTask.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final GlobalKey<ScaffoldState> drawerKey = GlobalKey();

  final authConn = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: drawerKey,
        drawer: SizedBox(width: 150, child: const SideBar()),
        backgroundColor: AppColors.primaryBg,
        body: SafeArea(
          child: Row(
            children: [
              !context.isPhone
                  ? const Expanded(
                      flex: 2,
                      child: SideBar(),
                    )
                  : const SizedBox(),
              Expanded(
                flex: 15,
                child: Column(children: [
                  !context.isPhone
                      ? const header()
                      : Container(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  drawerKey.currentState!.openDrawer();
                                },
                                icon: const Icon(
                                  Icons.menu,
                                  color: AppColors.primaryText,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Task Management',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: AppColors.primaryText),
                                  ),
                                  Text(
                                    'Manage Task Made Easy With Your Partner',
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: AppColors.primaryText),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              // const Icon(
                              //   Ionicons.notifications,
                              //   color: AppColors.primaryText,
                              //   size: 30,
                              // ),
                              const SizedBox(
                                width: 15,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: CircleAvatar(
                                  backgroundColor: Colors.amber,
                                  radius: 25,
                                  foregroundImage: NetworkImage(
                                      authConn.auth.currentUser!.photoURL!),
                                ),
                              )
                            ],
                          ),
                        ),
                  // content // isi page // screen
                  Expanded(
                    child: Container(
                      padding: !context.isPhone
                          ? const EdgeInsets.all(50)
                          : const EdgeInsets.all(20),
                      margin: !context.isPhone
                          ? const EdgeInsets.all(10)
                          : const EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: !context.isPhone
                            ? BorderRadius.circular(50)
                            : BorderRadius.circular(30),
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: Get.height * 0.35,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:  [
                                  const Text(
                                    'People You May Know',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 30,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  //my task apps
                                  PeopleYouMayKnow(),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                const Text(
                                  'My Task',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 30,
                                  ),
                                ),
                                !context.isPhone
                                    ? Expanded(
                                  child: Row(children: [
                                    MyTask(),
                                    MyFriends(),
                                  ]),
                                )
                                    : const MyTask(),
                              ],
                            )
                          ]),
                    ),
                  )
                ]),
              )
            ],
          ),
        ));
  }
}
