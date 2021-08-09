import 'package:flutter/material.dart';
// import 'package:intl/date_symbol_data_file.dart';
// import 'package:intl/date_symbol_data_http_request.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:todo_application/db/tasks_database.dart';
import 'package:todo_application/model/task.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:todo_application/pages/edit_task_page.dart';
import 'package:todo_application/widgets/task_card_widget.dart';
import 'task_detail_page.dart';

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

  @override
  void initState() {
    super.initState();
    refreshTasks();
    initializeDateFormatting('tr_TR', null);
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
          toolbarHeight: 80,
          centerTitle: true,
          title: Text(
            "todo App",
            style: TextStyle(
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ),
        body: Center(
          child: isLoading
              ? CircularProgressIndicator()
              : tasks.isEmpty
                  ? Text(
                      'Burada hiçbir şey yok!',
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 20),
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
        padding: EdgeInsets.all(4),
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
