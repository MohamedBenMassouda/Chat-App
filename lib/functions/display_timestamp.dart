String displayTimeStamp(DateTime timestamp) {
  if (timestamp.day == DateTime.now().day) {
    String hour = timestamp.hour.toString();
    String minute = timestamp.minute.toString();
    String second = timestamp.second.toString();
    String day = timestamp.day.toString();
    String month = timestamp.month.toString();
    String year = timestamp.year.toString();

    minute = minute.length == 1 ? "0$minute" : minute;
    hour = hour.length == 1 ? "0$hour" : hour;

    // Add Settings for the people that prefer 12 hour format

    // :$second $day/$month/$year
    return "$hour:$minute";
  } else if (timestamp.day ==
      DateTime.now().subtract(const Duration(days: 1)).day) {
    return "Yesterday";
  } else {
    String day = timestamp.day.toString();
    String month = timestamp.month.toString();
    String year = timestamp.year.toString();

    switch (month) {
      case "1":
        month = "Jan";
        break;
      case "2":
        month = "Feb";
        break;
      case "3":
        month = "Mar";
        break;
      case "4":
        month = "Apr";
        break;
      case "5":
        month = "May";
        break;
      case "6":
        month = "Jun";
        break;
      case "7":
        month = "Jul";
        break;
      case "8":
        month = "Aug";
        break;
      case "9":
        month = "Sep";
        break;
      case "10":
        month = "Oct";
        break;
      case "11":
        month = "Nov";
        break;
      case "12":
        month = "Dec";
        break;
    }

    String returnString;

    if (DateTime.now().year == timestamp.year) {
      returnString = "$month $day";
    } else {
      returnString = "$day $month $year";
    }

    return returnString;
  }
}
