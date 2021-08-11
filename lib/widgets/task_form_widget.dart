import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

final titleStyle = GoogleFonts.staatliches(fontSize: 24);
final descStyle1 = GoogleFonts.cabin(
  fontSize: 22,
  fontWeight: FontWeight.bold,
);

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
              SizedBox(height: 8),
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
            title != null && title.isEmpty ? 'Başlık boş geçilemez' : null,
        onChanged: onChangedTitle,
      );

  Widget buildDescription() => TextFormField(
        maxLines: 5,
        textAlignVertical: TextAlignVertical.top,
        textAlign: TextAlign.left,
        initialValue: description,
        style: TextStyle(color: Colors.black, fontSize: 18),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Açıklama',
          hintText: 'örn. Süt, mısır gevreği..',
          hintStyle: TextStyle(color: Colors.grey.shade600),
        ),
        //validator: (title) =>
        //title != null && title.isEmpty ? 'Açıklama boş geçilemez' : null,
        onChanged: onChangedDescription,
      );

  Widget buildTime(BuildContext context) => Container(
        width: 400,
        child: OutlinedButton(
          onPressed: () {
            DatePicker.showDateTimePicker(
              context,
              showTitleActions: true,
              minTime: DateTime.now(),
              onChanged: onChangedTime,
              locale: LocaleType.tr,
            );
          },
          child: Text(
            'Tarih ve Saat Seçiniz',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade800),
          ),
        ),
      );
}
