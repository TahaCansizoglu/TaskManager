import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management/core/constants/theme.dart';

import '../../core/components/task_card.dart';
import '../../core/constants/utils.dart';
import '../../core/database/db.dart';
import '../../core/init/screen_size.dart';
import '../../core/init/search.dart';
import '../../core/init/task_manager.dart';
import '../../core/models/taskmodel.dart';
import '../../core/service/firebase_service.dart';
import '../addtask/addtask_screen.dart';

class HomeScreen extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  HomeScreen({Key? key}) : super(key: key);
  List<Task> tasks = [];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> dbTasks = [];

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);

    return DefaultTabController(
        length: 4,
        child: Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBar(
              leading: const CircleAvatar(
                backgroundColor: Colors.white,
                child: FlutterLogo(),
              ),
              title: Consumer<TaskManager>(builder: (context, value, child) {
                return Text(value.name);
              }),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    showSearch(
                        context: context,
                        delegate: Search(tasks: widget.tasks));
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    handleClick(value, context);
                  },
                  itemBuilder: (BuildContext context) {
                    return {'Logout'}.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                ),
              ],
              bottom: PreferredSize(
                child: tab,
                preferredSize:
                    Size(double.infinity, getProportionateScreenHeight(50.7)),
              ),
            ),
            body: TabBarView(children: [
              _buildTasksList("All"),
              _buildTasksList("Daily"),
              _buildTasksList("Weekly"),
              _buildTasksList("Monthly"),
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
            )));
  }

  _buildTasksList(String taskType) {
    return Consumer<TaskManager>(
      builder: (context, value, child) {
        widget.tasks = [...value.tasks];
        var dbTasks = [...value.tasksType];
        if (taskType != "All") {
          dbTasks = value.tasks
              .where((element) => element.taskType == taskType)
              .toList();
        }
        if (dbTasks.isNotEmpty) {
          return Column(
            children: [
              Expanded(
                  flex: 1,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      GestureDetector(
                        onTap: () =>
                            Provider.of<TaskManager>(context, listen: false)
                                .changeTaskType("High", dbTasks),
                        child: HomeTaskCountCard(
                            size: Size(
                                ScreenSize.screenWidth, ScreenSize.screenWidth),
                            desc: "High Priority",
                            count: priorityLenght(widget.tasks, "High"),
                            color: Colors.red),
                      ),
                      HomeTaskCountCard(
                          size: Size(
                              ScreenSize.screenWidth, ScreenSize.screenWidth),
                          desc: "Low Priority",
                          count: priorityLenght(widget.tasks, "Low"),
                          color: Colors.yellow),
                      HomeTaskCountCard(
                          size: Size(
                              ScreenSize.screenWidth, ScreenSize.screenWidth),
                          desc: "Not Completed",
                          count: completedLenght(widget.tasks, 0),
                          color: Colors.blue),
                      HomeTaskCountCard(
                          size: Size(
                              ScreenSize.screenWidth, ScreenSize.screenWidth),
                          desc: "Complated",
                          count: completedLenght(widget.tasks, 1),
                          color: Colors.green),
                      HomeTaskCountCard(
                          size: Size(
                              ScreenSize.screenWidth, ScreenSize.screenWidth),
                          desc: "All",
                          count: widget.tasks.length,
                          color: Colors.grey),
                    ],
                  )),
              Expanded(
                flex: 5,
                child: ListView.builder(
                  itemCount: dbTasks.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _showBottom(context, dbTasks[index]),
                      child: HomeTaskSummary(
                        size: ScreenSize.screenWidth,
                        task: dbTasks[index],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }
        return Center(
          child: Text(" There are no $taskType tasks."),
        );
      },
    );
  }

  priorityLenght(List<Task> dbTasks, String type) =>
      dbTasks.where((element) => element.taskPriority == type).toList().length;
  completedLenght(List<Task> dbTasks, int type) =>
      dbTasks.where((element) => element.isCompleted == type).toList().length;

  Future<void> handleClick(String value, BuildContext context) async {
    switch (value) {
      case 'Logout':
        await DBHelper.deleteDb();
        await FirebaseService.logOut(context);

        break;
      case 'Settings':
        break;
    }
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
              HomeTaskSummary(task: value, size: ScreenSize.screenWidth),
              Visibility(
                visible: value.isCompleted == 0 ? true : false,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0))),
                  child: const Text('Complate Task'),
                  onPressed: () async {
                    var snap = await FirebaseService.firestore
                        .collection('Users')
                        .doc(FirebaseService.user!.uid)
                        .collection('todo')
                        .where('id', isEqualTo: value.id)
                        .get();

                    for (var element in snap.docs) {
                      FirebaseService.firestore
                          .collection('Users')
                          .doc(FirebaseService.user!.uid)
                          .collection('todo')
                          .doc(element.id)
                          .update({'isCompleted': 1});
                    }
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
                onPressed: () async {
                  var snap = await FirebaseService.firestore
                      .collection('Users')
                      .doc(FirebaseService.user!.uid)
                      .collection('todo')
                      .where('id', isEqualTo: value.id)
                      .get();

                  for (var element in snap.docs) {
                    FirebaseService.firestore
                        .collection('Users')
                        .doc(FirebaseService.user!.uid)
                        .collection('todo')
                        .doc(element.id)
                        .delete();
                  }

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

class HomeTaskCountCard extends StatelessWidget {
  const HomeTaskCountCard({
    Key? key,
    required this.size,
    required this.desc,
    required this.count,
    required this.color,
  }) : super(key: key);

  final Size size;
  final String desc;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withOpacity(.4),
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        height: size.height / 4 - 32,
        width: size.width / 3 - 22,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    desc,
                    style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        fontWeight: FontWeight.normal, color: Colors.white),
                  ),
                  Text(
                    '$count',
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        ?.copyWith(fontWeight: FontWeight.bold, color: color),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
