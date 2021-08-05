import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_application/db/tasks_database.dart';
import 'package:todo_application/model/task.dart';
import 'package:todo_application/widgets/task_form_widget.dart';

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
    time = widget.task?.deliveryTime ?? DateTime.now();
    done = widget.task?.done ?? false;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
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
    final isFormValid = title.isNotEmpty && description.isNotEmpty;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          onPrimary: Colors.white,
          primary: isFormValid ? Colors.green.shade300 : Colors.grey.shade700,
        ),
        onPressed: addTaskPage,
        child: Text('Save'),
      ),
    );
  }

  void addTaskPage() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      await addTask();

      Navigator.of(context).pop();
    }
  }

  Future addTask() async {
    final task = Task(
      title: title,
      description: description,
      deliveryTime: DateTime.now(),
      done: false,
    );

    await TasksDatabase.instance.create(task);
  }
}
