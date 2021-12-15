import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management/view/authentication/signin/signin.dart';

import '../../core/components/task_card.dart';
import '../../core/constants/theme.dart';
import '../../core/constants/utils.dart';
import '../../core/init/screen_size.dart';
import '../../core/init/task_manager.dart';
import '../../core/models/taskmodel.dart';
import '../addtask/addtask_screen.dart';

class HomeScreen extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
          drawer: Drawer(
            child: ListView(
              children: [
                DrawerHeader(
                    decoration: BoxDecoration(color: Colors.blueAccent),
                    child: Row(
                      children: [const FlutterLogo(), Text("Taha Cansizoğlu")],
                    )),
                ListTile(
                  title: Text("Çıkış Yap"),
                  onTap: (() async => await FirebaseAuth.instance
                      .signOut()
                      .whenComplete(() => Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignInScreen(),
                            ),
                            (Route<dynamic> route) => false,
                          ))),
                )
              ],
            ),
          ),
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: PreferredSize(
            preferredSize: Size(0, (ScreenSize.screenHeight / 16.7)),
            child: Card(
              color: whiteClr,
              child: tab,
            ),
          ),
          body: TabBarView(children: [
            _buildTasksList("Daily"),
            _buildTasksList("Weekly"),
            _buildTasksList("Monthly"),
            _buildTasksList("All")
          ]),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddTaskScreen()));
            },
            label: const Text("Add Task"),
            icon: const Icon(Icons.add),
          )),
    );
  }

  _buildTasksList(String taskType) {
    return Consumer<TaskManager>(
      builder: (context, value, child) {
        List<Task> task = value.tasks;
        if (taskType != "All") {
          task = value.tasks
              .where((element) => element.taskType == taskType)
              .toList();
        }
        if (task.isNotEmpty) {
          return ListView.builder(
            itemCount: task.length,
            itemBuilder: (context, index) {
              return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: GestureDetector(
                    onTap: () => _showBottom(context, task[index]),
                    child: TaskCard(
                      task: task[index],
                    ),
                  ));
            },
          );
        }
        return Center(
          child: Text(" There are no $taskType tasks."),
        );
      },
    );
  }

  _showBottom(BuildContext context, Task value) => showModalBottomSheet<void>(
        backgroundColor: darkBottomClr,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
        ),
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                height: 8,
              ),
              TaskCard(
                task: value,
                noteTextSize: 24,
              ),
              Visibility(
                visible: value.isCompleted == 0 ? true : false,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0))),
                  child: const Text('Complate Task'),
                  onPressed: () {
                    Provider.of<TaskManager>(context, listen: false)
                        .toggleTaskDone(value.id);
                    Navigator.pop(context);
                  },
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0))),
                child: const Text('Delete Task'),
                onPressed: () {
                  Provider.of<TaskManager>(context, listen: false)
                      .deleteTask(value);
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40.0))),
                child: const Text('Close'),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        },
      );
}
