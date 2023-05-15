import 'package:flutter/material.dart';

class DayIndicator extends StatelessWidget {
  String day;

  DayIndicator({
    super.key,
    required this.day,
  });

  @override
  Widget build(BuildContext context) {
    if (day == DateTime.now().toString().substring(0, 10)) {
      day = "Today";
    } else if (day ==
        DateTime.now()
            .subtract(const Duration(days: 1))
            .toString()
            .substring(0, 10)) {
      day = "Yesterday";
    } else {
      // Reverse day order and remove year
      day = day.split("-").reversed.join(" ").substring(0, 5);

      // Change month number to month name
      switch (day.split(" ")[1]) {
        case "01":
          day = "${day.substring(0, 3)}Jan";
          break;

        case "02":
          day = "${day.substring(0, 3)}Feb";
          break;

        case "03":
          day = "${day.substring(0, 3)}Mar";
          break;

        case "04":
          day = "${day.substring(0, 3)}Apr";
          break;

        case "05":
          day = "${day.substring(0, 3)}May";
          break;

        case "06":
          day = "${day.substring(0, 3)}Jun";
          break;

        case "07":
          day = "${day.substring(0, 3)}Jul";
          break;

        case "08":
          day = "${day.substring(0, 3)}Aug";
          break;

        case "09":
          day = "${day.substring(0, 3)}Sep";
          break;

        case "10":
          day = "${day.substring(0, 3)}Oct";
          break;

        case "11":
          day = "${day.substring(0, 3)}Nov";
          break;

        case "12":
          day = "${day.substring(0, 3)}Dec";
          break;
      }
    }

    return Container(
      padding: const EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            // decoration: BoxDecoration(
            //   color: Colors.transparent,
            //   border: Border.all(
            //     color: Colors.grey[700]!,
            //     width: 1,
            //   ),
            //   borderRadius: BorderRadius.circular(10),
            // ),
            child: Text(
              day,
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          
        ],
      ),
    );
  }
}
