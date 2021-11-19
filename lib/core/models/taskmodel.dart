class Task {
  int? id;
  String title;
  String note;
  int isCompleted;
  String date;
  String startTime;
  String endTime;
  String? backgroundColor;
  String? taskType;
  Task(
      {this.id,
      required this.title,
      required this.note,
      required this.isCompleted,
      required this.date,
      required this.startTime,
      required this.endTime,
      this.backgroundColor,
      this.taskType});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'isCompleted': isCompleted,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'backgroundColor': backgroundColor,
      'taskType': taskType
    };
  }

  Map<String, dynamic> fromJson(json) {
    id = json['id'];
    title = json['title'];
    note = json['note'];
    isCompleted = json['isCompleted'];
    date = json['date'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    backgroundColor = json['backgroundColor'];
    taskType = json['taskType'];
    return json['return'];
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as int,
      date: json['date'].toString(),
      endTime: json['endTime'].toString(),
      note: json['note'].toString(),
      startTime: json['startTime'].toString(),
      title: json['title'].toString(),
      isCompleted: json['isCompleted'] as int,
      backgroundColor: json['backgroundColor'].toString(),
      taskType: json['taskType'].toString(),
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['date'] = date;
    data['note'] = note;
    data['isCompleted'] = isCompleted;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['backgroundColor'] = backgroundColor;
    data['taskType'] = taskType;
    return data;
  }
}
