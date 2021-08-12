import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:todo_application/db/tasks_database.dart';
import 'package:todo_application/main.dart';
import 'package:todo_application/model/task.dart';
import 'package:todo_application/widgets/task_form_widget.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:todo_application/pages/task_detail_page.dart';

class EditTaskPage extends StatefulWidget {
  final Task? task;

  const EditTaskPage({
    Key? key,
    this.task,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditTaskPageState();
}

class _EditTaskPageState extends State<EditTaskPage> {
  final _formKey = GlobalKey<FormState>();
  late bool done;
  late String title;
  late String description;
  late DateTime time;

  @override
  void initState() {
    super.initState();

    title = widget.task?.title ?? '';
    description = widget.task?.description ?? '';
    time = widget.task?.time ?? DateTime.now();
    done = widget.task?.done ?? false;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
          toolbarHeight: 60,
          actions: [buildButton()],
        ),
        body: Form(
          key: _formKey,
          child: TaskFormWidget(
            title: title,
            description: description,
            time: time,
            onChangedTitle: (title) => setState(() => this.title = title),
            onChangedDescription: (description) =>
                setState(() => this.description = description),
            onChangedTime: (time) => setState(() => this.time = time),
          ),
        ),
      );

  Widget buildButton() {
    final isFormValid = title.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: isFormValid ? Colors.green.shade300 : Colors.grey.shade700,
        ),
        onPressed: addorUpdateTaskPage,
        child: Text('KAYDET'),
      ),
    );
  }

  void addorUpdateTaskPage() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      final isUpdating = widget.task != null;

      if (isUpdating) {
        await updateTask();
      } else {
        await addTask();
      }
      //scheduleNotification();
      Navigator.of(context).pop();
    }
  }

  Future addTask() async {
    final task = Task(
      title: title,
      description: description,
      time: time,
      done: false,
    );

    await TasksDatabase.instance.create(task);
  }

  Future updateTask() async {
    final task = widget.task!.copy(
      title: title,
      description: description,
      time: time,
      done: false,
    );

    await TasksDatabase.instance.update(task);
  }
}
