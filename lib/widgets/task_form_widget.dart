import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class TaskFormWidget extends StatelessWidget {
  final String? title;
  final String? description;
  final DateTime? time;

  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;
  final ValueChanged<DateTime> onChangedTime;

  const TaskFormWidget({
    Key? key,
    this.title = '',
    this.description = '',
    this.time,
    required this.onChangedTitle,
    required this.onChangedDescription,
    required this.onChangedTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildTitle(),
              SizedBox(height: 8),
              buildDescription(),
              SizedBox(height: 16),
              buildTime(context)
            ],
          ),
        ),
      );

  Widget buildTitle() => TextFormField(
        maxLines: 1,
        initialValue: title,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Başlık',
          labelStyle: TextStyle(fontSize: 18),
          hintText: 'örn. Alışverişe gidilecek',
          hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 16),
        ),
        validator: (title) =>
            title != null && title.isEmpty ? 'The title cannot be empty' : null,
        onChanged: onChangedTitle,
      );

  Widget buildDescription() => TextFormField(
        maxLines: 5,
        initialValue: description,
        style: TextStyle(color: Colors.black, fontSize: 18),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Açıklama',
          hintText: 'örn. Süt, mısır gevreği..',
          hintStyle: TextStyle(color: Colors.grey.shade600),
        ),
        validator: (title) => title != null && title.isEmpty
            ? 'The description cannot be empty'
            : null,
        onChanged: onChangedDescription,
      );

  Widget buildTime(BuildContext context) => OutlinedButton(
        onPressed: () {
          DatePicker.showDateTimePicker(context,
              showTitleActions: true,
              minTime: DateTime.now(), onChanged: (time) {
            print('change $time in time zone ' +
                time.timeZoneOffset.inHours.toString());
          }, onConfirm: (time) {
            print('confirm $time');
          }, locale: LocaleType.tr);
        },
        child: Text(
          'Tarih ve Saat Seçiniz',
          style: TextStyle(fontSize: 18),
        ),
      );
}
