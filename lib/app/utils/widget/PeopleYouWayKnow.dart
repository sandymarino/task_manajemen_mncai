import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:ionicons/ionicons.dart';
import '../../data/controller/auth_controller.dart';

class PeopleYouMayKnow extends StatelessWidget {
  final authCon = Get.find<AuthController>();

  PeopleYouMayKnow({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 200,
        child: FutureBuilder(
          future: authCon.getPeople(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            var data = snapshot.data!.docs;

            return ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                clipBehavior: Clip.antiAlias,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  var hasil = data[index].data();
                  return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Stack(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image(
                            image: NetworkImage(hasil['photo']),
                            height: Get.width * 0.3,
                            width: Get.width * 0.25,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Positioned(
                          bottom: 30,
                          left: 5,
                          child: Text(
                            hasil['name'],
                            style: const TextStyle(
                                color: Colors.black, fontSize: 15),
                          ),
                        ),
                        Positioned(
                            bottom: 50,
                            right: 0,
                            child: SizedBox(
                              height: 36,
                              width: 36,
                              child: ElevatedButton(
                                onPressed: () =>
                                    authCon.addFriends(hasil['email']),
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                                child: const Icon(Ionicons.add_circle_outline),
                              ),
                            ))
                      ]));
                });
          },
        ));
  }
}
