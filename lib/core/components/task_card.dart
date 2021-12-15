import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/theme.dart';
import '../init/screen_size.dart';
import '../models/taskmodel.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final double? noteTextSize;
  const TaskCard({Key? key, required this.task, this.noteTextSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(5)),
      width: ScreenSize.screenWidth,
      margin: EdgeInsets.only(bottom: getProportionateScreenHeight(8)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: _getcolor(task.backgroundColor.toString()),
        ),
        child: Row(children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task.title, style: card2TextStyle),
                const SizedBox(
                  height: 6,
                ),
                Text(task.date, style: card2TextStyle),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.access_alarm,
                      color: Colors.black,
                      size: 15,
                    ),
                    const SizedBox(width: 4),
                    Text("${task.startTime} - ${task.endTime}",
                        style: cardTextStyle),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  task.note,
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                        fontSize: noteTextSize ?? 12,
                        color: Colors.black,
                        height: 1.2),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: ScreenSize.screenHeight / 12,
            width: 0.5,
            color: Colors.grey[200]!.withOpacity(0.7),
          ),
          RotatedBox(
            quarterTurns: 3,
            child: Text(
                task.isCompleted == 1
                    ? "COMPLETED"
                    : "${task.taskType.toString().toUpperCase()}",
                style: card3TextStyle),
          ),
        ]),
      ),
    );
  }

  _getcolor(String hex) {
    if (hex != "000000") {
      return Color(int.parse("0xff$hex"));
    } else {
      return Color(int.parse("0xff123464"));
    }
  }
}
