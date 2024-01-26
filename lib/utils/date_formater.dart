


import 'package:flutter/src/painting/text_style.dart';

class DateFormatter {
  String formatToDDMMYYYY(DateTime dateTime) {
    String dateFormatted = "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}";

    return dateFormatted;
  }

  String formatToYYYYMMDD(String originalDate) {
    List<String> splitedDate = originalDate.split('/');
    DateTime date = DateTime(int.parse(splitedDate[2]), int.parse(splitedDate[1]), int.parse(splitedDate[0]));
    String dateFormatted = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

    return dateFormatted;
  }

  String formatToStringDDMMYYYY(String date) {
    List<String> pieces = date.split('-');

    return "${pieces[2]}/${pieces[1]}/${pieces[0]}";
  }

  String convertToDateTime(String date){
    DateTime data = DateTime.parse(date);

    DateFormatter formatter = DateFormatter();

    String dataFormatada = formatter.formatToDDMMYYYY(data);

    return dataFormatada;
  }

  String getHourFromTimestamp(String timestamp) {
    DateTime dateTime = DateTime.parse(timestamp);
    String hourFormatted = "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";

    return hourFormatted;
  }
}

