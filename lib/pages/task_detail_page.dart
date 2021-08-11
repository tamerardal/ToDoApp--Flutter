import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_application/db/tasks_database.dart';
import 'package:todo_application/model/task.dart';
import 'package:todo_application/pages/edit_task_page.dart';

class TaskDetailPage extends StatefulWidget {
  final int taskId;
  final Task? task;

  const TaskDetailPage({
    Key? key,
    required this.taskId,
    this.task,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  late Task task;
  bool isLoading = false;
  late bool done;
  final titleStyle = GoogleFonts.staatliches(fontSize: 24);
  final descStyle1 = GoogleFonts.cabin(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );
  final descStyle2 = GoogleFonts.cabin(
      fontSize: 22,
      decoration: TextDecoration.lineThrough,
      fontWeight: FontWeight.bold);

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
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
        toolbarHeight: 60,
        title: Text(
          task.title,
          style: titleStyle,
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
          ? Padding(
              padding: EdgeInsets.all(12),
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 8),
                children: [
                  Text(
                    DateFormat.yMMMMEEEEd('tr_TR').format(task.time) +
                        ' ' +
                        DateFormat.Hm().format(task.time),
                    style: TextStyle(color: Colors.black38),
                  ),
                  SizedBox(height: 8),
                  Text(
                    task.description,
                    style: descStyle1,
                  )
                ],
              ),
            )
          : Padding(
              padding: EdgeInsets.all(12),
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 8),
                children: [
                  Text(
                    DateFormat.yMMMMEEEEd('tr_TR').format(task.time) +
                        ' ' +
                        DateFormat.Hm().format(task.time),
                    style: TextStyle(
                      color: Colors.black38,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    task.description,
                    style: descStyle2,
                  )
                ],
              ),
            ));

  Widget deleteButton() => IconButton(
        icon: Icon(Icons.delete_rounded),
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
        icon: Icon(Icons.edit_rounded),
      );

  Widget completeButton() => IconButton(
      onPressed: () async {
        await TasksDatabase.instance.complete(task);
        Navigator.of(context).pop();
      },
      icon: task.done ? Icon(Icons.check_rounded) : Icon(Icons.cancel_rounded));
}
