import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:task_management/view/authentication/signin/signin.dart';
import 'package:task_management/view/authentication/signup/signup.dart';

import 'core/constants/utils.dart';
import 'core/database/db.dart';
import 'core/init/task_manager.dart';
import 'view/home/home_screen.dart';

User? user;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  user = await FirebaseAuth.instance.currentUser;

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  await DBHelper.initDb();
  runApp(ChangeNotifierProvider(
      create: (context) => TaskManager(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Task Management',
        theme: myTheme,
        debugShowCheckedModeBanner: false,
        home: user != null ? HomeScreen() : SignInScreen());
  }
}
