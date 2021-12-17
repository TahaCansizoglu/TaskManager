import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../core/constants/utils.dart';
import 'dart:math';
import '../../core/components/button.dart';
import '../../core/components/input_field.dart';
import '../../core/init/task_manager.dart';
import '../../core/models/taskmodel.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _noteController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  String _startTime = "8:30 AM";

  String _endTime = "9:30 AM";
  String _dropDownText = "Daily";
  late int taskType;
  late Color randomColor;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          centerTitle: true,
          title: Text("Add Task"),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 8,
              ),
              InputField(
                title: "Title",
                hint: "Enter title here.",
                controller: _titleController,
              ),
              InputField(
                  title: "Note",
                  hint: "Enter note here.",
                  controller: _noteController),
              InputField(
                title: "Date",
                hint: DateFormat.yMd().format(_selectedDate),
                widget: IconButton(
                  icon: (const Icon(
                    Icons.add,
                    color: Colors.grey,
                  )),
                  onPressed: () {
                    _getDateFromUser();
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: "Start Time",
                      hint: _startTime,
                      widget: IconButton(
                        icon: (const Icon(
                          Icons.add,
                          color: Colors.grey,
                        )),
                        onPressed: () {
                          _getTimeFromUser(isStartTime: true);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: InputField(
                      title: "End Time",
                      hint: _endTime,
                      widget: IconButton(
                        icon: (const Icon(
                          Icons.add,
                          color: Colors.grey,
                        )),
                        onPressed: () {
                          _getTimeFromUser(isStartTime: false);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 6,
              ),
              DropdownButtonFormField(
                  value: _dropDownText,
                  items: <String>['Daily', 'Weekly', 'Monthly']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _dropDownText = value.toString();
                    });
                  }),
              const SizedBox(
                height: 18.0,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MyButton(
                    label: "Create Task",
                    onTap: () {
                      _validateInputs();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _validateInputs() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTaskToDB();
      Navigator.pop(context);
    } else {
      _showAlert();
    }
  }

  _showAlert() {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Incorrect entry'),
        content: const Text('You have to fill in the fields.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  _addTaskToDB() {
    Task data = Task(
        note: _noteController.text,
        title: _titleController.text,
        date: DateFormat.yMd().format(_selectedDate),
        startTime: _startTime,
        endTime: _endTime,
        isCompleted: 0,
        backgroundColor: _randomColor(),
        taskType: _dropDownText);

    Provider.of<TaskManager>(context, listen: false).addTask(data);
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var _pickedTime = await _showTimePicker();
    String _formatedTime = _pickedTime.format(context);
    if (_pickedTime == null) {
      // ignore: avoid_print
      print("time canceld");
    } else if (isStartTime) {
      setState(() {
        _startTime = _formatedTime;
      });
    } else if (!isStartTime) {
      setState(() {
        _endTime = _formatedTime;
      });
    }
  }

  _randomColor() {
    int length = 6;
    String chars = '0123456789ABCDEF';
    String hex = "";
    while (length-- > 0) {
      hex += chars[(Random().nextInt(16)) | 0];
    }
    return hex;
  }

  _showTimePicker() async {
    return showTimePicker(
      initialTime: const TimeOfDay(hour: 8, minute: 30),
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
    );
  }

  _getDateFromUser() async {
    final DateTime? _pickedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (_pickedDate != null) {
      setState(() {
        _selectedDate = _pickedDate;
      });
    }
  }
}
