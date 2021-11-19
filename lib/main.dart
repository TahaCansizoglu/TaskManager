import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/constants/utils.dart';
import 'core/database/db.dart';
import 'core/init/task_manager.dart';
import 'view/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  await DBHelper.initDb();
  runApp(ChangeNotifierProvider(create: (context) => TaskManager(), child: MyApp()));
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
      home: HomeScreen(),
    );
  }
}
