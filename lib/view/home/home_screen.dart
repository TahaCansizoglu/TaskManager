import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/components/task_card2.dart';
import '../authentication/signin/signin.dart';

import '../../core/components/task_card.dart';
import '../../core/constants/theme.dart';
import '../../core/constants/utils.dart';
import '../../core/init/screen_size.dart';
import '../../core/init/task_manager.dart';
import '../../core/models/taskmodel.dart';
import '../addtask/addtask_screen.dart';

class HomeScreen extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  HomeScreen({Key? key}) : super(key: key);
  List<Task> task = [];
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name = "";

  @override
  Widget build(BuildContext context) {
    ScreenSize().init(context);

    return DefaultTabController(
      length: 4,
      child: FutureBuilder(
        future: getName(),
        builder: (context, snapshot) => Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBar(
              leading: const CircleAvatar(
                backgroundColor: Colors.white,
                child: FlutterLogo(),
              ),
              title: Text(name),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    showSearch(
                        context: context, delegate: Search(tasks: widget.task));
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
                    return {'Logout', 'Settings'}.map((String choice) {
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
      ),
    );
  }

  _buildTasksList(String taskType) {
    return Consumer<TaskManager>(
      builder: (context, value, child) {
        widget.task = value.tasks;
        if (taskType != "All") {
          widget.task = value.tasks
              .where((element) => element.taskType == taskType)
              .toList();
        }
        if (widget.task.isNotEmpty) {
          return ListView.builder(
            itemCount: widget.task.length,
            itemBuilder: (context, index) {
              return HomeTaskSummary(
                size: ScreenSize.screenWidth,
                task: widget.task[index],
              );
            },
          );
        }
        return Center(
          child: Text(" There are no $taskType tasks."),
        );
      },
    );
  }

  Future<void> handleClick(String value, BuildContext context) async {
    switch (value) {
      case 'Logout':
        await FirebaseAuth.instance
            .signOut()
            .whenComplete(() => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignInScreen(),
                  ),
                  (Route<dynamic> route) => false,
                ));

        break;
      case 'Settings':
        break;
    }
  }

  Future<String> getName() async {
    await firestore
        .collection('Users')
        .doc(user!.uid)
        .get()
        .then((value) => name = value['name']);
    return name;
  }
}

class Search extends SearchDelegate {
  List<Task> tasks;
  Search({required this.tasks});
  @override
  List<Widget>? buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back));
  }

  var selectedResult = "";

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Center(
        child: Text(selectedResult),
      ),
    );
  }

  List<Task> recentList = [];

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Task> suggestions = [];
    query.isEmpty
        ? suggestions = tasks
        : suggestions
            .addAll(tasks.where((element) => element.title.contains(query)));
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) => HomeTaskSummary(
          task: suggestions[index], size: ScreenSize.screenWidth),
    );
  }
}
