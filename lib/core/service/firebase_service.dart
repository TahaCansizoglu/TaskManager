import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/taskmodel.dart';
import '../../view/authentication/signin/signin.dart';
import '../../view/home/home_screen.dart';

class FirebaseService {
  static User? user = FirebaseAuth.instance.currentUser;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static String name = "";
  static Future<void> signIn(
      String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) => user = FirebaseAuth.instance.currentUser);
    } on FirebaseAuthException catch (e) {
      final snackBar = SnackBar(content: Text(e.message.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  static Future<void> signUp(
      String email, String password, String name, BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .whenComplete(() {
        user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          FirebaseService.firestore.collection("Users").doc(user!.uid).set({
            "name": name,
          });

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
              (Route<dynamic> route) => false);
        }
      });
    } on FirebaseAuthException catch (e) {
      final snackBar = SnackBar(content: Text(e.message.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print(e.code);
      print(e.message);
    }
  }

  static Future<QuerySnapshot<Map<String, dynamic>>> getFirebaseData() async {
    return await firestore
        .collection('Users')
        .doc(FirebaseService.user!.uid)
        .collection('todo')
        .get();
  }

  static Future<void> getName() async {
    await firestore
        .collection('Users')
        .doc(user!.uid)
        .get()
        .then((value) => name = value['name']);
  }

  static Future<void> addTaskFirebase(Task task) async {
    firestore
        .collection('Users')
        .doc(user!.uid)
        .collection('todo')
        .doc()
        .set(task.toJson());
  }

  static void sendFirebaseData(Task task) {
    FirebaseService.firestore
        .collection('Users')
        .doc(user!.uid)
        .collection('todo')
        .doc()
        .set(task.toJson());
  }

  static Future<void> logOut(BuildContext context) async {
    await FirebaseAuth.instance
        .signOut()
        .whenComplete(() => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const SignInScreen(),
              ),
              (Route<dynamic> route) => false,
            ));
  }

  static Future<void> updateField(
      Task task, String fieldName, var value) async {
    var snap = await firestore
        .collection('Users')
        .doc(user!.uid)
        .collection('todo')
        .where('title', isEqualTo: task.title)
        .where('note', isEqualTo: task.note)
        .get();

    for (var element in snap.docs) {
      await firestore
          .collection('Users')
          .doc(user!.uid)
          .collection('todo')
          .doc(element.id)
          .update({fieldName: value});
    }
  }

  static Future<void> resetPassword(String email, BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: email)
          .then((value) {
        final snackBar = SnackBar(
            content: Text("A password reset ling has been send to $email"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Future.delayed(
            const Duration(seconds: 2),
            () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignInScreen(),
                )));
      });
    } on FirebaseAuthException catch (e) {
      final snackBar = SnackBar(content: Text(e.message.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      print(e.code);
      print(e.message);
    }
  }
}
