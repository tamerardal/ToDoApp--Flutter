import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:todo_application/db/tasks_database.dart';
import 'package:todo_application/helper/notification_helper.dart';
import 'package:todo_application/model/task.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:todo_application/pages/edit_task_page.dart';
import 'package:todo_application/widgets/task_card_widget.dart';
import 'task_detail_page.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class TasksPage extends StatefulWidget {
  final int? taskId;
  final Task? task;

  const TasksPage({
    Key? key,
    this.taskId,
    this.task,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  late List<Task> tasks;
  bool isLoading = false;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final firstTitleStyle = GoogleFonts.lobster(
    fontSize: 40,
    decoration: TextDecoration.lineThrough,
    decorationThickness: 1.5,
    color: Colors.white,
  );
  final defaulStyle = GoogleFonts.swankyAndMooMoo(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: Colors.grey[600],
  );

  @override
  void initState() {
    super.initState();
    refreshTasks();
    initializeDateFormatting('tr_TR', null);

    super.initState();
  }

  Future refreshTasks() async {
    setState(() => isLoading = true);

    this.tasks = await TasksDatabase.instance.readAllNotes();

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
          toolbarHeight: 100,
          centerTitle: true,
          title: Text(
            "todo App",
            style: firstTitleStyle,
          ),
        ),
        body: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : tasks.isEmpty
                  ? Center(
                      child: Text(
                        'Hiç göreviniz yok, hemen ekleyin!',
                        style: defaulStyle,
                      ),
                    )
                  : buildNotes(),
        ),
        floatingActionButton: Container(
          height: 80,
          width: 80,
          child: FittedBox(
            child: FloatingActionButton(
              backgroundColor: Colors.red[300],
              child: Icon(Icons.add),
              onPressed: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => EditTaskPage()),
                );
                refreshTasks();
              },
            ),
          ),
        ),
      );

  Widget buildNotes() => StaggeredGridView.countBuilder(
        padding: EdgeInsets.all(1),
        itemCount: tasks.length,
        staggeredTileBuilder: (index) => StaggeredTile.fit(2),
        crossAxisCount: 4,
        mainAxisSpacing: 0.1,
        crossAxisSpacing: 0.1,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return GestureDetector(
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => TaskDetailPage(taskId: task.id!)),
              );
              refreshTasks();
            },
            child: TaskCardWidget(task: task, index: index),
          );
        },
      );
}
