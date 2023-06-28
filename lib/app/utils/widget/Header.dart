import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../../routes/app_pages.dart';
import '../style/AppColors.dart';

class header extends StatelessWidget {
  const header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 0.1,
      child: Padding(
        padding: const EdgeInsets.only(left: 40, right: 40, top: 25),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Task Management',
                style: TextStyle(fontSize: 28, color: AppColors.primaryText),
              ),
              Text(
                'Manage Task Made Easy With Your Partner',
                style: TextStyle(fontSize: 18, color: AppColors.primaryText),
              ),
            ],
          ),
          const Spacer(flex: 1),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.only(left: 40, right: 10),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.white),
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                hintText: 'Search',
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          const Icon(Ionicons.notifications, color: Colors.white),
          const SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () {
              Get.defaultDialog(
                title: 'Sign Out',
                content: Text('Are you sure want to sign out?'),
                cancel: ElevatedButton(
                  onPressed: () => Get.back(),
                  child: Text('Cancel'),
                ),
                confirm: ElevatedButton(
                  onPressed: () => Get.toNamed(Routes.LOGIN),
                  child: Text('Sign Out'),
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
                Icon(Ionicons.log_out_outline, color: Colors.white),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
