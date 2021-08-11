import 'package:flutter/material.dart';
import 'package:todo_application/model/task.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

final _lightColors = [
  Colors.amber.shade300,
  Colors.lightGreen.shade300,
  Colors.lightBlue.shade300,
  Colors.orange.shade300,
  Colors.pinkAccent.shade100,
  Colors.tealAccent.shade100
];

class TaskCardWidget extends StatelessWidget {
  TaskCardWidget({
    Key? key,
    required this.task,
    required this.index,
  }) : super(key: key);

  final Task task;
  final int index;

  @override
  Widget build(BuildContext context) {
    final color = _lightColors[index % _lightColors.length];
    final time = DateFormat.yMMMd('tr_TR').format(task.time);
    final hour = DateFormat.Hm().format(task.time);
    final minHeight = getMinHeight(index);
    final titleStyle = GoogleFonts.gochiHand(
      textStyle: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w200,
        decoration:
            task.done ? TextDecoration.none : TextDecoration.lineThrough,
        decorationThickness: 4,
        color: Colors.black87,
      ),
    );
    final descStyle = GoogleFonts.gochiHand(
      textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w100),
      decoration: task.done ? TextDecoration.none : TextDecoration.lineThrough,
      decorationThickness: 4,
      color: Colors.black87,
    );
    final timeStyle = GoogleFonts.play(
      textStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        decoration:
            task.done ? TextDecoration.none : TextDecoration.lineThrough,
        decorationThickness: 4,
      ),
    );

    return task.done
        ? Card(
            color: color,
            child: Container(
              constraints: BoxConstraints(minHeight: minHeight),
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    time + ' ' + hour,
                    style: timeStyle,
                  ),
                  SizedBox(height: 2),
                  Text(
                    task.title,
                    style: titleStyle,
                  ),
                  SizedBox(height: 4),
                  Text(
                    task.description,
                    style: descStyle,
                  ),
                ],
              ),
            ),
          )
        : Card(
            color: color,
            child: Container(
              constraints: BoxConstraints(minHeight: minHeight),
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    time + ' ' + hour,
                    style: timeStyle,
                  ),
                  SizedBox(height: 2),
                  Text(
                    task.title,
                    style: titleStyle,
                  ),
                  SizedBox(height: 4),
                  Text(
                    task.description,
                    style: descStyle,
                  ),
                ],
              ),
            ),
          );
  }

  /// To return different height for different widgets
  double getMinHeight(int index) {
    switch (index % 4) {
      case 0:
        return 100;
      case 1:
        return 125;
      case 2:
        return 150;
      case 3:
        return 100;
      default:
        return 125;
    }
  }
}
