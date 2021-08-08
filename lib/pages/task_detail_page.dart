import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
        title: Text(task.title),
        actions: [editButton(), deleteButton(), completeButton()],
      ),
      body: task.done
          ? Padding(
              padding: EdgeInsets.all(12),
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 8),
                children: [
                  Text(
                    DateFormat.yMMMd().format(task.deliveryTime),
                    style: TextStyle(color: Colors.black38),
                  ),
                  SizedBox(height: 8),
                  Text(
                    task.description,
                    style: TextStyle(color: Colors.black87, fontSize: 24),
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
                    DateFormat.yMMMd().format(task.deliveryTime),
                    style: TextStyle(
                      color: Colors.black38,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    task.description,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 24,
                      decoration: TextDecoration.lineThrough,
                    ),
                  )
                ],
              ),
            ));

  Widget deleteButton() => IconButton(
        icon: Icon(Icons.delete),
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
        icon: Icon(Icons.edit_outlined),
      );

  Widget completeButton() => IconButton(
      onPressed: () async {
        await TasksDatabase.instance.complete(task);
        Navigator.of(context).pop();
      },
      icon: Icon(Icons.check_circle_outline));
}
