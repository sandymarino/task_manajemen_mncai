import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../../data/controller/auth_controller.dart';
import '../../routes/app_pages.dart';
import '../style/AppColors.dart';

class MyTask extends StatelessWidget {
  final authConn = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: authConn.streamUsers(authConn.auth.currentUser!.email!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        //get task ID
        var taskId =
            ((snapshot.data!.data() as Map<String, dynamic>)['task_id'] ?? [])
                as List;

        return Expanded(
          child: ListView.builder(
              itemCount: taskId.length,
              clipBehavior: Clip.antiAlias,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: authConn.streamTask(taskId[index]),
                    builder: (context, snapshot2) {
                      if (snapshot2.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      // data task
                      var dataTask = snapshot2.data!.data();

                      if (dataTask != null) {
                        //data user photo
                        var dataUserList =
                            ((dataTask as Map<String, dynamic>)['asign_to'] ??
                                []) as List;

                        var date = DateTime.parse(dataTask['due_date']);
                        var deadlineDate = diffInDays(DateTime.now(), date);

                        return GestureDetector(
                          onTap: () {
                            Get.defaultDialog(
                                title: dataTask['title'],
                                content: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton.icon(
                                        onPressed: () {
                                          Get.toNamed(Routes.TASK_DETAIL,
                                              arguments: [
                                                {"index": taskId[index]},
                                              ]);
                                        },
                                        icon: const Icon(Ionicons.pencil),
                                        label: const Text('Update')),
                                    TextButton.icon(
                                        onPressed: () {
                                          authConn.deteleTask(taskId[index]);
                                          Get.snackbar("Task",
                                              "Task successfuly deleted");
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                        },
                                        icon: const Icon(Ionicons.trash),
                                        label: const Text('Delete')),
                                  ],
                                ));
                          },
                          child: Container(
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppColors.primaryBox,
                            ),
                            margin: EdgeInsets.all(10),
                            padding: EdgeInsets.all(20),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 50,
                                        child: Expanded(
                                          child: ListView.builder(
                                            padding: EdgeInsets.zero,
                                            itemCount: dataUserList.length,
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            physics: const ScrollPhysics(),
                                            itemBuilder: (context, index2) {
                                              return StreamBuilder<
                                                      DocumentSnapshot<
                                                          Map<String,
                                                              dynamic>>>(
                                                  stream: authConn.streamUsers(
                                                      dataUserList[index2]),
                                                  builder:
                                                      (context, snapshot3) {
                                                    if (snapshot2
                                                            .connectionState ==
                                                        ConnectionState
                                                            .waiting) {
                                                      return const Center(
                                                          child:
                                                              CircularProgressIndicator());
                                                    }
                                                    //data user photo
                                                    var dataUserImage =
                                                        snapshot3.data!.data();

                                                    return ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25),
                                                      child: CircleAvatar(
                                                        radius: 20,
                                                        foregroundImage:
                                                            NetworkImage(
                                                                dataUserImage![
                                                                    'photo']),
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
                                                BorderRadius.circular(20),
                                            color: const Color.fromARGB(
                                                255, 80, 80, 80)),
                                        child: Center(
                                          child: Text(
                                            '${double.parse(dataTask['status'].toString()).round()}%',
                                            style: const TextStyle(
                                              color: Colors.white,
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
                                    color:
                                        const Color.fromARGB(255, 80, 80, 80),
                                    child: Center(
                                      child: Text(
                                          '${dataTask['total_task_finished']} / ${dataTask['total_task']} Task',
                                          style: const TextStyle(
                                              color: Colors.white)),
                                    ),
                                  ),
                                  Text(
                                    dataTask['title'],
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    'Deadline $deadlineDate hari lagi',
                                    style: const TextStyle(
                                      color: Colors.black,
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
              }),
        );
      },
    );
  }
}

int diffInDays(DateTime from, DateTime to) {
  from = DateTime(from.year, from.month, from.day);
  to = DateTime(to.year, to.month, to.day);
  return (to.difference(from).inHours / 24).round();
}
