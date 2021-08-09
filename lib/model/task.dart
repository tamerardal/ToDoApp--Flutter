final String tableTask = 'tasks';

class TaskFields {
  static final List<String> values = [
    id,
    title,
    description,
    time,
    done,
  ];

  static final String id = '_id';
  static final String title = 'title';
  static final String description = 'description';
  static final String time = 'deliveryTime';
  static final String done = 'done';
}

class Task {
  final int? id;
  final String title;
  final String description;
  final DateTime time;
  final bool done;

  const Task(
      {this.id,
      required this.title,
      required this.description,
      required this.time,
      required this.done});

  Task copy({
    int? id,
    String? title,
    String? description,
    DateTime? time,
    bool? done,
  }) =>
      Task(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        time: time ?? this.time,
        done: done ?? this.done,
      );

  static Task fromJson(Map<String, Object?> json) => Task(
        id: json[TaskFields.id] as int?,
        title: json[TaskFields.title] as String,
        description: json[TaskFields.description] as String,
        time: DateTime.parse(json[TaskFields.time] as String),
        done: json[TaskFields.done] == 0,
      );

  Map<String, Object?> toJson() => {
        TaskFields.id: id,
        TaskFields.title: title,
        TaskFields.description: description,
        TaskFields.time: time.toIso8601String(),
        TaskFields.done: done ? 1 : 0,
      };
}
