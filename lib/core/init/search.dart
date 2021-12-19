import 'package:flutter/material.dart';
import '../components/task_card.dart';
import 'screen_size.dart';
import '../models/taskmodel.dart';

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
    query.isEmpty ? suggestions = tasks : suggestions.addAll(tasks.where((element) => element.title.contains(query)));
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) => HomeTaskSummary(task: suggestions[index], size: ScreenSize.screenWidth),
    );
  }
}
