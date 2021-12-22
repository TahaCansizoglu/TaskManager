import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import '../../core/components/widget/task_card.dart';
import '../../core/components/widget/taskcount_card.dart';
import '../../core/constants/theme.dart';
import '../profile/profile_screen.dart';
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
              centerTitle: true,
              elevation: 0,
              // leading: const CircleAvatar(
              //   backgroundColor: Colors.white,
              //   child: CircleAvatar(
              //     backgroundImage:
              //         AssetImage('assets/images/taskmanagericon.png'),
              //   ),
              // ),
              title: Consumer<TaskManager>(builder: (context, value, child) {
                return const Text("Task Manager");
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
                IconButton(
                  icon: Icon(Icons.person),
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileScreen(title: "title"),
                      )),
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
                // DBHelper.deleteDb();
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
        var counterList = [...value.tasks];
        if (taskType != "All") {
          dbTasks = value.tasksType
              .where((element) => element.taskType == taskType)
              .toList();
        }
        if (taskType != "All") {
          counterList = value.tasks
              .where((element) => element.taskType == taskType)
              .toList();
        }

        SchedulerBinding.instance?.addPostFrameCallback((_) =>
            Provider.of<TaskManager>(context, listen: false)
                .getListLength(counterList));
        return Column(
          children: [
            Expanded(
                flex: 1,
                child: Container(
                  decoration: const BoxDecoration(
                      color: lightblue,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  child: ListView(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    children: [
                      buildCountCard(context, counterList, "All", value),
                      buildCountCard(context, counterList, "High", value),
                      buildCountCard(context, counterList, "Low", value),
                      buildCountCard(context, counterList, 0, value),
                      buildCountCard(context, counterList, 1, value),
                    ],
                  ),
                )),
            dbTasks.isNotEmpty
                ? Expanded(
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
                  )
                : const Expanded(
                    flex: 5,
                    child: Center(
                      child: Text(" There are no tasks."),
                    ),
                  )
          ],
        );
      },
    );
  }

  GestureDetector buildCountCard(
      BuildContext context, List<Task> dbTasks, var type, TaskManager value) {
    if (type == "High" || type == "Low") {
      return GestureDetector(
        onTap: () => Provider.of<TaskManager>(context, listen: false)
            .changeTaskType(type, dbTasks),
        child: HomeTaskCountCard(
            size: Size(ScreenSize.screenWidth, ScreenSize.screenWidth),
            desc: "$type Priority",
            count: type == "High"
                ? value.countList["High"]
                : value.countList["Low"],
            color: type == "High" ? Colors.red : Colors.yellow.shade600),
      );
    } else if (type == 0 || type == 1) {
      return GestureDetector(
        onTap: () => Provider.of<TaskManager>(context, listen: false)
            .changeTaskType(type, dbTasks),
        child: HomeTaskCountCard(
            size: Size(ScreenSize.screenWidth, ScreenSize.screenWidth),
            desc: type == 0 ? "Not Completed" : "Completed",
            count: type == 0 ? value.countList["0"] : value.countList["1"],
            color: type == 0 ? Colors.blue : Colors.green),
      );
    } else {
      return GestureDetector(
        onTap: () => Provider.of<TaskManager>(context, listen: false)
            .changeTaskType(type, dbTasks),
        child: HomeTaskCountCard(
            size: Size(ScreenSize.screenWidth, ScreenSize.screenWidth),
            desc: "All Task",
            count: dbTasks.length,
            color: Colors.cyan),
      );
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
                    await FirebaseService.updateField(value, 'isCompleted', 1);
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
