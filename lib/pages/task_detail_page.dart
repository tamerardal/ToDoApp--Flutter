import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_application/db/tasks_database.dart';
import 'package:todo_application/model/task.dart';
import 'package:todo_application/pages/edit_task_page.dart';

import '../main.dart';

import 'package:timezone/timezone.dart' as tz;

late Task task;

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
  final titleStyle1 =
      GoogleFonts.staatliches(fontSize: 24, color: Colors.white);
  final titleStyle2 = GoogleFonts.staatliches(
    fontSize: 24,
    color: Colors.white,
    decoration: TextDecoration.lineThrough,
    decorationThickness: 2.5,
  );
  final descStyle1 = GoogleFonts.lato(
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );
  final descStyle2 = GoogleFonts.lato(
    fontSize: 22,
    decoration: TextDecoration.lineThrough,
    decorationThickness: 1.5,
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
          style: task.done ? titleStyle1 : titleStyle2,
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
                    style: timeStyle1,
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
                    style: timeStyle2,
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

// void scheduleNotification() async {
//   var scheduleNotificationDateTime = DateTime.now().add(Duration(minutes: -30));

//   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//     'task_notif',
//     'task_notif',
//     'Channel for Task notification',
//     icon: 'app_icon',
//     largeIcon: DrawableResourceAndroidBitmap('app_icon'),
//   );

//   var iOSPlatformChannelSpecifics = IOSNotificationDetails(
//     presentAlert: true,
//     presentBadge: true,
//     presentSound: true,
//   );

//   var platformChannelSpecifics = NotificationDetails(
//     android: androidPlatformChannelSpecifics,
//     iOS: iOSPlatformChannelSpecifics,
//   );

//   await flnp.zonedSchedule(
//       0,
//       'scheduled title',
//       'scheduled body',
//       tz.TZDateTime.local(task.time.second).add(Duration(seconds: 5)),
//       const NotificationDetails(
//           android: AndroidNotificationDetails('your channel id',
//               'your channel name', 'your channel description')),
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime);
// }
