import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/controller/auth_controller.dart';
import '../../../model/ListTileModel.dart';

class TaskList extends StatefulWidget {
  const TaskList({Key? key}) : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  bool rememberMe = false;

  List<ListTileModel> _items = [];

  String input = "";
  int i = 0;

  int getIndex(){
    if(_items.isEmpty){
      return 0;
    }else{
      return Random().nextInt(100);
    }
  }

  void _add(int index) {
    _items.add(ListTileModel(index, false, input));
    setState(() {});
  }

  void _remove(int index){
    if(_items.isNotEmpty){
      for (var element in _items) {
        if(element.index == index){
          _items.remove(element);
          setState(() {
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    final authCon = Get.find<AuthController>();

    return Scaffold(
      body: Column(
        children: [

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
                            style:
                            TextStyle(color: Colors.lightGreen, fontSize: 15)),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 390,
                child: ListView(
                    children: _items
                        .map(
                          (item) => CheckboxListTile(
                        value: item.enabled,
                        onChanged: (enabled) {
                          item.enabled = enabled!;
                          setState(() {});
                        },
                        title: Text(item.text,
                            style: TextStyle(color: Colors.black)),
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: Colors.black,
                        secondary: GestureDetector(
                          child: Icon(Icons.close),
                          onTap: () {
                            _remove(item.index);
                          },
                        ),
                      ),
                    )
                        .toList()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}