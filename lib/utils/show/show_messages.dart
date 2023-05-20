import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:true_chat_app/utils/day_indicator.dart';
import 'package:true_chat_app/utils/tiles/message_tile.dart';
import 'package:true_chat_app/utils/unread_indicator.dart';

class ShowMessages extends StatelessWidget {
  final Stream<DocumentSnapshot<Map<String, dynamic>>> stream;
  final String chatId;

  const ShowMessages({
    Key? key,
    required this.stream,
    required this.chatId,
  });

  void deleteMessage(messageId, message, uid, photoURL, timestamp) {
    if (uid != FirebaseAuth.instance.currentUser!.uid) {
      return;
    } else {
      FirebaseFirestore.instance.collection("chats").doc(chatId).update({
        "messages": FieldValue.arrayRemove([
          {
            "message": message,
            "timestamp": timestamp,
            "photoURL": photoURL,
            "uid": uid,
            "read": false,
          }
        ])
      });
    }
  }

  void edit() {}

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }


        final messages = snapshot.data!.get("messages");

        return ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            // After the user enters the chat it waits 3 seconds to mark the messages as read
            // if (index == 0) {
            //   Future.delayed(const Duration(seconds: 3), () {
            //     FirebaseFirestore.instance
            //         .collection("chats")
            //         .doc(chatId)
            //         .update({

            //         });
            //       });
            // }

            String currentDate = messages[index]["timestamp"]
                .toDate()
                .toString()
                .substring(0, 10);

            bool showDayIndicator = true;

            if (index > 0) {
              String previousDate = messages[index - 1]["timestamp"]
                  .toDate()
                  .toString()
                  .substring(0, 10);

              if (currentDate == previousDate) {
                showDayIndicator = false;
              }
            }

            return Column(
              children: [
                showDayIndicator
                    ? DayIndicator(day: currentDate)
                    : const SizedBox(),
                messages[index]["read"] == false &&
                        messages[index]["uid"] !=
                            FirebaseAuth.instance.currentUser!.uid
                    ? UnreadIndicator()
                    : const SizedBox(),
                MessageTile(
                  message: messages[index]["message"],
                  uid: messages[index]["uid"],
                  photoURL: messages[index]["photoURL"],
                  delete: () {
                    deleteMessage(
                      index,
                      messages[index]["message"],
                      messages[index]["uid"],
                      messages[index]["photoURL"],
                      messages[index]["timestamp"],
                    );
                  },
                  edit: edit,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
