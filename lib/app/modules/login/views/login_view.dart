import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:task_management_app/app/data/controller/auth_controller.dart';
import 'package:task_management_app/app/routes/app_pages.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  final authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue,
        body: Container(
          margin: context.isPhone
              ? EdgeInsets.all(Get.width * 0.05)
              : EdgeInsets.all(Get.height * 0.05),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.white,
          ),
          child: Row(children: [
            //Biru
            !context.isPhone
                ? Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          bottomLeft: Radius.circular(50),
                        ),
                        color: Color.fromARGB(255, 0, 15, 100),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(50.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                height: Get.height / 3,
                                width: Get.width / 5,
                                child: Image.asset(
                                  "assets/icons/mncai-logo.png",
                                ),
                              ),
                              const Text(
                                'Welcome',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 70,
                                ),
                              ),
                              const Text(
                                'Please Sign In',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                ),
                              ),
                              const Text(
                                'Start Your Project With Us',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ]),
                      ),
                    ),
                  )
                : const SizedBox(),
            //putih
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      context.isPhone
                          ? Column(
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                  Text(
                                    'Welcome',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 0, 15, 100),
                                      fontSize: 40,
                                    ),
                                  ),
                                  Text(
                                    'Please Sign In',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 0, 15, 100),
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    'Start Your Project With Us',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 0, 15, 100),
                                      fontSize: 15,
                                    ),
                                  ),
                                ])
                          : const SizedBox(),
                      Image.asset(
                        'assets/image/login.png',
                        height: Get.height * 0.5,
                      ),
                      FloatingActionButton.extended(
                        onPressed: () => authC.signInWithGoogle(),
                        label: const Text('Sign In With Google'),
                        icon: const Icon(Ionicons.logo_google,
                            color: Colors.white),
                      )
                    ]),
              ),
            )
          ]),
        ),
      ),
    ); //
  }
}
