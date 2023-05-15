import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:true_chat_app/pages/groups/group_info_page.dart';
import 'package:true_chat_app/utils/day_indicator.dart';
import 'package:true_chat_app/utils/my_text_field.dart';
import 'package:true_chat_app/utils/tiles/message_tile.dart';

class GroupChatPage extends StatefulWidget {
  final Stream<DocumentSnapshot<Map<String, dynamic>>> group;
  final String groupName;

  const GroupChatPage({
    super.key,
    required this.group,
    required this.groupName,
  });

  @override
  State<GroupChatPage> createState() => _GroupChatPageState();
}

class _GroupChatPageState extends State<GroupChatPage> {
  TextEditingController messageController = TextEditingController();

  String groupID = "";
  String groupPicture = "";
  String ownerUID = "";
  List<dynamic> members = [];
  Map<String, dynamic> owner = {};

  void deleteMessage(messageId, message, uid, sender, timestamp) {
    if (uid != FirebaseAuth.instance.currentUser!.uid) {
      return;
    } else {
      FirebaseFirestore.instance.collection("groups").doc(groupID).update({
        "messages": FieldValue.arrayRemove([
          {
            "message": message,
            "sender": sender,
            "timestamp": timestamp,
            "uid": uid,
          }
        ])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    void navigateToInfo() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GroupInfoPage(
            owner: owner,
            members: members,
            groupID: groupID,
            groupName: widget.groupName,
            groupPicture: groupPicture,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
            onTap: () {
              navigateToInfo();
            },
            child: Text(widget.groupName)),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.phone),
          ),
          IconButton(
            onPressed: () {
              navigateToInfo();
            },
            icon: const Icon(Icons.info),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: widget.group,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  ownerUID = snapshot.data!.data()!["owner"]["uid"];
                  owner = snapshot.data!.data()!["owner"];
                  members = snapshot.data!.data()!["members"];

                  groupID = snapshot.data!.id;
                  final messages = snapshot.data!.data()!["messages"];
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
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
                          showDayIndicator ? DayIndicator(day: currentDate) : Container(),

                          MessageTile(
                            message: messages[index]["message"],
                            uid: messages[index]["uid"],
                            sender: messages[index]["sender"],
                            photoURL: messages[index]["photoURL"],
                            edit: () {},
                            delete: () {
                              deleteMessage(
                                index,
                                messages[index]["message"],
                                messages[index]["uid"],
                                messages[index]["sender"],
                                messages[index]["timestamp"],
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          MyTextField(
            messageController: messageController,
            focusNode: FocusNode(),
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection("groups")
                  .doc(groupID)
                  .update({
                "messages": FieldValue.arrayUnion([
                  {
                    "uid": FirebaseAuth.instance.currentUser!.uid,
                    "sender": FirebaseAuth.instance.currentUser!.displayName,
                    "photoURL": FirebaseAuth.instance.currentUser!.photoURL,
                    "message": messageController.text,
                    "timestamp": DateTime.now(),
                  }
                ])
              });

              messageController.clear();
            },
          )
        ],
      ),
    );
  }
}
