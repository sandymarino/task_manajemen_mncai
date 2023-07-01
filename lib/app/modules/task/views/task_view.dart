import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../../../data/controller/auth_controller.dart';
import '../../../routes/app_pages.dart';
import '../../../utils/style/AppColors.dart';
import '../../../utils/widget/Header.dart';
import '../../../utils/widget/SideBar.dart';
import '../controllers/task_controller.dart';

class TaskView extends GetView<TaskController> {
  final GlobalKey<ScaffoldState> drawerKey = GlobalKey();
  final authCon = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: drawerKey,
      drawer: const SizedBox(width: 150, child: SideBar()),
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
                        padding: EdgeInsets.all(10),
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
                                    authCon.auth.currentUser!.photoURL!),
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
                            const Text(
                              'My Task',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Expanded(
                              //stream user for get task list
                              child: StreamBuilder<
                                  DocumentSnapshot<Map<String, dynamic>>>(
                                stream: authCon.streamUsers(
                                    authCon.auth.currentUser!.email!),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                  //get task ID
                                  var taskId = ((snapshot.data!.data()
                                          as Map<String, dynamic>)['task_id'] ??
                                      []) as List;

                                  return ListView.builder(
                                      itemCount: taskId.length,
                                      clipBehavior: Clip.antiAlias,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return StreamBuilder<
                                                DocumentSnapshot<
                                                    Map<String, dynamic>>>(
                                            stream: authCon
                                                .streamTask(taskId[index]),
                                            builder: (context, snapshot2) {
                                              if (snapshot2.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Center(
                                                    child:
                                                        CircularProgressIndicator());
                                              }

                                              // data task
                                              var dataTask =
                                                  snapshot2.data!.data();

                                              if (dataTask != null) {
                                                //data user photo
                                                var dataUserList = ((dataTask
                                                            as Map<String,
                                                                dynamic>)[
                                                        'asign_to'] ??
                                                    []) as List;

                                                var date = DateTime.parse(
                                                    dataTask['due_date']);
                                                var deadlineDate = diffInDays(
                                                    DateTime.now(), date);

                                                return GestureDetector(
                                                  onTap: () {
                                                    Get.defaultDialog(
                                                        title:
                                                            dataTask['title'],
                                                        content: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            TextButton.icon(
                                                                onPressed: () {
                                                                  Get.toNamed(
                                                                      Routes
                                                                          .TASK_DETAIL,
                                                                      arguments: [
                                                                        {
                                                                          "index":
                                                                              taskId[index]
                                                                        },
                                                                      ]);
                                                                },
                                                                icon: const Icon(
                                                                    Ionicons
                                                                        .pencil),
                                                                label: const Text(
                                                                    'Update')),
                                                            TextButton.icon(
                                                                onPressed: () {
                                                                  authCon.deteleTask(
                                                                      taskId[
                                                                          index]);
                                                                  Get.snackbar(
                                                                      "Task",
                                                                      "Task successfuly deleted");
                                                                  Navigator.of(
                                                                          context,
                                                                          rootNavigator:
                                                                              true)
                                                                      .pop();
                                                                },
                                                                icon: const Icon(
                                                                    Ionicons
                                                                        .trash),
                                                                label: const Text(
                                                                    'Delete')),
                                                          ],
                                                        ));
                                                  },
                                                  child: Container(
                                                    height: 200,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      color:
                                                          AppColors.primaryBox,
                                                    ),
                                                    margin: EdgeInsets.all(10),
                                                    padding: EdgeInsets.all(20),
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              SizedBox(
                                                                height: 50,
                                                                child: Expanded(
                                                                  child: ListView
                                                                      .builder(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                    itemCount:
                                                                        dataUserList
                                                                            .length,
                                                                    scrollDirection:
                                                                        Axis.horizontal,
                                                                    shrinkWrap:
                                                                        true,
                                                                    physics:
                                                                        const ScrollPhysics(),
                                                                    itemBuilder:
                                                                        (context,
                                                                            index2) {
                                                                      return StreamBuilder<
                                                                              DocumentSnapshot<Map<String, dynamic>>>(
                                                                          stream: authCon.streamUsers(dataUserList[index2]),
                                                                          builder: (context, snapshot3) {
                                                                            if (snapshot2.connectionState ==
                                                                                ConnectionState.waiting) {
                                                                              return const Center(child: CircularProgressIndicator());
                                                                            }
                                                                            //data user photo
                                                                            var dataUserImage =
                                                                                snapshot3.data!.data();

                                                                            return ClipRRect(
                                                                              borderRadius: BorderRadius.circular(25),
                                                                              child: CircleAvatar(
                                                                                radius: 20,
                                                                                foregroundImage: NetworkImage(dataUserImage!['photo']),
                                                                              ),
                                                                            );
                                                                          });
                                                                    },
                                                                  ),
                                                                ),
                                                              ),
                                                              const Spacer(),
                                                              Container(
                                                                height: 25,
                                                                width: 80,
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                    color: const Color
                                                                            .fromARGB(
                                                                        255,
                                                                        80,
                                                                        80,
                                                                        80)),
                                                                child: Center(
                                                                  child: Text(
                                                                    '${dataTask['status']}%',
                                                                    style:
                                                                        const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Spacer(),
                                                          Container(
                                                            height: 25,
                                                            width: 80,
                                                            color: const Color
                                                                    .fromARGB(
                                                                255,
                                                                80,
                                                                80,
                                                                80),
                                                            child: Center(
                                                              child: Text(
                                                                  '${dataTask['total_task_finished']} / ${dataTask['total_task']} Task',
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .white)),
                                                            ),
                                                          ),
                                                          Text(
                                                            dataTask['title'],
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20,
                                                            ),
                                                          ),
                                                          Text(
                                                            'Deadline $deadlineDate hari lagi',
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 15,
                                                            ),
                                                          ),
                                                        ]),
                                                  ),
                                                );
                                              } else {
                                                return Container();
                                              }
                                            });
                                      });
                                },
                              ),
                            )
                          ])),
                ),
              ])),
        ]),
      ),
      floatingActionButton: Align(
        alignment: const Alignment(0.95, 0.95),
        child: FloatingActionButton.extended(
          onPressed: () {
            addEditTask(context: context, type: 'Add', docId: '');
          },
          label: const Text('Add Task'),
          icon: const Icon(Ionicons.add),
        ),
      ),
    );
  }

  addEditTask({BuildContext? context, String? type, String? docId}) {
    Get.bottomSheet(
      SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          margin: context!.isPhone
              ? EdgeInsets.zero
              : const EdgeInsets.only(
                  left: 150,
                  right: 150,
                ),
          height: Get.height,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: Colors.white,
          ),
          child: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  Text(
                    '$type Task',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    controller: controller.titleController,
                    validator: (Value) {
                      if (Value == null || Value.isEmpty) {
                        return 'Cant be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    controller: controller.descriptionController,
                    validator: (Value) {
                      if (Value == null || Value.isEmpty) {
                        return 'Cant be empty';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  DateTimePicker(
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2200),
                    dateLabelText: 'Due Date',
                    dateHintText: 'Due Date',
                    decoration: InputDecoration(
                      hintText: 'Due Date',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    controller: controller.dueDateController,
                    validator: (Value) {
                      if (Value == null || Value.isEmpty) {
                        return 'Cant be empty';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ConstrainedBox(
                    constraints:
                        BoxConstraints.tightFor(width: Get.width, height: 40),
                    child: ElevatedButton(
                      onPressed: () {
                        controller.saveUpdateTask(
                          type: type,
                          titel: controller.titleController.text,
                          description: controller.descriptionController.text,
                          dueDate: controller.dueDateController.text,
                          docId: docId,
                        );
                      },
                      child: Text(type!),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              )),
        ),
      ),
    );
  }
}

int diffInDays(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}
