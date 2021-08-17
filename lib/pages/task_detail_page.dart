import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_application/db/tasks_database.dart';
import 'package:todo_application/model/task.dart';
import 'package:todo_application/pages/edit_task_page.dart';

final _lightColors = [
  Colors.amber.shade200,
  Colors.lightGreen.shade200,
  Colors.lightBlue.shade200,
  Colors.orange.shade200,
  Colors.pinkAccent.shade100,
  Colors.tealAccent.shade100,
];

class TaskDetailPage extends StatefulWidget {
  final int taskId;
  final Task? task;
  final int index;

  const TaskDetailPage({
    Key? key,
    required this.taskId,
    this.task,
    required this.index,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  late Task task;
  bool isLoading = false;
  late bool done;
  final appbarStyle1 = GoogleFonts.swankyAndMooMoo(
    fontSize: 24,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );
  final titleStyle1 = GoogleFonts.swankyAndMooMoo(
    fontSize: 30,
    color: Colors.black87,
    fontWeight: FontWeight.bold,
  );
  final titleStyle2 = GoogleFonts.swankyAndMooMoo(
    fontSize: 30,
    color: Colors.black87,
    decoration: TextDecoration.lineThrough,
    decorationThickness: 1.4,
    fontWeight: FontWeight.bold,
  );
  final descStyle = GoogleFonts.swankyAndMooMoo(
    textStyle: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    decoration: TextDecoration.none,
    decorationThickness: 1.4,
    color: Colors.black87,
  );
  final descStyle2 = GoogleFonts.swankyAndMooMoo(
    fontSize: 24,
    decoration: TextDecoration.lineThrough,
    decorationThickness: 1.4,
    fontWeight: FontWeight.bold,
  );
  final timeStyle1 = GoogleFonts.play(
    textStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.none,
    ),
  );
  final timeStyle2 = GoogleFonts.play(
    textStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      decoration: TextDecoration.lineThrough,
      decorationThickness: 1,
    ),
  );

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

  @override
  void initState() {
    super.initState();
    done = widget.task?.done ?? false;

    refreshTask();
  }

  Future refreshTask() async {
    setState(() => isLoading = true);

    this.task = await TasksDatabase.instance.readTask(widget.taskId);

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final color = _lightColors[task.id! % _lightColors.length];

    return Scaffold(
      appBar: AppBar(
        //backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 5,
        toolbarHeight: 60,
        title: Text(
          'Geri dön',
          style: appbarStyle1,
        ),
        //actions: [editButton(), deleteButton(), completeButton()],
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.red.shade300,
        child: task.done
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  deleteButton(),
                  editButton(),
                  completeButton(),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  deleteButton(),
                  completeButton(),
                ],
              ),
      ),
      body: task.done
          ? SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  color: color,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Container(
                      width: 400,
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat.yMMMMEEEEd('tr_TR').format(task.time) +
                                ' ' +
                                DateFormat.Hm().format(task.time),
                            style: timeStyle1,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            task.title,
                            style: titleStyle1,
                          ),
                          SizedBox(height: 8),
                          Text(
                            task.description,
                            style: descStyle,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(4),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  color: color,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Container(
                      width: 400,
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat.yMMMMEEEEd('tr_TR').format(task.time) +
                                ' ' +
                                DateFormat.Hm().format(task.time),
                            style: timeStyle2,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            task.title,
                            style: titleStyle2,
                          ),
                          SizedBox(height: 8),
                          Text(
                            task.description,
                            style: descStyle2,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget deleteButton() => IconButton(
        icon: Icon(
          Icons.delete_rounded,
          color: Colors.white,
        ),
        onPressed: () async {
          await TasksDatabase.instance.delete(widget.taskId);

          Navigator.of(context).pop();
        },
      );

  Widget editButton() => IconButton(
        onPressed: () async {
          if (isLoading) return;

          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => EditTaskPage(task: task)),
          );

          refreshTask();
        },
        icon: Icon(
          Icons.edit_rounded,
          color: Colors.white,
        ),
      );

  Widget completeButton() => IconButton(
      onPressed: () async {
        await TasksDatabase.instance.complete(task);
        Navigator.of(context).pop();
      },
      icon: task.done
          ? Icon(
              Icons.check_rounded,
              color: Colors.white,
            )
          : Icon(
              Icons.cancel_rounded,
              color: Colors.white,
            ));
}
