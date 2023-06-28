import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:task_management_app/app/routes/app_pages.dart';

class AuthController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  UserCredential? _userCredential;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController searchFriendsController;

  @override
  void onInit() {
    super.onInit();
    searchFriendsController = TextEditingController();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    searchFriendsController.dispose();
  }

  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await auth
        .signInWithCredential(credential)
        .then((value) => _userCredential = value);

    //Firebase
    CollectionReference users = firestore.collection('users');

    final cekUsers = await users.doc(googleUser?.email).get();
    if (!cekUsers.exists) {
      users.doc(googleUser?.email).set({
        'uid': _userCredential?.user!.uid,
        'name': googleUser?.displayName,
        'email': googleUser?.email,
        'photo': googleUser?.photoUrl,
        'createdAt': _userCredential!.user!.metadata.lastSignInTime.toString(),
        'lastLoginAt':
            _userCredential?.user!.metadata.lastSignInTime.toString(),
        //  'list_cari':[R,SA,DA]
      }).then((value) async {
        String temp = '';
        try {
          for (var i = 0; i < googleUser!.displayName!.length; i++) {
            temp = temp + googleUser.displayName![i];
            await users.doc(googleUser.email).set({
              'list_cari': FieldValue.arrayUnion([temp.toUpperCase()])
            }, SetOptions(merge: true));
          }
        } catch (e) {
          print(e);
        }
      });
      Get.offAllNamed(Routes.HOME);
    } else {
      users.doc(googleUser?.email).update({
        'lastLoginAt':
            _userCredential?.user!.metadata.lastSignInTime.toString(),
      });
      Get.offAllNamed(Routes.HOME);
    }
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    Get.offAllNamed(Routes.LOGIN);
  }

  var kataCari = [].obs;
  var hasilPencarian = [].obs;
  void searchFriends(String Keyword) async {
    CollectionReference users = firestore.collection('users');
    if (Keyword.isNotEmpty) {
      final hasilQuery = await users
          .where('list_cari', arrayContains: Keyword.toUpperCase())
          .get();
      print(hasilQuery.docs.length);
      if (hasilQuery.docs.isNotEmpty) {
        for (var i = 0; i < hasilQuery.docs.length; i++) {
          kataCari.add(hasilQuery.docs[i].data() as Map<String, dynamic>);
        }
      }
      if (kataCari.isNotEmpty) {
        hasilPencarian.value = [];
        kataCari.forEach((element) {
          print(element);
          hasilPencarian.add(element);
        });
        kataCari.clear();
      }
    } else {
      kataCari.value = [];
      hasilPencarian.value = [];
    }
    kataCari.refresh();
    hasilPencarian.refresh();
  }

  void addFriends(String _emailFriends) async {
    CollectionReference friends = firestore.collection('friends');

    final cekFriends = await friends.doc(auth.currentUser!.email).get();
    //cek data  ada atau tidak
    if (cekFriends.data() == null) {
      await friends.doc(auth.currentUser!.email).set({
        'emailMe': auth.currentUser!.email,
        'emailFriends': [_emailFriends],
      }).whenComplete(
          () => Get.snackbar("Friends", "Friends successfuly added"));
    } else {
      await friends.doc(auth.currentUser!.email).set({
        'emailFriends': FieldValue.arrayUnion([_emailFriends]),
      }, SetOptions(merge: true)).whenComplete(
          () => Get.snackbar("Friends", "Friends successfuly added"));
    }
    kataCari.clear();
    hasilPencarian.clear();
    searchFriendsController.clear();
    // Get.back();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamFriends() {
    return firestore
        .collection('friends')
        .doc(auth.currentUser!.email)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUsers(String email) {
    return firestore.collection('users').doc(email).snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getPeople() async {
    CollectionReference friendsCollec = firestore.collection('friends');

    final cekFriends = await friendsCollec.doc(auth.currentUser!.email).get();

    var listFriends =
        (cekFriends.data() as Map<String, dynamic>)['emailFriends'] as List;

    listFriends.add(auth.currentUser!.email);


    QuerySnapshot<Map<String, dynamic>> hasil = await firestore
        .collection('users')
        .where('email', whereNotIn:  listFriends)
        .get();

    return hasil;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamTask(String taskId) {
    return firestore.collection('task').doc(taskId).snapshots();
  }
}