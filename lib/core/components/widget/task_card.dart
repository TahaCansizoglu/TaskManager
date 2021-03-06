import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/theme.dart';
import '../../init/screen_size.dart';
import '../../models/taskmodel.dart';

class HomeTaskSummary extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const HomeTaskSummary({required this.task, required this.size});

  final Task task;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 10, 16, 0),
      child: Card(
        elevation: 10,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 80,
                decoration: BoxDecoration(
                    color: _getcolor(task.backgroundColor.toString(), "FF"),
                    borderRadius: BorderRadius.circular(45)),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    width: size - 113,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(task.title,
                            style: Theme.of(context).textTheme.subtitle2),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.timer,
                              color: darkGreyClr,
                              size: 15,
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Text(
                              task.startTime,
                              style: Theme.of(context).textTheme.subtitle2,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: size - 113,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(task.note,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyText1),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.calendar_today_rounded, size: 15),
                            const SizedBox(
                              width: 6,
                            ),
                            Text(task.date,
                                style: Theme.of(context).textTheme.subtitle2),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                height: ScreenSize.screenHeight / 12,
                width: 0.5,
                color: Colors.black.withOpacity(1),
              ),
              RotatedBox(
                quarterTurns: 3,
                child: Text(
                    task.isCompleted == 1
                        ? "COMPLETED"
                        : task.taskType.toString().toUpperCase(),
                    style: card3TextStyle),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getcolor(String hex, String opacity) {
    if (hex != "000000") {
      return Color(int.parse("0x$opacity$hex"));
    } else {
      return Color(int.parse("0xff123464"));
    }
  }
}
