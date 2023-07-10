import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:task_management_app/app/modules/task/views/task_list.dart';

import '../../../data/controller/auth_controller.dart';
import '../../../utils/style/AppColors.dart';
import '../../../utils/widget/Header.dart';
import '../../../utils/widget/SideBar.dart';

class TaskDetail extends StatefulWidget {
  const TaskDetail({super.key});

  @override
  State<TaskDetail> createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  final GlobalKey<ScaffoldState> drawerKey = GlobalKey();
  final authCon = Get.find<AuthController>();

  var arrayEmail = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: drawerKey,
      resizeToAvoidBottomInset: false,
      drawer: SizedBox(width: 150, child: const SideBar()),
      backgroundColor: AppColors.primaryBg,
      body: SafeArea(
        child: Row(children: [
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
                      child: Column(
                        children: [
                          Row(
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
                                      authCon.auth.currentUser!.photoURL!),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          context.isPhone
                              ? TextField(
                                  onChanged: (Value) =>
                                      authCon.searchMyFriends(Value),
                                  controller: authCon.searchFriendsController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding:
                                        EdgeInsets.only(left: 40, right: 10),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide:
                                          BorderSide(color: Colors.white),
                                    ),
                                    prefixIcon: const Icon(
                                      Icons.search,
                                      color: Colors.black,
                                    ),
                                    hintText: 'Search Your Friends',
                                  ),
                                )
                              : const SizedBox(),
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
                  child: Obx(
                    () => authCon.myhasilPencarian.isEmpty
                        ? TaskList(arrayEmail)
                        : ListView.builder(
                            padding: EdgeInsets.all(8),
                            shrinkWrap: true,
                            itemCount: authCon.myhasilPencarian.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  arrayEmail
                                      .add(authCon.myhasilPencarian[index]);
                                  authCon.searchMyFriends("");
                                  authCon.searchFriendsController.text = "";
                                },
                                child: Container(
                                  color: AppColors.primaryBg,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      authCon.myhasilPencarian[index],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              );
                            }),
                  ),
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}
