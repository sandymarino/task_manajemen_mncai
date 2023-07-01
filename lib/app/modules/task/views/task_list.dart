import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/controller/auth_controller.dart';
import '../../../model/ListTileModel.dart';

class TaskList extends StatefulWidget {
  final arrayEmail;

  TaskList(this.arrayEmail);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  var id = Get.arguments[0]['index'];
  bool rememberMe = false;

  List<ListTileModel> _items = [];

  String input = "";
  int i = 0;

  final authCon = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    authCon.getDetailTask(id).then((value) {
      setState(() {
        _items = value;
      });
    });
  }

  int getIndex() {
    if (_items.isEmpty) {
      return 0;
    } else {
      return Random().nextInt(100);
    }
  }

  void _add(int index) {
    _items.add(ListTileModel(index, false, input));
    setState(() {});
  }

  void _remove(int index) {
    if (_items.isNotEmpty) {
      for (var element in _items) {
        if (element.index == index) {
          _items.remove(element);
          setState(() {});
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var email = widget.arrayEmail as List;
    Widget getTextWidgets(List<dynamic> strings) {
      return new Column(
          children: strings.map((item) => new Text(item)).toList());
    }

    return Scaffold(
      body: Column(
        children: [
          getTextWidgets(email),
          ListView(
            shrinkWrap: true,
            padding: EdgeInsets.all(28.0),
            children: <Widget>[
              SizedBox(height: 30),
              Row(
                children: <Widget>[
                  const SizedBox(width: 0.2),
                  SizedBox(
                    width: 200,
                    child: TextField(
                        textAlign: TextAlign.left,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(138.0)),
                          hintText: 'Enter the text',
                        ),
                        onChanged: (val) {
                          input = val;
                        }),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 80,
                    child: Material(
                      borderRadius: BorderRadius.circular(30.5),
                      shadowColor: Colors.lightBlueAccent.shade100,
                      elevation: 1.0,
                      child: MaterialButton(
                        onPressed: () {
                          _add(getIndex());
                        },
                        child: const Text('ADD',
                            style: TextStyle(
                                color: Colors.lightGreen, fontSize: 15)),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                  height: 390,
                  child: Builder(builder: (context) {
                    return ListView(
                        children: _items
                            .map(
                              (item) => CheckboxListTile(
                                value: item.enabled == null
                                    ? false
                                    : item.enabled!,
                                onChanged: (enabled) {
                                  item.enabled = enabled;
                                  setState(() {});
                                },
                                title: Text(item.text == null ? "" : item.text!,
                                    style: TextStyle(color: Colors.black)),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                activeColor: Colors.black,
                                // secondary: GestureDetector(
                                //   child: Icon(Icons.close),
                                //   onTap: () {
                                //     _remove(item.index!);
                                //   },
                                // ),
                              ),
                            )
                            .toList());
                  })
                  // child: StreamBuilder<
                  //     DocumentSnapshot<
                  //         Map<String, dynamic>>>(
                  //   stream: authCon.streamTask(id),
                  //   builder: (context, snapshot) {
                  //     if(snapshot.data != null) {
                  //       var dataTask = snapshot.data!.data();
                  //       if (dataTask != null) {
                  //         var dataUserList = ((dataTask)[
                  //         'task_detail'] ??
                  //             []) as List;
                  //         dataUserList.forEach((element) {
                  //           var item = ListTileModel.fromJson(
                  //               element);
                  //           // setState(() {
                  //           // if(!_items.contains(item)) {
                  //             _items.add(item);
                  //           // }
                  //
                  //           // });
                  //           // _items.add(ListTileModel.fromJson(element));
                  //         });
                  //       }
                  //     }
                  //
                  //     print(_items.length);
                  //
                  //     if(_items.isNotEmpty) {
                  //       return ListView(
                  //           children: _items
                  //               .map(
                  //                 (item) =>
                  //                 CheckboxListTile(
                  //                   value: item.enabled == null ? false : item.enabled!,
                  //                   onChanged: (enabled) {
                  //
                  //                     item.enabled = enabled;
                  //                     setState(() {
                  //                     });
                  //                   },
                  //                   title: Text(item.text == null ? "" : item.text!,
                  //                       style: TextStyle(color: Colors.black)),
                  //                   controlAffinity: ListTileControlAffinity
                  //                       .leading,
                  //                   activeColor: Colors.black,
                  //                   // secondary: GestureDetector(
                  //                   //   child: Icon(Icons.close),
                  //                   //   onTap: () {
                  //                   //     _remove(item.index!);
                  //                   //   },
                  //                   // ),
                  //                 ),
                  //           )
                  //               .toList());
                  //     }else{
                  //       return Container();
                  //     }
                  //   }
                  // ),
                  ),
              ElevatedButton(
                onPressed: () {
                  email.forEach((element) {
                    authCon.saveEmail(id, element);
                  });

                  authCon.saveTask(id, _items);
                },
                child: Text('Simpan'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}