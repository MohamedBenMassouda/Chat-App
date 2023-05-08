import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:true_chat_app/pages/chat_page.dart';

class ConversationTile extends StatelessWidget {
  final String name;
  final friend;
  final String photoURL;
  final DocumentReference<Map<String, dynamic>> chatDoc;

  const ConversationTile({
    super.key,
    required this.name,
    required this.friend,
    required this.photoURL,
    required this.chatDoc,
  });

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
    } else if (timestamp.day == DateTime.now().subtract(const Duration(days: 1)).day) {
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

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(photoURL),
          ),
          title: Text(name),
          subtitle: StreamBuilder(
            stream: chatDoc.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('Loading');
              }

              final messages = snapshot.data!.get("messages") as List<dynamic>;

              if (messages.isEmpty) {
                return const Text("No messages yet");
              }

              final lastMessage = messages.last["message"];
              final lastMessageSender = messages.last["uid"] == friend["uid"]
                  ? friend["displayName"]
                  : "You";

              return Row(
                children: [
                  Text("$lastMessageSender: $lastMessage"),
                  const Spacer(),
                  Text(
                    displayTimeStamp(messages.last["timestamp"].toDate()),
                  ),
                ],
              );
            },
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  friend: friend,
                ),
              ),
            );
          },
        ));
  }
}
