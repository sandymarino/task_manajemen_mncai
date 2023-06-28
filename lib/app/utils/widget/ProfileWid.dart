import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/controller/auth_controller.dart';

class ProfileWid extends StatelessWidget {
  final authConn = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: !context.isPhone
          ? Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ClipRRect(
                    child: CircleAvatar(
                      backgroundColor: Colors.amber,
                      radius: 135,
                      foregroundImage:
                          NetworkImage(authConn.auth.currentUser!.photoURL!),
                    ),
                  ),
                ),
                //SizedBox(width: 20),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authConn.auth.currentUser!.displayName!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 50,
                        ),
                      ),
                      Text(
                        authConn.auth.currentUser!.email!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  ClipRRect(
                    child: CircleAvatar(
                      backgroundColor: Colors.amber,
                      radius: 120,
                      foregroundImage:
                          NetworkImage(authConn.auth.currentUser!.photoURL!),
                    ),
                  ),
                  SizedBox(height: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        authConn.auth.currentUser!.displayName!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 40,
                        ),
                      ),
                      Text(
                        authConn.auth.currentUser!.email!,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
