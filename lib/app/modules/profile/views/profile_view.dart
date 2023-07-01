import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:task_management_app/app/utils/widget/MyTask.dart';
import 'package:task_management_app/app/utils/widget/PeopleYouWayKnow.dart';

import '../../../data/controller/auth_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/style/AppColors.dart';
import '../../../utils/widget/Header.dart';
import '../../../utils/widget/ProfileWid.dart';
import '../../../utils/widget/SideBar.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final GlobalKey<ScaffoldState> drawerKey = GlobalKey();
  final authConn = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: drawerKey,
        drawer: const SizedBox(width: 150, child: SideBar()),
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
                              GestureDetector(
                                onTap: () {
                                  Get.defaultDialog(
                                    title: 'Sign Out',
                                    content:
                                        const Text('Are you sure want to sign out?'),
                                    cancel: ElevatedButton(
                                      onPressed: () => Get.back(),
                                      child: const Text('Cancel'),
                                    ),
                                    confirm: ElevatedButton(
                                      onPressed: () => authConn.logout(),
                                      child: const Text('Sign Out'),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: const [
                                    Text(
                                      "Sign Out",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Icon(Ionicons.log_out_outline,
                                        color: Colors.white),
                                  ],
                                ),
                              ),
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
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ProfileWid(),
                            const Text(
                              'People You Way Know',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            SizedBox(height: 220, child: PeopleYouMayKnow()),
                          ]),
                    ),
                  ),
                ]),
              )
            ],
          ),
        ));
  }
}
